self: super: 

with super; 

let
  stConfig = super.writeText "config.def.h" (builtins.readFile ./configs/st.conf.h);
in
{
  st = super.st.overrideAttrs(oldAttrs: rec {
    pname = "st";
    version = "0.8.5";

    src = fetchurl {
      url = "https://dl.suckless.org/st/st-${version}.tar.gz";
      sha256 = "sha256-6mgyID7QL/dBgry4raqexFTI+YnnkjLLhZZl4vVEqzc=";
    };

    buildInputs = oldAttrs.buildInputs or [] ++ [ pkgs.makeWrapper ];

    postPatch = "cp ${stConfig} config.def.h";

    patches = [
      ./patches/st.diff
    ];

  });
}
