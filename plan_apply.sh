#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <modules_file.txt> <plan|apply>"
    exit 1
fi

modules_file="$1"
operation="$2"

if [[ "$operation" != "plan" && "$operation" != "apply" ]]; then
    echo "Operation must be either 'plan' or 'apply'"
    exit 1
fi

while IFS= read -r line; do
    directory=$(echo "$line" | awk '{print $1}')
    target_module=$(echo "$line" | awk '{print $2}')

    echo "Changing directory to: $directory"
    cd "$directory" || { echo "Failed to change directory to $directory"; exit 1; }

    if [[ -n "$target_module" ]]; then
        echo "Running terraform $operation for target: $target_module"
        terraform "$operation" --target="$target_module" -auto-approve
    else
        echo "Running terraform $operation for the entire configuration"
        terraform "$operation" -auto-approve
    fi

    cd - > /dev/null || { echo "Failed to return to the previous directory"; exit 1; }

done < "$modules_file"

echo "All modules processed successfully!"
