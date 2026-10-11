# App Improvement Plan

Target users are mostly older devotees. Every change should make things easier to find and read, not just prettier.

## 1. Bug fixes (do first)

### Events disappear from the All Events page
Events are split into "upcoming" and "past", and some events fit neither group.

- **Running events vanish.** Upcoming only includes events whose *start* date is today or later ([event_list_page.dart:159](lib/features/EventManagement/presentation/pages/event_list_page.dart#L159)). A multi-day event that started yesterday is left out. The "LIVE" badge can only appear on an event's first day.
- **Recently finished events vanish for a week.** Past only includes featured events or events that ended more than 7 days ago ([past_events_list.dart:19-30](lib/features/EventManagement/presentation/widgets/past_events_list.dart#L19-L30)).
- **Fix:** sort by end date, so every event lands in exactly one group:
  - Ended before today → past
  - Started on or before today and ends today or later → happening now
  - Starts after today → upcoming

### Smaller issues
- The red dot on the home bell is always shown. Show it only when there are unread notifications.
- Admin login opens on a double-tap of Guruji's image ([home_page_content.dart:75](lib/features/Home/presentation/widgets/home_page_content.dart#L75)), which is easy to trigger by accident. Move it to a 3-second long-press, or to tapping the version number in Settings 7 times.
- The past events section is titled "Events", and its empty state says "Will be updated". Rename it and write a clearer empty state.

### Dead code
Gallery was replaced by Events in commit `c2f7250`.
- Delete `gallery_page.dart` and `gallery_remote_ds.dart`.
- Keep `FullScreenImageViewer` ([full_page_viewer_page.dart](lib/features/Gallery/presentation/pages/full_page_viewer_page.dart)), because event details uses it. Move it to `core/widgets`.

## 2. UX revamp

### Home screen
```
┌────────────────────────────────┐
│ [Guruji, smaller]  Arjun Guruji ⚙ 🔔│
├────────────────────────────────┤
│ TODAY · Sat 11 Oct          →  │  ← opens Panchang
│ Shukla Dashami                 │
│ Rahu Kaala 9:00–10:30          │
│ Next: Thursday Bhajan · 6 PM   │
├───────────────┬────────────────┤
│  Bhajans      │  Books         │
│  Astottara    │  Lyrics        │
│  Events       │  Contact       │
├───────────────┴────────────────┤
│  🙏  Donate / Seva  (full width)│
└────────────────────────────────┘
```
- **The six tiles are for content only.** Things people do daily (Panchang) or need to act on (Donate) go outside the grid.
- **The Today card** shows today's tithi, Rahu Kaala and the next event, and opens a full Panchang page.
- **Shrink Guruji's image.** Keep it, but it currently takes about a third of the screen.
- **Clearer labels:** "Audio" becomes "Bhajans" and "Connect" becomes "Contact".
- **Consider Kannada + English labels** on every tile (e.g. ಭಜನೆ / Bhajans). This is for the trust to decide.

### Contact page (replaces Connect)
- Order: Call, WhatsApp, Directions first, then social links (Website, YouTube, Facebook, Instagram, Threads).
- Donate moves off this page and onto home.

### Panchang
- Give it its own page, reached from the Today card, instead of sitting under the calendar.

### Events page: one simple list
1. **Happening now**
2. **Every week:** recurring events, e.g. "Every Thursday · 6 PM"
3. **Coming up:** big cards with a large date block
4. **Past events & photos:** collapsed by default
- Put a "Calendar" button at the top for the month grid.
- Remove the auto-scrolling carousel. It advances every 3 seconds, which is too fast to read.
- Replace the coloured dots with text labels ("Weekly", "Special").
- Use one events fetch instead of a separate fetch on each page.
- Optional: replace the "Interested" thumbs-up with "Remind me", using the local notifications that are already set up.

### Donate
- **Put the UPI button first.** Someone can't scan a QR code shown on their own phone.
- **Add preset amounts:** ₹101 · ₹251 · ₹501 · ₹1001, plus "Other amount".
- **Make bank details tap-to-copy** with a clear "Copied" confirmation.
- **Move the QR code lower,** labelled "For scanning from another phone".

### Rules for the whole app
- **One tap to anything important.** Nothing behind swipes, double-taps, auto-carousels or below-the-fold scrolling.
- **Words with icons, never icons alone.** Never use colour alone to carry meaning.
- **Text size:** at least 16 for body text and 14 for secondary text. There are 16 places using sizes 10–13.
- **Test with the phone's font size set to largest.** The Connect boxes are fixed at 150×100 and will clip.
- **Tap targets** of at least 48dp.
- **No dialog when leaving the audio player.** Just keep playing; the mini player can stop it.

## 3. Motion design

`flutter_animate`, `animations`, `lottie` and `vibration` are already in pubspec, but nothing imports them yet.

### Principles
- Springs with at most a tiny overshoot. No bouncy easing, glows or particles.
- Keep durations and spring settings in one shared file so everything moves the same way.
- Respect reduce-motion with `MediaQuery.disableAnimationsOf(context)`.
- Leave reading content still (books, lyrics, astottara, PDF). Use motion only for transitions and controls.
- Add haptics on likes, toggles, play/pause, theme changes and day selection.

### Fix half-built motion
- **Player animation controller:** `_animationController` runs but nothing uses it ([audio_player_page.dart:40](lib/features/AudioPlayer/presentation/pages/audio_player_page.dart#L40)). Connect it to `AnimatedIcon(AnimatedIcons.play_pause)`.
- **Home tile stagger:** the delay is added to the duration instead of delaying the start, and `index % 3` is used on a 2-column grid ([animated_grid_item.dart:9-10](lib/features/Home/presentation/widgets/animated_grid_item.dart#L9-L10)), so tiles appear in an uneven order.
- **Connectivity banner:** it has no exit animation ([top_snackbar.dart:32](lib/core/widgets/top_snackbar.dart#L32)).

### Highest impact
1. **Mini player ↔ full player.** The mini player should slide up on first play and expand into the full player with `OpenContainer`. Today it pops in and out abruptly.
2. **App-wide page transitions.** Add a `pageTransitionsTheme` using `SharedAxisPageTransitionsBuilder` in `main.dart`.
3. **Home tiles expand into their pages** with `OpenContainer`. Also add a slight press-down scale, since the tiles have no tap feedback today.
4. **Panchang day arc.** Draw a sunrise-to-sunset arc showing the sun's current position, with Rahu, Yamaganda and Gulika as segments on it. It draws itself when the day changes.

### Other places
- **Player:** loading spinner morphs into the play button, seek-bar thumb grows while dragging, title and art crossfade on track change, art shrinks slightly while paused.
- **Settings:** a sliding pill for the light/sepia/dark picker, and an animated live-preview card.
- **Reader:** animate the background and text colour when the theme changes.
- **Calendar:** short crossfade when the selected day changes, with event tiles staggered in.
- **Event "Interested" / "Remind me":** spring plus a rolling count, replacing the `Future.delayed` workaround.
- **Donate button:** button → loader → check. Copy actions show a check morph.
- **Connectivity banner:** one pill that morphs red → green instead of two separate banners.
- **Shimmer → content:** crossfade instead of a hard swap on Books, Astottara, Lyrics and Notifications.
- **Home notification popup:** fade-in backdrop with a scale-and-fade entrance.
- **City picker and reader search:** list items animate in and out as you type.
- **Splash → home:** Hero the "Arjun Guruji" title into the app bar.
- **Event card → details:** Hero on the image.

## 4. Suggested order
1. Event bug fixes and Gallery cleanup
2. Home layout, Contact page, Donate page, Panchang page
3. Events page restructure
4. Rules for the whole app (text sizes, labels, admin entry point)
5. Motion: fix half-built pieces, then the highest-impact items, then the rest

## Open decisions for the trust
- Kannada + English labels?
- Bring photos back under "Past events & photos"?
- Replace "Interested" with "Remind me"?
