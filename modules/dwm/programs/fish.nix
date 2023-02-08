{
  enable = true;
  shellAliases = {
    l="ls -lvh";
    ll="ls -lvAh";

    conf="cd ~/.config";

    ssh="TERM=xterm-256color /usr/bin/env ssh";

    # j="fasd_cd -d";     # cd, same functionality as j in autojump
    cat="bat -p";

  };
  shellInit = ''
    zoxide init fish | source
    set -gx XDG_CONFIG_HOME ~/.config/

    set -g fish_term24bit 1

    # preferred_background: 1e1e2e

    # Dracula Color Palette
    set -l foreground cdd6f4    #cdd6f4
    set -l selection 45475a     #45475a
    set -l comment 89b4fa       #89b4fa
    set -l red f38ba8           #f38ba8
    set -l orange fab387        #fab387
    set -l yellow f9e2af        #f9e2af
    set -l green a6e3a1         #a6e3a1
    set -l purple cba6f7        #cba6f7
    set -l cyan 74c7ec          #74c7ec
    set -l pink f5c2e7          #f5c2e7

    # Syntax Highlighting Colors
    set -gx fish_color_normal $foreground
    set -gx fish_color_command $cyan
    set -gx fish_color_keyword $pink
    set -gx fish_color_quote $yellow
    set -gx fish_color_redirection $foreground
    set -gx fish_color_end $orange
    set -gx fish_color_error $red
    set -gx fish_color_param $purple
    set -gx fish_color_comment $comment
    set -gx fish_color_selection --background=$selection
    set -gx fish_color_search_match --background=$selection
    set -gx fish_color_operator $green
    set -gx fish_color_escape $pink
    set -gx fish_color_autosuggestion $comment
    set -gx fish_color_cancel $red --reverse
    set -gx fish_color_option $orange

    # Default Prompt Colors
    set -gx fish_color_cwd $green
    set -gx fish_color_host $purple
    set -gx fish_color_host_remote $purple
    set -gx fish_color_user $cyan

    # Completion Pager Colors
    set -gx fish_pager_color_progress $comment
    set -gx fish_pager_color_background
    set -gx fish_pager_color_prefix $cyan
    set -gx fish_pager_color_completion $foreground
    set -gx fish_pager_color_description $comment
    set -gx fish_pager_color_selected_background --background=$selection
    set -gx fish_pager_color_selected_prefix $cyan
    set -gx fish_pager_color_selected_completion $foreground
    set -gx fish_pager_color_selected_description $comment
    set -gx fish_pager_color_secondary_background
    set -gx fish_pager_color_secondary_prefix $cyan
    set -gx fish_pager_color_secondary_completion $foreground
    set -gx fish_pager_color_secondary_description $comment


    set -U fish_cursor_default block
    set -U fish_cursor_insert line
    set -U fish_cursor_replace_one underscore
    set -U fish_cursor_visual block
    set -U fish_cursor_unknow line

    function fish_mode_prompt
      switch $fish_bind_mode
        case default
          echo -en "\e[2 q"
          set_color -o red #red
          echo "[N] "
        case insert
          echo -en "\e[6 q"
          set_color -o green #green
          echo "[I] "
        case replace_one
          echo -en "\e[4 q"
          set_color -o yellow #yellow
          echo "[R] "
        case visual
          echo -en "\e[2 q"
          set_color -o purple #magenta
          echo "[V] "
        case '*'
          echo -en "\e[2 q"
          set_color -o red #red
          echo "[?] "
      end
      set_color normal
    end

    ##if status is-interactive
    #    if string match -q -- 'tmux*' $TERM
    #        set -g fish_vi_force_cursor 1
    #    end
    ##end

    function fish_user_key_bindings
      fish_vi_key_bindings --no-erase insert
      bind -M insert \cn accept-autosuggestion
      bind --preset -M insert \cl echo test
      #  bind --erase --preset -M insert \cl echo test
      bind -m insert v 'tmux copy-mode; commandline -f repaint-mode'
    end

    # function fasd_cd -d "fasd builtin cd"
    #   if test (count $argv) -le 1
    #     command fasd "$argv"
    #   else
    #     fasd -e 'printf %s' $argv | read -l ret
    #     test -z "$ret"; and return
    #     test -d "$ret"; and cd "$ret"; or printf "%s\n" $ret
    #   end
    # end

    # function update_fasd_db --on-event fish_preexec -d "fasd takes record of the directories changed into"
    #     command fasd --proc (command fasd --sanitize "$argv") > "/dev/null" 2>&1
    # end

    function last_history_item; echo $history[1]; end
    abbr -a !! --position anywhere --function last_history_item

    function fish_greeting
    end
  '';
}
