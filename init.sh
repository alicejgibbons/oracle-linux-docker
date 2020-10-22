#!/bin/bash
set -e

echo  "Starting SSH ..." && /usr/sbin/sshd -p 2222 && echo "Starting flask server ..." && python3 app.py