#!/bin/bash

operation="$1"
modules_file="$2"
base_path="projects"

if [[ ! "$operation" =~ ^(apply|plan|apply-destroy|plan-destroy)$ ]]; then
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

case "$operation" in
  "apply")         tf_command="apply -auto-approve" ;;
  "plan")          tf_command="plan" ;;
  "apply-destroy") tf_command="destroy -auto-approve" ;;
  "plan-destroy")  tf_command="plan -destroy" ;;
esac

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
    terraform "$tf_command"
  else
    echo "Targeting module: $module"
    terraform "$tf_command" -target="$module"
  fi

  cd - > /dev/null || { echo "Failed to return to the previous directory"; exit 1; }

done < "$modules_file"

echo "All modules processed!"
