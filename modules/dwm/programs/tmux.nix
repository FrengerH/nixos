{ pkgs }:

{
  enable = true;
  plugins = with pkgs.tmuxPlugins; [
    dracula
  ];
  extraConfig = ''
    unbind C-b
    set-option -g prefix C-a
    set -g mouse on

    set -g history-limit 50000

    unbind C-l

    set -g set-clipboard on

    set -g window-size largest

    set -ga terminal-overrides ",st-256color"
    # set -g default-terminal "tmux-256color"
    # set -g default-terminal "xterm-256color"
    # set-option -ga terminal-overrides ",xterm-256color:Tc"
    set -g default-terminal "tmux-256color"
    set -ga terminal-overrides ",*256col*:Tc"

    set -g escape-time 10

    set-option -g repeat-time 0

    set -g monitor-activity on
    set -g visual-activity on 

    set -g status-interval 1

    set-option escape-time 40

    # Start windows and pane numbering with index 1 instead of 0
    set -g base-index 1
    setw -g pane-base-index 1

    # re-number windows when one is closed
    set -g renumber-windows on

    # Use vim keybindings in copy mode
    setw -g mode-keys vi

    set -g focus-events on

    bind-key -r i run-shell "tmux neww ~/.local/bin/cht.sh"

    bind-key -T copy-mode-vi v send-keys -X begin-selection; \
    bind-key -T copy-mode-vi V send-keys -X select-line; \
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle; \
    bind-key -T copy-mode-vi Escape send-keys -X cancel; \
    bind-key -T choice-mode-vi h send-keys -X tree-collapse ; \
    bind-key -T choice-mode-vi l send-keys -X tree-expand ; \
    bind-key -T choice-mode-vi H send-keys -X tree-collapse-all ; \
    bind-key -T choice-mode-vi L send-keys -X tree-expand-all ; \
    bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe "xclip -in -selection clipboard"; \
    bind-key -T copy-mode-vi y send-keys -X copy-pipe "xclip -in -selection clipboard"
  '';
}
