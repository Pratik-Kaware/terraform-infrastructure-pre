# 🏗️ Terraform Infrastructure for Pre-Production Environments

This repository contains modular, scalable, and production-aligned **Terraform infrastructure as code** for managing multiple pre-production projects (`con`, `cor`, etc.) on AWS using GitHub Actions.

---

<details> <summary>📁 Project Structure (copy-paste this in README)</summary>

envs/pre/
├── con/                  # Terraform code and pipelines for 'con'
├── cor/                  # Terraform code and pipelines for 'cor'

.github/
└── workflows/
    ├── tf-reusable-plan.yaml
    ├── tf-reusable-apply.yaml
    └── tf-reusable-destroy.yaml

</details>

You can even collapse it using <details> if you want it cleaner.



---

## ⚙️ Tech Stack

- Terraform 1.6+
- AWS (EC2, VPC, S3, IAM, etc.)
- GitHub Actions for CI/CD
- S3 as remote backend for Terraform state
- Terraform modules (reusable via Git source)
- (Optional) DynamoDB for state locking

---

## 🚀 CI/CD Pipelines

Each project (like `con`, `cor`) uses three pipelines:

1. **Terraform Plan**  
   - Triggered on `push`
   - Generates and uploads a `.tfplan` file to S3

2. **Terraform Apply**  
   - Manual (`workflow_dispatch`)
   - Downloads the `.tfplan` from S3 and applies it

3. **Terraform Destroy**  
   - Manual (`workflow_dispatch`)
   - Loads remote state and destroys resources

---

## ☁️ Remote State Configuration

Terraform uses an S3 bucket for storing state:


bucket         = "tf-state-bucket-pre-26-6"
key            = "pre/con/terraform.tfstate"
region         = "ap-south-1"
encrypt        = true
# dynamodb_table = "terraform-locks" (optional)
Use backend.conf in each project folder to configure the backend.


🧪 Troubleshooting Notes
Problem	Cause	Solution
terraform destroy says "no resources"	State exists but config missing	Ensure main.tf has actual resource blocks
terraform init fails to read backend config	Incorrect relative path	Use backend.conf relative to working-directory
terraform plan wants to recreate everything	Local state/config is out of sync	Use terraform import or refresh manually
GitHub Action can't destroy resources	.tfstate not uploaded or missing	Ensure init uses backend and .tfstate is pushed to S3
📦 Reusable Workflows (Planned)

To avoid repeating plan, apply, and destroy logic, we’re introducing reusable workflows:
Example

Reusable Workflow File: .github/workflows/tf-reusable-plan.yaml

on:
  workflow_call:
    inputs:
      path:
        required: true
        type: string


jobs:
  plan:
    uses: .github/workflows/tf-reusable-plan.yaml@main
    with:
      path: envs/pre/con
🛣️ Roadmap

Modular Terraform code for multiple projects

Remote backend with S3

Project-specific pipelines (plan/apply/destroy)

GitHub Actions integration

State import and recovery support

Reusable workflows for all actions

    Matrix-based dynamic environment deploys

🧑‍💻 How to Add a New Project

    Copy an existing project folder (like con)

    Update backend.conf, main.tf, and terraform.tfvars

    Add new workflows or reuse existing ones

    Push changes to trigger plan

📞 Support

Raise a GitHub issue or contact the DevOps team for help.




