# terraform-practice
Practice IaC creation with Terraform

# Terraform Operations Script

This script automates the process of running `terraform apply` or `terraform plan` on multiple projects and modules specified in a configuration file. It is designed to be flexible, supporting both entire configurations or specific modules within a project.

## Prerequisites

- **Terraform**: Ensure Terraform is installed and properly configured on your system.
- **Bash**: The script is written in Bash and should be executed in a Unix-like environment (Linux, macOS, GitBash, WSL on Windows).
- **Project Structure**: Your projects should follow a specific directory structure to work with this script. Example:
  ```
  projects/
    ├── project1/
    │   └── subdir1/
    ├── project2/
    │   └── subdir2/
    └── project3/
        └── subdir3/
  ```
- **Modules Configuration File**: A configuration file that lists the projects, subdirectories, and optional modules you want to target.

## Script Usage

### Steps to Run the Script:

1. **Save the script**: Save the following script content into a file, e.g., `terraform_operations.sh`.

2. **Make the script executable**:
   ```bash
   chmod +x terraform_operations.sh
   ```

3. **Prepare the modules configuration file**:
   Create a file (e.g., `modules.txt`) with the following format:
   ```
   project1 subdir1 module1
   project2 subdir2 module2
   project3 subdir3
   ```
   Each line represents:
   - The project name
   - The subdirectory within the project
   - (Optional) The specific Terraform module to target. If omitted, the entire configuration will be processed.

4. **Run the script**:
   The script expects two arguments:
   - The first argument (`operation`) should be either `apply` or `plan`, indicating the Terraform operation to run.
   - The second argument (`modules_file`) should be the path to the modules configuration file.

   Example:
   ```bash
   ./terraform_operations.sh apply modules.txt
   ```
   Or for planning:
   ```bash
   ./terraform_operations.sh plan modules.txt
   ```

### Script Behavior:

- **Operation Validation**: The script checks if the `operation` is either `apply` or `plan`. If not, it will exit with an error message.
- **Directory Navigation**: The script navigates to each project and subdirectory listed in the configuration file, executing the appropriate Terraform command.
- **Module Targeting**: If no module is specified in the configuration file, the script runs Terraform on the entire configuration. If a module is specified, the script targets that module specifically.
- **Output**: The script will print messages to indicate the project, subdirectory, and module being processed.

### Example Output:
For each line in the configuration file, the script will output:
```
In project: project1
Processing directory: projects/project1/subdir1
For module: module1
...
```

After processing all lines:
```
All modules processed!
```

## Notes

- The script assumes your projects follow a directory structure starting with `projects/` in the root. Adjust the `base_path` variable in the script if your structure is different.
- The script will automatically return to the previous directory after running the Terraform command in each project.