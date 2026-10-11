# Long-book reader: implementation plan

Prototype (behaviour reference): https://claude.ai/artifact/79RifhKUyeeULJQHQ8kRZx

## Goal

Replace `lib/core/widgets/content_view_page.dart` with a reader that splits long HTML into numbered sections, shows where the reader is, and lets older readers jump anywhere in two taps. No Firestore or data-model changes.

Call sites that must move to the new reader (same constructor: `title`, `content`, optional `chapterName`):

- `lib/features/Books/presentation/pages/all_books_page.dart` (html books)
- `lib/features/Books/presentation/pages/chapters_list_page.dart` (each chapter)
- `lib/features/Astottaras/presentation/pages/all_astottara_page.dart`
- `lib/features/Lyrics/presentation/pages/lyrics_listview_page.dart`

## Phase 1: groundwork

### 1. `lib/core/reader/reading_palette.dart`

`ReadingPalette.of(String readingTheme)` for the existing setting values `'light'`, `'sepia'`, `'dark'` (anything else → light).

| token | light | sepia | dark |
|---|---|---|---|
| background | `#FBF7EF` | `#F4ECD8` | `#15120F` |
| bar (app bar, contents header) | `#F2EADC` | `#EADFC6` | `#1E1A16` |
| surface (cards, location bar) | `#FFFDF8` | `#FAF4E6` | `#241F1A` |
| ink (body text) | `#000000` | `#000000` | `#EDE6D8` |
| muted (secondary text) | `#5C5045` | `#5E4A39` | `#B9AE9E` |
| line (dividers, empty progress) | `#DDD1BD` | `#D9C9A8` | `#3A322A` |
| buttonEdge (≥3:1 outlines) | `#9C8C76` | `#9A8463` | `#6E6253` |
| accent (fills only) | `#FFA000` | `#FFA000` | `#FFA000` |
| onAccent (text/icons on accent) | `#000000` | `#000000` | `#000000` |
| accentLine (labels, progress fill, scroll thumb, focus) | `#010036` | `#010036` | `#FFA000` |
| accentWash (current-row / arrival tint) | `#FFA000` @ 24% | `#FFA000` @ 24% | `#FFA000` @ 16% |
| bubbleBg / bubbleFg | `#010036` / `#FFFFFF` | `#010036` / `#FFFFFF` | `#EDE6D8` / `#15120F` |

Rules: amber is never used as text or a thin line on light/sepia (1.9:1). No red anywhere in the reader. No pure white backgrounds, no pure black dark background.

Also use the palette in the existing `ContentViewPage` colours and in the settings preview (`settings_page.dart` lines ~108 and ~120) so the colours ship even before the new reader.

### 2. `lib/core/reader/section_parser.dart`

Pure Dart: `List<ReaderSection> parseSections(String html)`.

`ReaderSection { int number /* 1-based */, String title /* plain text */, String? headingHtml, String bodyHtml, int length /* chars of the raw piece */ }`

Rules (match the prototype exactly):

1. Split on `<hr>` / `<hr/>` / `<hr />` (case-insensitive). Trim; drop empty pieces.
2. If the piece starts with `<h3…>…</h3>`: that h3 is the heading. `headingHtml` = its inner HTML, `bodyHtml` = the rest.
3. Else if the piece starts with a `<p>` that contains no `<br>` and more content follows it (≥ 20 chars): that `<p>` is the heading, same as above.
4. Else: no heading (`headingHtml` null, `bodyHtml` = whole piece); title = text of the first line of the first `<p>` (up to the first `<br>` or `</p>`).
5. Title cleaning: strip tags, decode entities (use `package:html` `parseFragment(...).text`), replace runs of `|`, `।`, `॥` with a space, collapse whitespace, trim, trim leading/trailing `-`/`–`.
6. Fallback title: `Section n`.

Only the opening heading counts. Other `<h3>` inside a piece are refrains or closing lines, and `<h4>` is used for numbered names 1–9 in astottaras; they are not index entries.

Add `html` as a direct dependency (it is already transitive via flutter_html).

### 3. Tests (create `test/`)

- Fixture `test/fixtures/sample_book.html` (the real sample book).
- `parseSections` on the fixture → 29 sections. Spot-check titles: 1 `ಶ್ರೀ ಗುರುಭ್ಯೋ ನಮ:`, 4 `ಗುರು ಪಾದುಕಾ ಸ್ತೋತ್ರಂ`, 5 `ಗುರ್ವಷ್ಟಕಮ್`, 15 `ರಾಮ ಬಂದ ಶ್ಯಾಮ ಬಂದ ಶಿವನೇ`, 26 `ವಿಬುಧಕೀರ್ತಿತಂ`, 29 `ಮಂಗಳ`.
- HTML without `<hr>` → 1 section. Empty string → 0 sections (reader shows the existing "Failed to load content" state).
- `ReadingPalette.of` returns the table values; unknown theme → light.

## Phase 2: the reader

### 4. Scrolling list

Use `scrollable_positioned_list` (`ItemScrollController.jumpTo`, `ItemPositionsListener`). One item per section, built lazily: heading block, then `Html(data: bodyHtml)`, then a "Next" card. If it cannot restore a position inside a section reliably, fall back to `super_sliver_list` and note why.

### 5. `lib/core/reader/reader_page.dart` (`ReaderPage`)

Same constructor as `ContentViewPage`; swap the four call sites. Delete `ContentViewPage` once nothing uses it.

- **1 section** (most lyrics/astottaras): plain reader, no location bar, no contents, no section number. Top bar still has theme + A−/A+.
- **≥ 2 sections**: full reader below; opens on the Contents screen.

Text style: existing `fontSize` and `fontStyle` settings (`notoserifkannada` / `notosanskannada`), line height 1.8. Inside bodies: `h4` renders like a paragraph with no margins (and the following `p` gets no top margin); inner `h3` is centred, weight 600, 0.95em, `accentLine` colour. UI numbers use the `poppins` family. UI labels in English.

### 6. Section heading (in the list)

A horizontal rule with a filled amber number circle (46 dp, black number) in the middle; below it the heading (if any) in the content font at 1.15× size, bold, centred. 34 dp top padding.

"Next" card at the end of each section: full width, ≥ 70 dp, `surface` fill, `line` border, label `Next · 14` in `accentLine`, next title (one line, ellipsis), chevron. Last section: "End of book / Back to contents".

### 7. Position tracking

From `ItemPositionsListener`, the current section is the one crossing a reading line 30% down the viewport; progress `r` = how far that line is through the section (0–1). If scrolled to the very end, current = last, r = 1. Everything (bar, bubble, saved position) reads this one value.

### 8. Location bar (bottom, always visible)

- Progress strip, 5 dp, full width: one segment per section, flex weight `max(length, 400)`, 2 dp gaps; filled with `accentLine` (done = full, current = r, later = empty), empty = `line`.
- Row: previous button (56×58, `buttonEdge` outline), middle pill (tap → Contents) showing `14 of 29` + `Contents ▴` in `accentLine` on top and the section title (17 sp, one line) below, next button. Disable prev on 1 and next on last.

### 9. Contents screen

Slides up over the reader (≈400 ms, ease-out). Header in `bar` colour: down-chevron "Back to reading", "Contents", book title · N sections.

- "Start reading" / "Continue reading" card: amber fill, black text, shows `14 · title`; closes Contents (reader is already at that position). Shows "Continue reading" when the reader has a saved or current position past the top.
- "Go to number" field: numeric keyboard, also accepts Kannada digits ೦–೯; Go button amber. Out of range → `Enter a number from 1 to N.`
- List: rows ≥ 68 dp, number circle + title (2 lines max). Current row: `accentWash` background, filled amber number, "Now reading" label. Scroll the current row to the middle when opening.

### 10. Jumps (contents row, go-to-number, prev/next, Next card)

Jump instantly to the section start (no animated scroll). Fade/slide the text in (~300 ms from 15% opacity, 12 dp below). The heading block flashes `accentWash` that fades out over ~2 s, and the number circle gives one expanding amber ring.

### 11. Top bar

`bar` background, `ink` foreground (no gradient in the reader). Contents button (when ≥ 2 sections), title, theme button (cycles light → sepia → dark via `UpdateTheme`, with a short toast "Sepia background"), A− / A+ stepping through 16, 18, 20, 22, 25, 28, 32 via `UpdateFontSize` (snap current value to nearest step; toast "Text size 4 of 7"; disable at ends). The settings page stays as is.

Changing text size must keep the reader on the same line: remember (section, r), rebuild, jump to the section, then one frame later correct using the new item height.

### 12. Resume

Save `{index, title, r}` per content in the existing `settingsBox` under `pos:<call-site-kind>:<title>` when scrolling settles (and on dispose). On open: if `sections[index].title` matches, restore; else find by title; else clamp. Only restore for ≥ 2 sections.

## Phase 3: motion

### 13. Scroll thumb and bubble

- Thumb on the right edge: 40×68 dp hit area, 6 dp visible bar (`accentLine`), always faintly visible (35%), full opacity while scrolling, wider (12 dp) while dragged. Dragging moves through sections weighted by `length` (the list is lazy, so there is no total pixel height); map thumb position → (section, r) → jump.
- Bubble left of the thumb: `bubbleBg`, 20 dp radius, number (36 sp poppins) + `/ N` + title (2 lines). Shows only while dragging or when travelling fast (> 60% of a viewport in 0.4 s); hides ~1.1 s after scrolling stops. Never shows for programmatic jumps.

### 14. Changing number and title

When the current section changes, the pill and bubble number/title slide in (~340 ms) from below when moving forward, from above when moving back.

### 15. Haptics and reduced motion

`HapticFeedback.selectionClick()` on section change while dragging the thumb. If `MediaQuery.disableAnimationsOf(context)`, skip all of the above animations.

## Phase 4: search and docs

### 16. Search (replaces the current one)

The current search wraps matches with a regex over raw HTML (can corrupt tags) and guesses the scroll offset. Replace it with a search sheet: search each section's plain text, list results as `number · title` + a snippet around the match, tap → jump to that section and highlight matches in that section only by wrapping text nodes (walk the DOM with `package:html`, never regex over markup).

### 17. `docs/book_content_format.md`

Short guide for whoever enters content: separate pieces with `<hr>`; start a piece with `<h3>` when its first line would be a poor name; numbers come from order.

## Out of scope for now

Turning chapter books into one sectioned reader, deep links to a section, Kannada UI labels, bumping the app version.

## Done when

- `flutter analyze` reports no new issues in touched files.
- `flutter test` passes, including a widget test: open `ReaderPage` with the fixture → Contents lists 29 rows; tap row 14 → bar shows `14 of 29`; tap next → `15 of 29`.
- Lyrics and astottaras without `<hr>` look like before (plain reader).
