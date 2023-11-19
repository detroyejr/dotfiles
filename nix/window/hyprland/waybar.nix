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
          "hyprland/workspaces"
      ],
      "modules-right": [
          "battery",
          "network",
          "pulseaudio",
          "pulseaudio#microphone",
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
          "exec": "TZ='America/New_York' date +' %H:%M   %Y-%m-%d'",
          "interval": 30
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
        "max-length": 50
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
          "on-click": "pamixer -t",
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
      }
  }
  '';

  home.file.".config/waybar/style.css".text = with colorScheme.colors; ''
    * {
        border: none;
        border-radius: 0;
        font-family: Ubuntu Nerd Font, monospace;
        font-weight: bold;
        font-size: 18px;
        min-height: 0;
    }

    window#waybar {
        background: rgba(21, 18, 27, 0);
        color: #ffffff;
    }

    tooltip {
        background: #${base01};
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #11111b;
    }

    #workspaces button {
        padding: 5px;
        color: #313244;
        margin-right: 5px;
    }

    #workspaces button.active {
        color: #a6adc8;
    }

    #workspaces button.focused {
        color: #a6adc8;
        background: #eba0ac;
        border-radius: 10px;
    }

    #workspaces button.urgent {
        color: #11111b;
        background: #a6e3a1;
        border-radius: 10px;
    }

    #custom-language,
    #window,
    #custom-clock,
    #battery,
    #pulseaudio,
    #network,
    #workspaces,  
    #custom-power, 
    #backlight {
        background: #${base00};
        padding: 0px 10px;
        margin: 3px 0px;
        margin-top: 10px;
        border: 1px solid #181825;
    }


    #workspaces {
        background: #${base00};
        border-radius: 10px;
        margin-left: 10px;
        padding-right: 0px;
        padding-left: 5px;
    }

    #window {
        border-radius: 10px;
        margin-left: 60px;
        margin-right: 60px;
    }

    #custom-clock {
        color: #fab387;
        color: #fab387;
        border-radius: 10px;
        margin-left: 5px;
        margin-right: 5px;
    }

    #battery {
        color: #a6e3a1;
        border-radius: 10px 0px 0px 10px;
        border-left: 0px;
        border-right: 0px;
    }

    #network {
        color: #f9e2af;
        border-left: 0px;
        border-right: 0px;
    }

    #pulseaudio {
        color: #89b4fa;
        border-left: 0px;
        border-right: 0px;
    }
    #pulseaudio.microphone {
        color: #cba6f7;
        margin-right: 5px;
        border-radius: 0 10px 10px 0;
    }
    #custom-power {
        color: #ffffff;
        border-left: 0px;
        border-right: 0px;
        border-radius: 10px;
        margin-right: 5px;
        margin-left: 5px;
    }
  '';
}
