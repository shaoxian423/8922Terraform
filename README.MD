1. Install Terraform：Setup Instructions (MacOS + WSL)

1.1  cd /tmp
1.2  curl -O https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_darwin_arm64.zip
1.3  unzip terraform_1.6.6_darwin_arm64.zip
1.4  sudo mv terraform /usr/local/bin/

2. Install Conftest

2.1  cd /tmp
2.2  curl -LO https://github.com/open-policy-agent/conftest/releases/download/v0.45.0/conftest_0.45.0_Darwin_arm64.tar.gz
2.3  tar -xzf conftest_0.45.0_Darwin_arm64.tar.gz
2.4  sudo mv conftest /usr/local/bin/
2.5  conftest --version

3. Usage Instructions

3.1. Initialize Terraform
     terraform init

3.2. Generate and Save Plan

3.2.1. Touch main.tf
context:
resource "local_file" "example" {
  content  = "Hello, Terraform!"
  filename = "example.txt"
}

3.2.2 terraform init 
3.2.3 terraform plan -out=tfplan
3.2.4 terraform show -json tfplan > tfplan.json

4. Test Against Policies

4.1 mkdir policies
4.2 touch policies/policy.rego
    content：
    package main

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "local_file"
  resource.change.after.filename == "example.txt"
  not resource.change.after.content == "Hello, Terraform!"
  msg := "Content of local_file.example must be 'Hello, Terraform!'"
}

4.3 conftest test tfplan.json -p policies
![alt text](image-1.png)

4. Interpret Output
Pass: All policies met
![alt text](image.png)=![alt text](image-2.png) 
This strategy checks the local_file resource to ensure that the content of the example.txt file is "Hello, Terraform!" .

Fail: Missing tags, insecure configs, etc.
![alt text](image-3.png)
Because：
![alt text](image-4.png)=/=![alt text](image-5.png)



