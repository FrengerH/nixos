self: super:

with super;

let
  calendar = super.writeShellScriptBin "calendar" (builtins.readFile ../scripts/dwmblocks/calendar.sh);
  battery = super.writeShellScriptBin "battery" (builtins.readFile ../scripts/dwmblocks/battery.sh);
  power = super.writeShellScriptBin "power" (builtins.readFile ../scripts/dwmblocks/power.sh);

  configFile = super.writeText "config.h" ''
    static Block blocks[] = {
    /*      pathu                                       interval        signal */
      BLOCK("${calendar.outPath}/bin/calendar",         30,             3),
      BLOCK("${battery.outPath}/bin/battery",          0,             4),
      BLOCK("${power.outPath}/bin/power power-menu",    30,             5)
    };

    // Maximum possible length of output from block, expressed in number of characters.
    #define CMDLENGTH 50

    // The status bar's delimiter which appears in between each block.
    #define DELIMITER "  "

    // Adds a leading delimiter to the statusbar, useful for powerline.
    #define LEADING_DELIMITER

    // Enable clickability for blocks. Needs `dwm` to be patched appropriately.
    // See the "Clickable blocks" section below.
    #define CLICKABLE_BLOCKS
  '';
in
{
  dwmblocks = super.dwmblocks.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "UtkarshVerma";
      repo = "dwmblocks-async";
      rev = "3e4e4dbbbe4680f9f71401b993070d6d1cbeca00";
      sha256 = "sha256-98jNhV1HvWKHucIHxD/8Q0rz74vu5W3MQ4Nd7LmwDyA=";
    };

    postPatch = "cp ${configFile} config.h";

  });
}
