#!/usr/bin/env bash

cd /etc/nixos

echo -e "\033[33m(1/2) updating flake...\033[0m"
sudo nix flake update

echo -e "\033[33m(2/2) switching to flake...\033[0m"
sudo nixos-rebuild switch --flake /etc/nixos#enterprise |& nom

pwd
lsd -a
