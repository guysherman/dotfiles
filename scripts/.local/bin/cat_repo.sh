#!/bin/bash

# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory> <file_extension>"
    exit 1
fi

# Assign arguments to variables
directory="$1"
file_extension="$2"

# Check if directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Find files and process each one
while IFS= read -r -d '' file; do
    echo "# start $file"
    cat "$file"
    echo "# end $file"
    echo
done < <(find "$directory" -type f -name "*.$file_extension" -print0)

exit 0
