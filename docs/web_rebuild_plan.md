# Website rebuild plan

Rebuild the `arjun-guruji-web` website so it uses the same Firebase data as the Flutter app, looks and behaves like the app, has the app's features, and works well on iPhone Safari, which is where most website users are.

Related: [plan.md](../plan.md) (app UX and motion plan) and [reader_plan.md](reader_plan.md) (long-book reader). The website should follow both, so the app and the website change together.

Current status (11 Oct 2026): Phase 0 is committed and the Phase 1 reading implementation is ready to commit. All content is available, confirmed by the project owner; the content-upload dependency is resolved. Real-device acceptance checks and the chapter-reader parity decision remain open. Donations are deferred.

---

## 1. Context

### 1.1 The two codebases

| | Flutter app (`arjun_guruji`) | Website (`arjun-guruji-web`) |
|---|---|---|
| Stack | Flutter, BLoC, Firestore, Hive | Vite 7, React 18, Tailwind 3, Flowbite, react-router 6 |
| Data | Firestore project `arjun-guruji-app` | Hardcoded: `.txt`/`.html`/`.pdf` in `public/assets/raw/`, lists in JSX |
| Repo | github.com/sogalabhi/arjun_guruji | github.com/sogalabhi/arjun-guruji-web |
| Users | Android | Mostly iPhone (Safari) |

The website is currently cloned inside the app repo at `arjun_guruji/arjun-guruji-web/`, where it shows as untracked. Move it to `~/coding/arjun-guruji-web`, or add it to the app's `.gitignore`.

### 1.2 Decisions already made
- **Keep React + Vite** and rebuild in place. Don't use Flutter web, which is too heavy and too weak at text and scrolling on iPhone Safari.
- **Bring the app's content features to the website:** reading, audio, events and Panchang, contact, notifications.
- **Donations are deferred for now.** The current web revamp excludes the Donate page, home Donate / Seva button, UPI payments, bank details and donation QR code. Revisit them in a later phase.
- **No new repo and no big-bang delete.** Work on a branch, replace pages one at a time, and delete old files only after their replacement works.
- **Gallery is dropped.** It was removed from the app in commit `c2f7250`, and on the website it's "Coming soon".

### 1.3 Firestore data (verified by reading it with the public key)

All collections are publicly readable, so the website needs no login.

| Collection | Docs | Fields |
|---|---|---|
| `Books` | 13 | `title`, `imageUrl`, `bookType` (`html` / `pdf` / `chapters`), `content` (HTML for html books, PDF URL for pdf books), `chapters[]` (`{chapterName, content}`), optional `lastUpdated` |
| `Astottara` | 6 | `title`, `content` (HTML), `imageUrl` |
| `Lyrics` | 62 | `title`, `category` (Kannada, e.g. `ನಿತ್ಯ ಭಜನೆಗಳು`), `content` (HTML) |
| `categories` | 4 | `name`, `imageUrl`; audio is in the **subcollection** `categories/{id}/audios`: `title`, `audioUrl`, `imageUrl`, `lyrics`, `category` |
| `audios` (top level) | 0 | Unused. The app reads the subcollection |
| `events` | 33 | `title`, `description`, `eventType` (`Recurring` / `Featured` / `One-time` / `Simple`), `startDate`, `endDate` (timestamps), `venue`, `city`, `place`, `guest`, `frequency`, `day`, `activities[]` (`{time, activity, venue}`), `interestedCount`, `galleryLinks[]`, `status`, `tags[]`, `isFeatured` |
| `Notifications` | 6 | `title`, `description`, `dateTime`, `image`, `onTapLink`, `isVisible` |
| `Gallery` | 1 | Not needed |

Data issues to clean up at the same time:
- `events/4K9TzN0hmNPOJB2WGrK4` has no title, type or venue. It looks like a test or broken entry.
- Book document IDs are a mix of readable slugs (`bhaktikusumanjali`) and random IDs (`cenPuBoSciw1hJ1rTAa8`). Website URLs should use a slug, not the raw ID (see 3.3).

### 1.4 Firebase config for the website
- **Use project `arjun-guruji-app`,** the one the Android app uses.
- **Don't copy the `web` entry in the app's `lib/firebase_options.dart`.** It points at an old project, `arjun-guruji-app-d6da1`.
- **The Web app is registered** under `arjun-guruji-app`. Its config was checked on 11 Oct 2026 and reads Firestore fine:
  ```js
  {
    apiKey: "AIzaSyD0Rh0sK5NnR5BaGk1eDQlAlC8L55fKTd8",
    authDomain: "arjun-guruji-app.firebaseapp.com",
    projectId: "arjun-guruji-app",
    storageBucket: "arjun-guruji-app.appspot.com",
    messagingSenderId: "699085946848",
    appId: "1:699085946848:web:a31ae560f5975bac557585",
    measurementId: "G-HJ42C2H32F",
  }
  ```
  - These values are public by design and ship in every web page, so they can be committed. Access is controlled by Firestore rules, not by keeping this config secret.
  - Only `firebase/app` and `firebase/firestore/lite` are needed. Skip `getAnalytics` from Firebase's sample snippet unless analytics is wanted (+~25 KB, and it needs a cookie/consent decision).
  - Optionally restrict this API key to the website's domain in Google Cloud console → Credentials.
- **Read-only from the website.** No writes, no admin screens.

### 1.5 Content comparison (already checked)
- **The text matches.** The 6 html books are identical in the website files and in Firestore, character for character, so switching to Firestore loses no text.
- **Missing from the website:** ಅವಧೂತ ಮಹಿಮೆ and ಗುರು ಅನುಭೂತಿ. The other pdf books exist in `raw/` but aren't linked.
- **Website only:** the full ಗುರು ಚರಿತ್ರೆ (`raw/gc/`, 56 html chapters, plus `gc_eng.pdf` and `gurucharitre-kan.pdf`), and the ashram directions with bus numbers in `contact.jsx`. Move both into Firestore and the app.
- **Lyrics:** the website has 56, hardcoded in 3 lists (daily, arati, others), with English file names shown as titles. Firestore has 62, in Kannada categories.

### 1.6 Problems in the current website
1. **Refreshing a reader page breaks it.** The reader gets its data from `useLocation().state`. Refreshing, opening a shared link, or Safari reloading a background tab leaves `state` undefined and the page blank.
2. **A 256px blank gap.** `sm:ml-64` shifts content from 640px wide, but the sidebar only appears from 1024px (`lg:block`). iPhone landscape and iPad portrait lose a quarter of the screen.
3. **The hamburger throws an error.** Every list page runs `document.getElementById("openBtn").style`, but no element has that id. The mobile sidebar also has no backdrop and no tap-outside-to-close.
4. **Oversized boxes.** `p-36` boxes on Lyrics and Contact are 300px+ wide, and `h-96` (384px) covers show one book per phone screen.
5. **Narrow reader text.** The reader's `px-10` + `p-4` leaves about 270px for text on a 375px iPhone. Txt books are in `<pre>`, so they render in a monospace font.
6. **No reader settings** (theme, size, font) and no search.
7. **Missing iPhone basics:** `lang="kn"`, safe-area insets, `theme-color`, a real title and icon. The current ones are Vite defaults.
8. **The logo is hotlinked** from `sriarjunaavadhoota.org`.
9. **Leftover code:** `test123.jsx` (with a `/test` route), `sideBar2.jsx`, `public/assets/raw/test.jsx`, and Flowbite loaded from a CDN as well as from npm.
10. **No hosting config,** so deep links will 404 unless the host falls back to `index.html`.

### 1.7 App screens to mirror

| App screen | File | Website route |
|---|---|---|
| Home | `lib/features/Home/presentation/widgets/home_page_content.dart` | `/` |
| Books list | `lib/features/Books/presentation/pages/all_books_page.dart` | `/books` |
| Chapters | `lib/features/Books/presentation/pages/chapters_list_page.dart` | `/books/:slug` |
| Reader | `lib/core/widgets/content_view_page.dart` (to be replaced per reader_plan.md) | `/books/:slug[/:chapter]`, `/astottara/:slug`, `/lyrics/:category/:slug` |
| Astottara | `lib/features/Astottaras/presentation/pages/all_astottara_page.dart` | `/astottara` |
| Lyrics | `lib/features/Lyrics/presentation/pages/lyrics_categories_page.dart`, `lyrics_listview_page.dart` | `/lyrics`, `/lyrics/:category` |
| Audio | `lib/features/AudioPlayer/presentation/pages/*` | `/audio`, `/audio/:category`, plus a mini player |
| Events & calendar | `lib/features/EventManagement/presentation/pages/*` | `/events`, `/events/calendar`, `/events/:id` |
| Panchang | `lib/features/EventManagement/presentation/widgets/panchang_card.dart` | `/panchang` |
| Contact | `lib/features/Contact/presentation/pages/connect_page.dart`, `contact_page.dart` | `/contact` |
| Notifications | `lib/features/Notifications/presentation/pages/notifications_page.dart` | `/notifications` |
| Settings | `lib/features/Settings/presentation/pages/settings_page.dart` | `/settings` (reader settings only) |

### 1.8 App visual language to copy

| Token | Value |
|---|---|
| App bar gradient | `#010036` → `#332FFF`, left to right |
| Tile / accent | amber `#FFD146` (tiles), `#FFA000` (accent) |
| UI font | Poppins (`fonts/poppins_medium.ttf`) |
| Reading fonts | Noto Sans Kannada / Noto Serif Kannada |
| Title font | Samarkan, for "Arjun Guruji" |
| Reader palette | The light / sepia / dark tokens in reader_plan.md §1 |

---

## 2. Principles
- **The app is the reference.** Same data, same words, same order, same colours. If they differ, change the app first or decide explicitly.
- **Every screen has a URL.** Refresh, back, share, and Safari reloading a tab must all work. Nothing is passed only through router state.
- **Mobile-first for iPhone Safari.** Design at 375px, then scale up. Use safe-area insets, 44pt tap targets, and minimum 16px UI text (18–20px for reading).
- **Built for older users,** following the rules in plan.md: one tap to anything important, words with icons, no auto-carousels, no hidden gestures.
- **Read-only, lightweight and fast.** Use `firebase/firestore/lite` instead of the full SDK, load heavy parts (Panchang, PDF) only when needed, and target under 150 KB gzipped JS for the first load.
- **Delete as you go.** Each phase removes the old files it replaces.

---

## 3. Architecture

### 3.1 Dependencies
- **Keep:** `react`, `react-dom`, `react-router-dom`, `vite`, `@vitejs/plugin-react`, `tailwindcss`, `postcss`, `autoprefixer`, `eslint*`.
- **Add:** `firebase` (only `firebase/firestore/lite` is imported).
- **Remove:** `flowbite`, `flowbite-react`, the Flowbite CDN script, `react-anchor-link-smooth-scroll`, `react-router-hash-link`, and `react-pdf` (pdfs open in Safari's built-in viewer instead).

### 3.2 Folder layout
```
src/
  main.jsx, App.jsx          router + layout
  firebase.js                initializeApp + getFirestore (lite)
  data/                      one module per collection: books.js, astottara.js, lyrics.js,
                             audio.js, events.js, notifications.js (fetch + map to plain objects)
  hooks/useCollection.js     load + cache (memory, then sessionStorage), loading / error states
  layout/                    AppBar, Page, BackButton, BottomSafeArea
  components/                Tile, Card, ListRow, Skeleton, EmptyState, ErrorState
  reader/                    Reader, ReaderSettings, sections (port of reader_plan.md parser), search
  features/                  home/, books/, astottara/, lyrics/, audio/, events/, panchang/,
                             contact/, notifications/, settings/
  settings/                  reader settings context (stored in localStorage)
public/
  fonts/                     Poppins, Noto Sans Kannada, Noto Serif Kannada, Samarkan (self-hosted)
  icons/                     favicon, apple-touch-icon, manifest icons
  panchang.js                compiled from the app's Dart Panchang (phase 3)
tools/panchang/              Dart source for panchang.js (phase 3)
```

### 3.3 URLs and slugs
- **Slugs, not raw IDs.** URLs use a readable slug: the document ID if it's already readable, otherwise a slug field added in Firestore. Until that field exists, fall back to the document ID so links still work.
- **Chapters** are addressed by number, e.g. `/books/gurudaari/12`.
- **Lyrics categories** are Kannada, so they're URL-encoded. Alternatively, add a `categorySlug` field in Firestore.
- **Hosting must rewrite every path to `/index.html`.**

### 3.4 Data loading
- **Fetch each collection once per session** and cache it in memory and `sessionStorage`. Collections are small (largest is about 1.3 MB of book text; book content loads only when a book is opened if we split it later).
- **Every list shows a skeleton, an empty state and an error state with Retry.** Never a blank page.
- **No realtime listeners.** Use plain `getDocs` / `getDoc`.

### 3.5 Hosting
- **Pick one host:** Firebase Hosting (same project; `firebase.json` with `rewrites: [{source: "**", destination: "/index.html"}]`), Vercel, or Netlify.
- **Firebase Hosting is recommended,** since everything stays in one project.
- **Cache headers:** long-term caching for hashed assets, `no-cache` for `index.html`.

---

## 4. Phases

Each phase is shippable on its own. Work on branch `app-parity`. Merge to `main` and deploy at the end of each phase, or once at the end; that's for you to decide.

### Phase 0: Groundwork
No visible change for users yet.

Tasks
1. Move the repo out of the app folder (see 1.1). Create the branch.
2. Remove Flowbite and the unused packages. Delete `test123.jsx`, the `/test` route, `sideBar2.jsx` and `public/assets/raw/test.jsx`.
3. Add `firebase`. Create `src/firebase.js` using the web app config from 1.4.
4. Add the Tailwind theme tokens from 1.8 and self-hosted fonts.
5. `index.html`: `lang="kn"`, `viewport-fit=cover`, `theme-color`, real title ("Arjun Guruji"), favicon, `apple-touch-icon`, `manifest.webmanifest`.
6. Build the shared layout: gradient app bar with a back button and title, a page container with safe-area padding, and skeleton, empty and error components.
7. Hosting config with the SPA rewrite. Deploy a preview URL.

Done when
- `npm run build` passes, lint is clean, and the preview URL loads.
- A test page reads one Firestore document on a real iPhone.

### Phase 1: Reading
Books, Astottara, Lyrics and one reader.

Tasks
1. `data/books.js`, `astottara.js`, `lyrics.js`, mapped exactly as the app's models do (e.g. `content` is HTML for `html` books and a PDF URL for `pdf` books; chapters are `{chapterName, content}`).
2. List pages: Books (cover grid, 2 columns on phone), Astottara, Lyrics categories, then lyrics within a category. Add a search box, matching the app.
3. Chapters page for `chapters` books.
4. **Reader** with:
   - the light / sepia / dark palette, font size (16–32), and sans or serif font, all as in the app's Settings, stored in `localStorage`;
   - a reading column of at most 720px with 16px side padding and safe-area insets;
   - search inside the text with highlight and next/previous;
   - the sections and contents jump list from reader_plan.md, applied the same way in the app and on the website;
   - previous/next chapter buttons at the end of each chapter;
   - remembering where you stopped in each book (`localStorage`).
5. **PDF books** open the PDF URL in Safari's viewer in a new tab, with a clear "Opens PDF" label.
6. **ಗುರು ಚರಿತ್ರೆ:** content availability is confirmed by the project owner. Use the Firestore content; the old `raw/gc` fallback is no longer needed.
7. Delete `contentView.jsx`, `content/ab.jsx`, `content/gdb.jsx`, `content/gv.jsx`, the old `books.jsx`, `ast.jsx` and `lyrics.jsx`, and every `raw/*.txt` that is now served from Firestore.

Done when
- Every book, astottara and lyric in Firestore opens by URL, survives a refresh, and can be shared.
- Reader settings persist between visits.
- There's no horizontal scroll at 320px, 375px, 430px, iPhone landscape or iPad.
- The text matches the app's reader for 3 sample items.

### Phase 2: Home, Contact, Notifications

Tasks
1. **Home** as in plan.md §2:
   - a smaller Guruji image;
   - the **Today** card (tithi, Rahu Kaala, next event); until Phase 3 it shows only the next event;
   - 6 tiles: Bhajans, Books, Astottara, Lyrics, Events, Contact;
   - a bell that opens Notifications.
2. **Contact:** call, WhatsApp and directions first, then Website, YouTube, Facebook, Instagram and Threads (the app's 6 links), plus the ashram address and bus directions from the current website.
3. **Notifications:** only those with `isVisible` true, sorted by `dateTime`, newest first. Show the image if there is one, and open `onTapLink` if there is one.
4. Delete the old `home.jsx`, `contact.jsx`, `sideBar.jsx`, `gallery.jsx` and `songs.jsx`.

Done when
- Every screen is reachable from home in at most 2 taps.

### Phase 3: Events and Panchang

Tasks
1. **Panchang engine:** compile the app's Panchang logic to JavaScript.
   - `tools/panchang/` is a small Dart package that depends on `tithi_engine: 5.1.1` (the same version as the app). Its `bin/main.dart` mirrors `PanchangService.getForDate` line for line and exposes `window.arjunPanchang.getForDate(y, m, d, city)` and `cities()` through `dart:js_interop`.
   - Build it with `dart compile js -O2 -o public/panchang.js tools/panchang/bin/main.dart`, which gives about 190 KB raw, 65 KB gzipped.
   - Load it only on pages that need it.
   - **Already tested:** a Node run gave 245 cities and correct tithi, sunrise, sunset, Rahu Kaala and tithi segments for Mysore and Bangalore.
   - Add an npm script, `build:panchang`, and a note to rebuild whenever the app updates `tithi_engine`.
2. **Panchang page** (`/panchang`):
   - tithi with its segments, lunar month, sunrise, sunset, Rahu Kaala, Yamaganda and Gulika Kaala, showing the same fields as `panchang_card.dart`;
   - a date picker and a city picker with search, remembering the city in `localStorage` and defaulting to Mysore;
   - all times shown in IST.
3. **Today card** on home, filled from the Panchang engine.
4. **Events list** (`/events`), using the fixed grouping from plan.md §1:
   - groups by end date: happening now, every week (recurring), coming up, past events (collapsed);
   - big date blocks, text labels instead of coloured dots, no carousel.
5. **Event details** (`/events/:id`): image, description, programme schedule (`activities`), venue with a map link, gallery images in a full-screen viewer, and the interested count shown read-only.
6. **Calendar** (`/events/calendar`): a month grid with event markers. Tapping a day shows that day's events and Panchang.
7. Fix the same event-grouping bug in the app in the same phase, so both match.

Done when
- Panchang matches the app for 5 dates × 3 cities.
- Multi-day events show as "happening now" on their middle days.
- Events that ended in the last week appear under past.

### Phase 4: Audio

Tasks
1. Load `categories`, then each category's `audios` subcollection, the same way the app does.
2. **Category grid,** then a **track list**, then the **player:** artwork, title, seek bar, previous/next, shuffle, repeat, and lyrics/playlist toggles, as in `audio_player_page.dart`.
3. **Mini player** fixed at the bottom on all pages while something is playing, mirroring the app's `now_playing_snackbar.dart`, and keeping clear of the home indicator.
4. **Media Session API** for the iPhone lock screen and Control Centre: title, artwork, play/pause, next/previous, seek.
5. **iPhone limits.** Audio keeps playing while Safari is in the background, but not after the tab is closed or reloaded. Playback must also start from a tap, since autoplay is blocked. Say this in the UI only if it causes confusion.
6. Remember the last track and position in `localStorage`, and offer "Continue".

Done when
- Playback works with the screen locked on a real iPhone.
- Lock-screen controls work.
- Moving between pages doesn't stop playback.

### Phase 5: Polish and launch

Tasks
1. Motion from plan.md §3, kept light: page transitions, the mini player expanding into the full player, the play/pause morph, skeleton-to-content fades. Respect `prefers-reduced-motion`.
2. Make it installable on the home screen: manifest, icons, `apple-mobile-web-app-capable`, and a status bar style. Optionally add a service worker that caches the app shell and recently read texts for offline reading.
3. **Accessibility:** a sensible heading order, labels on icon buttons, contrast of at least 4.5:1, visible focus, and correct zoom up to 200%.
4. **Performance:** Lighthouse mobile score of at least 90; lazy-load images; split routes into separate bundles.
5. **Final check on real devices:** iPhone SE size, a recent iPhone, iPad, and Android Chrome.
6. Merge to `main`, deploy, and point the domain at it.

Done when
- Nothing from the old site remains in `src/` or `public/assets/raw/`, apart from whatever is still waiting for a Firestore upload.
- Every route works on a real iPhone, after a refresh and from a shared link.

---

## 5. Test checklist (every phase)
- [ ] 320px, 375px, 390px and 430px wide; iPhone landscape; iPad portrait and landscape
- [ ] Refresh and share on every route
- [ ] Notch and home indicator never cover content
- [ ] No horizontal scroll
- [ ] Kannada renders in Noto Sans or Serif Kannada, never a fallback or monospace font
- [ ] Loading, empty and error states on every list
- [ ] Back works, both the button and the swipe-back gesture
- [ ] iPhone font-size setting at its largest: nothing clips

---

## 6. Open questions and dependencies
1. **Write access for remaining data maintenance** (slugs, fixing the broken event). Content availability is confirmed and uploads are no longer a Phase 1 blocker. The committed `service-account.json` is dead (`invalid_grant`). Use an authorized write method, such as the app's admin screens or the Firebase console; keep any fresh service account key outside the repo.
2. **Security.**
   - The old key is still in git history and should be revoked and removed from git.
   - The admin push-notification screen ships an admin key in the APK.
   - Firestore rules may allow public writes; check them in the console.

   Fix these before the website goes live, since the website exposes the same public config.
3. **Hosting choice** and **domain**: which URL the website currently runs on, and who controls DNS.
4. **Labels:** Kannada + English, the same as whatever is decided for the app (plan.md, open decisions).
5. **Gallery:** dropped. Confirm no one expects it on the website.
6. **Audio data:** confirm every category's `audios` subcollection has real tracks. The top-level `audios` collection is empty, and the app has dummy seeding code.

---

## 7. Order and rough size

| Phase | Depends on | Rough size |
|---|---|---|
| 0 Groundwork | — | Small |
| 1 Reading | 0 | Large |
| 2 Home, Contact, Notifications | 0 | Medium |
| 3 Events, Panchang | 0; app bug fix in parallel | Large |
| 4 Audio | 0 | Medium |
| 5 Polish and launch | 1–4 | Medium |

Phases 2, 3 and 4 can run in any order after Phase 1. Reading goes first because it's what website users mostly use, and it's where the refresh bug hits them.
