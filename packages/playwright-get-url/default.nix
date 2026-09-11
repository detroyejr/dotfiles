final: prev: {
  playwright-get-url = prev.stdenvNoCC.mkDerivation (attrs: {
    name = "playwright-get-url";
    version = "0.1";
    dontUnpack = true;
    buildInputs = with prev; [
      makeWrapper
    ];
    python = prev.python3.withPackages (ps: [ ps.playwright ]);

    script = prev.writeText "playwright-get-url.py" ''
      import argparse
      import os
      from playwright.sync_api import sync_playwright

      args = argparse.ArgumentParser()
      args.add_argument("url")
      args.add_argument("--wait", default=5)
      opts = args.parse_args()
      urls = opts.url.split(",")

      with sync_playwright() as p:
          browser = p.chromium.launch(headless=False)
          page = browser.new_page()
          for url in urls:
              page.goto(url)
              page.wait_for_timeout(int(opts.wait) * 1000)
          print(page.content())
          browser.close()
    '';

    installPhase = ''
      mkdir $out/bin -p
      makeWrapper ${prev.xvfb-run}/bin/xvfb-run $out/bin/playwright-get-url \
        --add-flags ${attrs.python}/bin/python \
        --add-flags ${attrs.script} \
        --set PLAYWRIGHT_BROWSERS_PATH ${prev.playwright-driver.browsers}
    '';
  });
}
