{config, pkgs, colorScheme, ...}:
{
  home.file.".config/eww/eww.yuck".text = ''
    (defwindow bar
      :monitor 0
      :windowtype "dock"
      :geometry (geometry :x "0%"
                          :y "0%"
                          :width "100%"
                          :height "40px"
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
      (eventbox 
        :onscroll "bash ~/.config/eww/scripts/change-active-workspace {} ''${current_workspace}" 
        :class "workspaces-widget"
        (box :space-evenly true
             :class "workspaces"
             :orientation "h"
             :space-evenly false
             :halign "start"
             :valign "center"
             :spacing 15 
          (label :text "''${workspaces}''${current_workspace}" :visible false)
          (for workspace in workspaces
            (eventbox :class "current" :onclick "hyprctl dispatch workspace ''${workspace.id}"
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
      (box :class "window"
        (label :text window :valign "center")
      ))

    ;; Right Side.

    (defwidget info []
      (eventbox 
        :onscroll "bash ~/.config/eww/scripts/change-active-workspace {} ''${current_workspace}" 
        :class "workspaces-widget"
        (box :space-evenly true
             :class "info"
             :orientation "h"
             :space-evenly true
             :halign "end"
             :valign "center"
             :spacing 20
          (battery :status {EWW_BATTERY.BAT1.status}
                 :battery {EWW_BATTERY.BAT1.capacity}
                 :charge "󰂄" :alert "󰂃" :one "󰁺" :two "󰁻" :three "󰁼" :four "󰁽" 
                 :five "󰁾" :six "󰁿" :seven "󰂀" :eight "󰂁" :nine "󰂂" :ten "󰁹")
          (volume :mute "󰖁" :low "" :medium "" :high "󰕾")
          (net :class "net")
          (power :class "power")
          )
        )
      )

  (defwidget metric [label value onchange]
    (box :orientation "h"
         :class "metric"
         :space-evenly false
      (box :class "label" label)
      (scale :min 0
             :max 101
             :active {onchange != ""}
             :value value
             :onchange onchange)))

    (defwidget battery [battery charge status alert one two three
                        four five six seven eight nine ten]
      (box :class "battery"
        (label :text {status == 'Charging' ? charge :
          battery < 5 ? alert :
            battery < 10 ? one :
              battery < 20 ? two :
                battery < 30 ? three :
                  battery < 40 ? four :
                    battery < 50 ? five :
                      battery < 60 ? six :
                        battery < 70 ? seven :
                          battery < 80 ? eight :
                            battery < 90 ? nine : ten}
          :tooltip "''${battery}%")
        )
      )

    (defwidget volume [mute low medium high]
      (button 
        :class "volume" 
        :onclick "if pgrep -x .pavucontrol-wr > /dev/null; then kill $(pgrep -x '.pavucontrol-wr'); else pavucontrol; fi"
        (label :text {
          volume < 1 ? mute :
            volume < 40 ? low :
              volume < 70 ? medium : high
        }
          :tooltip "''${volume}%")
        )
      )


    (defwidget net []
      (box :class "net"
        (label :text {wifi_status == '1' ? "" : "󰤭"} :tooltip {wifi_name})
      )
    )

    (defwidget power []
      (box :class "power"
        (button :onclick "wlogout" :timeout 100000 "")
      )
    )

    ;; Workspace
    (deflisten workspaces :initial "[]" "bash ~/.config/eww/scripts/get-workspaces")
    (deflisten current_workspace :initial "1" "bash ~/.config/eww/scripts/get-active-workspace")
    (deflisten window :initial "..." "sh ~/.config/eww/scripts/get-window-title")
    (defpoll wifi_name :interval "5s" `nmcli -g "CONNECTION" device status | awk 'NR<2'`)
    (defpoll wifi_status :interval "5s" `nmcli -g "STATE" device status | grep -E "^connected$" | wc -l`)
    (defpoll volume :interval "1s" "scripts/getvol")

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
      font-family: "BlexMono Nerd Font Mono, monospace";
      font-weight: bold;
      font-size: 16px;
      background: #${base00};
      color: #${base06};
    }

    .workspaces {
      color: #d9d9d9;
      margin-left: 15px;
    }

    .window {
      padding-right: 100px;
      padding-left: 100px;
    }

    .info {
      margin-right: 15px;
      font-size: 24px;
    }

    .current {
      color: #${base05};
    }

    .time {
      color: #${base0A};
    }

    .volume {
      color: #${base0D};
    }

    .battery {
      color: #${base0B};
      font-size: 15px;
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
      socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | \
        stdbuf -o0 awk -F '>>|,' '/^activewindow>>/{print substr($3, 1, 60) }'
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

  home.file.".config/eww/scripts/getvol" = {
    text = ''
      #!/bin/sh

      if command -v pamixer &>/dev/null; then
          if [ true == $(pamixer --get-mute) ]; then
              echo 0
              exit
          else
              pamixer --get-volume
          fi
      else
          amixer -D pulse sget Master | awk -F '[^0-9]+' '/Left:/{print $3}'
      fi
    '';
    executable = true;
  };
}

