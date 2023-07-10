#!/usr/bin/env bash
cp apache/* ./
docker build . --tag elestio4test/espocrm:latest
