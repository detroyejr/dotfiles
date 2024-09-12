{
  config,
  pkgs,
  colorScheme,
  wallpaper,
  ...
}:
{
  home.packages = with pkgs; [
    swaylock-effects
    wlogout
  ];

  home.file.".config/swaylock/config".text = with colorScheme.colors; ''
    font="BlexMono Nerd Font Mono"

    clock
    timestr=%R
    datestr=%a, %e of %B

    # Add current screenshot as wallpaper
    #screenshots

    # Add an image as a background
    image="${builtins.toString wallpaper}"

    # Show/Hide indicator circle
    indicator

    # smaller indicator
    indicator-radius=100

    # bigger indicator
    # indicator-radius=300

    indicator-thickness=5
    indicator-caps-lock

    # Define all colors

    key-hl-color=00000066
    separator-color=#${base03}

    inside-color=#${base03}
    inside-clear-color=ffffff00
    inside-caps-lock-color=ffffff00
    inside-ver-color=ffffff00
    inside-wrong-color=ffffff00

    ring-color=#${base07}
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
    * {
      background-image: none;
    }

    window {
      background-color: rgba(12, 12, 12, 0.9);
    }

    button {
      color: #FFFFFF;
      background-color: #1E1E1E;
      border-style: solid;
      border-width: 2px;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
    }

    button:focus, button:active, button:hover {
      background-color: #3700B3;
      outline-style: none;
    }

    #lock {
        background-image: image(url("/home/detroyejr/.config/dotfiles/dotfiles/wlogout/icons/lock.png"));
    }

    #logout {
        background-image: image(url("/home/detroyejr/.config/dotfiles/dotfiles/wlogout/icons/logout.png"));
    }

    #suspend {
        background-image: image(url("/home/detroyejr/.config/dotfiles/dotfiles/wlogout/icons/suspend.png"));
    }

    #hibernate {
        background-image: image(url("/home/detroyejr/.config/dotfiles/dotfiles/wlogout/icons/hibernate.png"));
    }

    #shutdown {
        background-image: image(url("/home/detroyejr/.config/dotfiles/dotfiles/wlogout/icons/shutdown.png"));
    }

    #reboot {
        background-image: image(url("/home/detroyejr/.config/dotfiles/dotfiles/wlogout/icons/reboot.png"));
    }

  '';

  home.file.".config/wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "sleep 1; hyprlock",
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
