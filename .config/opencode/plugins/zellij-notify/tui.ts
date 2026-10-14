import { spawnSync } from "node:child_process"
import { Plugin } from "@opencode/plugin/tui"

// Zellij cross-session notify. Runs in the CLI process (not the shared
// background server), so ZELLIJ_SESSION_NAME is the pane's own session.
// The current session gets the icon alone; every other session gets the icon
// plus the originating session name via zjstatus.
const ICON = "\uee0d"

const notify = () => {
  const current = process.env.ZELLIJ_SESSION_NAME || "unknown"
  const listed = spawnSync("zellij", ["list-sessions", "-ns"], { encoding: "utf8" })
  if (listed.status !== 0) return
  for (const session of listed.stdout.trim().split("\n").filter(Boolean)) {
    const msg = session === current ? `zjstatus::notify::${ICON} ` : `zjstatus::notify::${ICON} ${current}`
    spawnSync("zellij", ["--session", session, "pipe", "--", msg], { stdio: "ignore" })
  }
}

export default Plugin.define({
  id: "h4s.zellij-notify",
  setup(context) {
    if (!process.env.ZELLIJ_SESSION_NAME) return
    return context.data.on("session.execution.succeeded", notify)
  },
})
