show_host() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_host_icon" "󰒋"
  set_tmux_batch_option_default "@catppuccin_host_color" "$thm_magenta"
  set_tmux_batch_option_default "@catppuccin_host_text" "#H"

  run_tmux_batch_commands

  index=$1
  icon=$(get_tmux_batch_option "@catppuccin_host_icon")
  color=$(get_tmux_batch_option "@catppuccin_host_color")
  text=$(get_tmux_batch_option "@catppuccin_host_text")

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
