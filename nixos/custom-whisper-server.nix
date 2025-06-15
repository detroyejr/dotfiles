{ pkgs, ... }:

let
  ggml-medium = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-medium.en.bin";
    hash = "sha256-zDfpNHgzjsdwAoGnrDChASiSnrj0J92i6GX6qPbaQ1Y=";
  };
in
{
  environment.systemPackages = [pkgs.yt-dlp];
      
  systemd.services.custom-whisper-server = {
    path = [ "${pkgs.custom-whisper-server}/bin:${pkgs.yt-dlp}/bin:/run/wrappers/bin/:$PATH" ];
    script = ''
      ls "${ggml-medium}"
      TEMP=$(mktemp -d)
      ${pkgs.custom-whisper-server}/bin/custom-whisper-server \
        --model "${ggml-medium}" \
        --paths $TEMP
        --output-dir "/home/detroyejr/Documents/Personal/Reading/Podcasts & Lectures/" \
        --threads 6
    '';
    wantedBy = [ "multi-user.target" ];
  };

}
