# Playwright CLI over MCP

Use `playwright-cli` (installed at `~/.local/bin/playwright-cli`) for all browser automation instead of the MCP playwright tools (`mcp__plugin_playwright_*`).

## Why

Playwright CLI saves snapshots to disk and returns file paths — ~4x more token-efficient than MCP which streams accessibility trees inline into context.

## Usage

```bash
# Always export PATH first
export PATH="$HOME/.local/bin:$PATH"

# Core commands
playwright-cli open <url>           # open browser and navigate
playwright-cli snapshot             # capture page structure (saved to .playwright-cli/)
playwright-cli click <ref>          # click element by ref from snapshot
playwright-cli fill <ref> <text>    # fill input
playwright-cli type <text>          # type into focused element
playwright-cli goto <url>           # navigate
playwright-cli screenshot           # take screenshot
playwright-cli close                # close browser

# Read snapshots from disk
cat .playwright-cli/page-*.yml      # page structure with element refs
cat .playwright-cli/console-*.log   # console output
```

## Pattern

1. `playwright-cli open <url>` — opens browser, returns snapshot path
2. Read the snapshot YAML to find element refs
3. `playwright-cli click <ref>` / `playwright-cli fill <ref> <text>` to interact
4. `playwright-cli snapshot` to capture updated state after interactions

## Web Research

For research tasks (fetching academic papers, documentation sites, wikis), **prefer playwright-cli over WebFetch**. Many sites (Google Scholar, Wikipedia, ACM, IEEE, Springer) block raw HTTP requests but render fine in a real browser.

```bash
# Fetch a page that blocks WebFetch
export PATH="$HOME/.local/bin:$PATH"
playwright-cli open "https://scholar.google.com/scholar?q=code+ontology"
cat .playwright-cli/page-*.yml   # read rendered content
playwright-cli close
```

When spawning subagents for web research, instruct them to use `playwright-cli` via Bash instead of WebFetch for sites that require JavaScript or block bots.
