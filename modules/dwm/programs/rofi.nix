{ config, pkgs }:

let
  font = (builtins.readFile ../theme/font.rasi);
  colors = (builtins.readFile ../theme/colors.rasi);
  launcherTheme = builtins.toFile "rofi-theme.rasi" (font + colors + builtins.readFile ../theme/rofi-theme.rasi);
  searchTheme = builtins.toFile "rofi-search.rasi" (font + colors + builtins.readFile ../theme/rofi-search.rasi);
  powerMenuTheme = builtins.toFile "power-menu.rasi" (font + colors + builtins.readFile ../theme/power-menu.rasi);
  confirmTheme = builtins.toFile "confirm.rasi" (font + colors + builtins.readFile ../theme/confirm.rasi);
  askPassTheme = builtins.toFile "askpass.rasi" (font + colors + builtins.readFile ../theme/askpass.rasi);
in
  {
    launcher = pkgs.writeShellScriptBin "launcher" ''
      rofi -theme ${launcherTheme} -show drun       
    '';

    rofi-ssh = pkgs.writeShellScriptBin "rofi-ssh" ''
      rofi -theme ${launcherTheme} -show fb -modi "fb:/home/${config.defaultUser}/work/scripts/rofissh/result/bin/rofissh"
    '';

    rofi-projects = pkgs.writeShellScriptBin "rofi-projects" ''
      rofi -theme ${launcherTheme} -kb-custom-1 "Ctrl+s" -show fb -modi "fb:/home/${config.defaultUser}/work/scripts/rofiprojects/result/bin/rofiprojects"
    '';

    rofi-ff = pkgs.writeShellScriptBin "rofi-ff" ''
      rofi -theme ${searchTheme} -show fb -modi "fb:/home/${config.defaultUser}/work/scripts/rofiff/result/bin/rofiff"
    '';

    power-menu = pkgs.writeShellScriptBin "power-menu" ''
      THEME="${powerMenuTheme}"

      rofi_command="rofi -theme $THEME"

      uptime=$(uptime -p | sed -e 's/up //g')

      # Options
      if [[ "$DIR" == "powermenus" ]]; then
          shutdown="󰐥"
          reboot="󰜉"
          lock="󰌾"
          suspend="󰒲"
          logout="󰗽 "
      else

      # For some reason the Icons are mess up I don't know why but to fix it uncomment section 2 and comment section 1 but if the section 1 icons are mess up uncomment section 2 and comment section 1

          # Buttons
          layout=`cat $THEME | grep BUTTON | cut -d'=' -f2 | tr -d '[:blank:],*/'`
          if [[ "$layout" == "TRUE" ]]; then
            # Section 2
                shutdown="󰐥"
                reboot="󰜉"
                lock="󰌾"
                suspend="󰒲"
                logout="󰗽 "


          else
            # Section 2
                shutdown="󰐥 Shutdown"
                reboot="󰜉 Restart"
                lock="󰌾 Lock"
                suspend="󰒲 Sleep"
                logout="󰗽 Logout"
          fi
      fi

      # Ask for confirmation
      rdialog () {
      rofi -dmenu\
          -i\
          -no-fixed-num-lines\
          -p "Are You Sure? : "\
          -theme "${confirmTheme}"
      }

      # Display Help
      show_msg() {
          rofi -theme "${askPassTheme}" -e "Options : yes / no / y / n"
      }

      # Variable passed to rofi
      options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

      chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 0)"
      case $chosen in
          $shutdown)
              ans=$(rdialog &)
              if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
                  systemctl poweroff
              elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
                  exit
              else
                  show_msg
              fi
              ;;
          $reboot)
              ans=$(rdialog &)
              if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
                  systemctl reboot
              elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
                  exit
              else
                  show_msg
              fi
              ;;
          $lock)
              sh $(which light-locker-command) -l
              ;;
          $suspend)
              ans=$(rdialog &)
              if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
                  systemctl suspend
              elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
                  exit
              else
                  show_msg
              fi
              ;;
          $logout)
              ans=$(rdialog &)
              if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
                  sh loginctl kill-session $XDG_SESSION_ID
              elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
                  exit
              else
                  show_msg
              fi
              ;;
      esac

    '';
  }
