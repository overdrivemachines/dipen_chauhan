#!/usr/bin/env bash
# Deploy a Rails app that lives in ./code next to this script.
# Copy this script into another Rails app and adjust APP_ROOT if needed.

# Exit immediately when a command fails, and make failed pipeline commands fail the script.
set -eo pipefail

# Print the line number when a command fails so deploy failures are easier to locate.
trap 'echo "ERROR: Line $LINENO failed. Exiting."; exit 1' ERR

# Show brief usage help and exit before doing any deploy work.
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<'HELP'
Usage:
  ./update.sh
  KEY=value ./update.sh

Common switches:
  APP_ROOT=/path/to/code          Default: ./code next to update.sh
  GIT_REMOTE=origin              Git remote to fetch
  GIT_BRANCH=master              Git branch to deploy
  GIT_STRATEGY=hard_reset        hard_reset or ff_only
  CLEAN_UNTRACKED=0              Set 1 to run protected git clean
  RUN_BUN_INSTALL=1              Set 0 to skip Bun install
  RUN_MIGRATIONS=1               Set 0 to skip Rails migrations
  RUN_ASSETS_PRECOMPILE=1        Set 0 to skip asset precompile
  RESTART_PASSENGER=1            Set 0 to skip Passenger restart
  RUN_SMOKE_CHECKS=1             Set 0 to skip Rails/runtime smoke checks

Examples:
  GIT_BRANCH=staging ./update.sh
  GIT_STRATEGY=hard_reset CLEAN_UNTRACKED=1 ./update.sh
  RUN_MIGRATIONS=0 RESTART_PASSENGER=0 ./update.sh
HELP
  exit 0
fi

# Directory where this update.sh file is located.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# App directory; override for another project with: APP_ROOT=/path/to/app ./update.sh
APP_ROOT="${APP_ROOT:-${SCRIPT_DIR}/code}"

# Git remote to deploy from; override with: GIT_REMOTE=upstream ./update.sh
GIT_REMOTE="${GIT_REMOTE:-origin}"

# Git branch to deploy; override with: GIT_BRANCH=master ./update.sh
GIT_BRANCH="${GIT_BRANCH:-master}"

# Default git mode is deployment-oriented: fetch, then make tracked files match the remote branch.
# Options:
#   hard_reset = force tracked files to match the remote branch exactly
#   ff_only    = preserve local changes; abort if the VPS has diverged
GIT_STRATEGY="${GIT_STRATEGY:-hard_reset}"

# Default is to keep untracked files, because uploads, logs, SQLite DBs, and local config may be untracked.
# Set CLEAN_UNTRACKED=1 only when you are sure all important writable files live outside the repo or are excluded below.
CLEAN_UNTRACKED="${CLEAN_UNTRACKED:-0}"

# Paths protected from git clean when CLEAN_UNTRACKED=1.
# Keep storage for uploads and Rails SQLite databases, log for app logs, tmp for runtime files, and vendor/bundle for gems.
GIT_CLEAN_EXCLUDES=(
  "vendor"
  "vendor/bundle"
  ".bundle"
  "storage"
  "storage/*.sqlite3"
  "storage/*.sqlite3-*"
  "db/*.sqlite3"
  "db/*.sqlite3-*"
  "log"
  "tmp"
  ".env"
  ".env.production"
)

# Rails environment used for migrations and asset compilation.
RAILS_ENV="${RAILS_ENV:-production}"

# Rack environment used by Rack-compatible tooling.
RACK_ENV="${RACK_ENV:-$RAILS_ENV}"

# Node environment used by JS tooling.
NODE_ENV="${NODE_ENV:-production}"

# Bundler groups skipped during production install.
BUNDLE_WITHOUT="${BUNDLE_WITHOUT:-development:test}"

# Bundler install path; defaults inside the app so gems survive deploys.
BUNDLE_PATH="${BUNDLE_PATH:-${APP_ROOT}/vendor/bundle}"

# Number of parallel Bundler jobs; tune this down for small VPS instances.
BUNDLE_JOBS="${BUNDLE_JOBS:-2}"

# Number of times Bundler retries transient network failures.
BUNDLE_RETRY="${BUNDLE_RETRY:-3}"

# Whether to install Bun dependencies.
RUN_BUN_INSTALL="${RUN_BUN_INSTALL:-1}"

# Whether to run Rails database migrations.
RUN_MIGRATIONS="${RUN_MIGRATIONS:-1}"

# Whether to precompile Rails assets.
RUN_ASSETS_PRECOMPILE="${RUN_ASSETS_PRECOMPILE:-1}"

# Whether to restart Passenger after deploy.
RESTART_PASSENGER="${RESTART_PASSENGER:-1}"

# Whether to run a basic Rails runtime check before reporting a successful deploy.
RUN_SMOKE_CHECKS="${RUN_SMOKE_CHECKS:-1}"

# Ensure the app directory exists before trying to deploy it.
if [[ ! -d "$APP_ROOT" ]]; then
  echo "ERROR: $APP_ROOT does not exist"
  exit 1
fi

# Move into the app directory so git, mise, bundle, bun, and rails read project files.
cd "$APP_ROOT"

# Ensure this app directory is actually a git checkout.
if [[ ! -d .git ]]; then
  echo "ERROR: $APP_ROOT is not a git repository"
  exit 1
fi

# Prefer the default mise install path, then fall back to PATH.
if [[ -x "$HOME/.local/bin/mise" ]]; then
  MISE="$HOME/.local/bin/mise"
elif command -v mise >/dev/null 2>&1; then
  MISE="$(command -v mise)"
else
  echo "ERROR: mise not found. Install mise for this deploy user first."
  echo "Expected: $HOME/.local/bin/mise or a mise executable on PATH."
  exit 1
fi

# Fetch remote refs without modifying the working tree.
echo "==> Fetching ${GIT_REMOTE}/${GIT_BRANCH}"
git fetch --prune "$GIT_REMOTE"

# Deploy the requested branch according to the selected git strategy.
case "$GIT_STRATEGY" in
  ff_only)
    # Abort if local tracked files would be overwritten or if history diverged.
    echo "==> Updating code with fast-forward only"
    git merge --ff-only "${GIT_REMOTE}/${GIT_BRANCH}"
    ;;
  hard_reset)
    # Force tracked files to exactly match the remote branch.
    echo "==> Updating code with hard reset"
    git reset --hard "${GIT_REMOTE}/${GIT_BRANCH}"
    ;;
  *)
    # Stop on unknown strategies rather than guessing.
    echo "ERROR: Unknown GIT_STRATEGY=$GIT_STRATEGY. Use ff_only or hard_reset."
    exit 1
    ;;
esac

# Optionally remove untracked files while preserving known runtime data directories.
if [[ "$CLEAN_UNTRACKED" == "1" ]]; then
  echo "==> Removing untracked files except protected runtime paths"
  CLEAN_ARGS=(-fd)
  for path in "${GIT_CLEAN_EXCLUDES[@]}"; do
    CLEAN_ARGS+=(-e "$path")
  done
  git clean "${CLEAN_ARGS[@]}"
else
  echo "==> Keeping untracked files"
fi

# Require mise config because it defines Ruby, Node, and Bun versions.
if [[ ! -f mise.toml ]]; then
  echo "ERROR: mise.toml missing from $APP_ROOT"
  exit 1
fi

# Mark this repo's mise config as trusted if mise requires trust on this machine.
echo "==> Trusting mise config"
"$MISE" trust "$APP_ROOT/mise.toml" >/dev/null 2>&1 || true

# Install the Ruby, Node, and Bun versions declared in mise.toml.
echo "==> Installing mise tools from mise.toml"
"$MISE" install

# Export Rails environment for Rails commands.
export RAILS_ENV

# Export Rack environment for Rack-compatible gems.
export RACK_ENV

# Export Node environment for JS tooling.
export NODE_ENV

# Export Bundler group exclusions.
export BUNDLE_WITHOUT

# Tell Bundler to install in deployment mode using Gemfile.lock.
export BUNDLE_DEPLOYMENT=true

# Export Bundler install path.
export BUNDLE_PATH

# Ensure the Bundler install path exists before bundle install.
mkdir -p "$BUNDLE_PATH"

# Print runtime versions so deploy logs show exactly what mise selected.
echo "==> Runtime versions"
"$MISE" exec -- ruby -v
"$MISE" exec -- node -v
"$MISE" exec -- bun -v

# Require a locked Ruby dependency graph for repeatable production deploys.
echo "==> Verifying Ruby lockfile"
[[ -f Gemfile.lock ]] || { echo "ERROR: Gemfile.lock missing"; exit 1; }

# Read the Bundler version pinned by Gemfile.lock so deploys use the same
# resolver/installer version as development.
BUNDLER_VERSION="$(
  awk '
    $0 == "BUNDLED WITH" { getline; gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0); print; exit }
  ' Gemfile.lock
)"
[[ -n "$BUNDLER_VERSION" ]] || { echo "ERROR: Could not determine Bundler version from Gemfile.lock"; exit 1; }

# Require Bun's lockfile only when Bun install is enabled.
if [[ "$RUN_BUN_INSTALL" == "1" ]]; then
  echo "==> Verifying Bun lockfile"
  [[ -f bun.lock ]] || { echo "ERROR: bun.lock missing"; exit 1; }
fi

# Install the exact Bundler version pinned by Gemfile.lock into the selected mise Ruby.
if ! "$MISE" exec -- gem list bundler -i -v "$BUNDLER_VERSION" >/dev/null 2>&1; then
  echo "==> Installing Bundler $BUNDLER_VERSION"
  "$MISE" exec -- gem install bundler -v "$BUNDLER_VERSION"
fi

# Install Ruby gems from Gemfile.lock into BUNDLE_PATH.
echo "==> Installing Ruby gems"
"$MISE" exec -- bundle "_${BUNDLER_VERSION}_" install --jobs "$BUNDLE_JOBS" --retry "$BUNDLE_RETRY"

# Install JS dependencies from bun.lock when enabled.
if [[ "$RUN_BUN_INSTALL" == "1" ]]; then
  echo "==> Installing JS deps"
  "$MISE" exec -- bun install --frozen-lockfile --production
fi

# Run Rails migrations when enabled.
if [[ "$RUN_MIGRATIONS" == "1" ]]; then
  echo "==> Running database migrations"
  "$MISE" exec -- bundle exec rails db:migrate
fi

# Compile Rails assets when enabled.
if [[ "$RUN_ASSETS_PRECOMPILE" == "1" ]]; then
  echo "==> Precompiling assets"
  "$MISE" exec -- bundle exec rails assets:precompile
fi

# Verify the Rails app boots and can reach its primary database before reporting a successful deploy.
if [[ "$RUN_SMOKE_CHECKS" == "1" ]]; then
  echo "==> Running Rails production smoke check"
  "$MISE" exec -- bundle exec rails runner - <<'RUBY'
ActiveRecord::Base.connection.execute("SELECT 1")
puts "Rails boot and primary database OK"
RUBY
fi

# Restart the Passenger app when enabled.
if [[ "$RESTART_PASSENGER" == "1" ]]; then
  echo "==> Restarting app with Passenger"
  if command -v passenger-config >/dev/null 2>&1; then
    passenger-config restart-app "$APP_ROOT" --ignore-app-not-running
  else
    "$MISE" exec -- passenger-config restart-app "$APP_ROOT" --ignore-app-not-running
  fi
fi

# Final success marker for deploy logs.
echo "==> Deploy complete."
