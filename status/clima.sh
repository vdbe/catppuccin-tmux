# Requires https://github.com/vascomfnunes/tmux-clima
show_clima() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_clima_icon" ""
  set_tmux_batch_option_default "@catppuccin_clima_color" "$thm_yellow"
  set_tmux_batch_option_default "@catppuccin_clima_text" "#{clima}"

  run_tmux_batch_commands

  index=$1
  icon="$(get_tmux_batch_option "@catppuccin_clima_icon")"
  color="$(get_tmux_batch_option "@catppuccin_clima_color")"
  text="$(get_tmux_batch_option "@catppuccin_clima_text")"

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
