#!/usr/bin/env bash
# pre-commit-test-gate.sh
# Runs tests before Claude commits code

INPUT="$1"

# Only intercept git commit commands
if ! echo "$INPUT" | grep -q "git commit"; then
  exit 0
fi

echo "🧪 Running tests before commit..."

# Detect and run test suite
if [ -f "package.json" ] && grep -q '"test"' package.json; then
  npm test || { echo "❌ Tests failed. Fix before committing."; exit 1; }
elif [ -f "pyproject.toml" ] || [ -f "pytest.ini" ] || [ -f "setup.py" ]; then
  python -m pytest || { echo "❌ Tests failed. Fix before committing."; exit 1; }
elif [ -f "Cargo.toml" ]; then
  cargo test || { echo "❌ Tests failed. Fix before committing."; exit 1; }
elif [ -f "go.mod" ]; then
  go test ./... || { echo "❌ Tests failed. Fix before committing."; exit 1; }
else
  echo "ℹ️  No test runner detected, skipping pre-commit tests"
fi

exit 0
