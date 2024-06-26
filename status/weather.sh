# Requires https://github.com/xamut/tmux-weather.

show_weather() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_weather_icon" ""
  set_tmux_batch_option_default "@catppuccin_weather_color" "$thm_yellow"
  set_tmux_batch_option_default "@catppuccin_weather_text" "#{weather}"

  run_tmux_batch_commands

  index=$1
  icon="$(get_tmux_batch__option "@catppuccin_weather_icon")"
  color="$(get_tmux_batch__option "@catppuccin_weather_color")"
  text="$(get_tmux_batch__option "@catppuccin_weather_text")"

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
