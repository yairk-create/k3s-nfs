#!/bin/bash

set -e

NAMESPACE="voltask"

echo "🔧 Creating namespace: $NAMESPACE"
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo "📦 Applying PersistentVolume..."
kubectl apply -f pv.yaml

echo "📦 Applying PersistentVolumeClaim..."
kubectl apply -f pvc.yaml -n "$NAMESPACE"

echo "🚀 Deploying application..."
kubectl apply -f deployment.yaml -n "$NAMESPACE"

echo "✅ Done. Use the following to check the status:"
echo "   kubectl get all -n $NAMESPACE"
