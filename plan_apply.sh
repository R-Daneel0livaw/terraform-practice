#!/bin/bash

operation="$1"  
modules_file="$2"
base_path="projects"

if [[ "$operation" != "apply" && "$operation" != "plan" && "$operation" != "apply-destroy" && "$operation" != "plan-destroy" ]]; then
  echo "Error: Operation must be 'apply', 'plan', 'apply-destroy', or 'plan-destroy'."
  exit 1
fi

if [[ "$operation" == "apply-destroy" || "$operation" == "plan-destroy" ]]; then
  echo "WARNING: You are about to execute a $operation operation, which may delete resources!"
  read -r -p "Are you sure you want to proceed? (yes/no): " confirmation
  if [[ "$confirmation" != "yes" ]]; then
    echo "Operation aborted."
    exit 0
  fi
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  project=$(awk '{print $1}' <<< "$line")
  path="${base_path}/${project}/$(awk '{print $2}' <<< "$line")"
  module=$(awk '{print $3}' <<< "$line")

  echo "In project: $project"
  echo "Processing directory: $path"
  echo "For module: ${module:-ALL}"

  cd "$path" || exit 1

  if [ -z "$module" ]; then
    echo "No module specified, running on entire configuration."

    if [[ "$operation" == "apply" ]]; then
      terraform apply -auto-approve
    elif [[ "$operation" == "plan" ]]; then
      terraform plan
    elif [[ "$operation" == "apply-destroy" ]]; then
      terraform destroy -auto-approve
    elif [[ "$operation" == "plan-destroy" ]]; then
      terraform plan -destroy
    fi
  else
    echo "Targeting module: $module"

    if [[ "$operation" == "apply" ]]; then
      terraform apply -target="$module" -auto-approve
    elif [[ "$operation" == "plan" ]]; then
      terraform plan -target="$module"
    elif [[ "$operation" == "apply-destroy" ]]; then
      terraform destroy -target="$module" -auto-approve
    elif [[ "$operation" == "plan-destroy" ]]; then
      terraform plan -destroy -target="$module"
    fi
  fi

  cd - > /dev/null || { echo "Failed to return to the previous directory"; exit 1; }

done < "$modules_file"

echo "All modules processed!"
