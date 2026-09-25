---
name: niri-screenshot
description: Capture and inspect a specific niri window by title or app ID. Use when a task needs a screenshot of one window in a running niri session.
---

# Capture a niri Window

1. Obtain the target window ID before taking a screenshot. Filter by title:

```sh
window_id=$(niri msg --json windows | jq -er 'first(.[] | select((.title // "") | test("<title>"; "i")) | .id)')
```

Filter by application ID when it is more stable:

```sh
window_id=$(niri msg --json windows | jq -er 'first(.[] | select((.app_id // "") | test("<app-id>"; "i")) | .id)')
```

Replace the placeholder with a specific regular expression. If the command finds no window or the target is ambiguous, inspect `niri msg --json windows` and refine the filter. Never guess a window ID.

2. Create a unique absolute output path under `/tmp`:

```sh
screenshot_path="/tmp/niri-screenshot-${window_id}-$(date +%s%N).png"
```

3. Capture only that window:

```sh
niri msg action screenshot-window \
  --id "$window_id" \
  --path "$screenshot_path" \
  --write-to-disk true
```

Add `--show-pointer true` only when the pointer is relevant.

4. Confirm that the output file exists and is not empty. Then inspect the image at `$screenshot_path` with the current agent's image inspection tool. Base all visual claims on that inspection.

See [references/niri-help.txt](references/niri-help.txt) for the installed command help.
