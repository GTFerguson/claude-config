# Playwright CLI Browser Automation

Use `playwright-cli` (at `~/.local/bin/playwright-cli`) for all browser automation. Do NOT use MCP playwright tools (`mcp__plugin_playwright_*`).

## Why

Playwright CLI saves snapshots to disk and returns file paths — ~4x more token-efficient than MCP which streams accessibility trees inline into context.

## Setup

Always export PATH first in every Bash command:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Commands

| Command | Description |
|---------|------------|
| `playwright-cli open <url>` | Open browser and navigate |
| `playwright-cli goto <url>` | Navigate to URL |
| `playwright-cli snapshot` | Capture page structure to .playwright-cli/ |
| `playwright-cli screenshot` | Take viewport screenshot |
| `playwright-cli screenshot <ref>` | Screenshot specific element |
| `playwright-cli click <ref>` | Click element by ref |
| `playwright-cli fill <ref> <text>` | Fill input field |
| `playwright-cli type <text>` | Type into focused element |
| `playwright-cli hover <ref>` | Hover over element |
| `playwright-cli press <key>` | Press keyboard key |
| `playwright-cli resize <w> <h>` | Resize viewport |
| `playwright-cli eval <js>` | Evaluate JavaScript |
| `playwright-cli console` | Get console messages |
| `playwright-cli close` | Close browser |

## Pattern

1. `playwright-cli open <url>` — opens browser, returns snapshot path
2. Read the snapshot YAML to find element refs: `cat .playwright-cli/page-*.yml`
3. `playwright-cli click <ref>` / `playwright-cli fill <ref> <text>` to interact
4. `playwright-cli snapshot` to capture updated state after interactions
5. `playwright-cli screenshot` to visually verify

## Reading Results

```bash
cat .playwright-cli/page-*.yml      # page structure with element refs
cat .playwright-cli/console-*.log   # console output
```

Screenshot images can be read with the Read tool to view them visually.

## Important

- For local file URLs, use `file:///` protocol — but note playwright-cli may block file:// URLs. Use a local HTTP server instead.
- For evaluating JS, keep expressions simple — complex functions may fail serialization.
- Use `resize` before `screenshot` when testing specific viewport sizes.
