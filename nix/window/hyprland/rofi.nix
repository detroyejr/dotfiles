{ config, pkgs, colorScheme, ... }:
{


  home.packages = with pkgs; [
    rofi
    rofi-power-menu
  ];

  home.file.".config/rofi".source = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "master";
    sha256 = "sha256-YjyrxappcLDoh3++mtZqCyxQV2qeoNhhUy2XGwlyTng=";
  } + "/files";
 
  # home.file.".config/rofi/colors.rasi".text = with colorScheme.colors; ''
  #   * {
  #       accent: #${base06};
  #       bg-col-light: #${base09};
  #       bg-col:  #${base00};
  #       blue: #${base0D};
  #       border-col: #${base04};
  #       fg-col2: #e78284;
  #       fg-col: #c6d0f5;
  #       grey: #737994;
  #       selected-col: #${base02};
  #       separatorcolor: #e78284;
  #       width: 600;
  #       height: 400;
  #       font: "BlexMono Nerd Font Mono, monospace 16";
  #   }
  #
  #   element-text, element-icon , mode-switcher {
  #       background-color: inherit;
  #       text-color:       inherit;
  #   }
  #
  #   window {
  #       height: @width;
  #       border: 1px;
  #       border-color: @border-col;
  #       border-radius: 40px;
  #       background-color: @bg-col;
  #   }
  #
  #   mainbox {
  #       background-color: @bg-col;
  #   }
  #
  #   inputbar {
  #       children: [prompt,entry];
  #       background-color: @bg-col;
  #       border-radius: 5px;
  #       padding: 2px;
  #   }
  #
  #   prompt {
  #       background-color: @blue;
  #       padding: 6px;
  #       text-color: @bg-col;
  #       border-radius: 3px;
  #       margin: 20px 0px 0px 20px;
  #   }
  #
  #   textbox-prompt-colon {
  #       expand: false;
  #       str: ":";
  #   }
  #
  #   entry {
  #       padding: 6px;
  #       margin: 20px 0px 0px 10px;
  #       text-color: @fg-col;
  #       background-color: @bg-col;
  #   }
  #
  #   listview {
  #       border: 0px 0px 0px;
  #       padding: 6px 0px 0px;
  #       margin: 10px 0px 0px 20px;
  #       columns: 1;
  #       lines: 10;
  #       background-color: @bg-col;
  #   }
  #
  #   element {
  #       padding: 5px;
  #       background-color: @bg-col;
  #       text-color: @fg-col  ;
  #   }
  #
  #   element-icon {
  #       size: 25px;
  #   }
  #
  #   element selected {
  #       background-color:  @selected-col ;
  #       text-color: @fg-col2  ;
  #   }
  #
  #   mode-switcher {
  #       spacing: 0;
  #     }
  #
  #   button {
  #       padding: 10px;
  #       background-color: @bg-col-light;
  #       text-color: @grey;
  #       vertical-align: 0.5;
  #       horizontal-align: 0.5;
  #   }
  #
  #   button selected {
  #     background-color: @bg-col;
  #     text-color: @blue;
  #   }
  #
  #   message {
  #       background-color: @bg-col-light;
  #       margin: 2px;
  #       padding: 2px;
  #       border-radius: 5px;
  #   }
  #
  #   textbox {
  #       padding: 6px;
  #       margin: 20px 0px 0px 20px;
  #       text-color: @blue;
  #       background-color: @bg-col-light;
  #   }
  #
  # '';
}
