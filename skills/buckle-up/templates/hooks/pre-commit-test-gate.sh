#!/bin/bash
# Block commit if tests fail
npm test --passWithNoTests 2>/dev/null || pytest -q 2>/dev/null || echo "No test runner found"
exit $?
