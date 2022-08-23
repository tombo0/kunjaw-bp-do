#!/bin/bash

export KOPS_STATE_STORE="s3://bp-kurikulum"

kops create cluster --name bpkurikulum.my.id --zones us-east-2a --master-size t2.medium --node-size t2.medium --node-count 2

kops update cluster --name bpkurikulum.my.id --yes --admin

kops validate cluster --name bpkurikulum.my.id --wait 10m