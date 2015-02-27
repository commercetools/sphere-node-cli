#!/bin/bash

cat > "sphere-credentials.json" << EOF
{
  "client_id": "${SPHERE_CLIENT_ID}",
  "client_secret": "${SPHERE_CLIENT_SECRET}",
  "project_key": "${SPHERE_PROJECT_KEY}"
}
EOF