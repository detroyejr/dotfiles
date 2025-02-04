{ pkgs, ... }:

let
  models = pkgs.linkFarm "llm-models" {
  "Qwen2.5-Coder-1.5B-Q8_0-GGUF.gguf" = pkgs.fetchurl {
    name = "Qwen2.5-Coder-1.5B-Q8_0-GGUF.gguf";
    url = "https://huggingface.co/ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF/resolve/main/qwen2.5-coder-1.5b-q8_0.gguf?download=true";
    sha256 = "sha256-KYcclNFXJ6biQ/eaNxE9SuYlpiFbXoAL9Bojry2jKDI=";
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
  # services.ollama.enable = false;
  # services.ollama.host = "0.0.0.0";

  # Llama CPP
  services.llama-cpp.enable = true;
  services.llama-cpp.model = "${models}/Qwen2.5-Coder-1.5B-Q8_0-GGUF.gguf";
  services.llama-cpp.extraFlags = [
    "-ngl"
    "99" 
    "-fa" 
    "-ub" 
    "1024" 
    "-b" 
    "4096"
    "--ctx-size" 
    "0" 
    "--cache-reuse"
    "512"
  ];
  services.llama-cpp.port = 11434; # Default for ollama.
  services.llama-cpp.host = "0.0.0.0";
}
