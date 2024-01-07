{pkgs, config, hyprland, colorScheme, ...}:
{
  programs.waybar = {
    enable = true;
  };

  home.file.".config/waybar/config.jsonc".text = with colorScheme.colors; ''

  {
      "layer": "top",
      "position": "top",
      "mod": "dock",
      "exclusive": true,
      "passtrough": false,
      "gtk-layer-shell": true,
      "height": 0,
      "modules-left": [
          "custom/clock",
          "hyprland/workspaces",
      ],
      "modules-center": [
          "hyprland/window"
      ],
      "modules-right": [
          "custom/playerctl",
          "battery",
          "network",
          "pulseaudio",
          "custom/power"
      ],
      "hyprland/window": {
          "format": "{}"
      },
      "hyprland/workspaces": {
          "on-scroll-up": "hyprctl dispatch workspace e+1",
          "on-scroll-down": "hyprctl dispatch workspace e-1",
          "all-outputs": true,
          "on-click": "activate"
      },
      "custom/clock": {
          "exec": "TZ='America/New_York' date +'%I:%M %p'",
          "interval": 30,
          "tooltip": false
      },
      "battery": {
        "tooltip": true,
        "format": "{icon}",
        "format-icons": ["", "", "", "", ""]
      },
      "network": {
        "interface": "wlp1s0",
        "format": "{ifname}",
        "format-wifi": "",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "format-disconnected": "", //An empty format will hide the module.
        "tooltip-format": "{ifname} via {gwaddr} ",
        "tooltip-format-wifi": "{essid} ({signalStrength}%) ",
        "tooltip-format-ethernet": "{ifname} ",
        "tooltip-format-disconnected": "Disconnected",
        "max-length": 50,
        "on-click": "if pgrep -x nmtui-connect > /dev/null; then kill $(pgrep -x nmtui-connect); else kitty -e nmtui-connect; fi"
      },
      "clock": {
          "format": "{: %X   %Y-%m-%d}",
          "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
          "interval": 60

      },
      "pulseaudio": {
          "format": "{icon}",
          "tooltip": true,
          "tooltip-format": "{volume}%",
          "format-muted": "󰝟",
          "on-click": "if pgrep -x .pavucontrol-wr > /dev/null; then kill $(pgrep -x '.pavucontrol-wr'); else pavucontrol; fi",
          "on-scroll-up": "pamixer -i 5",
          "on-scroll-down": "pamixer -d 5",
          "scroll-step": 5,
          "format-icons": {
              "headphone": "",
              "hands-free": "",
              "headset": "",
              "phone": "",
              "portable": "",
              "car": "",
              "default": ["", "", ""]
          }
      },
      "pulseaudio#microphone": {
          "format": "",
          "tooltip": true,
          "tooltip-format": "{format_source} {volume}%",
          "format-source-muted": " Muted",
          "on-click": "pamixer --default-source -m",
          "on-scroll-up": "pamixer --default-source -i 5",
          "on-scroll-down": "pamixer --default-source -d 5",
          "scroll-step": 5
      },
      "custom/power": {
        "format": "",
        "on-click": "wlogout",
        "tooltip": false
      },
      "custom/playerctl": {
        "format": "{}",
        "return-type": "json",
        "max-length": 40,
        "exec": "$HOME/.local/bin/playerctl-waybar 2> /dev/null",
        "on-click": "export WINDOW=$(playerctl metadata | head -n1 | awk '{ print $1 }') && hyprctl dispatch focuswindow $WINDOW",
        "on-right-click": "sys-notif media",
        "on-scroll-up": "playerctl position 3+",
        "on-scroll-down": "playerctl position 3-"
      },
      "custom/notification": {
        "tooltip": false,
        "format": "{icon}",
        "format-icons": {
          "notification": "<span foreground='red'><sup></sup></span>",
          "none": "",
          "dnd-notification": "<span foreground='red'><sup></sup></span>",
          "dnd-none": "",
          "inhibited-notification": "<span foreground='red'><sup></sup></span>",
          "inhibited-none": "",
          "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
          "dnd-inhibited-none": ""
        },
        "return-type": "json",
        "exec-if": "which swaync-client",
        "exec": "swaync-client -swb",
        "on-click": "swaync-client -t -sw",
        "on-click-right": "swaync-client -d -sw"
      }
  }
  '';

  home.file.".config/waybar/style.css".text = with colorScheme.colors; ''
    * {
        border: none;
        border-radius: 0;
        font-family: "BlexMono Nerd Font", monospace;
        font-weight: bold;
        font-size: 14px;
    }

    /* window#waybar {
        background: #${color0};
        color: #ffffff;
    } */

    tooltip {
        background: #${color0};
        border-width: 2px;
        border-style: solid;
        border-color: #${color0};
    }

    #workspaces button {
        padding: 5px;
        color: #${color6};
        background: #${color0};
        margin-right: 5px;
    }

    #workspaces button.active {
        color: #${color5};
    }

    #workspaces button.focused {
        color: #${color6};
        background: #${color0};
    }

    #workspaces button.urgent {
        color: #${color6};
        background: #${color0};
    }

    #battery,
    #custom-clock,
    #custom-language,
    #custom-notification,
    #custom-playerctl,
    #custom-power,
    #network,
    #pulseaudio,
    #window,
    #workspaces,
    #backlight {
        background: #${color0};
        padding: 0px 10px;
        margin: 3px 0px;
    }


    #workspaces {
        background: #${color0};
        margin-left: 10px;
        padding-right: 0px;
        padding-left: 5px;
    }

    #window {
        margin-left: 60px;
        margin-right: 60px;
    }

    #custom-clock {
        color: #${color10};
        margin-left: 5px;
        margin-right: 5px;
    }
    
    #custom-notifcation {
        color: #${color10};
        border-left: 0px;
        border-right: 0px;
    }

    #battery {
        color: #${color11};
        border-left: 0px;
        border-right: 0px;
    }

    #network {
        color: #${color12};
        border-left: 0px;
        border-right: 0px;
    }

    #pulseaudio {
        color: #${color13};
        border-left: 0px;
        border-right: 0px;
    }
    #pulseaudio.microphone {
        color: #${color14};
        margin-right: 5px;
    }
    #custom-power {
        color: #${color7};
        border-left: 0px;
        border-right: 0px;
        border-radius: 10px;
        margin-right: 5px;
        margin-left: 5px;
    }

    #custom-playerctl {
        color: #FFFFFF;
        border-left: 0px;
        border-right: 0px;
        border-radius: 10px;
        margin-right: 5px;
        margin-left: 5px;
    }
  '';

  home.file.".local/bin/playerctl-waybar".text = with colorScheme.colors; ''
    #!/usr/bin/env bash
    exec 2>"$XDG_RUNTIME_DIR/waybar-playerctl.log"
    IFS=$'\n\t'

    while true; do

      while read -r playing position length name artist title arturl hpos hlen; do
        # remove leaders
        playing=''${playing:1} position=''${position:1} length=''${length:1} name=''${name:1}
        artist=''${artist:1} title=''${title:1} arturl=''${arturl:1} hpos=''${hpos:1} hlen=''${hlen:1}

        # build line
        line="''${artist:+$artist ''${title:+- }}''${title:+$title }''${hpos:+$hpos''${hlen:+|}}$hlen"

        # json escaping
        line="''${line//\"/\\\"}"
        ((percentage = length ? (100 * (position % length)) / length : 0))
        case $playing in
        ⏸️ | Paused) text='<span foreground=\"#${color13}\" size=\"smaller\">'"$line"'</span>' ;;
        ▶️ | Playing) text="<small>$line</small>" ;;
        *) text='<span foreground=\"#${color14}\"></span>' ;;
        esac

        # integrations for other services (nwg-wrapper)
        if [[ $title != "$ptitle" || $artist != "$partist" || $parturl != "$arturl" ]]; then
          typeset -p playing length name artist title arturl >"$XDG_RUNTIME_DIR/waybar-playerctl.info"
          pkill -8 nwg-wrapper
          ptitle=$title partist=$artist parturl=$arturl
        fi

        # exit if print fails
        printf '{"text":"%s","tooltip":"%s","class":"%s","percentage":%s}\n' \
          "$text" "$playing $name | $line" "$percentage" "$percentage" || break 2

      done < <(
        # requires playerctl>=2.0
        # Add non-space character ":" before each parameter to prevent 'read' from skipping over them
        playerctl --follow metadata --player playerctld --format \
          $':{{emoji(status)}}\t:{{position}}\t:{{mpris:length}}\t:{{playerName}}\t:{{markup_escape(artist)}}\t:{{markup_escape(title)}}\t:{{mpris:artUrl}}\t:{{duration(position)}}\t:{{duration(mpris:length)}}' &
        echo $! >"$XDG_RUNTIME_DIR/waybar-playerctl.pid"
      )

      # no current players
      # exit if print fails
      echo '<span foreground=#dc322f>⏹</span>' || break
      sleep 15

    done

    kill "$(<"$XDG_RUNTIME_DIR/waybar-playerctl.pid")"
  '';
  home.file.".local/bin/playerctl-waybar".executable = true;
}

