#!/bin/bash

modules_file="$1"
action="$2"  

if [[ "$action" != "apply" && "$action" != "plan" ]]; then
  echo "Error: Action must be 'apply' or 'plan'."
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  path=$(echo "$line" | cut -d ' ' -f1)
  module=$(echo "$line" | cut -d ' ' -f2)

  echo "Processing directory: $path"
  
  cd "$path" || exit 1

  if [ -z "$module" ]; then
    echo "No module specified, running on entire configuration."
    if [[ "$action" == "apply" ]]; then
      terraform apply -auto-approve
    else
      terraform plan
    fi
  else
    echo "Targeting module: $module"
    if [[ "$action" == "apply" ]]; then
      terraform apply -target="$module" -auto-approve
    else
      terraform plan -target="$module"
    fi
  fi

  cd - > /dev/null

done < "$modules_file"

echo "All modules processed!"
