#!/bin/bash

export KOPS_STATE_STORE="s3://bp-kurikulum"

kops delete cluster --name bpkurikulum.my.id --yes