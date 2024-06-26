show_date_time() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_date_time_icon" "󰃰"
  set_tmux_batch_option_default "@catppuccin_date_time_color" "$thm_blue"
  set_tmux_batch_option_default "@catppuccin_date_time_text" "#%Y-%m-%d %H:%M"

  run_tmux_batch_commands

  index=$1
  icon="$(get_tmux_batch_option "@catppuccin_date_time_icon")"
  color="$(get_tmux_batch_option "@catppuccin_date_time_color")"
  text="$(get_tmux_batch_option "@catppuccin_date_time_text")"

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
