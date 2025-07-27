#!/usr/bin/env bash

set -e

echo "🚀 Deploying manifests to K3s cluster..."

for file in manifests/*.yaml; do
    echo "→ Applying $file"
    kubectl apply -f "$file"
done

echo "✅ All manifests deployed successfully!"
