# West Trojan Run

A side-scrolling platformer set on Main Street in West, Texas, starring the
West Trojan. Runs in the browser; installs to the Home Screen on iPhone, iPad,
and Android.

## Play it right now

Double-click `index.html`. That's it — no build, no install, no server.

## Where it lives

**<https://wleslielong.github.io/West-Trojan-Run/>**

Hosted by GitHub Pages out of the `main` branch of
[wleslielong/West-Trojan-Run](https://github.com/wleslielong/West-Trojan-Run),
root folder. The repo is public, which is what lets Pages serve it for free.

## Publishing an update

1. Edit the files in your local clone
2. Bump the version — see **Releasing** below, it is four places, not one
3. GitHub Desktop → write a summary → **Commit to main** → **Push origin**

Pages redeploys on its own within a minute or two. There is nothing to drag and
nothing to configure again.

## Releasing

Every file has to sit next to `index.html` on the server, so never publish just
the one file. And bump all four of these together or the update won't be visible:

| Where | Looks like |
|---|---|
| `index.html` version tag | `<div id="vtag">v2.0</div>` |
| `index.html` start screen | `BUILD 2.0 &middot;` |
| `index.html` script | `var VERSION='2.0';` |
| `sw.js` | `var CACHE = 'wtr-2.0';` |

If the build number on screen doesn't change after a deploy, the `sw.js` `CACHE`
line is what got missed. GitHub Pages also holds a CDN cache for about 10
minutes, so give it a moment before assuming something broke.

## Install it as an app

**iPhone / iPad** — open <https://wleslielong.github.io/West-Trojan-Run/> in
**Safari** (not Chrome; Chrome on iOS cannot do this), tap **Share**, then **Add
to Home Screen**. It launches full-screen with no browser bars. *Confirmed working
on iPad.*

**Android** — open the same URL in Chrome. Tap **ADD TO HOME SCREEN** on the
start screen, or use Chrome's ⋮ menu → *Install app*.

Once installed it works with no signal.

## Controls

Touch: ◀ ▶ to move, JUMP to hop, stomp enemies from above.
Keyboard: arrow keys, space to jump.


## Questions between turns

Built for ages 5-8. A question appears after you press START and again after
every death, switching at random between two kinds:

- **A sum** — the two numbers never add up to more than 10.
- **A sight word** — a picture and a word with one letter missing, like a bus
  and `B _ S`, and you pick the vowel that finishes it.

Three big buttons either way, no typing. A wrong answer just lets you try
again — it never costs a life or a turn.

## Power-ups

| Pickup | What it does | How long |
|---|---|---|
| Kolache | Invincible | 6 seconds |
| Cowboy Boots | Jump 1.5x higher | 6 seconds |
| Lone Star | Grow to double size | Until a bad guy touches you |

They blink and bob so they are easy to spot, and the Trojan does a flashing
transform when you grab one.

## Is it working?

Under the START button:

- **BUILD 2.0 · JS OK** in green — good.
- **JS NOT RUNNING** in red — the script died; the game won't respond.

A red bar across the bottom means an error, and it says what. Tap to dismiss.

If you publish an update and the build number doesn't change, you're seeing a
cached copy — add `?v=2` to the end of the URL (then `?v=3`, and so on).

## What's in here

| File | What it is |
|---|---|
| `index.html` | The entire game |
| `manifest.webmanifest` | App name, icon, and display settings |
| `sw.js` | Makes it work offline |
| `icon-*.png`, `apple-touch-icon.png` | App icons |
| `tools/make-icons.ps1` | Regenerates those icons |
| `West Trojan - Red Black Logo.jpeg` | The school logo artwork |
| `trojan-logo-*.png`, `tools/make-logo.ps1` | Cleaned-up logo and the script that makes it |
| `CLAUDE West Trojan Game.md` | Notes for working on the code |

See the notes file before changing anything — it records several fixes that
exist because of real crashes on real iPads.
