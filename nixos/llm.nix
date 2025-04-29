{ pkgs, ... }:

let
  models = pkgs.linkFarm "llm-models" {
  "Qwen3-32B-Q3_K_M.gguf" = pkgs.fetchurl {
    name = "Qwen3-32B-Q3_K_M.gguf";
    url = "https://huggingface.co/unsloth/Qwen3-32B-GGUF/resolve/main/Qwen3-32B-Q3_K_M.gguf?download=true";
    sha256 = "sha256-84s/xfEHxz3VbvdQ+JfkYZYTthcEgg1Y1S8uwPcC6zM=";
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
  services.llama-cpp.enable = false;
  services.llama-cpp.model = "${models}/Qwen3-32B-Q3_K_M.gguf";
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
  services.llama-cpp.port = 11434; # Default for ollama.
  services.llama-cpp.host = "0.0.0.0";
}
