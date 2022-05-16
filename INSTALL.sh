#!/bin/bash
exec sudo --preserve-env=HOME "$(pwd)/ins.sh" "$@"
