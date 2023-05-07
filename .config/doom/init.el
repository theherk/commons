;;; init.el -*- lexical-binding: t; -*-

;; 'SPC h d h' for docs.
;; 'K' for module docs.

;; It is possible that adding the childframe module flag for vertico
;; first is required. When loaded for both vertico and comany at the
;; same time, there was an issue with the icons on the left side. It
;; is unclear if this was the solution. Another possiblity is that
;; adding this module flag after the icons flag is the solution.
;;
;; Further clarification. It seems one must add childframe alone to
;; vertico, then after sync and open, add icons to vertico.

(doom! :completion
       company
       (vertico +icons)

       :config
       literate

       :ui
       deft
       doom
       doom-dashboard
       (emoji +unicode)
       hl-todo
       ligatures
       modeline
       ophints
       (popup +defaults)
       (treemacs +lsp)
       unicode
       vc-gutter
       (window-select +switch-window)
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       snippets

       :emacs
       (dired +icons)
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       vterm

       :checkers
       syntax
       spell

       :tools
       direnv
       editorconfig
       lookup
       (lsp +peek)
       magit
       make
       terraform
       tree-sitter

       :os
       (:if IS-MAC macos)

       :lang
       emacs-lisp
       json
       javascript
       latex
       lua
       (markdown +grip)
       (org +roam2 +pretty)
       (python +lsp +pyright +pyenv +tree-sitter)
       rst
       (rust +lsp)
       (sh +fish +lsp)
       web
       yaml

       :config
       (default +bindings +smartparens))
