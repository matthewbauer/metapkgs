let
  mapAttrs = f: set: builtins.listToAttrs (
      map (attr: { name = attr; value = f set.${attr}; })
    (builtins.attrNames set));

  # XXX: provide a fallback for older nix versions without fetchTarball
  inherit (builtins) fetchTarball;

  channels = {
    dingo       = "15.09";
    emu         = "16.03";
    flounder    = "16.09";
    gorilla     = "17.03";
    hummingbird = "17.09";
    impala      = "18.03";
    jellyfish   = "18.09";
    koi         = "19.03";
    loris       = "19.09";
  };

  # XXX: 13.10, 14.04, and 14.12 have locale issues
  channelSets = (mapAttrs (v:
      import (fetchTarball
        "https://nixos.org/channels/nixos-${v}/nixexprs.tar.xz") {})
      channels) // {
    aardvark    = (import (fetchTarball "https://nixos.org/channels/nixos-13.10/nixexprs.tar.xz") {}).pkgs;
    baboon      = (import (fetchTarball "https://nixos.org/channels/nixos-14.04/nixexprs.tar.xz") {}).pkgs;
    caterpillar = (import (fetchTarball "https://nixos.org/channels/nixos-14.12/nixexprs.tar.xz") {}).pkgs;
  };

  ghcs = with channelSets; {
    inherit (hummingbird.haskell.compiler) ghc6104;
    ghc6121 = baboon.pkgs.haskell.packages_ghc6121.ghc;
    ghc6122 = baboon.pkgs.haskell.packages_ghc6122.ghc;
    inherit (hummingbird.haskell.compiler) ghc6123;
    ghc701 = baboon.pkgs.haskell.packages_ghc701.ghc;
    ghc702 = baboon.pkgs.haskell.packages_ghc702.ghc;
    ghc703 = baboon.pkgs.haskell.packages_ghc703.ghc;
    inherit (impala.haskell.compiler) ghc704;
    ghc721 = baboon.pkgs.haskell.packages_ghc721.ghc;
    inherit (hummingbird.haskell.compiler.ghc722);
    ghc741 = baboon.pkgs.haskell.packages_ghc741.ghc;
    inherit (impala.haskell.compiler) ghc742;
    ghc761 = baboon.pkgs.haskell.packages_ghc761.ghc;
    ghc762 = baboon.pkgs.haskell.packages_ghc762.ghc;
    inherit (impala.haskell.compiler) ghc763;
    inherit (hummingbird.haskell.compiler) ghc783;
    inherit (impala.haskell.compiler) ghc784;
    inherit (hummingbird.haskell.compiler) ghc7102;
    inherit (jellyfish.haskell.compiler) ghc7103;
    inherit (hummingbird.haskell.compiler) ghc801;
    inherit (jellyfish.haskell.compiler) ghc802;
    inherit (hummingbird.haskell.compiler) ghc821;
    inherit (koi.haskell.compiler) ghc822;
    inherit (impala.haskell.compiler) ghc841;
    inherit (jellyfish.haskell.compiler) ghc843;
    inherit (koi.haskell.compiler) ghc844;
    inherit (jellyfish.haskell.compiler) ghc861;
    inherit (jellyfish.haskell.compiler) ghc862;
    inherit (jellyfish.haskell.compiler) ghc863;
    inherit (koi.haskell.compiler) ghc864;
  };

in channelSets // ghcs
