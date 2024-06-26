show_session() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_session_icon" ""
  set_tmux_batch_option_default "@catppuccin_session_color" "#{?client_prefix,$thm_red,$thm_green}"
  set_tmux_batch_option_default "@catppuccin_session_text" "#S"

  run_tmux_batch_commands

  index=$1
  icon=$(get_tmux_batch_option "@catppuccin_session_icon")
  color=$(get_tmux_batch_option "@catppuccin_session_color")
  text=$(get_tmux_batch_option "@catppuccin_session_text")

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
