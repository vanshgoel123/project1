#!/bin/sh
curl -sS http://localhost:5000/health || exit 1
