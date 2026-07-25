# Repository agent guide

## Mission and priorities

This repository is the structured source of truth for official Multi Theft
Auto: San Andreas Lua API and core-engine documentation. Follow
`CONTRIBUTING.md`:

1. Complete and stabilize the YAML API structure.
2. Make the site render that structure correctly and consistently.
3. Port in-scope legacy documentation only after the structure and display are
   ready.

Keep content focused on built-in functions, events, elements, types, data
structures, and native MTA behavior. Do not add third-party resources,
community content, general scripting tutorials, or fan-made project pages.

## Repository map

- `functions/`, `events/`, `elements/`, and `types/` contain YAML source data.
- Adjacent `examples/` directories contain source examples referenced by YAML.
- `schemas/` defines the YAML data contract used by `tools/validate.sh`.
- `assets/` contains source images and audio.
- `web/src/content.config.ts` loads the root YAML collections.
- `web/src/pages/reference/` and `web/src/components/` render reference pages.
- `web/src/content/docs/` contains hand-authored Starlight content.
- `web/src/data/` contains structured data for hand-authored reference pages.

Use the `update-wiki-documentation` skill when creating, migrating, reviewing,
or restructuring wiki documentation.

## Generated files

Do not edit these generated or ignored paths:

- `web/src/assets/`
- `web/src/grammars/`
- `web/public/grammars/`
- `web/.astro/`
- `web/dist/`

`npm run dev` and `npm run build` run `web/scripts/preprocess.js`. It generates
the Lua grammar and replaces `web/src/assets/` with a copy of the root
`assets/`. Edit `assets/` or `web/mta_highlighting/` instead.

## Setup and local development

Use Node.js 22.12 or newer and Git LFS.

```bash
git lfs pull
npm --prefix web ci
npm --prefix web run dev
```

The development site is available at `http://localhost:4321`.

## Documentation rules

- Treat the schemas as the authoritative structural contract. Inspect nearby,
  complete entries of the same category for established usage.
- For a function, event, element, or type page, edit its root YAML source and
  referenced examples or assets. Do not hand-author a duplicate generated page.
- Keep filenames and `name` values aligned with the exact API identifier unless
  the file is an intentional redirect.
- Prefer Markdown links such as `[setElementData](/reference/setElementData)`.
  Preserve working MediaWiki-style links when editing nearby text, but do not
  introduce new ones.
- Keep examples focused, executable, side-correct, and stored beside their YAML
  category. Reference them with relative `examples/...` paths.
- Use `requires_review: true` for an incomplete imported function entry. Use a
  specific `meta.needs_checking` message when a technical claim needs expert
  verification. Remove either marker only after resolving it.
- Do not present assumptions from the legacy wiki as verified MTA behavior.
- Reuse existing components and theme tokens. Avoid page-specific styling when
  an established component or shared style solves the same problem.
- Make images descriptive with useful alt text and keep tables usable on narrow
  screens.

## Verification

Use the narrowest relevant check while iterating:

```bash
# All YAML schemas plus Astro and TypeScript diagnostics
tools/check.sh

# Fast checks followed by a production build
tools/check.sh --full

# YAML only
tools/validate.sh
```

Run `tools/check.sh --full` for changes to rendering, shared components,
preprocessing, build configuration, or dependencies. For a data-only change,
run `tools/check.sh` and inspect the affected page in the development server.
Confirm that referenced examples, assets, and internal links resolve.

## Working agreements

- Inspect `git status` and relevant diffs before editing. Preserve unrelated
  user changes in a dirty working tree.
- Keep branches and pull requests focused on one reviewable concern.
- Do not edit external Cloudflare Pages configuration from this repository.
- Do not commit, push, open a pull request, deploy, or change external systems
  unless the user explicitly asks.
- Before handoff, state what changed, which checks ran, and any unresolved
  review or migration questions.
