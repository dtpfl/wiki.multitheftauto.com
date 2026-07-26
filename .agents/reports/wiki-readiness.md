# Wiki readiness audit

Snapshot date: 2026-07-26

Branch: `chore/agentic-coding-prep` at `f14164e7`

This report measures structural and migration readiness. It does not certify
that every technical statement matches current MTA behavior. Current MTA source
or verified runtime behavior remains the authority for technical review.

## Scope

| Collection | Documents |
| --- | ---: |
| Functions | 1,407 |
| Events | 220 |
| Elements | 71 |
| Types | 9 |
| **Total** | **1,707** |

The audit parsed all collection YAML, inspected the function renderer, resolved
referenced examples and preview images, and requested documentation routes from
the local development server.

## Priority 0: structural correctness

Address these before attempting broad legacy-content migration.

### Dual-side functions hidden by the renderer

Thirty-one function files define both `client` and `server` without a `shared`
block. `getFunctionType()` selects `client` in this shape, so
`parseFunctionSyntaxes()` does not render the server syntax.

| Category | Affected files |
| --- | ---: |
| Player | 11 |
| Input | 9 |
| Output | 4 |
| Ped | 2 |
| Marker | 1 |
| Projectile | 1 |
| Radar_area | 1 |
| Utility | 1 |
| Vehicle | 1 |

Representative cases:

- `functions/Input/bindKey.yaml` omits the rendered server `thePlayer`
  argument.
- `functions/Ped/createPed.yaml` omits the rendered server `synced` argument.
- `functions/Output/outputChatBox.yaml` contains distinct client and server
  contracts.

Choose and enforce one representation:

1. normalize common data into `shared` with side overlays; or
2. make the renderer support independent client and server roots.

Do not remove review markers while performing a mechanical normalization.

### Duplicate parameters

- `functions/World/setWorldProperty.yaml` stores `value` three times in one
  parameter list, and all three descriptions are placeholders.
- `functions/Drawing/dxCreateTexture.yaml` duplicates `textureFormat` in the
  audited branch snapshot. The correction was subsequently merged into
  upstream `main` by
  [PR #56](https://github.com/multitheftauto/wiki.multitheftauto.com/pull/56)
  and is excluded from the remaining queue. It will reach this stacked branch
  when its base is updated.

Add a semantic validation rule for duplicate names within a single rendered
syntax after resolving the known failures.

### Explicitly incomplete event

`events/Browser/onClientBrowserPopup.yaml` contains:

- `TODO` as the event description;
- `TODO` as the source description; and
- three empty parameter descriptions.

This is the only event with explicit placeholder content. All 220 events have
an example and a populated source object.

### Return and parameter gaps

- 7 reviewed functions have no return block:
  - `functions/Weapon_creation/setWeaponTarget.yaml`
  - `functions/Text/textItemSetText.yaml`
  - `functions/Text/textItemSetPriority.yaml`
  - `functions/Text/textDisplayRemoveText.yaml`
  - `functions/Text/textDisplayAddText.yaml`
  - `functions/Text/textDisplayAddObserver.yaml`
  - `functions/Text/textDestroyTextItem.yaml`
- 21 return blocks have an empty description. Nineteen belong to reviewed
  functions; the other two are overloads in `utf8.fold` and `utf8.title`.
- 270 parameter descriptions contain `MISSING_PARAM_DESC`.
- 18 parameter descriptions are empty strings.

The placeholder and empty-string counts describe stored fields. Shared logical
arguments represented separately on client and server can contribute more than
once.

### Local routes returning 404

The audit requested 477 unique routes referenced by collection YAML. Thirteen
current-site routes returned 404:

**Reference routes**

- `/reference/Building`
- `/reference/elements`
- `/reference/Event_Source_Element`
- `/reference/filepath`
- `/reference/game_processing_order`
- `/reference/ID_Lists/Character_skins`
- `/reference/isMTAWindowFocused`
- `/reference/meta.xml`
- `/reference/Object`
- `/reference/serial`

**Article routes**

- `/articles/Client_commands`
- `/articles/Server_Commands`
- `/articles/Server_Manual`

Check casing and canonical destinations before changing these links. Some
targets represent pages that have not been migrated yet.

## Priority 1: migration state

### Review markers

- 724 of 1,407 function files (51.5%) contain `requires_review: true`.
- Those files contain 755 marked side blocks because 31 files mark both client
  and server roots.
- Events, elements, and types contain no `requires_review` markers.
- 35 `needs_checking` entries exist in 34 files:
  - 32 function files;
  - 2 event files;
  - one function has separate client and server entries.

### Placeholder state

- 116 function files contain 270 `MISSING_PARAM_DESC` values.
- `onClientBrowserPopup` contains the two remaining `TODO` values.
- No other `TODO`, `TBD`, or `THIS ... NEEDS DOCUMENTATION` marker was found in
  collection YAML.

### Legacy links

- 454 Markdown links point to `/wiki/...`.
- They occur in 332 files and represent 162 unique routes.
- Each currently returns the new site's 404 page. Client-side fallback can
  redirect the visitor to the old wiki, so these are migration debt rather than
  missing source files.
- Do not bulk-rewrite them blindly. Replace a link only after confirming the
  canonical new route or intentionally retaining an old-wiki destination.

### Examples and assets

- No referenced example file is missing.
- No referenced preview image is missing.
- 22 example files are not referenced by any YAML entry. Review them before
  either attaching or removing them; an orphan is not proof that a file is
  obsolete.

## Informational coverage

These fields are optional under the current schemas and are not validation
failures.

| Coverage | Result |
| --- | ---: |
| Functions with examples | 1,360 / 1,407 |
| Functions with version metadata | 78 / 1,407 |
| Events with examples | 220 / 220 |
| Events with version metadata | 0 / 220 |
| Elements with examples | 4 / 71 |
| Elements with preview images | 16 / 71 |
| Types with descriptions | 7 / 9 |
| Types implemented as redirects | 2 / 9 |

Add version data only when an authoritative version can be verified. Do not
manufacture examples or images merely to increase coverage.

## Recommended work queue

### Phase A: renderer and high-confidence defects

1. Decide how independent client/server roots should render and cover the 31
   affected files with tests.
2. Complete `onClientBrowserPopup`.
3. Correct `setWorldProperty` parameter modeling.
4. Complete the seven missing return contracts and 21 blank return summaries.
5. Resolve the thirteen broken current-site routes.
6. Add non-destructive audit checks for duplicate parameter names, placeholders,
   empty descriptions, and referenced paths.

### Phase B: reviewed function batches

Finish small categories first to validate the workflow and reduce the number of
partially migrated areas:

1. Module (2), Settings_registry (2), Map (3), Path (3), SVG (6), Team (8)
2. Light (8), Radar_area (8), Projectile (8), Output (9), Searchlight (9),
   Pickup (10)
3. Weapon (12), Server (13), Water (13), Weapon_creation (14), Marker (16),
   Object (16), Input (19), Text (20)
4. Resource (38), Player (58), Ped (79), Utility (83), World (117), Vehicle
   (150)

Move `Text` forward when addressing the missing-return batch. Within each
category, resolve explicit placeholders and `needs_checking` questions before
general prose cleanup.

### Phase C: legacy links and optional coverage

1. Replace `/wiki/...` links as their destination pages become available.
2. Review the 22 orphan examples.
3. Add examples, previews, and version metadata only where they materially
   improve the reference and can be verified.

## Refresh procedure

Refresh this snapshot after structural changes or completion of a documentation
batch:

1. run `tools/validate.sh`;
2. run `tools/check.sh`;
3. search collection YAML for `requires_review`, `needs_checking`,
   `MISSING_PARAM_DESC`, `TODO`, and empty descriptions;
4. audit duplicate parameter names per rendered syntax;
5. resolve every referenced example and preview image;
6. request unique `/reference`, `/articles`, and `/wiki` routes from the local
   server;
7. update the counts and snapshot commit above.

Treat lower counts as progress only when the underlying uncertainty was
actually resolved.
