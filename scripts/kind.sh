#!/usr/bin/env bash
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/..
echo $ROOT

IGNORE_FIXED_IMAGE_LOAD=${IGNORE_FIXED_IMAGE_LOAD:-"NO"}

function kind_up_cluster {
	# when update kind version, please change this file and github action file.
	# https://github.com/kubernetes-sigs/kind/releases
	case $K8S_VERSION in
	v1.18 | v1.18.20)
		kind_image="kindest/node:v1.18.20@sha256:61c9e1698c1cb19c3b1d8151a9135b379657aee23c59bde4a8d87923fcb43a91"
		;;
	v1.19 | v1.19.16)
		kind_image="kindest/node:v1.19.16@sha256:707469aac7e6805e52c3bde2a8a8050ce2b15decff60db6c5077ba9975d28b98"
		;;
	v1.20 | v1.20.15)
		kind_image="kindest/node:v1.20.15@sha256:d67de8f84143adebe80a07672f370365ec7d23f93dc86866f0e29fa29ce026fe"
		;;
	v1.21 | v1.21.14)
		kind_image="kindest/node:v1.21.14@sha256:f9b4d3d1112f24a7254d2ee296f177f628f9b4c1b32f0006567af11b91c1f301"
		;;
	v1.22 | v1.22.13)
		kind_image="kindest/node:v1.22.13@sha256:4904eda4d6e64b402169797805b8ec01f50133960ad6c19af45173a27eadf959"
		;;
	v1.23 | v1.23.10)
		kind_image="kindest/node:v1.23.10@sha256:f047448af6a656fae7bc909e2fab360c18c487ef3edc93f06d78cdfd864b2d12"
		;;
	v1.24 | v1.24.15)
		kind_image="kindest/node:v1.24.15@sha256:24473777a1eef985dc405c23ab9f4daddb1352ca23db60b75de9e7c408096491"
		;;
	v1.25 | v1.25.0)
		kind_image="kindest/node:v1.25.0@sha256:428aaa17ec82ccde0131cb2d1ca6547d13cf5fdabcc0bbecf749baa935387cbf"
		;;
	*)
		echo $K8S_VERSION "is not support"
		exit 1
		;;
	esac
	echo "kind to create cluster"
	kind create cluster --config=$ROOT/scripts/kind-conf.yaml --image $kind_image
	echo "kind cluster created done."
}

function pre_load_image() {
	pre_load_images=(
		hyperledgerk8s/registry:2
		hyperledgerk8s/docker:stable
		hyperledgerk8s/kaniko-executor:v1.9.1
		hyperledgerk8s/bash:5.1.4
		hyperledgerk8s/ubuntu:22.04
	)
	for image in ${pre_load_images[*]}; do
		docker pull ${image}
		kind load docker-image ${image}
	done
}

export K8S_VERSION=v1.24
kind_up_cluster
if [[ ${IGNORE_FIXED_IMAGE_LOAD} != "YES" ]]; then
	pre_load_image
else
	echo "According to the configuration, pre_load_image will not running."
fi
