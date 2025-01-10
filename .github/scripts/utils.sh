#!/bin/bash

# Color Definitions
BOLD_GREEN="\033[1;32m"
LIME_GREEN="\033[38;5;118m"
RED="\033[0;31m"
RED_RUST="\033[1;38;5;202m"
GREEN_GLOW="\033[38;5;10m"
SKYLINE_BLUE="\033[38;5;51m"
WHITE="\033[38;5;255m"
# Function to apply color & format command output
format_output() {
  ##!!! Commands must not include $(...) command substitution, as it can lead to unexpected issues when used within bash -c or eval.
  ##!!! e.g git add $(git ls-files --others --exclude-standard | grep -v '^\.github/')
  local command="$1"  # The command to run (e.g., 'git clean -df')
  local color="${2:-$WHITE}"  # Default to white if no color is provided
  local exception_list="${3:-}"  # Default to an empty string if no exception list is provided
  # Capture the output of the command into an array
  #mapfile -t lines < <(bash -c "$command" 2>&1)
  # Run the command using eval, redirecting both stdout and stderr to a temporary variable

  echo -e "\n${GREEN_GLOW}╭──────════[ ${RESET}${SKYLINE_BLUE}${command}${RESET}${GREEN_GLOW} ]════──────${RESET}"
  mapfile -t lines < <(eval "$command" 2>&1)
  local status=0
  # Iterate over the lines
  for i in "${!lines[@]}"; do
    local found_exception=false
    if [[ "${lines[$i]}" =~ [eE]rror ]]; then
     # Check each line in the exception list if any
      while IFS= read -r exception; do
        if [[ "${lines[$i]}" == *"$exception"* ]]; then
           found_exception=true
          break
        fi
      done <<< "$exception_list"
      if [ "$found_exception" = false ]; then
        status=1  # Set status to 1 if no exception is found
      fi
    fi
    
    # Update color if status is not 0 or found_exception is true
    if [ $status -ne 0 ] || [ "$found_exception" = true ]; then
      color="$RED"
    fi

    if [ $i -eq $((${#lines[@]} - 1)) ]; then
      # Last line: append '╰'
      echo -e "${GREEN_GLOW}│  ─ ${RESET}${color}${lines[$i]}${RESET}"
    else
      # All other lines: append '├'
      echo -e "${GREEN_GLOW}│  ─ ${RESET}${color}${lines[$i]}${RESET}"
    fi
  done
  echo -e "${GREEN_GLOW}╰──────═══════════════════════════════════════ ${RESET}"
  if [ $status -ne 0 ]; then
    exit 1
  fi
}

#exception_list=$(echo -e "some known error\nanother known issue")
#format_output "git status" "$WHITE" "$exception_list"