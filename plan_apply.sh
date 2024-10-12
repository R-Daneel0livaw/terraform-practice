#!/bin/bash

operation="$1"  
modules_file="$2"
base_path="environments"

if [[ "$operation" != "apply" && "$operation" != "plan" ]]; then
  echo "Error: Operation must be 'apply' or 'plan'."
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  path="${base_path}/$(awk '{print $1}' <<< "$line")"
  module=$(awk '{print $2}' <<< "$line")

  echo "Processing directory: $path"
  echo "For module: ${module:-ALL}"
  
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
