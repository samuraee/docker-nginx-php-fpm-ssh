#!/bin/bash

echo "Starting Supervisor"
supervisord -c /etc/supervisord.conf
