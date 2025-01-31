{ pkgs, ... }:

let
  models = pkgs.linkFarm "llm-models" {
  "DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf" = pkgs.fetchurl {
    name = "DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf";
    url = "https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf?download=true";
    sha256 = "sha256-cx7OjQbcftpvZXKZf+ue4SWNsHhIJ+ZCkJ2bVlZBk3s=";
  };
};
in
{
  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    llama-cpp
    pkgs.python3Packages.huggingface-hub 
  ];

  # Ollama.
  services.ollama.enable = false;
  services.ollama.host = "0.0.0.0";

  # Llama CPP
  services.llama-cpp.enable = true;

  services.llama-cpp.model = "${models}/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf";
  services.llama-cpp.extraFlags = [
    "--temp"
    "0.6" # recommended for R1
    "-ngl"
    "99"
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
  services.llama-cpp.port = 11434; # Default for ollama.
  services.llama-cpp.host = "0.0.0.0";
}
