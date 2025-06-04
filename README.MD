Terraform and Conftest CI/CD Pipeline
Project Overview
This project demonstrates a CI/CD pipeline using Terraform and Conftest to automate infrastructure code testing and validation. It provides step-by-step instructions for:

Installing Terraform and Conftest on macOS (Apple Silicon) and WSL (Ubuntu).
Generating Terraform plans and converting them to JSON format.
Testing infrastructure plans against predefined policies using Conftest.
Integrating the pipeline with GitHub Actions for automated testing.

Prerequisites
Before starting, ensure you have the following:

Operating System: macOS (Apple Silicon) or WSL (Ubuntu).
Tools:
Git
curl
unzip
tar


GitHub Account: Required for creating a repository and running GitHub Actions workflows.

Installation Steps
1. Install Terraform
On macOS (Apple Silicon)
cd /tmp
curl -O https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_darwin_arm64.zip
unzip terraform_1.6.6_darwin_arm64.zip
sudo mv terraform /usr/local/bin/
terraform -v

On WSL (Ubuntu)
cd /tmp
curl -O https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -v

Expected Output:

The terraform -v command should output Terraform v1.6.6.

2. Install Conftest
On macOS (Apple Silicon)
cd /tmp
curl -LO https://github.com/open-policy-agent/conftest/releases/download/v0.45.0/conftest_0.45.0_Darwin_arm64.tar.gz
tar -xzf conftest_0.45.0_Darwin_arm64.tar.gz
sudo mv Zconftest /usr/local/bin/
conftest --version

On WSL (Ubuntu)
cd /tmp
curl -LO https://github.com/open-policy-agent/conftest/releases/download/v0.45.0/conftest_0.45.0_Linux_x86_64.tar.gz
tar -xzf conftest_0.45.0_Linux_x86_64.tar.gz
sudo mv conftest /usr/local/bin/
conftest --version

Expected Output:

The conftest --version command should output Conftest: 0.45.0.

Usage Instructions
3.1 Initialize Terraform
terraform init


Purpose: Initializes the Terraform working directory and downloads required provider plugins (e.g., hashicorp/local).

3.2 Generate and Save Terraform Plan
3.2.1 Create main.tf
Create a file named main.tf with the following content:
resource "local_file" "example" {
  content  = "Hello, Terraform!"
  filename = "example.txt"
}

3.2.2 Reinitialize (if needed)
If you made changes to main.tf, reinitialize Terraform:
terraform init

3.2.3 Generate Terraform Plan
Generate a Terraform plan and save it as tfplan:
terraform plan -out=tfplan

3.2.4 Convert to JSON Format
Convert the Terraform plan to JSON format for Conftest testing:
terraform show -json tfplan > tfplan.json

4. Test Against Policies
4.1 Create Policies Directory
mkdir policies

4.2 Create Policy File
Create a policy file named policy.rego inside the policies directory with the following content:
package main

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "local_file"
  resource.change.after.filename == "example.txt"
  not resource.change.after.content == "Hello, Terraform!"
  msg := "Content of local_file.example must be 'Hello, Terraform!'"
}

4.3 Run Conftest Test
Test the Terraform plan against the policy:
conftest test tfplan.json -p policies
![alt text](image-1.png)
4.4 Interpret Output

Pass:

If the content in main.tf is "Hello, Terraform!", the test passes:PASS - tfplan.json
![alt text](image.png)=![alt text](image-2.png)

This policy ensures the local_file resource's example.txt file content is exactly "Hello, Terraform!".


Fail:

If the content does not match (e.g., "Hello, World!"), the test fails:FAIL - tfplan.json - Content of local_file.example must be 'Hello, Terraform!'
![alt text](image-3.png)

Failure may also occur due to other policy violations, such as missing tags or insecure configurations (if additional policies are defined).
![alt text](image-4.png)=/=![alt text](image-5.png)


5. GitHub Actions Integration
5.1 Create Workflow Directory
mkdir -p .github/workflows

5.2 Create Workflow File
Create a file named terraform-conftest.yml inside the .github/workflows directory with the following content:
name: Terraform and Conftest CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  terraform-conftest:
    name: Terraform Plan and Conftest Test
    runs-on: ubuntu-latest

    steps:
      # Checkout the code
      - name: Checkout code
        uses: actions/checkout@v3

      # Install Terraform
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.6

      # Install Conftest
      - name: Install Conftest
        run: |
          curl -LO https://github.com/open-policy-agent/conftest/releases/download/v0.45.0/conftest_0.45.0_Linux_x86_64.tar.gz
          tar -xzf conftest_0.45.0_Linux_x86_64.tar.gz
          sudo mv conftest /usr/local/bin/
          conftest --version

      # Init Terraform
      - name: Terraform Init
        run: terraform init

      # Setup Terraform plan
      - name: Terraform Plan
        id: plan
        run: terraform plan -out=tfplan -no-color

      # Transform JSON format
      - name: Convert Terraform Plan to JSON
        run: terraform show -json tfplan > tfplan.json

      # Run Conftest tests
      - name: Conftest Test
        run: conftest test tfplan.json -p policies

5.3 Push Code to GitHub

Create a New Repository on GitHub:

Create a repository named 8922Terraform under your GitHub account (e.g., shaoxian423/8922Terraform).


Initialize Local Git Repository and Push:


git init
git add .
git commit -m "Initial commit with Terraform, Conftest, and GitHub Actions"
git remote add origin https://github.com/shaoxian423/8922Terraform.git
git push -u origin main


Verify Workflow:
Visit your GitHub repository (https://github.com/shaoxian423/8922Terraform).
Go to the Actions tab to check the workflow run.
The workflow should execute all steps and display a PASS result for the Conftest test if the policy is met.



Contributing
This project is derived from the work of boda0004. Contributions are welcome! Feel free to submit Pull Requests or Issues to improve the project.
Authors

boda0004(github: boda0004)
duan007 (GitHub: shaoxian423)


