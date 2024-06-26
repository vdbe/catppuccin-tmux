#!/bin/sh

get_tmux_option() {
  local option value default
  option="$1"
  default="$2"
  value=$(tmux show-option -gqv "$option")

  if [ -n "$value" ]
  then
    if [ "$value" = "null" ]
    then
      echo ""

    else
      echo "$value"
    fi

  else
    echo "$default"

  fi
}

get_interpolated_tmux_option() {
  local option value default
  option="$1"
  default="$2"
  value=$(tmux show-option -gqv "$option")

  if [ -n "$value" ]
  then
    if [ "$value" = "null" ]
    then
      echo ""

    else
      do_color_interpolation "$value"
    fi

  else
    echo "$default"
  fi
}

set() {
  local option=$1
  local value=$2
  tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
  local option=$1
  local value=$2
  tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

get_tmux_batch_option() {
	local option
	option="$1"

	for option_index in "${!tmux_batch_options[@]}"; do
		IFS=":" read -r read_option read_value <<<"${tmux_batch_options[$option_index]}"
		if [[ "$read_option" == "$option" ]]; then
			echo "$read_value"
			return
		fi
	done
}

get_interpolated_tmux_batch_option() {
	local option
	option="$1"

	for option_index in "${!tmux_batch_options[@]}"; do
		IFS=":" read -r read_option read_value <<<"${tmux_batch_options[$option_index]}"
		if [[ "$read_option" == "$option" ]]; then
			do_color_interpolation "$read_value"
			return
		fi
	done
}

set_tmux_batch_option_default() {
	local option value
	option="$1"
	value="$2"

	tmux_batch_options+=("$option:$value")
	tmux_batch_options_commands+=("show-option -gq $option ;")
}

set_tmux_batch_option() {
	local option value
	option="$1"
	value="$2"

	for option_index in "${!tmux_batch_options[@]}"; do
		read -d ':' -r read_option <<<"${tmux_batch_options[$option_index]}"
		if [[ "$read_option" == "$option" ]]; then
			tmux_batch_options["$option_index"]="$option:$value"
      # shellcheck disable=SC2034
			tmux_batch_commands["$option_index"]="show-option -gq $option ;"
			return
		fi
	done

	set_tmux_batch_option_default "$option" "$value"
}

run_tmux_batch_commands() {
	local temp

  # shellcheck disable=SC2048,SC2086
	while IFS=' ' read -r option value; do
		if [ -n "$value" ]; then
			if [ "$value" = "null" ]; then
				set_tmux_batch_option "$option" ""
			else
				temp="${value%\"}"
				temp="${temp#\"}"
				set_tmux_batch_option "$option" "$temp"
			fi
		fi
	done < <(tmux ${tmux_batch_options_commands[*]})

	tmux_batch_options_commands=()
}
