#!/bin/sh
#husky 0.14.3

command_exists () {
  command -v "$1" >/dev/null 2>&1
}

has_hook_script () {
  [ -f package.json ] && cat package.json | grep -q "\"$1\"[[:space:]]*:"
}

# Check if prepush script is defined, skip if not
has_hook_script prepush || exit 0

# Node standard installation
export PATH="$PATH:/c/Program Files/nodejs"

# Check that npm exists
command_exists npm || {
  echo >&2 "husky > can't find npm in PATH, skipping prepush script in package.json"
  exit 0
}

# Export Git hook params
export GIT_PARAMS="$*"

# Run npm script
echo "husky > npm run -s prepush (node `node -v`)"
echo

npm run -s prepush || {
  echo
  echo "husky > pre-push hook failed (add --no-verify to bypass)"
  exit 1
}