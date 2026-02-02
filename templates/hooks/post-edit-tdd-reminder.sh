#!/usr/bin/env bash
# post-edit-tdd-reminder.sh
# Nudges toward test-first when code is edited

FILE="$1"

# Skip if editing test files
if echo "$FILE" | grep -qE "(test_|_test\.|\.test\.|\.spec\.|__tests__)"; then
  exit 0
fi

# Skip non-code files
if ! echo "$FILE" | grep -qE "\.(ts|tsx|js|jsx|py|go|rs|java|rb|kt|swift|c|cpp|h)$"; then
  exit 0
fi

# Skip if this is a new file (likely implementing after writing test)
if [ ! -f "$FILE" ]; then
  exit 0
fi

echo "📝 Consider: Does this change have test coverage?"
exit 0
