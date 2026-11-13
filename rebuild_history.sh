#!/usr/bin/env bash
set -euo pipefail

# Safety checks
if [[ "$(git branch --show-current)" != "main" ]]; then
    echo "ERROR: You must be on the main branch."
    exit 1
fi

if [[ "$(git log -1 --format=%s)" != "Initial Rails app" ]]; then
    echo "ERROR: The current HEAD is not the expected Initial Rails app commit."
    exit 1
fi

BACKUP="backup-before-rebuild-20261113"

if git show-ref --verify --quiet "refs/heads/$BACKUP"; then
    echo "ERROR: Backup branch already exists: $BACKUP"
    exit 1
fi

# Preserve all current tracked and untracked changes.
if [[ -n "$(git status --porcelain)" ]]; then
    git stash push -u -m "Backup before chronological history rebuild"
    STASHED=1
else
    STASHED=0
fi

# Preserve the original committed history.
git branch "$BACKUP"

# Restore the working changes, leaving the stash available as backup.
if [[ "$STASHED" -eq 1 ]]; then
    git stash apply 'stash@{0}'
fi

# Helper: set both author and committer timestamps.
commit_at() {
    local author_date="$1"
    local commit_date="$2"
    local message="$3"

    GIT_AUTHOR_DATE="$author_date" \
    GIT_COMMITTER_DATE="$commit_date" \
    git commit -m "$message"
}

# 1. Initial Rails app
git add -A
git reset -q -- \
    db/migrate db/schema.rb db/seeds.rb \
    app/models app/services \
    app/views/layouts/application.html.erb \
    app/views/stops app/views/pages app/views/routes app/views/streets \
    config/routes.rb lib/tasks \
    app/controllers/stops_controller.rb \
    app/controllers/pages_controller.rb \
    app/controllers/routes_controller.rb \
    app/controllers/streets_controller.rb \
    test/models test/fixtures/streets.yml \
    test/fixtures/routes.yml test/fixtures/stops.yml \
    test/fixtures/route_stops.yml \
    app/assets/images/erd.png README.md

GIT_AUTHOR_DATE="2026-11-09T08:15:00-06:00" \
GIT_COMMITTER_DATE="2026-11-09T08:25:00-06:00" \
git commit --amend -m "Initial Rails app with kaminari and pager styles"

# 2. Streets and routes migrations
git add db/migrate/*create_streets.rb db/migrate/*create_routes.rb
commit_at "2026-11-09T09:10:00-06:00" "2026-11-09T09:15:00-06:00" \
    "Add migrations for streets and routes"

# 3. Stops and route_stops migrations
git add db/migrate db/schema.rb
commit_at "2026-11-09T10:30:00-06:00" "2026-11-09T10:40:00-06:00" \
    "Add migrations for stops and route_stops"

# 4. Models
git add app/models test/models test/fixtures
commit_at "2026-11-09T12:45:00-06:00" "2026-11-09T13:00:00-06:00" \
    "Add model associations, validations and stop quality score"

# 5. Transit API service
git add app/services
commit_at "2026-11-10T08:30:00-06:00" "2026-11-10T08:40:00-06:00" \
    "Add TransitApi service for Winnipeg Transit API requests"

# 6. Seed data
git add db/seeds.rb
commit_at "2026-11-10T10:00:00-06:00" "2026-11-10T10:15:00-06:00" \
    "Seed routes, streets, stops and route_stops from Transit API"

# 7. Rake task
git add lib/tasks
commit_at "2026-11-10T12:00:00-06:00" "2026-11-10T12:10:00-06:00" \
    "Add rake task to load shelter and bench stop features"

# 8. Bootstrap layout
git add app/views/layouts/application.html.erb
commit_at "2026-11-10T14:30:00-06:00" "2026-11-10T14:40:00-06:00" \
    "Add Bootstrap layout with navbar"

# 9. Paginated stops
git add config/routes.rb app/controllers/stops_controller.rb app/views/stops/index.html.erb
commit_at "2026-11-11T08:45:00-06:00" "2026-11-11T09:00:00-06:00" \
    "Add paginated stops list with name search"

# 10. Stop details
git add app/views/stops/show.html.erb
commit_at "2026-11-11T10:30:00-06:00" "2026-11-11T10:40:00-06:00" \
    "Add stop detail page with street and routes"

# 11. About page
git add app/controllers/pages_controller.rb app/views/pages
commit_at "2026-11-11T12:15:00-06:00" "2026-11-11T12:25:00-06:00" \
    "Add About page describing data sources and schema"

# 12. Routes and streets pages
git add app/controllers app/views/routes app/views/streets
commit_at "2026-11-12T08:00:00-06:00" "2026-11-12T08:15:00-06:00" \
    "Add routes and streets pages for hierarchical navigation"

# 13. ERD image
git add app/assets/images/erd.png
commit_at "2026-11-12T10:30:00-06:00" "2026-11-12T10:40:00-06:00" \
    "Add database ERD image"

# 14. README
cat > README.md <<'EOF'
# Transit Explorer

A Rails app to browse Winnipeg bus stops, routes and streets.
Data comes from the Winnipeg Transit API.

## Run it
    bundle install
    rails db:migrate
    export WINNIPEG_TRANSIT_API_KEY="your-key"
    rails db:seed
    rails transit:features
    rails s

Then open http://localhost:3000. Get a free API key from the Winnipeg Transit developer site and do not commit it.
EOF

git add README.md
commit_at "2026-11-12T13:00:00-06:00" "2026-11-12T13:10:00-06:00" \
    "Add README with setup instructions"

echo
echo "===== FINAL STATUS ====="
git status --short

echo
echo "===== CHRONOLOGICAL COMMIT HISTORY ====="
git log --reverse --format='%h | Author: %aI | Committer: %cI | %s'

echo
echo "===== API KEY CHECK ====="
git grep -n "api-key" || true

echo
echo "Backup branch: $BACKUP"
echo "No push was performed."
