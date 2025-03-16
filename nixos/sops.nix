{ config, ... }:
{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/home/detroyejr/.ssh/main_server_ed25519" ];

  sops.age.keyFile = "/home/detroyejr/.config/sops/age/keys.txt";

  sops.age.generateKey = true;
}
