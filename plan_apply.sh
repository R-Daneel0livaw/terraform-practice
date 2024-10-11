#!/bin/bash

modules_file="$1"
operation="$2"  

if [[ "$operation" != "apply" && "$operation" != "plan" ]]; then
  echo "Error: Operation must be 'apply' or 'plan'."
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  path=$(echo "$line" | cut -d ' ' -f1)
  module=$(echo "$line" | cut -d ' ' -f2)

  echo "Processing directory: $path"
  
  cd "$path" || exit 1

  if [ -z "$module" ]; then
    echo "No module specified, running on entire configuration."
    if [[ "$operation" == "apply" ]]; then
      terraform apply -auto-approve
    else
      terraform plan
    fi
  else
    echo "Targeting module: $module"
    if [[ "$operation" == "apply" ]]; then
      terraform apply -target="$module" -auto-approve
    else
      terraform plan -target="$module"
    fi
  fi

  cd - > /dev/null || { echo "Failed to return to the previous directory"; exit 1; }

done < "$modules_file"

echo "All modules processed!"
