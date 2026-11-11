# Retail Lakehouse: AWS/Databricks-style ETL on a Windows laptop

## Scope
Phase 1: install and validate WSL2/Docker/Terraform/AWS CLI; start LocalStack.
Phase 2 preview: provision three LocalStack S3 buckets with Terraform and upload example orders.
Later: PySpark + Delta Lake medallion transformations; Airflow orchestration; tests; optional real cloud deployment.

## Requirements
Windows 11, WSL2 Ubuntu, Docker Desktop with WSL integration, VS Code WSL extension, Terraform, Git, Python 3, AWS CLI, LocalStack developer token. No real AWS credentials required.

## In Windows PowerShell (Administrator if installing WSL)
```powershell
wsl --install -d Ubuntu
wsl --update
wsl --list --verbose
```
Restart when prompted. Open Ubuntu, set Linux user/password.

## Ubuntu: install prerequisites
```bash
sudo apt-get update
sudo apt-get install -y git curl wget unzip gnupg lsb-release ca-certificates python3 python3-venv python3-pip awscli
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform
```
Install Docker Desktop on Windows separately. Enable WSL integration for Ubuntu in Docker Desktop settings. Run `docker info` from Ubuntu to verify. Do not install a separate Docker Engine in Ubuntu.

## Phase 1
Copy/extract this repository into ~/projects/aws-databricks-local-lab (inside Ubuntu, not /mnt/c).

DO NOT FORGET TO GRANT PERMISSION
chmod +x ./scripts/

if wsl isn't able to connect to Docker, follow these steps:

```
On Windows:
    1. Open Docker Desktop from the Start menu.
    2. Confirm that the Docker Engine is running.
    3. Open Settings → General and ensure Use the WSL 2 based engine is enabled.
    4. Go to Settings → Resources → WSL Integration.
    5. Enable integration for your Ubuntu distribution.
    6. Click Apply & Restart if you changed anything.
```
```bash
cd ~/projects/aws-databricks-local-lab
./scripts/check-env.sh
cp .env.example .env
```
Edit `.env` to put your LocalStack developer token. Never commit `.env`.
```bash
docker compose -f docker/compose.yaml --env-file .env up -d
docker compose -f docker/compose.yaml --env-file .env ps
./scripts/check-localstack.sh
```
If Docker Compose needs .env from the project root, pass `--env-file .env` as above.

## Phase 2 preview: Terraform local S3
```bash
cd terraform/local
terraform init
terraform fmt -check
terraform validate
terraform plan -out=lab.tfplan
terraform apply lab.tfplan
terraform output
cd ../..
./scripts/check-localstack.sh
./scripts/create-sample.sh
```
No real AWS resources created. The provider endpoint is hard-coded to localhost.

## Lifecycle
```bash
# Stop containers but keep persistent LocalStack volume
docker compose -f docker/compose.yaml --env-file .env down
# When finished with Phase 2, remove Terraform-managed resources
cd terraform/local && terraform destroy && cd ../..
# Delete local emulator data ONLY if intentionally resetting
docker compose -f docker/compose.yaml --env-file .env down -v
```

## Notes
* LocalStack versions as of 2026 require an auth token. License availability/terms may change. See https://docs.localstack.cloud/aws/getting-started/auth-token/ .
* If you prefer not to create a LocalStack account, we can substitute MinIO (S3 compatible) with Terraform's MinIO provider or direct APIs in a later variant.
* Docker Desktop license terms depend on your organization; personal use typically qualifies for Docker Personal.
* Pin Docker image and Terraform versions after an initial successful setup for reproducibility.
* This package is a starter repo, not a tested deployment on your personal machine.

## Notes

```
Some issues encountered:

9. Troubleshooting guide
Problem	What to check
docker: command not found	Enable Docker Desktop's WSL integration for Ubuntu
Cannot connect to Docker daemon	Start Docker Desktop and run docker info
terraform: command not found	Confirm HashiCorp repository installation
LocalStack exits during startup	Verify .env token and inspect docker logs retail-localstack
Port 4566 already allocated	Check docker ps for another running instance
Terraform cannot connect to S3	Verify LocalStack health and localhost endpoint
Docker containers run slowly	Store the project inside Ubuntu, not /mnt/c/
```