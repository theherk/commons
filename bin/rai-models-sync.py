#!/usr/bin/env python3
"""Refresh the RAI Gateway model catalog and sync it into the tracked
goose and opencode provider configs.

raicode has no non-interactive "refresh models" command -- the catalog in
~/.raicode/opencode.json is only refreshed as a side effect of a normal
client launch. This script triggers that by launching `raicode` briefly in
the background, waiting for the refresh, then killing it -- before reading
the resulting model list and writing it into:

  - ~/commons/.config/opencode/opencode.json  (provider.raicode.models, plus
    name/npm/baseURL/wire_api -- apiKey is left pointing at our own env var,
    never overwritten with raicode's ephemeral {env:RAICODE_API_KEY})
  - ~/commons/.config/goose/custom_providers/raicode.json (models array,
    context_limit/max_tokens derived from limit.context/limit.output)

Both provider.raicode blocks above are generated output: re-run this script
to pick up new/renamed models rather than hand-editing them, or a future
sync will silently clobber manual changes.

Usage:
  rai-models-sync.py [--dry-run] [--no-refresh]
"""
import json
import subprocess
import sys
import time
from pathlib import Path

HOME = Path.home()
RAICODE_CONFIG = HOME / ".raicode" / "opencode.json"
OPENCODE_CONFIG = HOME / "commons" / ".config" / "opencode" / "opencode.json"
GOOSE_PROVIDER = HOME / "commons" / ".config" / "goose" / "custom_providers" / "raicode.json"

OPENCODE_APIKEY_TEMPLATE = "{env:RAICODE_OPENCODE_TOKEN}"
GOOSE_API_KEY_ENV = "RAICODE_GOOSE_TOKEN"
GOOSE_BASE_URL = "https://gateway.raicode.no"


def refresh_raicode_catalog(timeout_secs: float = 6.0, settle_secs: float = 3.0) -> None:
    """Launch raicode briefly to force it to refresh its model catalog."""
    try:
        proc = subprocess.Popen(
            ["raicode"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            stdin=subprocess.DEVNULL,
        )
    except FileNotFoundError:
        print("rai-models-sync: raicode not found in PATH", file=sys.stderr)
        sys.exit(1)

    time.sleep(settle_secs)
    proc.terminate()
    try:
        proc.wait(timeout=max(timeout_secs - settle_secs, 1))
    except subprocess.TimeoutExpired:
        proc.kill()
        proc.wait()


def load_json(path: Path) -> dict:
    with path.open() as f:
        return json.load(f)


def dump_json(path: Path, data: dict) -> None:
    with path.open("w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def sync_opencode(raicode_cfg: dict, dry_run: bool) -> tuple[set, set]:
    upstream_provider = raicode_cfg["provider"]["raicode"]
    upstream_models = upstream_provider["models"]

    cfg = load_json(OPENCODE_CONFIG)
    existing_provider = cfg.setdefault("provider", {}).get("raicode", {})
    existing_models = existing_provider.get("models", {})

    added = set(upstream_models) - set(existing_models)
    removed = set(existing_models) - set(upstream_models)

    new_provider = dict(upstream_provider)
    new_provider["options"] = dict(upstream_provider.get("options", {}))
    new_provider["options"]["apiKey"] = OPENCODE_APIKEY_TEMPLATE

    cfg["provider"]["raicode"] = new_provider

    if not dry_run:
        dump_json(OPENCODE_CONFIG, cfg)

    return added, removed


def sync_goose(raicode_cfg: dict, dry_run: bool) -> tuple[set, set]:
    upstream_models = raicode_cfg["provider"]["raicode"]["models"]

    existing = load_json(GOOSE_PROVIDER) if GOOSE_PROVIDER.exists() else {}
    existing_models = {m["name"]: m for m in existing.get("models", [])}

    added = set(upstream_models) - set(existing_models)
    removed = set(existing_models) - set(upstream_models)

    goose_models = []
    for name, meta in upstream_models.items():
        entry = {"name": name}
        limit = meta.get("limit", {})
        if "context" in limit:
            entry["context_limit"] = limit["context"]
        if "output" in limit:
            entry["max_tokens"] = limit["output"]
        goose_models.append(entry)

    new_cfg = {
        "name": existing.get("name", "raicode"),
        "engine": existing.get("engine", "anthropic"),
        "display_name": existing.get("display_name", "RAI Gateway"),
        "description": existing.get(
            "description", "DNB RAI Gateway (Bedrock/Anthropic via raicode)"
        ),
        "api_key_env": GOOSE_API_KEY_ENV,
        "base_url": GOOSE_BASE_URL,
        "models": goose_models,
        "supports_streaming": True,
        "requires_auth": True,
    }

    if not dry_run:
        dump_json(GOOSE_PROVIDER, new_cfg)

    return added, removed


def main() -> None:
    args = sys.argv[1:]
    dry_run = "--dry-run" in args
    no_refresh = "--no-refresh" in args

    if not no_refresh:
        print("rai-models-sync: refreshing RAI Gateway catalog via raicode...")
        before = RAICODE_CONFIG.read_bytes() if RAICODE_CONFIG.exists() else b""
        refresh_raicode_catalog()
        after = RAICODE_CONFIG.read_bytes() if RAICODE_CONFIG.exists() else b""
        if before == after:
            print(
                "rai-models-sync: warning: catalog file did not change; "
                "model list may be stale",
                file=sys.stderr,
            )

    if not RAICODE_CONFIG.exists():
        print(f"rai-models-sync: {RAICODE_CONFIG} not found", file=sys.stderr)
        print(
            "rai-models-sync: run without --no-refresh so raicode can create it",
            file=sys.stderr,
        )
        sys.exit(1)

    raicode_cfg = load_json(RAICODE_CONFIG)

    oc_added, oc_removed = sync_opencode(raicode_cfg, dry_run)
    gs_added, gs_removed = sync_goose(raicode_cfg, dry_run)

    prefix = "[dry-run] " if dry_run else ""
    print(f"{prefix}opencode.json: +{sorted(oc_added)} -{sorted(oc_removed)}")
    print(f"{prefix}goose/custom_providers/raicode.json: +{sorted(gs_added)} -{sorted(gs_removed)}")
    print(f"{prefix}done")


if __name__ == "__main__":
    main()
