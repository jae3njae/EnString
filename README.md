# Enstring

An infinite canvas for organizing ideas — notes, pages you can click into,
images, framed groups, and connection strings between them. Three themes
(light / soft / dark), marquee multi-select, grouping, undo/redo, and labelled
connections. With Supabase wired up it has password login and cloud save, so
your boards persist when you close the tab and follow you to any device.

This is a static site: a few files, no server to run. You edit it in VS Code
and host it free on GitHub Pages.

---

## What you need
- A free Supabase account (the database + login).
- VS Code (you have it). The **Live Server** extension is the easiest way to run it.
- A GitHub account (to host it online).

---

## Part 1 — Run it locally (about 10 minutes)

### 1. Create a Supabase project
1. Go to supabase.com → sign in → **New project**.
2. Give it a name and a database password (save that password somewhere).
3. Wait ~1 minute for it to finish setting up.

### 2. Create the database table
1. In your project, open **SQL Editor → New query**.
2. Open `supabase-setup.sql` from this folder, copy everything, paste it in, **Run**.
   You should see "Success". This makes one `boards` table and locks it to each user.

### 3. Turn off email confirmation (so you can log in immediately)
For a solo project this avoids the confirm-by-email step:
- **Authentication → Sign In / Providers → Email** → turn **Confirm email** OFF → Save.
(You can turn it back on later if you ever invite others.)

### 4. Paste your keys into the app
1. In Supabase: **Project Settings → API**.
2. Copy the **Project URL** and the **anon public** key.
3. Open `config.js` in VS Code and paste them into the two fields. Save.

### 5. Open it with a local server (not by double-clicking)
The app loads its login library over the web, which browsers block on a raw
`file://` path. So serve it instead:
- In VS Code, install the **Live Server** extension, then right-click
  `index.html` → **Open with Live Server**.
- (Or, in a terminal in this folder: `python3 -m http.server 5500`, then visit
  `http://localhost:5500`.)

### 6. Sign up and use it
- Click **New here? Create an account**, enter your name + email + a password.
- You're in. Everything you do auto-saves to the cloud (watch the status text,
  bottom-left). Close the tab and log back in — it's all there.

> If you skip the Supabase steps, the app still opens in **local mode**: no login,
> and it saves only in that one browser. Filling in `config.js` switches on the
> real login + cloud save.

---

## Part 2 — Put it online with GitHub Pages

1. Create a new repository on GitHub and push these files to it
   (`index.html`, `config.js`, `supabase-setup.sql`, `README.md`).
   In VS Code: Source Control panel → Initialize → commit → Publish to GitHub.
2. On GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a
   branch**, pick `main` and `/ (root)`, **Save**.
3. After a minute you get a URL like `https://yourname.github.io/enstring/`.
4. Back in Supabase: **Authentication → URL Configuration** → add that URL under
   **Site URL** (and Redirect URLs). Save.
5. Open the URL, log in, done. Bookmark it — that's your app.

Note: `config.js` will be public in the repo. That's fine — the anon key is
designed to be public, and Row Level Security is what actually protects your
data. Never put the Supabase *service_role* key or your database password in
these files.

---

## How your data is stored
Your entire workspace — every node, connection, nested page, and the canvas
position — is saved as one JSON document in the `boards` table, keyed to your
user id. The app writes it on a short delay after each change and on **Save now**
(⌘/Ctrl+S). **Export backup** in the account menu downloads that JSON if you ever
want an offline copy or to move it elsewhere.

## Keyboard shortcuts
- Double-click empty canvas: new note · double-click a page: enter it
- Drag empty space: marquee select · Shift-click: add/remove from selection
- Space-drag (or middle-mouse, or the Hand tool): pan · scroll: zoom
- ⌘/Ctrl+G: group selection · Delete: remove · ⌘/Ctrl+A: select all
- ⌘/Ctrl+Z: undo · ⇧⌘/Ctrl+Z: redo · ⌘/Ctrl+S: save now
- Double-click a connection string: add/edit its label

## Files
- `index.html` — the whole app
- `config.js` — your Supabase keys
- `supabase-setup.sql` — run once to create the table + security rules