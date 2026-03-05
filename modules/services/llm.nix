{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.llm;

  models = pkgs.linkFarm "llm-models" {
    "Qwen3-30B-A3B-GGUF.gguf" = pkgs.fetchurl {
      name = "Qwen3-30B-A3B-GGUF.gguf";
      url = "https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF/resolve/main/Qwen3-30B-A3B-UD-IQ1_S.gguf?download=true";
      sha256 = "";
    };
  };
in
{
  options.services.llm.enable = lib.mkEnableOption "llm service module";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rocmPackages.rocminfo
      llama-cpp
      pkgs.python3Packages.huggingface-hub
    ];

    services.llama-cpp.enable = true;
    services.llama-cpp.model = "${models}/Qwen3-30B-A3B-GGUF.gguf";
    services.llama-cpp.extraFlags = [
      "-ngl"
      "99"
      "--temp"
      "0.7"
      "-fa"
      "-ub"
      "1024"
      "-b"
      "1024"
      "--ctx-size"
      "0"
      "--cache-reuse"
      "256"
    ];
    services.llama-cpp.port = 11434;
    services.llama-cpp.host = "0.0.0.0";
  };
}
