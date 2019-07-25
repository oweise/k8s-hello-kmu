#!/usr/bin/env bash
export AWS_ACCESS_KEY=$(aws configure get access_key)
export AWS_SECRET_KEY=$(aws configure get secret_key)
export AWS_REGION=$(aws configure get region)

cd "$(dirname "$0")"
. ../config.sh

cat input.template.tfvars | envsubst > ../tmp/input.tfvars
terraform destroy -auto-approve \
    -var-file=../tmp/input.tfvars \
    -var database_password="${DATABASE_PASSWORD}" \
    -var access_key="${AWS_ACCESS_KEY}" \
    -var secret_key="${AWS_SECRET_KEY}"

rm ../tmp/input.tfvars