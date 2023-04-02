{config, pkgs, colorScheme, ...}:
{
  home.packages = with pkgs; [
    swaylock-effects
  ];

  home.file.".config/swaylock/lock.sh".text = with colorScheme.colors; ''
    swaylock \
      --config $HOME/.config/swaylock/swaylock.conf \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 100 \
      --indicator-thickness 7 \
      --effect-blur 7x5 \
      --effect-vignette 0.5:0.5 \
      --ring-color ${base0B} \
      --key-hl-color ${base03} \
      --line-color ${base03} \
      --inside-color ${base03} \
      --separator-color ${base03} \
  '';
  
  home.file.".config/swaylock/swaylock.conf".text = ''
  ignore-empty-password
  '';

}
