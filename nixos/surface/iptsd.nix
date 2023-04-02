{config, pkgs, ...}:
let
  # For iptsd 0.5.1
  pkg-0_5_1 = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/ee01de29d2f58d56b1be4ae24c24bd91c5380cea.tar.gz";
      # Hash obtained using `nix-prefetch-url --unpack <url>`

      sha256 = "0829fqp43cp2ck56jympn5kk8ssjsyy993nsp0fjrnhi265hqps7";
    })
    {
      system = "x86_64-linux";
    };
in
{
  systemd.services.iptsd = {
    description = "IPTSD";
    path = [
      pkg-0_5_1.iptsd
    ];
    script = "iptsd";
    wantedBy = [ "multi-user.target" ];
  };
}
