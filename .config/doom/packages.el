;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! exec-path-from-shell)
(package! hackernews)
(package! kaolin-themes)
;; (package! night-owl-theme)
;; (package! md4rd)
(package! org-modern)
;; (package! ox-jira)
(package! rego-mode)

;; org-roam needs unpinned to use latest.
(unpin! org-roam)
(package! org-roam-ui)
