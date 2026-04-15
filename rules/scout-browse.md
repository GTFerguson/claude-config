# Scout Browse over MCP

Use `scout-browse` for all browser automation instead of the MCP playwright tools (`mcp__plugin_playwright_*`) or `playwright-cli`. It uses Patchright (anti-detect browser) with a persistent Google profile and NopeCHA CAPTCHA solver — far more capable against anti-bot protections.

## Why

Scout Browse saves snapshots to disk and returns file paths — ~4x more token-efficient than MCP which streams accessibility trees inline into context. It also has better stealth than playwright-cli (Patchright + profile + CAPTCHA solver).

## Usage

```bash
# Core commands
scout-browse open <url>           # open browser and navigate
scout-browse snapshot             # capture page structure + extract embedded JSON
scout-browse click <ref>          # click element by ref from snapshot
scout-browse fill <ref> <text>    # fill input
scout-browse type <text>          # type into focused element
scout-browse goto <url>           # navigate
scout-browse resize <w> <h>      # set viewport size (e.g. 1440 900)
scout-browse scroll <target>     # up, down, top, bottom, or pixel amount
scout-browse screenshot           # take screenshot
scout-browse close                # close browser
```

## Flags

- `--headless` — run headless. **Default to this for localhost / dev servers / internal tools.** Faster, doesn't steal focus, and doesn't load the persistent profile's other tabs (which can pollute snapshots and mis-target clicks on tab-name collisions).
- `--no-profile` — don't load Google profile
- `--no-extensions` — don't load NopeCHA
- `--profile <path>` — use custom profile directory

**Headless vs headed — pick deliberately:**
- **Default: headless** for localhost, Vite dev servers, internal dashboards, anything you control. `scout-browse --headless open <url>`. Avoids tab pollution from the persistent Google profile.
- **Fall back to headed** (no `--headless`, the default) only when the site has anti-bot protection (Cloudflare, Google Scholar, some journals) or needs the persistent Google profile's auth cookies.

## Pattern

1. `scout-browse open <url>` — opens browser, returns snapshot path
2. Read the snapshot YAML: `cat .scout-browse/page-*.yml`
3. Check for extracted data: `cat .scout-browse/jsonld-*.json` or `cat .scout-browse/next-data-*.json`
4. `scout-browse click <ref>` / `scout-browse fill <ref> <text>` to interact
5. `scout-browse snapshot` to capture updated state

## Output Directory

All output goes to `.scout-browse/` in the current directory:
- `page-{timestamp}.yml` — page accessibility snapshot
- `jsonld-{timestamp}.json` — extracted JSON-LD (schema.org) data
- `next-data-{timestamp}.json` — extracted `__NEXT_DATA__` (Next.js)
- `screenshot-{timestamp}.png` — page screenshots
- `console-{timestamp}.log` — browser console output

## Web Research

For research tasks (fetching academic papers, documentation sites, wikis), **prefer scout-browse over WebFetch**. Many sites (Google Scholar, Wikipedia, ACM, IEEE, Springer) block raw HTTP requests but render fine in a real browser.

```bash
scout-browse open "https://scholar.google.com/scholar?q=code+ontology"
cat .scout-browse/page-*.yml   # read rendered content
scout-browse close
```

When spawning subagents for web research, instruct them to use `scout-browse` via Bash instead of WebFetch for sites that require JavaScript or block bots.
