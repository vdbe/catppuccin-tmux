show_load() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_load_icon" "󰊚"
  set_tmux_batch_option_default "@catppuccin_load_color" "$thm_blue"
  set_tmux_batch_option_default "@catppuccin_load_text" "#{load_full}"

  run_tmux_batch_commands

  index=$1
  icon="$(get_tmux_batch_option "@catppuccin_load_icon")"
  color="$(get_tmux_batch_option "@catppuccin_load_color")"
  text="$(get_tmux_batch_option "@catppuccin_load_text")"

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
