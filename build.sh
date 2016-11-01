#!/bin/bash

pushd ubuntu/16.04
docker build -t quay.io/inviqa_images/ubuntu:16.04 .
popd

pushd php-apache/7.0
docker build -t quay.io/inviqa_images/php-apache:7.0 .
popd

pushd ez/6.x
docker build -t quay.io/inviqa_images/ez:6.x .
popd