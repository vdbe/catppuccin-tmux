show_battery() {
  local index icon color text module
  # shellcheck disable=SC2034
  local tmux_batch_options_commands=()
  # shellcheck disable=SC2034
  local tmux_batch_options=()

  set_tmux_batch_option_default "@catppuccin_battery_icon" "#{battery_icon}"
  set_tmux_batch_option_default "@catppuccin_battery_color" "$thm_yellow"
  set_tmux_batch_option_default "@catppuccin_battery_text" "#{battery_percentage}"

  # As long as the set-option's are behind _all_ show_options this is fine.
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier8 󰁹 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier7 󰂁 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier6 󰁿 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier5 󰁾 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier4 󰁽 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier3 󰁼 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier2 󰁻 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_charge_tier1 󰁺 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_status_charged 󰚥 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_status_charging 󰂄 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_status_discharging 󰂃 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_status_unknown 󰂑 ;")
  tmux_batch_options_commands+=("set-option -gq @batt_icon_status_attached 󱈑 ;")

  run_tmux_batch_commands

  index=$1
  icon=$(get_tmux_batch_option "@catppuccin_battery_icon")
  color=$(get_tmux_batch_option "@catppuccin_battery_color")
  text=$(get_tmux_batch_option "@catppuccin_battery_text")

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
