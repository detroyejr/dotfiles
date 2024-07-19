final: prev: {
  # fprintd = prev.fprintd.overrideAttrs {
  #   mesonCheckFlags = [
  #     "--no-suite"
  #     "fprintd:TestPamFprintd"
  #   ];
  # };

  # nix = prev.nix.overrideAttrs {
  #   # NOTE: Patch valid for nix v2.18.5
  #   patches = [
  #     (builtins.toFile "nice.patch" ''
  #       diff --git a/src/libstore/build/local-derivation-goal.cc b/src/libstore/build/local-derivation-goal.cc
  #       index 5ab231f24..de68d6768 100644
  #       --- a/src/libstore/build/local-derivation-goal.cc
  #       +++ b/src/libstore/build/local-derivation-goal.cc
  #       @@ -1740,6 +1740,7 @@ void LocalDerivationGoal::runChild()
  #                } catch (SysError &) { }
  #
  #        #if __linux__
  #       +        nice(15);
  #                if (useChroot) {
  #
  #                    userNamespaceSync.writeSide = -1;
  #     '')
  #   ];
  # };
}
