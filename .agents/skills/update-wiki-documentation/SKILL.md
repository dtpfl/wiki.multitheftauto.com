---
name: update-wiki-documentation
description: Create, migrate, review, or restructure documentation in the Multi Theft Auto wiki repository. Use for function, event, element, type, reference, ID-list, or official article pages; YAML documentation and Lua examples; documentation links, assets, layout, or page rendering.
---

# Update wiki documentation

Follow the repository's data-first documentation system and preserve the
official MTA team's scope and page conventions.

## Establish the task

1. Read `CONTRIBUTING.md` and the applicable root `AGENTS.md`.
2. Classify the target as:
   - a generated function, event, element, or type page;
   - a hand-authored reference or ID-list page;
   - an official article; or
   - a renderer or shared presentation change.
3. Stop and report a scope conflict before adding third-party, community, or
   general tutorial content.
4. Read [page structure](references/page-structure.md) before authoring or
   reviewing a page.

## Gather authoritative context

1. Read the applicable file in `schemas/` and `schemas/common-defs.yaml`.
2. Read two or three complete entries in the same category and side. Prefer
   entries without `requires_review` and with descriptions, parameters,
   returns, examples, and version metadata.
3. Read the applicable renderer in `web/src/pages/reference/` when changing
   structure, presentation, or a field whose display is unclear.
4. Treat current MTA source, official change information, and verified behavior
   as stronger evidence than legacy wiki prose. Preserve uncertainty explicitly.

## Make the documentation change

1. Edit the canonical source:
   - root YAML plus adjacent examples for generated API pages;
   - `web/src/content/docs/` for Starlight content;
   - `web/src/pages/reference/` and `web/src/data/` for bespoke reference pages.
2. Keep technical names, sides, types, defaults, version numbers, and return
   behavior exact. Do not infer missing facts.
3. Write a concise purpose-first description. Put constraints and hazards in
   notes, and keep parameter descriptions specific to that parameter.
4. Use existing components for notes, code, images, changelogs, versions, and
   related links. Avoid duplicating presentation in page-local markup.
5. In Astro templates, add an explicit `{" "}` between adjacent inline nodes
   when a visible space is intended. Do not rely on formatting whitespace.
6. Add or update focused examples when the page contract expects them. Verify
   every referenced path.
7. Prefer Markdown links to canonical local routes. Confirm the destination
   exists and use external links only when they add authoritative information.
8. Retain `requires_review` or `needs_checking` until its underlying uncertainty
   is resolved. Make review notes actionable rather than generic.

## Verify the result

1. Run `tools/validate.sh` while iterating on YAML.
2. Run `tools/check.sh` after a documentation change.
3. Run `tools/check.sh --full` after changing a renderer, component, content
   loader, shared data, preprocessing, or build behavior.
4. Restart the development server after changing root YAML if the rendered
   route is stale; external collections may not reliably hot-reload.
5. Inspect every affected route at `http://localhost:4321`, including narrow
   viewport behavior for tables and images.
6. Review `git diff` for unrelated changes, generated output, placeholder text,
   broken paths, and accidentally removed review markers.
7. Report the files changed, checks performed, visual routes inspected, and
   unresolved technical questions. Do not commit or push unless explicitly
   requested.
