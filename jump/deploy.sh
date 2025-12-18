#!/bin/bash

set -e

NAMESPACE=${NAMESPACE:-wiremock}
ACTION=${1:-apply}

echo "Wiremock Jump Service Deployment Script"
echo "=================================="
echo "Namespace: $NAMESPACE"
echo "Action: $ACTION"
echo ""

case $ACTION in
  apply|create)
    echo "Deploying Wiremock Jump service..."
    echo "Ensuring namespace '$NAMESPACE' exists..."
    kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f - --validate=false
    echo "Applying manifests to namespace '$NAMESPACE'..."
    kubectl apply -f . -n $NAMESPACE
    echo ""
    echo "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available deployment/wiremock-jump -n $NAMESPACE --timeout=60s
    echo ""
    echo "Wiremock Jump service deployed successfully!"
    echo ""
    echo "To test the service from within the cluster:"
    echo "1. Create a test pod:"
    echo "   kubectl run curl-test --image=curlimages/curl -i --tty --rm --restart=Never -n $NAMESPACE -- sh"
    echo "2. From within the test pod, run:"
    echo "   curl -X POST http://wiremock-jump-service/validate \\"
    echo "        -H 'Content-Type: application/json' \\"
    echo "        -H 'x-api-key: test-key' \\"
    echo "        -d '{\"orgId\":\"46376cb6-0b4e-472b-97f8-f6dc74de5c3f\",\"deviceId\":\"806e0bbd-90fe-4cef-8715-618581b77e9e\",\"scanTime\":\"2025-10-20T21:42:35.070Z\",\"token\":\"test:valid_entry\",\"venueId\":\"7\",\"isEntry\":true}'"
    echo "3. Exit the test pod with 'exit' command"
    echo ""
    echo "For HTTPS access (port 443), ensure your ingress controller is configured"
    echo "and update the host in 04_ingress.yaml to your desired domain."
    ;;
  delete|remove)
    echo "Removing Wiremock Jump service..."
    kubectl delete -f . -n $NAMESPACE
    echo "Wiremock Jump service removed successfully!"
    ;;
  status)
    echo "Checking Wiremock Jump service status..."
    kubectl get all -l app=wiremock-jump -n $NAMESPACE
    ;;
  *)
    echo "Usage: $0 [apply|delete|status]"
    echo ""
    echo "Examples:"
    echo "  $0 apply          # Deploy the Wiremock Jump service"
    echo "  $0 delete         # Remove the Wiremock Jump service"
    echo "  $0 status         # Check service status"
    echo ""
    echo "Environment variables:"
    echo "  NAMESPACE         # Kubernetes namespace (default: wiremock)"
    exit 1
    ;;
esac 