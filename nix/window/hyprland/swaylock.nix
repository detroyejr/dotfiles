{config, pkgs, colorScheme, ...}:
{
  home.packages = with pkgs; [
    swaylock-effects
    wlogout
  ];

  home.file.".config/swaylock/lock.sh".text = with colorScheme.colors; ''
    swaylock   
  '';
  home.file.".config/swaylock/config".text = with colorScheme.colors; ''
  ignore-empty-password
  font="BlexMono Nerd Font Mono"

  clock
  timestr=%R
  datestr=%a, %e of %B

  # Add current screenshot as wallpaper
  # screenshots

  # Add an image as a background 
  # In my setup the current wallpaper (requires wallpaper scripts in /scripts)
  image=~/.local/share/eog-wallpaper.jpg

  # Fade in time
  fade-in=0.01

  # Effect for background
  # effect-blur=20x6
  # effect-greyscale
  effect-pixelate=5

  # Show/Hide indicator circle
  indicator

  # smaller indicator
  indicator-radius=200

  # bigger indicator
  # indicator-radius=300

  indicator-thickness=20
  indicator-caps-lock

  # Define all colors

  key-hl-color=00000066
  separator-color=#${base03}

  inside-color#${base03}=
  inside-clear-color=ffffff00
  inside-caps-lock-color=ffffff00
  inside-ver-color=ffffff00
  inside-wrong-color=ffffff00

  ring-color=#${base03}
  ring-clear-color=ffffff
  ring-caps-lock-color=ffffff
  ring-ver-color=ffffff
  ring-wrong-color=ffffff

  line-color=00000000
  line-clear-color=ffffffFF
  line-caps-lock-color=ffffffFF
  line-ver-color=ffffffFF
  line-wrong-color=ffffffFF

  text-color=ffffff
  text-clear-color=ffffff
  text-ver-color=ffffff
  text-wrong-color=ffffff

  bs-hl-color=ffffff
  caps-lock-key-hl-color=ffffffFF
  caps-lock-bs-hl-color=ffffffFF
  disable-caps-lock-text
  text-caps-lock-color=ffffff

  '';

  home.file.".config/swaylock/swaylock.conf".text = ''
  ignore-empty-password
  '';

  home.file.".config/wlogout/icons".source = ../../../dotfiles/wlogout/icons;
  home.file.".config/wlogout/style.css".text = ''
      /*
              _                         _
    __      _| | ___   __ _  ___  _   _| |_
    \ \ /\ / / |/ _ \ / _` |/ _ \| | | | __|
     \ V  V /| | (_) | (_| | (_) | |_| | |_
      \_/\_/ |_|\___/ \__, |\___/ \__,_|\__|
                      |___/

    by Stephan Raabe (2023)
    -----------------------------------------------------
    */

    /* -----------------------------------------------------
     * Import Pywal colors
     * ----------------------------------------------------- */

    /* -----------------------------------------------------
     * General
     * ----------------------------------------------------- */

    * {
      font-family: "BlexMono Nerd Font Mono", Ubuntu, sans-serif;
      background-image: none;
      transition: 20ms;
    }

    window {
      background-color: rgba(12, 12, 12, 0.1);
    }

    button {
      color: #FFFFFF;
        font-size:20px;

        background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;

      border-style: solid;
      background-color: rgba(12, 12, 12, 0.3);
      border: 3px solid #FFFFFF;

        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
    }

    button:focus,
    button:active,
    button:hover {
        color: @color11;
      background-color: rgba(12, 12, 12, 0.5);
      border: 3px solid @color11;
    }

    /*
    -----------------------------------------------------
    Buttons
    -----------------------------------------------------
    */

    #lock {
      margin: 10px;
      border-radius: 20px;
      background-image: image(url("icons/lock.png"));
    }

    #logout {
      margin: 10px;
      border-radius: 20px;
      background-image: image(url("icons/logout.png"));
    }

    #suspend {
      margin: 10px;
      border-radius: 20px;
      background-image: image(url("icons/suspend.png"));
    }

    #hibernate {
      margin: 10px;
      border-radius: 20px;
      background-image: image(url("icons/hibernate.png"));
    }

    #shutdown {
      margin: 10px;
      border-radius: 20px;
      background-image: image(url("icons/shutdown.png"));
    }

    #reboot {
      margin: 10px;
      border-radius: 20px;
      background-image: image(url("icons/reboot.png"));
    }

  '';

  home.file.".config/wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "sleep 1; swaylock",
        "text" : "Lock",
        "keybind" : "l"
    }
    {
        "label" : "hibernate",
        "action" : "sleep 1; systemctl hibernate",
        "text" : "Hibernate",
        "keybind" : "h"
    }
    {
        "label" : "logout",
        "action" : "sleep 1; hyprctl dispatch exit",
        "text" : "Logout",
        "keybind" : "e"
    }
    {
        "label" : "shutdown",
        "action" : "sleep 1; systemctl poweroff",
        "text" : "Shutdown",
        "keybind" : "s"
    }
    {
        "label" : "suspend",
        "action" : "sleep 1; systemctl suspend",
        "text" : "Suspend",
        "keybind" : "u"
    }
    {
        "label" : "reboot",
        "action" : "sleep 1; systemctl reboot",
        "text" : "Reboot",
        "keybind" : "r"
    }
  '';
}
