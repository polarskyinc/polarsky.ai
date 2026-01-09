Welcome to Polar Sky!

## Local preview (Jekyll)

### Option A: Docker (recommended)

- Start: `JEKYLL_PORT=4001 docker compose up --build` (use `4000` if it’s free)
- Open: `http://localhost:4001`
- Stop: `docker compose down`
- Shortcut: `JEKYLL_PORT=4001 ./bin/serve`
- You do NOT need to restart on most edits (auto-reload is enabled); restart if you change `_config.yml`, `Gemfile`/`Gemfile.lock`, or `Dockerfile`.

### Option B: Native Ruby

- Install Ruby `3.2.x`
- Run: `gem install bundler && bundle install`
- Start: `bundle exec jekyll serve --livereload`
