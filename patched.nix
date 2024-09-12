{ system, nixpkgs, ... }:
{ }

# You should use overrides, but in some rare cases this works better.
# let
#   base = nixpkgs.legacyPackages.${system};
# in
# {
#   patched = (import nixpkgs { inherit system; }).applyPatches {
#     name = "patched";
#     src = nixpkgs;
#     patches = [
#       (base.fetchpatch {
#         url = "https://github.com/NixOS/nixpkgs/pull/341226.patch";
#         hash = "sha256-asnviq/pGFUg1iSbcH+IqfaocODRnMAcTfPyU48CImo=";
#       })
#     ];
#   };
# }
