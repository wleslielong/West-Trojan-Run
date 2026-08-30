# West Trojan Run

A side-scrolling platformer set on Main Street in West, Texas, starring the
West Trojan. Runs in the browser; installs to the Home Screen on iPhone, iPad,
and Android.

## Play it right now

Double-click `index.html`. That's it — no build, no install, no server.

## Put it online

1. Go to <https://netlify.com/drop>
2. Drag **this whole folder** onto the page (not just `index.html`)
3. You get a permanent `https://…netlify.app` URL

Dragging the folder matters. The icons, `manifest.webmanifest`, and `sw.js` have
to sit next to `index.html` for the game to install as an app. Drop only the one
file and it still plays fine, it just won't install on Android or work offline.

To publish an update later, drag the folder onto the *same* Netlify site again.

## Install it as an app

**iPhone / iPad** — open the URL in **Safari** (not Chrome; Chrome on iOS cannot
do this), tap **Share**, then **Add to Home Screen**. It launches fullscreen with
no browser bars.

**Android** — open the URL in Chrome. Tap **ADD TO HOME SCREEN** on the start
screen, or use Chrome's ⋮ menu → *Install app*.

Once installed it works with no signal.

## Controls

Touch: ◀ ▶ to move, JUMP to hop, stomp enemies from above.
Keyboard: arrow keys, space to jump, F for fullscreen.

## Is it working?

Under the START button:

- **BUILD 1.5 · JS OK** in green — good.
- **JS NOT RUNNING** in red — the script died; the game won't respond.

A red bar across the bottom means an error, and it says what. Tap to dismiss.

If you publish an update and the build number doesn't change, you're seeing a
cached copy — add `?v=2` to the end of the URL (then `?v=3`, and so on).

## What's in here

| File | What it is |
|---|---|
| `index.html` | The entire game |
| `manifest.webmanifest` | App name, icon, and fullscreen settings |
| `sw.js` | Makes it work offline |
| `icon-*.png`, `apple-touch-icon.png` | App icons |
| `tools/make-icons.ps1` | Regenerates those icons |
| `CLAUDE West Trojan Game.md` | Notes for working on the code |

See the notes file before changing anything — it records several fixes that
exist because of real crashes on real iPads.
