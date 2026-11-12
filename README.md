# Terraform: test platform (VPC + EKS)

Two independent deployments of the same platform, each with its own state file,
plus a local `emulator` environment for testing modules against
[AWS Emulator](https://github.com/aws/aws-emulator) without touching a real account.

```
envs/
  dev/       # 2 AZs, 1 shared NAT gateway   → state: test/dev/terraform.tfstate
  prod/      # 3 AZs, 1 NAT gateway per AZ   → state: test/prod/terraform.tfstate
  emulator/  # VPC module only, local        → state: test/emulator/terraform.tfstate (in the emulator)
modules/
  platform/   # wires vpc + eks together; what each env calls
  vpc/        # VPC, public/private subnets, IGW, NAT, routes
  eks/        # EKS Auto Mode cluster (terraform-aws-modules/eks)
```

## Usage

Run everything from the environment's folder:

```bash
cd envs/dev          # or envs/prod
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

In VS Code: **Tasks: Run Task → tf: init / tf: plan / tf: apply plan**, then pick the environment.

## Changing an environment

All per-environment values (region, CIDR, AZ count, NAT mode, Kubernetes version,
allowed API CIDRs, tags) live in `envs/<env>/main.tf`. The backend bucket is in
`envs/<env>/backend.tf`.

To change the platform for **both** environments, edit `modules/`. Then plan dev
first, apply it, and only then plan and apply prod.

## Testing locally with AWS Emulator

`envs/emulator` runs the `vpc` module against AWS Emulator in Docker. The `eks`
module is left out, because EKS Auto Mode is not a realistic emulator target.

```bash
./setup-emu.sh               # build + start the emulator, create the state bucket
source ./emu-env.sh          # point AWS CLI / Terraform at https://127.0.0.1:9297
cd envs/emulator
terraform init -reconfigure
terraform apply
terraform destroy
```

| File | Role |
|---|---|
| `dockerfile` | Amazon Linux image with the `aws-emulator` RPM, listening on port 9297 |
| `setup-emu.sh` | (Re)starts the `emu` container, waits for health, creates the `tf-state-emulator` bucket |
| `emu-env.sh` | Sets the endpoint, generated credentials and CA bundle. Run it with `source`, don't execute it |

Things to know:

- **Source `emu-env.sh` in each new shell.** Running it as a script sets the
  variables only in a child process. The VS Code tasks don't load it either,
  so run the emulator env from a terminal.
- **Everything is in memory.** Restarting the container wipes all resources,
  the state bucket and the state, and generates new keys and a new CA. After a
  restart, run `./setup-emu.sh`, then `source ./emu-env.sh`, then
  `terraform init -reconfigure`.
- **Use `127.0.0.1`, not `0.0.0.0`.** The emulator's certificate only covers
  `localhost`, `127.0.0.1` and `::1`. The port is published on `127.0.0.1` only.
- **There are two safeguards against hitting real AWS.** The backend's S3
  endpoint is hard-coded to the emulator. The provider has
  `allowed_account_ids = ["000000000000"]`, so it refuses to run with real
  credentials.
- **Coverage varies by service.** Unsupported operations return
  `501 Not Implemented`. Check the
  [fidelity report](https://docs.aws.amazon.com/emulator/latest/userguide/fidelity.html)
  before relying on a service.

## Before the first run

- Set the real state bucket names in `envs/dev/backend.tf` and `envs/prod/backend.tf`.
- Set `eks_public_access_cidrs` in each `main.tf` to your own IP or VPN range.
- Commit each `envs/<env>/.terraform.lock.hcl`.
