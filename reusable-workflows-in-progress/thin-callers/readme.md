This houses thin callers which will be used per folder for calling the reusable workflow

Use Matrix Strategy (if needed)

If you ever want to run plans for all folders in one go:

strategy:
  matrix:
    folder: [con, cor, net]

steps:
  - name: Terraform Plan
    run: terraform plan -out=tfplan
    working-directory: envs/pre/${{ matrix.folder }}