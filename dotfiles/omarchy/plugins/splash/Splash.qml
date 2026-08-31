import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs.Ui

Item {
  id: root

  property string splashText: ""

  function refreshSplash() {
    if (!splashProc.running) splashProc.running = true
  }

  Process {
    id: splashProc
    command: ["hyprctl", "splash"]
    stdout: StdioCollector {
      onStreamFinished: root.splashText = String(text || "").trim()
    }
    onExited: if (exitCode !== 0) root.splashText = ""
  }

  Component.onCompleted: refreshSplash()

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData

      screen: modelData
      visible: !remapGuard.remapping && root.splashText !== ""
      color: "transparent"
      anchors { top: true; bottom: true; left: true; right: true }

      ScreenMoveRemap {
        id: remapGuard
        window: panel
      }

      WlrLayershell.namespace: "omarchy-splash"
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      exclusionMode: ExclusionMode.Ignore

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        color: Qt.rgba(1, 1, 1, 0.8)
        font.family: "Sans"
        font.pixelSize: Math.max(12, Math.round(parent.height / 76))
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        textFormat: Text.PlainText
        text: root.splashText
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.35)
      }
    }
  }
}
