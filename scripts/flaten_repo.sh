#!/bin/bash

# Output file
output_file="context.txt"

# Create or clear the output file
echo "" > "$output_file"

# First, add the tree output to the file
# Note: Using tree -I to ignore node_modules, .git, and other common ignore patterns
tree -I 'node_modules|.git|dist|build|coverage|.next|.venv|__pycache__' -a -I '*.pyc' >> "$output_file"

# Add a separator
echo -e "\n===========================================\n" >> "$output_file"

# Function to process each file
process_file() {
    local file="$1"
    echo -e "\nFile: $file\n-------------------------------------------" >> "$output_file"
    cat "$file" >> "$output_file"
    echo -e "\n-------------------------------------------\n" >> "$output_file"
}

# Find all matching files, excluding common directories to ignore
find . \
    -type d \( -name node_modules -o -name .git -o -name dist -o -name build -o -name coverage -o -name .next -o -name .venv -o -name __pycache__ \) -prune -o \
    -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.json" -o -name "*.md" -o -name "*.py" \) \
    -print0 | while IFS= read -r -d '' file; do
        process_file "$file"
done

echo "Context file has been created at: $output_file"