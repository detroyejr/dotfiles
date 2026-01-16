{ ... }:
{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;

    age = {
      sshKeyPaths = [ "/home/detroyejr/.ssh/main_server_ed25519" ];
      keyFile = "/home/detroyejr/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };
}
