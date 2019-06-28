#!/usr/bin/env bash
export AWS_ACCESS_KEY=$(aws configure get access_key)
export AWS_SECRET_KEY=$(aws configure get secret_key)

cd "$(dirname "$0")"
. ../config.sh

ansible-playbook -i aws.inventory down.yml -e db_root_password="${DB_ROOT_PASSWORD}" -e owner="${OWNER}"