show_pane_default_format() {
  local number color background text fill

  number="#{pane_index}"
  color="$(get_tmux_batch_option "@catppuccin_pane_color")"
  background="$(get_tmux_batch_option "@catppuccin_pane_background_color")"
  text="$(get_tmux_batch_option "@catppuccin_pane_default_text")"
  fill="$(get_tmux_batch_option "@catppuccin_pane_default_fill")" # number, all, none

  default_pane_format=$(build_pane_format "$number" "$color" "$background" "$text" "$fill")

  echo "$default_pane_format"
}
