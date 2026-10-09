# Picture Time

A toddler-safe picture slideshow. Type a topic (dogs, tigers, bees, fire trucks…) and it pulls
hundreds of photos and shows them full-screen, one at a time. There are no links, so there is
nothing for little fingers to click away to.

**Live app:** https://desjani.github.io/toddler-pictures/

## On a phone (recommended)

Open the link above on the phone, then install it and lock the phone to it.

**iPhone / iPad**
1. In Safari, tap **Share → Add to Home Screen**. Always open it from that icon, so there's no address bar.
2. Turn on **Settings → Accessibility → Guided Access** and set a passcode.
3. Start a slideshow, **triple-click the side (or Home) button**, then tap **Start**. She can't swipe
   home or switch apps until you triple-click again and enter the passcode.

**Android**
1. In Chrome, tap **⋮ → Add to Home screen** (or **Install app**). It opens full-screen from the icon.
2. Turn on **Settings → Security → App pinning** and **Ask for PIN before unpinning**.
3. Open Recent apps, tap the Picture Time icon on its card, then tap **Pin**.

The app's own protections cover everything inside the page. The phone's Home swipe can only be
blocked by Guided Access or App pinning; no web page can block it.

## On a computer

```bash
./run.sh
```

This opens the app in a **Chrome kiosk window**: full-screen, no tabs, no address bar, and a
separate browser profile with no bookmarks or accounts. It's the most locked-down way to run it.

`./run.sh --window` opens it in a normal app window instead, which is handy for trying things out.
You can also just open `index.html` in any browser, but you get fewer protections.

## Using it

1. Tap a suggestion or type a topic and press **Go!**
2. The slideshow starts and locks.
   - **Tap the left quarter** of the screen to go back. **Tap anywhere else** for the next picture.
     Swiping works too (right = back, left = next). Use this when she asks to "go back" after a
     picture changes. You can turn it off in Settings, and then every tap goes forward.
   - When a slideshow starts, an overlay shows the Back and Next zones for half a second.
     A tap dismisses it sooner.
   - Keyboard mashing just moves to the next picture.
   - It can also move on by itself (Settings → *Change picture automatically*).
   - The word shows as a small label in the top-left corner (can be turned off). There are no sounds.
   - **Wait between taps** (Settings) ignores taps for 1–10 seconds after a change, so she can't
     race through pictures. Automatic changes aren't affected.
3. **To exit:** **press and hold** the faint 🔒 in the top-right corner for about 1.5 seconds, then answer the
   addition question on the keypad. Quick taps on the lock are ignored. A wrong answer, or 12 seconds without input, sends it back to the pictures.
4. **Settings** are saved on the device and remembered next time. Defaults: change pictures only
   when tapped, left-side back zone on, 1-second wait between taps, word label on, Openverse on,
   theme Auto (follows the phone's dark mode; can be forced to Light or Dark).
5. To close the kiosk window completely: exit the slideshow first, then press **Alt+F4**.

## What the lock does

| Problem | Protection |
|---|---|
| Clicking links / buttons on image sites | Only bare images are shown. There are no links anywhere in the slideshow |
| Back button, Android back gesture, iOS edge-swipe, mouse back button | History is trapped (and topped up on every tap), so Back keeps you on the slideshow |
| Long-press "Save image / Open in new tab" menus | Disabled. Images can't be touched, and long-press callouts are off |
| Pull-to-refresh, scrolling, pinch and double-tap zoom | Blocked while the slideshow runs |
| Address bar and browser buttons on phones | Hidden when opened from the home-screen icon |
| Leaving full-screen (Esc) | Chrome keyboard lock means Esc must be *held*. If full-screen is lost anyway, the next tap restores it |
| Ctrl+W, Ctrl+T, F5, Ctrl+R, Alt+←, etc. | Captured by keyboard lock and swallowed while the slideshow runs |
| Closing or reloading the tab | A "Leave site?" confirmation appears |
| Right-click menus, dragging pictures, text selection | Disabled |
| Screen going to sleep | Wake lock keeps the screen on |
| Address bar, tabs, new windows | Hidden in kiosk mode (`run.sh`) |

A web page can't block OS-level controls: the phone's Home swipe, or the Super key and virtual
desktop shortcuts on a computer. Use Guided Access or App pinning on phones (see above).

## Where the pictures come from

- **Wikimedia Commons**: always used. Free, no API key, mostly real photographs.
- **Openverse**: on by default (Settings) for more variety. It is requested with `mature=false`
  and photographs only. If Openverse is down, it's skipped without an error.

Titles and tags are checked against a block-list to skip maps, diagrams, skeletons, dead
animals, hunting photos, adult content and so on. Neither source is moderated for toddlers,
so watch the first few pictures of any new topic.

No API keys or accounts are needed. It's a static site (one HTML file, a manifest and a small service
worker) hosted on GitHub Pages. `run.sh` only needs `python3` and Chrome/Chromium/Brave.
