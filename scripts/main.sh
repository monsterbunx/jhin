#!/bin/bash

apt update
apt upgrade -y
apt install -y curl ca-certificates

tail -f /dev/null
