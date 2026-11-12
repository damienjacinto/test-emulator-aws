#!/bin/bash
# Builds and (re)starts the emulator, then checks it. Afterwards, in your shell:
#   source ./emu-env.sh
set -e
cd "$(dirname "$0")"

docker build -t aws-emulator .

docker rm -f emu 2>/dev/null || true
mkdir -p ~/.aws/emulator
docker run -d --rm --name emu --memory=2g -p 127.0.0.1:9297:9297 \
  -v ~/.aws/emulator:/home/emulator/.aws/emulator \
  aws-emulator -p 9297 --telemetry off

source ./emu-env.sh

# Wait for startup (keys and CA are regenerated on every start)
for i in $(seq 1 30); do
  curl -sf --cacert "$AWS_CA_BUNDLE" "$AWS_ENDPOINT_URL/__admin/health" >/dev/null 2>&1 && break
  sleep 1
done

curl --cacert "$AWS_CA_BUNDLE" "$AWS_ENDPOINT_URL/__admin/health"; echo
identity=$(aws sts get-caller-identity --no-cli-pager --output json)
echo "$identity"

# State bucket for envs/emulator (emulator state is in-memory, so recreate on every start)
aws s3api create-bucket --bucket tf-state-emulator --no-cli-pager >/dev/null
echo "State bucket tf-state-emulator ready"
