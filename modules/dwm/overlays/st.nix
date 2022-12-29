self: super: 

with super; 

let
  stConfig = super.writeText "config.def.h" (builtins.readFile ./configs/st.conf.h);
  startupScript = super.writeShellScriptBin "startupScript" (builtins.readFile ../scripts/tmux-start.sh); 
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

    # src = super.fetchFromGitHub {
    #   owner = "FrengerH";
    #   repo = "st";
    #   rev = "7fb0c0cc681f36be2ad12091ef93a41671f32738";
    #   sha256 = "sha256-pULT784097GkY+rXElCCYLExJ5ORxYlJ5qeXCojUx0c=";
    # };

    patches = [
      ./patches/st.diff
    ];

    postInstall = oldAttrs.postInstall or "" + ''
      wrapProgram $out/bin/st \
        --append-flags "-e ${startupScript}/bin/startupScript" \
    '';

  });
}
