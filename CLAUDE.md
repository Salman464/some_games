# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Rails 8.1 app for a board-game marketplace. It is the basis of a **UI styling test**: the `Game` CRUD scaffold already works, and the task (see `README.md`) is to style the `/games` pages to match a Figma design and add a footer. Treat polish, attention to detail, and production-readiness as the primary goal — the functional behavior is mostly already in place.

Figma reference: https://www.figma.com/design/6XHByblmhiYRDWbJMHpbnV/UI-test?node-id=0-1

## Commands

- `bundle install` then `bin/rails db:setup` — first-time setup (creates DB, loads schema, seeds ~80 board games from `db/seeds.rb`).
- `bin/dev` — run the app. This uses `Procfile.dev` (foreman) to run **two** processes: the Rails server **and** `yarn watch:css`. Running `bin/rails server` alone will not rebuild CSS.
- `bin/rails test` — run the Minitest suite. Single file: `bin/rails test test/models/game_test.rb`. Single test by line: `bin/rails test test/models/game_test.rb:12`.
- `bin/rails test:system` — Capybara/Selenium system tests (separate from `bin/rails test`).
- `bin/rubocop` — lint (rubocop-rails-omakase style). `bin/brakeman` — security scan.
- The app lives at `http://localhost:3000/games` (there is no root route).

## CSS build pipeline — important

CSS is **not** served by Propshaft from raw SCSS. The flow is:

`app/assets/stylesheets/application.bootstrap.scss` → compiled by `sass` (with `--load-path=node_modules`) → `app/assets/builds/application.css` → run through PostCSS/autoprefixer (in place).

- Bootstrap 5.3 and bootstrap-icons are pulled from `node_modules` and `@import`ed in `application.bootstrap.scss`. Add new stylesheets by importing them there (see how `games` is imported); a standalone `.scss` file will not be picked up otherwise.
- Edit SCSS, not the generated `app/assets/builds/application.css` (it is overwritten on every build).
- `yarn build:css` does a one-off compile; `bin/dev` runs `yarn watch:css` to rebuild on change. If styles aren't updating, confirm the css process in `bin/dev` is running.
- JS uses **importmap-rails** (`config/importmap.rb`, Stimulus controllers in `app/javascript/controllers`), while CSS uses **cssbundling-rails** (Yarn/Sass). The two asset systems are separate — don't conflate them.

## Domain model

Single model: `Game` (`app/models/game.rb`) with `name`, `price_cents` (integer), and `condition` — an ActiveRecord enum mapping `mint:1, excellent:2, good:3, as_is:4`. There are no validations and no associations. `db/seeds.rb` is the source of game data; matching board-game cover images live in `app/assets/images/board_game_images/` keyed by game name (e.g. `Catan.jpg`).

Note: `db/seeds.rb` assigns decimal dollar values (e.g. `34.99`) to the integer `price_cents` column, so they truncate on save. Be aware of this if working on price display/formatting.

## Conventions

- Standard Rails scaffold layout: `GamesController` is a textbook `resources :games` controller; views in `app/views/games/` include both `.html.erb` and `.json.jbuilder` variants per action.
- Database is SQLite across all environments. Caching, jobs, and Action Cable use the `solid_*` gems (database-backed), not Redis.
- Deployment is via Kamal (`.kamal/`, `Dockerfile`) — relevant only if asked about deploy.
