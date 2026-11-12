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
    // The event stream is server-wide: every TUI attached to the shared server
    // sees every session's events (other panes, subagents). Only notify for a
    // root session this TUI is actually showing.
    return context.data.on("session.execution.succeeded", (event: any) => {
      const id = event?.data?.sessionID ?? event?.sessionID ?? event?.details?.data?.sessionID
      if (!id) return
      if (context.data.session.root(id) !== id) return
      const route: any = context.route?.current
      const mine = new Set<string>()
      if (route?.name === "session" && route.params?.sessionID) mine.add(route.params.sessionID)
      for (const tab of context.ui?.tabs?.list?.() ?? []) mine.add((tab as any).sessionID)
      if (mine.has(id)) notify()
    })
  },
})
