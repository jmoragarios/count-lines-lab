#!/bin/bash

# Function to count the number of lines in text files for a specific owner
count_lines_by_owner() {
  owner=$1
  count=0

  for file in *.txt; do
    if [[ $(stat -c '%U' "$file") == "$owner" ]]; then
      filename=$(echo "$file" | cut -d':' -f2)
      echo "$filename lines: $(wc -l < "$file")"
      count=$((count + $(wc -l < "$file")))
      
    fi
  done

  echo "Total lines for owner $owner: $count"
}

# Function to count the number of lines in text files created in a specific month
count_lines_by_month() {
  month=$1
  count=0

  for file in *.txt; do
    if [[ $(date -r "$file" +%m) == "$month" ]]; then
      filename=$(echo "$file" | cut -d':' -f2)
      echo "$filename lines: $(wc -l < "$file")"
      count=$((count + $(wc -l < "$file")))
    fi
  done

  echo "Total lines for files created in month $month: $count"
}

# Function to display the script's help message
display_help() {
  echo "Usage: $0 [-o <owner>] [-m <month>]"
  echo "Options:"
  echo "  -o <owner>    Count lines for files owned by <owner>"
  echo "  -m <month>    Count lines for files created in <month>"
}

# Parse command-line arguments
while getopts "o:m:" opt; do
  case $opt in
    o)
      count_lines_by_owner "$OPTARG"
      ;;
    m)
      count_lines_by_month "$OPTARG"
      ;;
    *)
      display_help
      exit 1
      ;;
  esac
done

# If no arguments are provided, display help message
if [[ $OPTIND -eq 1 ]]; then
  display_help
fi