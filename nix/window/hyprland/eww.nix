{config, pkgs, colorScheme, ...}:  
{
  home.file.".config/eww/eww.yuck".text = ''
    (defwindow bar
      :monitor 0
      :windowtype "dock"
      :geometry (geometry :x "0%"
                          :y "0%"
                          :width "100%"
                          :height "30px"
                          :anchor "top center")
      :exclusive true
      (bar))

    ;; Left Side.
    (defwidget bar []
      (centerbox :orientation "h" :class "bar"
        (workspaces)
        (window_name)
        (info))
      )



    (defwidget workspaces []
      (eventbox :onscroll "bash ~/.config/eww/scripts/change-active-workspace {} ''${current_workspace}" :class "workspaces-widget"
        (box :space-evenly true
             :class "workspaces"
             :orientation "h"
             :space-evenly false
             :halign "start"
             :spacing 20
          (label :text "''${workspaces}''${current_workspace}" :visible false)
          (for workspace in workspaces
            (eventbox :onclick "hyprctl dispatch workspace ''${workspace.id}"
              (box :class "workspace-entry ''${workspace.id == current_workspace ? "current" : ""} ''${workspace.windows > 0 ? "occupied" : "empty"}"
                (label :text "''${workspace.id}")
                )
              )
            )
          (time)
          )
        )
      )

    (defwidget time []
      (box :class "time" :orientation "h" :space-evenly false :halign "end"
        time))

    ;; Middle.
    (defwidget window_name []
      (box
        (label :text "''${window}"
        )
      ))

    ;; Right Side.

    (defwidget info []
      (eventbox :onscroll "bash ~/.config/eww/scripts/change-active-workspace {} ''${current_workspace}" :class "workspaces-widget"
        (box :space-evenly true
             :class "info"
             :orientation "h"
             :space-evenly false
             :halign "end"
             :spacing 10 
          (battery :status {EWW_BATTERY.BAT1.status}
                 :battery {EWW_BATTERY.BAT1.capacity}
                 :charge "" :one "" :two "" :three "" :four ""
                 :five "" :six "" :seven "")
          (net :class "net")
          (power :class "power")
          )
        )
      )
    (defwidget battery [battery status one two three
                        four five six seven charge]
      (box :class "battery" :spacing 10 
        (label :text {status == 'Charging' ? charge :
          battery < 15 ? one :
            battery < 30 ? two :
              battery < 45 ? three :
                battery < 60 ? four :
                  battery < 75 ? five :
                    battery < 95 ? six : seven}
          :tooltip "''${battery}%")
        )
      )

    (defwidget net []
      (box :class "net" :spacing 20
        (label :text {wifi_status == '1' ? "" : "󰤭"} :tooltip {wifi_name})
      )
    )

    (defwidget power []
      (button :class "power" :onclick "bash -c 'wlogout'" :timeout 3000 "")
    )

    ;; Workspace
    (deflisten workspaces :initial "[]" "bash ~/.config/eww/scripts/get-workspaces")
    (deflisten current_workspace :initial "1" "bash ~/.config/eww/scripts/get-active-workspace")
    (deflisten window :initial "..." "sh ~/.config/eww/scripts/get-window-title")
    (defpoll wifi_name :interval "5s" `nmcli -g "CONNECTION" device status | awk 'NR<2'`)
    (defpoll wifi_status :interval "5s" `nmcli -g "STATE" device status | grep -E "^connected$" | wc -l`)

    ;; Time
    (defpoll time :interval "1s"
      "date '+%I:%M %p'")
  '';

  home.file.".config/eww/eww.scss".text = with colorScheme.colors; ''
    * {
      all: unset; //Unsets everything so you can style everything from scratch
    }

    //Global Styles
    .bar {
      font-family: "BlexMono Nerd Font, monospace";
      font-weight: bold;
      font-size: 14px;
      padding-top: 5px;
      background: #${base00};
      color: #${base06};
    }

    .workspaces {
      color: #d9d9d9;
      margin-left: 15px;
    }

    .info {
      margin-right: 15px;
    }

    .current {
      color: #${base05};
    }

    .time {
      color: #${base0A};
    }

    .battery {
      margin-right: 20px;
      color: #${base0B};
    }

    .net {
      color: #${base0C};
    }
  '';

  home.file.".config/eww/scripts/change-active-workspace" = {
    text = ''
      #! /usr/bin/env bash
      function clamp {
        min=$1
        max=$2
        val=$3
        python -c "print(max($min, min($val, $max)))"
      }

      direction=$1
      current=$2
      if test "$direction" = "down"
      then
        target=$(clamp 1 10 $(($current+1)))
        echo "jumping to $target"
        hyprctl dispatch workspace $target
      elif test "$direction" = "up"
      then
        target=$(clamp 1 10 $(($current-1)))
        echo "jumping to $target"
        hyprctl dispatch workspace $target
      fi
    '';
    executable = true;
  };

  home.file.".config/eww/scripts/get-active-workspace" = {
    text = ''
    #!/usr/bin/env bash
    hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'

    socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
    stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'
    '';
    executable = true;
  };

  home.file.".config/eww/scripts/get-window-title" = {
    text = ''
      #!/bin/sh
      hyprctl activewindow -j | jq --raw-output .title
      socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | stdbuf -o0 awk -F '>>|,' '/^activewindow>>/{print $3}'
    '';
    executable = true;
  };

  home.file.".config/eww/scripts/get-workspaces" = {
    text = ''
    #!/usr/bin/env bash
    spaces (){
      WORKSPACE_WINDOWS=$(hyprctl workspaces -j | jq 'map(select(.windows > 0) | {key: .id | tostring, value: .windows}) | from_entries')
      ACTIVE_WINDOWS=$(hyprctl activeworkspace -j | jq "{(.id | tostring): 1}")
      ALL_WINDOWS=$(echo "[''${ACTIVE_WINDOWS}, ''${WORKSPACE_WINDOWS}]" | jq 'add')
      seq 1 10 | jq --argjson windows "''${ALL_WINDOWS}" --slurp -Mc 'map(tostring) | map({id: ., windows: ($windows[.]//0)})' | jq -Mc 'map(select(.windows > 0))'
    }

    spaces
    socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
      spaces
    done
    '';
    executable = true;
  };
}

