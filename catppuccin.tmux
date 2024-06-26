#!/usr/bin/env bash

# Set path of script
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# import
# shellcheck source=./builder/module_builder.sh
source "${PLUGIN_DIR}/builder/module_builder.sh"
# shellcheck source=./builder/window_builder.sh
source "${PLUGIN_DIR}/builder/window_builder.sh"
# shellcheck source=./builder/pane_builder.sh
source "${PLUGIN_DIR}/builder/pane_builder.sh"
# shellcheck source=./utils/tmux_utils.sh
source "${PLUGIN_DIR}/utils/tmux_utils.sh"
# shellcheck source=./utils/interpolate_utils.sh
source "${PLUGIN_DIR}/utils/interpolate_utils.sh"
# shellcheck source=./utils/module_utils.sh
source "${PLUGIN_DIR}/utils/module_utils.sh"

main() {
  # Aggregate all commands in one array
  local tmux_commands=()

  # Aggregate all tmux option for tmux_batch_option
  local tmux_batch_options_commands=()
  local tmux_batch_options=()

  # Set default batch options
  set_tmux_batch_option_default "@catppuccin_custom_plugin_dir" "${PLUGIN_DIR}/custom"
  set_tmux_batch_option_default "@catppuccin_flavour" "mocha"
  set_tmux_batch_option_default "@catppuccin_status_default" "on"
  set_tmux_batch_option_default "@catppuccin_status_justify" "left"
  set_tmux_batch_option_default "@catppuccin_status_background" "theme"
  set_tmux_batch_option_default "@catppuccin_pane_status_enabled" "no"
  set_tmux_batch_option_default "@catppuccin_pane_border_status" "off"
  set_tmux_batch_option_default "@catppuccin_pane_left_separator" "█"
  set_tmux_batch_option_default "@catppuccin_pane_middle_separator" "█"
  set_tmux_batch_option_default "@catppuccin_pane_right_separator" "█"
  set_tmux_batch_option_default "@catppuccin_pane_number_position" "left"
  set_tmux_batch_option_default "@catppuccin_window_separator" ""
  set_tmux_batch_option_default "@catppuccin_window_left_separator" "█"
  set_tmux_batch_option_default "@catppuccin_window_right_separator" "█"
  set_tmux_batch_option_default "@catppuccin_window_middle_separator" "█ "
  set_tmux_batch_option_default "@catppuccin_window_number_position" "left"
  set_tmux_batch_option_default "@catppuccin_window_status_enable" "no"
  set_tmux_batch_option_default "@catppuccin_status_left_separator" ""
  set_tmux_batch_option_default "@catppuccin_status_right_separator" "█"
  set_tmux_batch_option_default "@catppuccin_status_connect_separator" "yes"
  set_tmux_batch_option_default "@catppuccin_status_fill" "icon"
  set_tmux_batch_option_default "@catppuccin_status_modules_left" ""
  set_tmux_batch_option_default "@catppuccin_status_modules_right" "application session"

  run_tmux_batch_commands

  # module directories
  local custom_path modules_custom_path modules_status_path modules_window_path modules_pane_path
  custom_path="$(get_tmux_batch_option "@catppuccin_custom_plugin_dir")"
  modules_custom_path=$custom_path
  modules_status_path=$PLUGIN_DIR/status
  modules_window_path=$PLUGIN_DIR/window
  modules_pane_path=$PLUGIN_DIR/pane

  # load local theme
  local theme
  local color_interpolation=()
  local color_values=()
  local temp
  theme="$(get_tmux_batch_option "@catppuccin_flavour")"
  # NOTE: Pulling in the selected theme by the theme that's being set as local
  # variables.
  # https://github.com/dylanaraps/pure-sh-bible#parsing-a-keyval-file
  # shellcheck source=./catppuccin-frappe.tmuxtheme
  while IFS='=' read -r key val; do
    # Skip over lines containing comments.
    # (Lines starting with '#').
    [ "${key##\#*}" ] || continue

    # '$key' stores the key.
    # '$val' stores the value.
    eval "local $key"="$val"

    # TODO: Find a better way to strip the quotes from `$val`
    temp="${val%\"}"
    temp="${temp#\"}"
    color_interpolation+=("\#{$key}")
    color_values+=("${temp}")
  done <"${PLUGIN_DIR}/themes/catppuccin_${theme}.tmuxtheme"

  # Set default batch options that need color codes
  set_tmux_batch_option_default "@catppuccin_pane_border_style" "fg=${thm_gray}"
  set_tmux_batch_option_default "@catppuccin_pane_active_border_style" \
    "#{?pane_in_mode,fg=${thm_yellow},#{?pane_synchronized,fg=${thm_magenta},fg=${thm_orange}}}"

  # Set default batch options for _always_ used in _always_ ran modules
  # ./pane/pane_default_format.sh
  set_tmux_batch_option_default "@catppuccin_pane_color" "$thm_green"
  set_tmux_batch_option_default "@catppuccin_pane_background_color" "$thm_gray"
  set_tmux_batch_option_default "@catppuccin_pane_default_text" "#{b:pane_current_path}"
  set_tmux_batch_option_default "@catppuccin_pane_default_fill" "number"
  # ./window/window_default_format.sh
  set_tmux_batch_option_default "@catppuccin_window_default_color" "$thm_blue"
  set_tmux_batch_option_default "@catppuccin_window_default_background" "$thm_gray"
  set_tmux_batch_option_default "@catppuccin_window_default_text" "#{b:pane_current_path}"
  set_tmux_batch_option_default "@catppuccin_window_default_fill" "number"
  # ./window/window_current_format.sh
  set_tmux_batch_option_default "@catppuccin_window_current_color" "$thm_orange"
  set_tmux_batch_option_default "@catppuccin_window_current_background" "$thm_bg"
  set_tmux_batch_option_default "@catppuccin_window_current_text" "#{b:pane_current_path}"
  set_tmux_batch_option_default "@catppuccin_window_current_fill" "number"

  run_tmux_batch_commands

  # status general
  local status_default status_justify status_background message_background
  status_default=$(get_tmux_batch_option "@catppuccin_status_default")
  # shellcheck disable=SC2121
  set status "$status_default"

  status_justify=$(get_tmux_batch_option "@catppuccin_status_justify")
  set status-justify "$status_justify"

  status_background=$(get_tmux_batch_option "@catppuccin_status_background")
  if [ "${status_background}" = "theme" ]; then
    set status-bg "${thm_bg}"
    message_background="${thm_gray}"
  else
    if [ "${status_background}" = "default" ]; then
      set status-style bg=default
      message_background="default"
    else
      message_background="$(do_color_interpolation "$status_background")"
      set status-bg "${message_background}"
    fi
  fi

  set status-left-length "100"
  set status-right-length "100"

  # messages
  set message-style "fg=${thm_cyan},bg=${message_background},align=centre"
  set message-command-style "fg=${thm_cyan},bg=${message_background},align=centre"

  # panes
  local pane_border_status pane_border_style \
    pane_active_border_style pane_left_separator pane_middle_separator \
    pane_right_separator pane_number_position pane_format
  pane_status_enable=$(get_tmux_batch_option "@catppuccin_pane_status_enabled") # no, yes
  pane_border_status=$(get_tmux_batch_option "@catppuccin_pane_border_status")  # off, bottom
  pane_border_style=$(get_interpolated_tmux_batch_option "@catppuccin_pane_border_style")
  pane_active_border_style=$(
    get_interpolated_tmux_batch_option "@catppuccin_pane_active_border_style"
  )
  pane_left_separator=$(get_tmux_batch_option "@catppuccin_pane_left_separator")
  pane_middle_separator=$(get_tmux_batch_option "@catppuccin_pane_middle_separator")
  pane_right_separator=$(get_tmux_batch_option "@catppuccin_pane_right_separator")
  pane_number_position=$(get_tmux_batch_option "@catppuccin_pane_number_position") # right, left
  pane_format=$(load_modules "pane_default_format" "$modules_custom_path" "$modules_pane_path")

  setw pane-border-status "$pane_border_status"
  setw pane-active-border-style "$pane_active_border_style"
  setw pane-border-style "$pane_border_style"
  setw pane-border-format "$(do_color_interpolation "$pane_format")"

  # window
  local window_status_separator window_left_separator window_right_separator \
    window_middle_separator window_number_position window_status_enable \
    window_format window_current_format

  window_status_separator=$(get_interpolated_tmux_batch_option "@catppuccin_window_separator")
  setw window-status-separator "$window_status_separator"

  window_left_separator=$(get_tmux_batch_option "@catppuccin_window_left_separator")
  window_right_separator=$(get_tmux_batch_option "@catppuccin_window_right_separator")
  window_middle_separator=$(get_tmux_batch_option "@catppuccin_window_middle_separator")
  window_number_position=$(get_tmux_batch_option "@catppuccin_window_number_position") # right, left
  window_status_enable=$(get_tmux_batch_option "@catppuccin_window_status_enable")     # no, yes

  window_format=$(load_modules "window_default_format" "$modules_custom_path" "$modules_window_path")
  setw window-status-format "$(do_color_interpolation "$window_format")"

  window_current_format=$(load_modules "window_current_format" "$modules_custom_path" "$modules_window_path")
  setw window-status-current-format "$(do_color_interpolation "$window_current_format")"

  # status module
  local status_left_separator status_right_separator status_connect_separator \
    status_fill status_modules_left status_modules_right
  status_left_separator=$(get_tmux_batch_option "@catppuccin_status_left_separator")
  status_right_separator=$(get_tmux_batch_option "@catppuccin_status_right_separator")
  status_connect_separator=$(get_tmux_batch_option "@catppuccin_status_connect_separator")
  status_fill=$(get_tmux_batch_option "@catppuccin_status_fill")

  status_modules_left=$(get_tmux_batch_option "@catppuccin_status_modules_left")
  loaded_modules_left=$(load_modules "$status_modules_left" "$modules_custom_path" "$modules_status_path")
  set status-left "$(do_color_interpolation "$loaded_modules_left")"

  status_modules_right=$(get_tmux_batch_option "@catppuccin_status_modules_right")
  loaded_modules_right=$(load_modules "$status_modules_right" "$modules_custom_path" "$modules_status_path")
  set status-right "$(do_color_interpolation "$loaded_modules_right")"

  # modes
  setw clock-mode-colour "${thm_blue}"
  setw mode-style "fg=${thm_pink} bg=${thm_black4} bold"

  tmux "${tmux_commands[@]}"
}

main "$@"
