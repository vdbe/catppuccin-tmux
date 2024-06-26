show_directory() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_directory_icon" ""
  set_tmux_batch_option_default "@catppuccin_directory_color" "$thm_pink"
  set_tmux_batch_option_default "@catppuccin_directory_text" "#{b:pane_current_path}"

  run_tmux_batch_commands

  index=$1
  icon=$(get_tmux_batch_option "@catppuccin_directory_icon")
  color=$(get_tmux_batch_option "@catppuccin_directory_color")
  text=$(get_tmux_batch_option "@catppuccin_directory_text")

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
