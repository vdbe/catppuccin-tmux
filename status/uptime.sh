show_uptime() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_uptime_icon" "󰔟"
  set_tmux_batch_option_default "@catppuccin_uptime_color" "$thm_green"
  set_tmux_batch_option_default "@catppuccin_uptime_text" "#(uptime | sed 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/ day.*, */d /; s/:/h /; s/ min//; s/$/m/')"

  run_tmux_batch_commands

  index=$1
  icon="$(get_tmux_batch_option "@catppuccin_uptime_icon")"
  color="$(get_tmux_batch_option "@catppuccin_uptime_color")"
  text="$(get_tmux_batch_option "@catppuccin_uptime_text")"

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
