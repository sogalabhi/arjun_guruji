# Entering book, astottara and lyrics content

The app reads the `content` / `htmlContent` HTML you enter. Long books are split into numbered
sections so readers can jump to "number 14" and everyone lands in the same place.

## The rules

1. **Separate pieces with `<hr>`.** Every `<hr>` starts a new section (stotra, song, chapter,
   saying, whatever the book is made of).
2. **Start a piece with `<h3>` when its first line would be a poor name.** The reader names each
   section like this:
   - If the piece starts with `<h3>...</h3>` (or `<h4>...</h4>`), that is the name, shown as
     the heading.
   - Otherwise, if it starts with a one-line `<p>` (no `<br>`) followed by more text, that
     paragraph is the name.
   - Otherwise the name is the first line of the first `<p>` (up to the first `<br>`).
3. **Numbers.** If the book has a printed edition with numbered songs, type the printed number at
   the start of each name: `<h3>10. ಭವರೋಗವೈದ್ಯನೇ</h3>` (Kannada digits `೧೦.` work too). When
   most pieces start with a number like this, the reader shows those numbers, so "song 10" in
   the app is song 10 on paper. Pieces without one (an opening prayer, a preface) show no number.
   If the book has no printed numbers, type none: the reader numbers pieces 1, 2, 3 in order.
4. **No `<hr>` at all** means a single piece: the plain reader, with no numbers or contents.
   This is the right choice for a short lyric or an astottara.

Only the opening heading counts. Other `<h3>` inside a piece are shown as refrains or closing
lines (centred), and none of them appear in the contents.

Avoid `<h4>` for anything else. Older content has lines numbered 1–9 as `<h4>` and 10 onwards as
`<p>` (astottara names, numbered sayings, verse lists). That came from a conversion, not a rule:
write all of them the same way, as lines in a `<p>`.

## Example

```html
<h3>|| ಶ್ರೀ ಗುರುಭ್ಯೋ ನಮ: ||</h3>
<p>ಮೊದಲ ಶ್ಲೋಕ ...<br>
ಎರಡನೇ ಸಾಲು ...</p>
<hr>
<p>ರಾಮ ಬಂದ ಶ್ಯಾಮ ಬಂದ<br>
ಶಿವನೇ ಬಂದ ...</p>
<hr>
<h3>ಮಂಗಳ</h3>
<p>ಮಂಗಳಂ ...</p>
```

This is three sections. The first is named by its `<h3>`, the second by its first line, the third
by its `<h3>`.

## Tips

- Separators such as `|`, `।` and `॥` around a name are fine; they are dropped from the contents
  but kept in the heading.
- Use `<h3>` when the first line is long, is only a verse number, or repeats on every piece.
- Keep each piece to one song or stotra. Very short pieces are fine; very long ones are harder to
  find a place in.
- Use `<br>` inside a `<p>` for the lines of a verse and a new `<p>` between verses.
