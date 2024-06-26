# Requires https://github.com/arl/gitmux

show_gitmux() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_gitmux_icon" "󰊢"
  set_tmux_batch_option_default "@catppuccin_gitmux_color" "$thm_green"
  set_tmux_batch_option_default "@catppuccin_gitmux_text" "#(gitmux \"#{pane_current_path}\")"

  run_tmux_batch_commands

  index=$1
  icon="$(get_tmux_batch_option "@catppuccin_gitmux_icon")"
  color="$(get_tmux_batch_option "@catppuccin_gitmux_color")"
  text="$(get_tmux_batch_option "@catppuccin_gitmux_text")"

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
