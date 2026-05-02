export const ZellijNotifyPlugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const current = process.env.ZELLIJ_SESSION_NAME || "unknown"
        const sessions = await $`zellij list-sessions -ns`.quiet().text()
        for (const session of sessions.trim().split("\n").filter(Boolean)) {
          const msg = session === current
            ? "zjstatus::notify::"
            : "zjstatus::notify:: " + current
          await $`zellij --session ${session} pipe -- ${msg}`.quiet().nothrow()
        }
      }
    },
  }
}
