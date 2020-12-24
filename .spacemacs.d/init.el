;; -*- mode: emacs-lisp -*-
(defun dotspacemacs/layers ()
  (setq-default
    dotspacemacs-distribution 'spacemacs
    dotspacemacs-configuration-layer-path '()
    dotspacemacs-configuration-layers
    '(nginx
       auto-completion
       c-c++
       (colors :variables
         colors-enable-nyan-cat-progress-bar t)
       dap
       emacs-lisp
       emoji
       docker
       git
       go
       (go :variables
         go-backend 'lsp
         gofmt-command "goimports")
       (groovy :variables
         groovy-backend 'lsp
         groovy-lsp-jar-path "/home/h4s/projects/github.com/prominic/groovy-language-server/build/libs/groovy-language-server-all.jar")
       gtags
       html
       javascript
       (markdown :variables
         markdown-asymmetric-header t
         markdown-command "blackfriday-tool")
       org
       plantuml
       python
       (ranger :variables
         ranger-show-preview t
         ranger-cleanup-on-disable t
         ranger-cleanup-eagerly t)
       react
       rust
       salt
       (shell :variables
         shell-default-shell 'eshell
         close-window-with-terminal t)
       syntax-checking
       (terraform :variables
         terraform-auto-format-on-save t
         terraform-backend 'lsp)
       themes-megapack
       typescript
       version-control
       windows-scripts
       xkcd
       yaml)
    dotspacemacs-additional-packages '(dracula-theme editorconfig tramp-term)
    dotspacemacs-excluded-packages '()
    dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  (setq-default
    dotspacemacs-elpa-https t
    dotspacemacs-elpa-timeout 5
    dotspacemacs-check-for-update t
    dotspacemacs-editing-style 'vim
    dotspacemacs-verbose-loading nil
    ;; Artwork by matlocktheartist
    ;; https://www.deviantart.com/matlocktheartist/art/Bruce-Lee-Puzzled-322967405
    dotspacemacs-startup-banner (substitute-in-file-name "${HOME}/commons/img/bruce-matlocktheartist_400w.png")
    dotspacemacs-startup-lists nil
    dotspacemacs-startup-recent-list-size 5
    dotspacemacs-scratch-mode 'markdown-mode
    dotspacemacs-themes '(doom-dracula dracula spacemacs-dark spacemacs-light)
    dotspacemacs-colorize-cursor-according-to-state t
    dotspacemacs-default-font '("Ubuntu Mono" :size 20 :weight normal :width normal)
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
    dotspacemacs-mode-line-theme '(all-the-icons :separator none)
    dotspacemacs-smooth-scrolling t
    dotspacemacs-line-numbers 'relative
    dotspacemacs-smartparens-strict-mode t
    dotspacemacs-highlight-delimiters 'current
    dotspacemacs-persistent-server nil
    dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
    dotspacemacs-default-package-repository nil
    dotspacemacs-whitespace-cleanup 'trailing
    ))

(defun dotspacemacs/user-init ()
  (setq frame-resize-pixelwise t)
  (setq-default git-magit-status-fullscreen t))

(defun dotspacemacs/user-config ()
  ;; editorconfig
  (editorconfig-mode 1)
  (add-hook 'after-change-major-mode-hook 'editorconfig-apply 'append)

  ;; go
  (add-hook 'before-save-hook 'gofmt-before-save)

  ;; modeline
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-purpose-off)
  (display-time-mode 1)
  (setq display-time-24hr-format t)

  ;; project layout
  ;; TODO: Create this helpful function, and run from helm-find-files as eshell alias.
  ;; 1. Create new perspective layout named projectile project.
  ;;     - Switch to if exists.
  ;; 2. Open file of README.md if directory.
  ;; 3. Create new eyebrowse workspace (2) with full projectile e-shell.
  ;; 4. Switch back to file opened.
  ;; (defun open-project ())

  ;; snippets
  (setcdr yas-snippet-dirs (cons "~/.spacemacs.d/private/snippets" (rest yas-snippet-dirs)))

  ;; translate
  (defun trans-en-no-region (&optional b e)
    (interactive "r")
    (shell-command-on-region b e "trans en:no -b")
    (end-of-line)
    (newline-and-indent)
    (insert-buffer "*Shell Command Output*"))
  (defun trans-no-en-region (&optional b e)
    (interactive "r")
    (shell-command-on-region b e "trans no:en -b")
    (end-of-line)
    (newline-and-indent)
    (insert-buffer "*Shell Command Output*"))
  (spacemacs/declare-prefix "C-t" "translate")
  (spacemacs/set-leader-keys "C-t n" 'trans-en-no-region)
  (spacemacs/set-leader-keys "C-t e" 'trans-no-en-region)
  )
  )
