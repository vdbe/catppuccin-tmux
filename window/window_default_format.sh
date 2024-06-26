show_window_default_format() {
  local number color background text fill default_window_format

  number="#I"
  color=$(get_tmux_batch_option "@catppuccin_window_default_color")
  background=$(get_tmux_batch_option "@catppuccin_window_default_background")
  text="$(get_tmux_batch_option "@catppuccin_window_default_text")" # use #W for application instead of directory
  fill="$(get_tmux_batch_option "@catppuccin_window_default_fill")" # number, all, none

  default_window_format=$(build_window_format "$number" "$color" "$background" "$text" "$fill")

  echo "$default_window_format"
}
