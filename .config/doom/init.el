;;; init.el -*- lexical-binding: t; -*-

;; 'SPC h d h' for docs.
;; 'K' for module docs.

(doom! :completion
       company
       ivy

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
       nav-flash
       ophints
       (popup +defaults)
       (treemacs +lsp)
       unicode
       vc-gutter
       vi-tilde-fringe
       window-select
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       snippets

       :emacs
       dired
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       syntax
       spell

       :tools
       debugger (+lsp)
       direnv
       docker
       editorconfig
       (eval +overlay)
       lookup
       lsp
       magit
       make
       terraform

       :os
       (:if IS-MAC macos)

       :lang
       emacs-lisp
       (go +lsp)
       json
       (java +meghanada)
       javascript
       latex
       markdown
       org
       plantuml
       (python +lsp +pyright +pyenv)
       rst
       (rust +lsp)
       sh
       web
       yaml

       :config
       (default +bindings +smartparens))
