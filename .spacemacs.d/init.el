;; -*- mode: emacs-lisp -*-
(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
    dotspacemacs-distribution 'spacemacs
    dotspacemacs-configuration-layer-path '()
    dotspacemacs-configuration-layers
    '(
       auto-completion
       better-defaults
       c-c++
       colors
       csv
       emacs-lisp
       emoji
       docker
       git
       go
       gtags
       html
       javascript
       markdown
       nginx
       org
       plantuml
       python
       rust
       salt
       search-engine
       shell
       spell-checking
       syntax-checking
       terraform
       themes-megapack
       typescript
       version-control
       windows-scripts
       xkcd
       yaml
       )
    dotspacemacs-additional-packages
    '(
       editorconfig
       tramp-term
       )
    dotspacemacs-excluded-packages '()
    dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  (setq-default
    dotspacemacs-elpa-https t
    dotspacemacs-elpa-timeout 5
    dotspacemacs-check-for-update t
    dotspacemacs-editing-style 'vim
    dotspacemacs-verbose-loading nil
    dotspacemacs-startup-banner 'random
    dotspacemacs-startup-lists nil
    dotspacemacs-startup-recent-list-size 5
    dotspacemacs-scratch-mode 'markdown-mode
    dotspacemacs-themes '(sanityinc-tomorrow-eighties
                           spacemacs-dark
                           spacemacs-light)
    dotspacemacs-colorize-cursor-according-to-state t
    dotspacemacs-default-font '("Ubuntu Mono"
                                 :size 20
                                 :weight normal
                                 :width normal
                                 :powerline-scale 1.1)
    dotspacemacs-leader-key "SPC"
    dotspacemacs-emacs-leader-key "M-m"
    dotspacemacs-major-mode-leader-key ","
    dotspacemacs-major-mode-emacs-leader-key "C-M-m"
    dotspacemacs-distinguish-gui-tab nil
    dotspacemacs-command-key ":"
    dotspacemacs-remap-Y-to-y$ t
    dotspacemacs-default-layout-name "Default"
    dotspacemacs-display-default-layout nil
    dotspacemacs-auto-resume-layouts nil
    dotspacemacs-auto-save-file-location 'cache
    dotspacemacs-max-rollback-slots 5
    dotspacemacs-use-ido nil
    dotspacemacs-helm-resize nil
    dotspacemacs-helm-no-header nil
    dotspacemacs-helm-position 'bottom
    dotspacemacs-enable-paste-micro-state t
    dotspacemacs-which-key-delay 0.4
    dotspacemacs-which-key-position 'bottom
    dotspacemacs-loading-progress-bar t
    dotspacemacs-fullscreen-at-startup nil
    dotspacemacs-fullscreen-use-non-native nil
    dotspacemacs-maximized-at-startup t
    dotspacemacs-active-transparency 90
    dotspacemacs-inactive-transparency 90
    dotspacemacs-mode-line-unicode-symbols t
    dotspacemacs-smooth-scrolling nil
    dotspacemacs-line-numbers 'relative
    dotspacemacs-smartparens-strict-mode t
    dotspacemacs-highlight-delimiters 'current
    dotspacemacs-persistent-server nil
    dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
    dotspacemacs-default-package-repository nil
    dotspacemacs-whitespace-cleanup 'trailing
    ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init'.  You are free to put almost
any user code here.  The exception is org related code, which should be placed
in `dotspacemacs/user-config'."
  (setq-default dotspacemacs-configuration-layers
    '(
       (colors :variables
         colors-colorize-identifiers 'all
         colors-enable-nyan-cat-progress-bar t)
       ))
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration. You are free to put any user code."
  ;; editorconfig
  (editorconfig-mode 1)
  (add-hook 'after-change-major-mode-hook 'editorconfig-apply 'append)

  ;; go
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq go-use-gometalinter t)

  ;; javascript
  (add-hook 'js2-mode-hook
    (defun my-js2-mode-setup ()
      (flycheck-mode t)
      (when (executable-find "eslint")
        (flycheck-select-checker 'javascript-eslint))))

  ;; misc
  (setq browse-url-browser-function 'browse-url-generic
    engine/browser-function 'browse-url-generic
    browse-url-generic-program "chromium")
  (spacemacs/set-leader-keys "jB" 'pop-tag-mark)
  (spacemacs/set-leader-keys "G" 'pop-tag-mark)

  ;; modeline
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-purpose-off)

  ;; python
  (add-hook 'python-mode-hook (lambda ()
                                (flycheck-mode 1)
                                (semantic-mode 1)
                                (setq flycheck-checker 'python-pylint
                                  flycheck-checker-error-threshold 900
                                  flycheck-pylintrc "~/.pylintrc")))

  ;; snippets
  (setcdr yas-snippet-dirs (cons "~/.spacemacs.d/private/snippets" (rest yas-snippet-dirs)))
  (setq powerline-default-separator 'nil)

  ;; tramp
  (eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
  (setq tramp-chunksize 500)
  ;; (setq projectile-mode-line "Projectile") https://github.com/bbatsov/projectile/issues/893
  )
