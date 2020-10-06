#!/bin/bash
#set -xv
# Docker usage with makefile

# Installation
make install

# Mysql migration structure
make db-migration-structure
# You can combine command: make install db-migration-structure


# Uninstall
# make uninstall
