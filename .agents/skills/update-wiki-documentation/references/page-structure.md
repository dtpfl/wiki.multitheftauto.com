# Wiki page structure

Use this reference as a description of the repository's current data contract
and renderer behavior. The schemas and implementation remain authoritative.

## Scope and sources

The repository is intended for official MTA:SA Lua API and core-engine
documentation. Its current priority is complete structured API data, followed
by reliable presentation, followed by migration of in-scope legacy content.

Use evidence in this order:

1. Current MTA source or verified runtime behavior
2. Official version and change information
3. Existing schemas and established repository conventions
4. Legacy wiki content, retained with a review marker when not verified

Do not silently turn a legacy statement into an authoritative claim.

## Page routing

| Page kind | Canonical source | Contract | Renderer |
| --- | --- | --- | --- |
| Function | `functions/<Category>/<name>.yaml` | `schemas/function.yaml` | `web/src/pages/reference/[func].astro` |
| Event | `events/<Category>/<name>.yaml` | `schemas/event.yaml` | `web/src/pages/reference/[event].astro` |
| Element | `elements/<Category>/<name>.yaml` | `schemas/element.yaml` | `web/src/pages/reference/[element].astro` |
| Type | `types/<name>.yaml` | Current neighboring entries | `web/src/pages/reference/[theType].astro` |
| Article | `web/src/content/docs/` | Starlight content schema | Starlight |
| Bespoke reference | `web/src/pages/reference/` and often `web/src/data/` | Nearby page and shared components | Page itself |

Astro derives generated API route IDs from YAML filenames. Avoid creating a
hand-authored page that duplicates a generated route.

## Generated function pages

Define one or more of `shared`, `client`, and `server`. Put the common contract
under `shared` when the API exists on both sides. Use client or server overlays
only for real differences. YAML anchors are appropriate for shared data, but do
not merge an anchor into the mapping that defines it.

The renderer presents content in this order:

1. Pair, unresolved checking notice, and HTTP-only warning
2. Version status and purpose-first description
3. Notes
4. OOP syntax
5. Procedural syntax, required arguments, optional arguments, and returns
6. Code examples and preview images
7. Changelog and linked issues
8. Related pages

Authoring rules:

- Keep `name` identical to the API function and filename.
- Describe behavior and outcome before edge cases.
- Give every parameter an exact `name`, API `type`, and useful description.
- Store optional defaults as the literal Lua-facing value expected by the
  schema. Do not label an argument optional without its real default.
- Describe success and failure behavior in `returns.description`; enumerate
  each returned value in order.
- Use `pair` for a meaningful getter/setter counterpart.
- Add `oop` only when the class, method, constructor, side, and static behavior
  are known.
- Use `syntaxes` only for genuine overloads, not prose variations.

## Generated event pages

The renderer presents description and notes, parameter signature, source
element, canceling behavior, code examples, changelog, and related pages.

Authoring rules:

- Set the exact event `name` and `type` (`client` or `server`).
- Explain when the event fires and any important ordering or side constraints.
- Describe every handler parameter in delivery order.
- Identify `source_element.type` and explain what `source` represents here.
- Add `canceling` only when cancel behavior is supported and verified.
- Mark uncertain cancel behavior or source semantics with a specific
  `meta.needs_checking` message.
- Keep each example's `side` consistent with the event type.

## Generated element and type pages

Element pages present the category, description, preview images, OOP-only and
compatible functions, optional examples, and related pages.

- Use the canonical lowercase element name.
- Explain what the element represents, how it is created, and material
  lifecycle or behavior constraints.
- Use `oop_only_methods` only for methods that do not map to procedural
  functions.
- Use category-level `see_also` groups for relevant functions and events.

Type pages currently render either `description` or `redirect`.

- Explain accepted values, units or shape, and important Lua/MTA semantics.
- Use a redirect only for a true alias.
- Do not invent a richer type structure until a schema and renderer support it.

## Hand-authored references and ID lists

Use MDX for primarily prose documentation. Use Astro when a page needs
structured data, reusable components, generated tables, images, or derived Lua
snippets. Keep substantial reusable datasets in `web/src/data/` rather than
embedding them in page markup.

Prefer this page flow:

1. A concise explanation of what the reference contains and where it is used
2. Important qualifications in an existing note component
3. The primary reference table, list, or prose sections
4. Optional copyable Lua data, excluded from search when it only duplicates the
   visible reference
5. Related reference pages

For ID lists, preserve the exact numeric identifiers and stable ordering from
the authoritative source. Keep labels and descriptions distinct, make wide
tables horizontally usable, and link the APIs that consume the identifiers.
Do not copy presentation-only values into multiple files.

## Descriptions, notes, and review state

- Start descriptions with what the API or concept does.
- Keep parameter-specific facts with the parameter.
- Put warnings, limitations, performance guidance, and security-sensitive
  behavior in typed notes (`info`, `warning`, `important`, or `tip`).
- Use `version.added`, `updated`, `deprecated`, or `removed` only with verified
  version information.
- Use changelog entries for discrete historical API changes, not general prose.
- Keep `requires_review: true` on incomplete imported function data.
- Use `meta.needs_checking` for a concrete technical question an expert can
  resolve.

## Examples and assets

- Store Lua examples in the category's adjacent `examples/` directory.
- Use the YAML-relative `examples/<file>.lua` path.
- Demonstrate the documented contract with the smallest realistic example.
- Avoid obsolete APIs, unsafe patterns, unexplained globals, and unrelated
  framework code.
- Label OOP examples with `oop: true`; use a concise title only when it
  distinguishes variants.
- Store source media under root `assets/`, not generated `web/src/assets/`.
- Give preview images a useful description and rendered images meaningful alt
  text.

## Links and presentation

- Prefer canonical Markdown routes:
  `[setElementData](/reference/setElementData)`.
- Use `/articles/...` only for in-scope articles that exist in the new site.
- Do not add new MediaWiki `[[...]]` links; the renderer supports them only for
  migrated content.
- Check anchors and filename casing.
- Reuse `AutoStarlightPage`, `NoteBox`, `CodeExamplesSection`, `PreviewImages`,
  `VersionBox`, and `SeeAlsoSection` where applicable.
- Use MDX for primarily prose content and Astro when structured data or
  components materially improve the page.
- Keep Astro's default JSX-style whitespace handling. In `.astro` templates,
  use an explicit `{" "}` wherever adjacent inline text, elements, or
  components require a visible space; indentation and line breaks are removed
  by Astro 7 and must not carry semantic meaning.
- Audit and fix shared renderers and components before individual pages. Do not
  edit YAML, Markdown, or MDX content solely to compensate for Astro template
  whitespace, and do not enable legacy `compressHTML: true` as a global fix.
- Keep heading levels sequential and page titles unique.
- Prefer shared theme tokens over literal colors.
- Make wide tables horizontally usable and keep important prose outside tables.
- Exclude large helper tables or repeated generated material from search only
  when it would reduce search quality.
