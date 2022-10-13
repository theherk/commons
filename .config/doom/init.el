;;; init.el -*- lexical-binding: t; -*-

;; 'SPC h d h' for docs.
;; 'K' for module docs.

(doom! :app
       everywhere

       :completion
       (company +childframe)
       (vertico +childframe +icons)

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
       eshell
       vterm

       :checkers
       (syntax +childframe)
       spell

       :tools
       (debugger +lsp)
       direnv
       docker
       editorconfig
       (eval +overlay)
       lookup
       (lsp +peek)
       (magit +forge)
       make
       terraform

       :os
       (:if IS-MAC macos)

       :lang
       emacs-lisp
       (go +lsp)
       json
       (java +lsp)
       javascript
       latex
       lua
       nim
       (markdown +grip)
       (org +roam2)
       plantuml
       (python +lsp +pyright +pyenv)
       rst
       (rust +lsp)
       sh
       web
       yaml

       :config
       (default +bindings +smartparens))
