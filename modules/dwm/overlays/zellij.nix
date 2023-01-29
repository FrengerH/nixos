self: super:

with super;

let
in
{
  zellij = super.zellij.overrideAttrs(oldAttrs: rec {
    pname = "zellij";
    # version = "0.34.4";
    
    # src = fetchFromGitHub {
    #   owner = "FrengerH";
    #   repo = "zellij";
    #   rev = "27c219d5296c6bfc0529c5930281cfaa50215848";
    #   sha256 = "sha256-bYNqtiF88xJp6si3iYpMQqhIwiLRSLeSwSxYhCq69jQ=";
    # };

    # cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
    #   inherit src; # You need to pass "src" here again,
    #                # otherwise the old "src" will be used.
    #   outputHash = "sha256-Bxm0hvdxhDZiVWWfxuedkb46YzbEvYrCgQ1IOY0pJZA=";
    # });

    # cargoPatches = [
    #   "./patches/zellij-compact.diff"
    # ];

  });
}

