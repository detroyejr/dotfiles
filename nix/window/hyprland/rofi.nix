{config, pkgs, colorScheme, ...}:
{
  programs.rofi = {
    enable = true;
    theme = "colors";
  };


  home.packages = with pkgs; [
    rofi-power-menu
  ];
 
  home.file.".config/rofi/colors.rasi".text = with colorScheme.colors; ''
    * {
        accent: #${base06};
        bg-col-light: #${base09};
        bg-col:  #${base00};
        blue: #${base0D};
        border-col: #${base04};
        fg-col2: #e78284;
        fg-col: #c6d0f5;
        grey: #737994;
        selected-col: #${base02};
        separatorcolor: #e78284;
        width: 1200;
        height: 1200;
        font: "BlexMono Nerd Font Mono, monospace 30";
    }

    element-text, element-icon , mode-switcher {
        background-color: inherit;
        text-color:       inherit;
    }

    window {
        height: 650px;
        border: 1px;
        border-color: @border-col;
        border-radius: 40px;
        background-color: @bg-col;
    }

    mainbox {
        background-color: @bg-col;
    }

    inputbar {
        children: [prompt,entry];
        background-color: @bg-col;
        border-radius: 5px;
        padding: 2px;
    }

    prompt {
        background-color: @blue;
        padding: 6px;
        text-color: @bg-col;
        border-radius: 3px;
        margin: 20px 0px 0px 20px;
    }

    textbox-prompt-colon {
        expand: false;
        str: ":";
    }

    entry {
        padding: 6px;
        margin: 20px 0px 0px 10px;
        text-color: @fg-col;
        background-color: @bg-col;
    }

    listview {
        border: 0px 0px 0px;
        padding: 6px 0px 0px;
        margin: 10px 0px 0px 20px;
        columns: 1;
        lines: 10;
        background-color: @bg-col;
    }

    element {
        padding: 5px;
        background-color: @bg-col;
        text-color: @fg-col  ;
    }

    element-icon {
        size: 25px;
    }

    element selected {
        background-color:  @selected-col ;
        text-color: @fg-col2  ;
    }

    mode-switcher {
        spacing: 0;
      }

    button {
        padding: 10px;
        background-color: @bg-col-light;
        text-color: @grey;
        vertical-align: 0.5; 
        horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @blue;
    }

    message {
        background-color: @bg-col-light;
        margin: 2px;
        padding: 2px;
        border-radius: 5px;
    }

    textbox {
        padding: 6px;
        margin: 20px 0px 0px 20px;
        text-color: @blue;
        background-color: @bg-col-light;
    }

  '';

  home.file.".config/networkmanager-dmenu/config.ini".text = ''
    ## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
    ## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

    [dmenu]
    dmenu_command = rofi -dmenu -theme ~/.config/rofi/wifi.rasi
    # # Note that dmenu_command can contain arguments as well like `rofi -width 30`
    # # Rofi and dmenu are set to case insensitive by default `-i`
    # l = number of lines to display, defaults to number of total network options
    # fn = font string
    # nb = normal background (name, #RGB, or #RRGGBB)
    # nf = normal foreground
    # sb = selected background
    # sf = selected foreground
    # b =  (just set to empty value and menu will appear at the bottom
    # m = number of monitor to display on
    # p = Custom Prompt for the networks menu
    # pinentry = Pinentry command
    rofi_highlight = True
    compact = True

    # # override normal foreground and background colors (dmenu) or use the
    # # -password option (rofi) to obscure passphrase entry
    # [dmenu_passphrase]
    # nf = #222222
    j# nb = #222222
    # rofi_obscure = True

    [editor]
    terminal = kitty
    gui_if_available = True
    # terminal = <name of terminal program>
    # gui_if_available = <True or False>
    '';

    home.file.".config/rofi/wifi.rasi".text = with colorScheme.colors; ''

    @import "colors.rasi"

    configuration {
      show-icons:		false;
      sidebar-mode: 	false;
      hover-select: true;
      me-select-entry: "";
      me-accept-entry: [MousePrimary];
    }
    *{
      font: "BlexMono Nerd Font Mono, monospace 11";
      //Colors
      foreground:#f8f8f2; 				//Text
      accent: @selected; 					//Highlight
      foreground-selection:@fg-col; 	//Selection_fg
      background-selection: @selected; 		//Selection_bg

      transparent:					#ffffff00;
      background-color:				@transparent;
      text-color:						@fg-col;
      selected-normal-foreground:		@fg-col-light;
      normal-foreground:       		@fg-col;
      alternate-normal-background:	@transparent;
      selected-urgent-foreground:  	@fg-col;
      urgent-foreground:           	@fg-col;
      alternate-urgent-background: 	@bg-col;
      active-foreground:           	@accent;
      selected-active-foreground:  	@bg-col-light;
      alternate-normal-foreground: 	@fg-col;
      alternate-active-background: 	@bg-col;
      bordercolor:                 	@bg-col;
      normal-background:           	@transparent;
      selected-normal-background:  	@bg-col-light;
      separatorcolor:              	@accent;
      urgent-background:           	@accent;
      alternate-urgent-foreground: 	@fg-col;
      selected-urgent-background:  	@accent;
      alternate-active-foreground: 	@fg-col;
      selected-active-background:  	@transparent;
      active-background:           	@transparent;
    }
    window {
        width:                          400px;
      text-color:			@fg-col;
      background-color:	@bg-col;
      border-radius: 		20px;
      padding: 			18;
    }
    mainbox {
      border:		0;
      padding: 	0;
    }
    textbox {
      text-color: @fg-col;
    }
    listview {
        columns:                        1;
        lines:							15;
        spacing:                        4px;
        cycle:                          true;
        dynamic:                        true;
        layout:                         vertical;
        text-color:		#${base06};
    }
    element {
      border:			0;
      padding:		18px 18px;
      border-radius:	100%;
    }
    element-text {
      padding:		0;
      background-color: none;
      text-color:       inherit;
    }
    element.normal.normal {
      text-color:			@normal-foreground;
      background-color:	@normal-background;
    }
    element.normal.urgent {
      text-color:			@urgent-foreground;
      background-color:	@urgent-background;
    }
    element.normal.active {
      text-color:			@active-foreground;
      background-color:	@backgroundAdditional;
    }
    element.selected.normal {
      text-color:			@selected-normal-foreground;
      background-color:	@selected-normal-background;
    }
    element.selected.urgent {
      text-color:			@selected-urgent-foreground;
      background-color:	@selected-urgent-background;
    }
    element.selected.active {
      text-color:			@fg-col;
      background-color:	@accent;
    }
    element.alternate.normal {
      text-color:			@alternate-normal-foreground;
      background-color:	@alternate-normal-background;
    }
    element.alternate.urgent {
      text-color:			@alternate-urgent-foreground;
      background-color:	@alternate-urgent-background;
    }
    element.alternate.active {
      text-color:			@alternate-active-foreground;
      background-color:	@alternate-active-background;
    }
    mode-switcher {
      border:	0;
    }
    button selected {
      text-color:			@selected-normal-foreground;
      background-color:	@selected-normal-background;
    }
    button normal {
      text-color:	@fg-col;
    }

    inputbar {
      children: [textbox-prompt-colon,entry];
    }

    textbox-prompt-colon{
      expand:	false;
      margin: 0 0 20px 0;
      str:	":";
    }

    entry {
      placeholder:	"";
    }
    '';
}
