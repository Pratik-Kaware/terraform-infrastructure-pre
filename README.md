# 🏗️ Terraform Infrastructure for Pre-Production Environments

This repository contains modular, scalable, and production-aligned **Terraform infrastructure as code** for managing multiple pre-production environments (`con`, `cor`, etc.) on AWS.

---

## 📁 Project Structure

```bash
envs/pre/
├── con/                  # Project-specific Terraform config and pipelines
├── cor/
├── ...
.github/
└── workflows/
    ├── tf-reusable-plan.yaml       # Reusable Terraform Plan workflow (in-progress)
    ├── tf-reusable-apply.yaml      # Reusable Terraform Apply workflow (planned)
    └── tf-reusable-destroy.yaml    # Reusable Terraform Destroy workflow (planned)
'''

Each project folder (e.g., con, cor) contains:

    Terraform config (main.tf, variables.tf, terraform.tfvars)

    CI/CD workflows for plan, apply, and destroy

⚙️ Tech Stack

    Terraform 1.6+

    AWS (VPC, EC2, S3, IAM, etc.)

    Terraform modules (reusable, versioned via Git)

    GitHub Actions for CI/CD

    S3 as the remote state backend

    (Optional) DynamoDB for state locking

🚀 CI/CD Pipelines

Each environment supports three GitHub Action workflows:
1. Terraform Plan (auto on push)

    Runs on every code change

    Generates .tfplan file

    Uploads .tfplan to S3

2. Terraform Apply (manual)

    Triggered via workflow_dispatch

    Downloads .tfplan from S3 and applies it

3. Terraform Destroy (manual)

    Triggered via workflow_dispatch

    Uses remote state (S3) to destroy infrastructure

☁️ Remote State Setup

Terraform state is stored in an S3 bucket:

bucket  = "tf-state-bucket-pre-26-6"
key     = "pre/con/terraform.tfstate"
region  = "ap-south-1"
encrypt = true

💡 Use the backend.conf in each folder to configure this.
🧪 Troubleshooting Insights
🔥 Common Pitfalls & Solutions
Issue	Cause	Fix
terraform destroy shows “no resources”	State file exists but config not present	Ensure actual resource blocks exist in main.tf
terraform init fails to read backend config	Relative path issue	Use backend-config="backend.conf" if already in envs/pre/con
terraform plan shows to recreate all	Local config out of sync with state	Use terraform import and validate state
Destroy runs in CI can't find state	.tfstate not uploaded to S3	Use terraform init with backend to auto-load
📦 Reusable Workflow Strategy (Planned)

We are standardizing CI/CD via GitHub Reusable Workflows:
✅ Benefits

    DRY pipeline logic

    Easy to onboard new projects

    Parameterized folder support

🛠 Structure (In Progress)

# .github/workflows/tf-reusable-plan.yaml
on:
  workflow_call:
    inputs:
      path:
        required: true
        type: string

Projects like envs/pre/con will invoke:

jobs:
  call-plan:
    uses: .github/workflows/tf-reusable-plan.yaml@main
    with:
      path: envs/pre/con

📌 Roadmap

Modular infrastructure using GitHub-hosted Terraform modules

S3-based remote state per environment

CI/CD for plan/apply/destroy using GitHub Actions

Terraform state recovery and import scripts

Reusable workflows for all environments

    Dynamically generated matrix jobs for all folders

👨‍💻 Contributing

To add a new project (e.g., net):

    Clone envs/pre/con folder

    Update backend.conf and terraform.tfvars

    Add resource logic in main.tf

    Create or reuse workflows

📞 Support

For issues, raise a GitHub Issue or contact the DevOps Infra team.
📜 License

This project is licensed under the MIT License.


---

Let me know if you'd like:
- Automatically generated reusable workflows (`plan`, `apply`, `destroy`)
- Custom badge support for workflows
- A CONTRIBUTING.md with onboarding steps
