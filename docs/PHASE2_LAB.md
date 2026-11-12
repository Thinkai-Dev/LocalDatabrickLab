# Phase 2 — Reusable Terraform S3 infrastructure (WSL2 / laptop only)

## Prerequisites

Phase 1 completed, LocalStack healthy, and 3 buckets provisioned with the original
Phase 1 Terraform configuration. Keep original `terraform/local/terraform.tfstate`
and `.terraform.lock.hcl`. Never overwrite or delete a working state file.

## Upgrade instructions (copy new files, do NOT replace the directory)

Copy the updated `terraform/local/*.tf` files and the new
`terraform/modules/s3-bucket/` directory into your existing project.
Never overwrite the existing `terraform.tfstate` or `.terraform.lock.hcl`.

### 1 — Backup

From your EXISTING project, BEFORE copying the new files:

```bash
cd ~/projects/LocalDatabrickLab/terraform/local
terraform state list
mkdir -p ../../backups
terraform state pull > ../../backups/phase1-before-modules.tfstate
chmod 600 ../../backups/phase1-before-modules.tfstate
```

Verify the state includes `aws_s3_bucket.retail["raw"]` etc. If it does not,
stop: this migration addresses only the Phase 1 starter's `for_each` resources.

### 2 — Copy the upgraded files

Unzip the Phase 2 package into a **different temporary location** so your
existing local Terraform state is not replaced:

```bash
mkdir -p ~/projects/phase2-package
unzip -o ~/projects/aws-databricks-local-lab-phase2.zip -d ~/projects/phase2-package
cp -a ~/projects/phase2-package/aws-databricks-local-lab/terraform/modules \
  ~/projects/LocalDatabrickLab/terraform/
cp ~/projects/phase2-package/aws-databricks-local-lab/terraform/local/*.tf \
  ~/projects/LocalDatabrickLab/terraform/local/
cp ~/projects/phase2-package/aws-databricks-local-lab/scripts/{check-phase2.sh,backup-phase1-state.sh} \
  ~/projects/LocalDatabrickLab/scripts/
mkdir -p ~/projects/LocalDatabrickLab/docs
cp ~/projects/phase2-package/aws-databricks-local-lab/docs/{ARCHIVED_QUESTIONS.md,PHASE2_LAB.md} \
  ~/projects/LocalDatabrickLab/docs/
chmod +x ~/projects/LocalDatabrickLab/scripts/*.sh
```

### 3 — Validate planned migration

```bash
cd ~/projects/LocalDatabrickLab/terraform/local
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=phase2.tfplan
terraform show phase2.tfplan
```

Expected: three `moved` addresses, no bucket replacement or destruction.
Do not apply if the plan proposes to destroy or recreate any bucket.

### 4 — Apply and verify

```bash
terraform apply phase2.tfplan
terraform state list
terraform output bucket_names
cd ../..
./scripts/check-phase2.sh
./scripts/create-sample.sh
```

If you've already refactored the project differently, do not apply blindly;
first inspect `terraform state list` and adapt the moved blocks.

## Optional extension

Set `enable_versioning = true` in a `terraform.tfvars` file (not provided),
then plan again. Do not assume emulator support for advanced S3 features;
inspect results first. This step is optional and is not required for success.

## Design Decisions
```
Decision	                      Engineering rationale
One reusable bucket module	    Enforces consistent infrastructure definitions
for_each	                      Gives each bucket an explicit, stable resource identity
moved.tf	                      Preserves resource ownership during refactoring
Local variables	                Keeps infrastructure intent readable
Input validation	              Catches certain invalid values before provisioning
force_destroy = false	          Reduces the risk of deleting non-empty buckets
Separate terraform/local root	  Keeps our emulator configuration separate from a future real-AWS deployment
Optional versioning	            Allows us to test additional behavior after the initial migration

```

## Safety

The local provider only points S3 requests to `localhost:4566` and uses dummy
credentials. Do not copy this provider configuration into a real cloud setup.
State files contain infrastructure metadata and may contain secrets.
