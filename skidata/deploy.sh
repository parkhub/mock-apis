#!/bin/bash

set -e

NAMESPACE=${NAMESPACE:-wiremock}
ACTION=${1:-apply}

echo "Wiremock Skidata Service Deployment Script"
echo "=================================="
echo "Namespace: $NAMESPACE"
echo "Action: $ACTION"
echo ""

case $ACTION in
  apply|create)
    echo "Deploying Wiremock Skidata service..."
    echo "Ensuring namespace '$NAMESPACE' exists..."
    kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
    echo "Applying manifests to namespace '$NAMESPACE'..."
    kubectl apply -f . -n $NAMESPACE
    echo ""
    echo "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available deployment/wiremock-skidata -n $NAMESPACE --timeout=60s
    echo ""
    echo "Wiremock Skidata service deployed successfully!"
    echo ""
    echo "To test the service from within the cluster:"
    echo "1. Create a test pod:"
    echo "   kubectl run curl-test --image=curlimages/curl -i --tty --rm --restart=Never -n $NAMESPACE -- sh"
    echo "2. From within the test pod, run:"
    echo "   curl -X POST http://wiremock-skidata-service/bei/DTASales/ReservationApi/reservation/v1/123456 \\"
    echo "        -H 'Content-Type: application/json' \\"
    echo "        -H 'Authorization: Basic dGVzdA==' \\"
    echo "        -H 'Idempotency-Key: test-key' \\"
    echo "        -d '{\"productId\":\"test\",\"reservationCode\":\"test\",\"primaryId\":{},\"validation\":{},\"carParks\":[]}'"
    echo "3. Exit the test pod with 'exit' command"
    echo ""
    echo "For HTTPS access (port 443), ensure your ingress controller is configured"
    echo "and update the host in 04_ingress.yaml to your desired domain."
    ;;
  delete|remove)
    echo "Removing Wiremock Skidata service..."
    kubectl delete -f . -n $NAMESPACE
    echo "Wiremock Skidata service removed successfully!"
    ;;
  status)
    echo "Checking Wiremock Skidata service status..."
    kubectl get all -l app=wiremock-skidata -n $NAMESPACE
    ;;
  *)
    echo "Usage: $0 [apply|delete|status]"
    echo ""
    echo "Examples:"
    echo "  $0 apply          # Deploy the Wiremock Skidata service"
    echo "  $0 delete         # Remove the Wiremock Skidata service"
    echo "  $0 status         # Check service status"
    echo ""
    echo "Environment variables:"
    echo "  NAMESPACE         # Kubernetes namespace (default: wiremock)"
    exit 1
    ;;
esac 