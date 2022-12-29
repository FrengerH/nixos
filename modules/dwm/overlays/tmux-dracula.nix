self: super:

with super;

let

in
{
  tmuxPlugins.dracula = super.tmuxPlugins.dracula.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "FrengerH";
      repo = "tmux-dracula";
      rev = "32370225f2c0aa57a8563eb82ba8b3ed78f961ab";
      sha256 = "sha256-GPCC6JtCfyhCkLy9v1HW+1/cE77nZbmb1KnQw8VVP04=";
    };
  });
}
