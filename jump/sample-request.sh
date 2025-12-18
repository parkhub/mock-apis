#!/bin/bash

# Jump Wiremock Sample Requests
# This script demonstrates how to test the Jump wiremock service with different scenarios

WIREMOCK_URL=${WIREMOCK_URL:-"http://wiremock-jump-service"}
if [[ "$WIREMOCK_URL" == *"localhost"* ]] || [[ "$WIREMOCK_URL" == *"127.0.0.1"* ]]; then
  WIREMOCK_URL="http://localhost:8080"
fi

echo "Testing Jump Wiremock Service"
echo "============================="
echo "Target URL: $WIREMOCK_URL"
echo ""

# Test 1: Valid Entry (success case)
echo "Test 1: Valid Entry"
echo "-------------------"
curl -X POST "$WIREMOCK_URL/validate" \
  -H 'Content-Type: application/json' \
  -H 'x-api-key: test-key' \
  -d '{
    "orgId": "46376cb6-0b4e-472b-97f8-f6dc74de5c3f",
    "deviceId": "806e0bbd-90fe-4cef-8715-618581b77e9e",
    "scanTime": "2025-10-20T21:42:35.070Z",
    "token": "test:valid_entry",
    "venueId": "7",
    "isEntry": true
  }'
echo -e "\n"

# Test 2: Already Entered (failure case)
echo "Test 2: Already Entered"
echo "-----------------------"
curl -X POST "$WIREMOCK_URL/validate" \
  -H 'Content-Type: application/json' \
  -H 'x-api-key: test-key' \
  -d '{
    "orgId": "46376cb6-0b4e-472b-97f8-f6dc74de5c3f",
    "deviceId": "806e0bbd-90fe-4cef-8715-618581b77e9e",
    "scanTime": "2025-10-20T21:42:35.070Z",
    "token": "test:already_entered",
    "venueId": "7",
    "isEntry": true
  }'
echo -e "\n"

# Test 3: Ticket Not Found (failure case)
echo "Test 3: Ticket Not Found"
echo "------------------------"
curl -X POST "$WIREMOCK_URL/validate" \
  -H 'Content-Type: application/json' \
  -H 'x-api-key: test-key' \
  -d '{
    "orgId": "46376cb6-0b4e-472b-97f8-f6dc74de5c3f",
    "deviceId": "806e0bbd-90fe-4cef-8715-618581b77e9e",
    "scanTime": "2025-10-20T21:42:35.070Z",
    "token": "test:not_found",
    "venueId": "7",
    "isEntry": true
  }'
echo -e "\n"

# Test 4: Device Not Found (failure case - wrong venue)
echo "Test 4: Device Not Found"
echo "------------------------"
curl -X POST "$WIREMOCK_URL/validate" \
  -H 'Content-Type: application/json' \
  -H 'x-api-key: test-key' \
  -d '{
    "orgId": "46376cb6-0b4e-472b-97f8-f6dc74de5c3f",
    "deviceId": "806e0bbd-90fe-4cef-8715-618581b77e9e",
    "scanTime": "2025-10-20T21:42:35.070Z",
    "token": "test:valid_entry",
    "venueId": "8",
    "isEntry": true
  }'
echo -e "\n"

echo "All tests completed!"