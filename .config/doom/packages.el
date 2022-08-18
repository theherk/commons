;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! ef-themes)
(package! exec-path-from-shell)
(package! hackernews)
;; (package! night-owl-theme)
;; (package! md4rd)
(package! org-modern)
(package! ox-gfm)
;; (package! ox-jira)
(package! ox-pandoc)
(package! rego-mode)

;; org-roam needs unpinned to use latest.
(unpin! org-roam)
(package! org-roam-ui)
