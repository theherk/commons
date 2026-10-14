import { spawnSync } from "node:child_process"
import { Plugin } from "@opencode/plugin"

// RTK plugin: rewrites shell commands through `rtk rewrite` for token savings.
// Requires rtk >= 0.23.0 in PATH. All rewrite logic lives in rtk itself
// (src/discover/registry.rs); edit the Rust registry, not this file.
//
// Runs on the shell `create.before` hook, which fires after permission rules
// have evaluated the original command, so permission rules need no rtk-prefixed twins.

export default Plugin.define({
  id: "h4s.rtk",
  async setup(ctx) {
    const probe = spawnSync("which", ["rtk"], { encoding: "utf8" })
    if (probe.status !== 0) {
      console.warn("[rtk] rtk binary not found in PATH; plugin disabled")
      return
    }

    await ctx.shell.hook("create.before", (event) => {
      if (!event.command) return
      const result = spawnSync("rtk", ["rewrite", event.command], { encoding: "utf8" })
      const rewritten = String(result.stdout ?? "").trim()
      if (rewritten && rewritten !== event.command) event.command = rewritten
    })
  },
})
