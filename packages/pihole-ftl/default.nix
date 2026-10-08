final: prev: {
  pihole-ftl = prev.pihole-ftl.overrideAttrs (old: {
    # Upstream PR #2939 removes the unused loop index in this function.
    postPatch = (old.postPatch or "") + ''
      sed -i '/^void sanitize_dns_hosts(/,/^}/ {
        /^[[:space:]]*int i = 0;$/d
        s/, i++)/)/
      }' src/config/validator.c
    '';
  });
}
