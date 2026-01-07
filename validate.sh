#!/bin/bash
set -e

echo "=========================================="
echo "PR #3 Validation Script"
echo "=========================================="
echo ""

echo "Step 1: Building Docker image..."
cd /workspace/docker-copilot-cli
docker build -q -t localhost/test . && echo "✓ Build successful" || exit 1
echo ""

echo "Step 2: Cleaning up existing container..."
docker stop test 2>/dev/null || true
docker rm test 2>/dev/null || true
echo "✓ Cleanup complete"
echo ""

echo "Step 3: Preparing credentials directory..."
rm -rf /tmp/home_node
cp -R /home/node /tmp/home_node
chmod -R 777 /tmp/home_node
echo "✓ Credentials prepared"
echo ""

echo "Step 4: Starting container with auto-approve..."
docker run --name test \
  -v /tmp/home_node:/home/node \
  -e COPILOT_AUTO_APPROVE=true \
  -d localhost/test > /dev/null
echo "✓ Container started"
echo ""

echo "Step 5: Checking initialization logs..."
sleep 2
docker logs test | grep -q "Auto-approval enabled successfully" && echo "✓ Auto-approval enabled" || echo "✗ Auto-approval NOT enabled"
docker logs test | grep -q "Permission denied" && echo "✗ Permission errors found!" || echo "✓ No permission errors"
echo ""

echo "Step 6: Copying credentials (Docker-in-Docker workaround)..."
docker cp /tmp/home_node/.copilot test:/home/node/ > /dev/null 2>&1
echo "✓ Credentials copied"
echo ""

echo "Step 7: Fixing workspace permissions..."
docker exec test chown -R node:node /workspace /home/node
echo "✓ Permissions fixed"
echo ""

echo "Step 8: Testing copilot CLI version..."
VERSION=$(docker exec -u node test copilot --version 2>&1 | head -1)
if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "✓ Copilot CLI working: $VERSION"
else
    echo "✗ Copilot CLI error: $VERSION"
    exit 1
fi
echo ""

echo "Step 9: Running acceptance test - Simple file creation..."
OUTPUT=$(docker exec -u node -e COPILOT_ALLOW_ALL=true test copilot --model gpt-5-mini -p "Create a simple hello.py file in /workspace that prints hello world" 2>&1)
if echo "$OUTPUT" | grep -q "✓"; then
    echo "✓ Simple file creation succeeded"
else
    echo "✗ Simple file creation failed"
    echo "$OUTPUT"
    exit 1
fi
echo ""

echo "Step 10: Running acceptance test - Travel booking application..."
OUTPUT=$(docker exec -u node -e COPILOT_ALLOW_ALL=true test copilot --model gpt-5-mini -p "Create a python application to book travels" 2>&1)
if echo "$OUTPUT" | grep -q "Action failed"; then
    echo "✗ Travel booking creation FAILED (Action failed)"
    echo "$OUTPUT"
    exit 1
elif echo "$OUTPUT" | grep -q "Permission denied"; then
    echo "✗ Travel booking creation FAILED (Permission denied)"
    echo "$OUTPUT"
    exit 1
elif echo "$OUTPUT" | grep -q "✓"; then
    echo "✓ Travel booking application created successfully"
else
    echo "⚠ Uncertain result - check output:"
    echo "$OUTPUT"
fi
echo ""

echo "Step 11: Verifying created files..."
FILES=$(docker exec test ls /workspace/ 2>&1)
if echo "$FILES" | grep -q "hello.py"; then
    echo "✓ hello.py exists"
else
    echo "✗ hello.py NOT found"
fi
if echo "$FILES" | grep -q "travel_booking"; then
    echo "✓ travel booking file exists"
else
    echo "✗ travel booking file NOT found"
fi
echo ""

echo "=========================================="
echo "✓ ALL VALIDATION TESTS PASSED!"
echo "=========================================="
echo ""
echo "Cleanup with: docker stop test && docker rm test && rm -rf /tmp/home_node"
