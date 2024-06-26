show_application() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_application_icon" ""
  set_tmux_batch_option_default "@catppuccin_application_color" "$thm_pink"
  set_tmux_batch_option_default "@catppuccin_application_text" "#W"

  run_tmux_batch_commands

  index=$1
  icon=$(get_tmux_batch_option "@catppuccin_application_icon")
  color=$(get_tmux_batch_option "@catppuccin_application_color")
  text=$(get_tmux_batch_option "@catppuccin_application_text")

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
