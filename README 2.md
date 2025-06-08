# Terraform and Conftest CI/CD Pipeline

## Project Overview

This project demonstrates a CI/CD pipeline integrating Terraform for infrastructure as code and Conftest for policy as code. The pipeline ensures infrastructure deployments follow security and compliance standards through automated testing.

## Repository Structure

```bash
.
├── terraform/              # Terraform configuration files
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── policy/             # Rego policies for Conftest
│       └── deny_owner.rego
├── .github/workflows/      # GitHub Actions CI/CD pipeline
│   └── ci.yml
├── README.md               # Project documentation
└── .conftestignore         # Files to ignore during policy testing
```

## Getting Started

### Prerequisites

- Terraform
- Conftest
- GitHub CLI (if testing locally)
- Azure CLI (for Azure resources)

### Setup

1. Initialize Terraform:

```bash
cd terraform
terraform init
```

2. Run Conftest to test policies:

```bash
conftest test main.tf --policy policy/
```

3. Apply Terraform (after passing policy checks):

```bash
terraform apply
```

### GitHub Actions Workflow

The `.github/workflows/ci.yml` file includes:

- Terraform formatting check
- Policy checks using Conftest
- Terraform plan

## Policy Example

Example Rego policy (`deny_owner.rego`) to deny hardcoded `Owner` tags:

```rego
package main

deny[msg] {
  input.resource.tags.Owner
  not startswith(input.resource.tags.Owner, "team-")
  msg = "Owner tag must start with 'team-'."
}
```

## Notes

- To comment out a specific line in Terraform (e.g. `Owner = "sha..."`), use `#` at the beginning of the line.
- Customize Rego policies as per your organization’s requirements.

## License

MIT
