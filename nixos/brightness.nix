{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [86];
        events = ["key"];
        command = "/run/current-system/sw/bin/brightnessctl set +10%";
      }
      {
        keys = [87];
        events = ["key"];
        command = "/run/current-system/sw/bin/brightnessctl set -10%";
      }
    ];
  };
}
