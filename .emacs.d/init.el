;; I'm so stupid reminders
;; term-mode C-c intead of C-x
;; term-mode C-c C-j to character mode C-c C-k back to default line mode
;; helm - C-<backspace> to disable auto-completion (to create file)
;; to open second instance of named buffer rename-buffer
;; local sudo /sudo::

(setq package-enable-at-startup nil) (package-initialize)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Ubuntu Mono")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/"))))
 '(tool-bar-mode nil)
 '(x-select-enable-clipboard t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2d2d2d" :foreground "#cccccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Ubuntu Mono")))))
(if window-system
    (tool-bar-mode -1)
  )
(menu-bar-mode -1) 
(toggle-scroll-bar -1)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-linum-mode t)
(setq magit-last-seen-setup-instructions "1.4.0")
(setq-default indent-tabs-mode nil)

;; install packages
(require 'cl)
(defvar packages-list
  '(company
    company-go
    evil
    evil-leader
    evil-surround
    evil-nerd-commenter
    helm
    jinja2-mode
    magit
    markdown-mode
    color-theme-sanityinc-tomorrow
    tramp-term
    yaml-mode
    yasnippet
    helm-c-yasnippet)
  "List of packages needs to be installed at launch")

(defun has-package-not-installed ()
  (loop for p in packages-list
        when (not (package-installed-p p)) do (return t)
        finally (return nil)))
(when (has-package-not-installed)
  ;; Check for new packages (package versions)
  (message "%s" "Get latest versions of all packages...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; Install the missing packages
  (dolist (p packages-list)
    (when (not (package-installed-p p))
      (package-install p))))

;; Company Mode
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "C-q")     #'company-complete)

;; Evil Mode
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "0" 'delete-window
  "1" 'delete-other-windows
  "2" 'split-window-below
  "3" 'split-window-right
  "b" 'helm-buffers-list
  "f" 'helm-find-files
  "k" 'kill-buffer
  "o" 'other-window
  "s" 'helm-yas-complete
  "w" 'save-buffer
  "x" 'helm-M-x)
;; nerd-commenter leaders
(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
)
(require 'evil-surround)
(global-evil-surround-mode 1)
(require 'evil)
(evil-mode 1)

;; json-mode
(add-hook 'json-mode-hook
  (function (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)
            (setq evil-shift-width js-indent-level))))

;; Markdown
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; YAML
(autoload 'yaml-mode "yaml-mode"
  "Major mode for editing yaml files" t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; Jinja2
(autoload 'jinja2-mode "jinja2-mode"
  "Major mode for editing jinja2 files" t)
(add-to-list 'auto-mode-alist '("\\.sls\\'" . jinja2-mode))
(add-to-list 'auto-mode-alist '("\\.jinja2\\'" . jinja2-mode))

;; Javascript
(setq js-indent-level 2)

;; Backup files
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; MELPA
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; tramp
(require 'tramp)
(add-to-list 'tramp-default-proxies-alist
  '("172\\.31\\.2\\.156" "\\`root\\'" "/ssh:hsherwood@%h:"))

;; yasnippet
;; this is a workaround for version differences between helm and yas
(defalias 'yas--template-file 'yas--template-get-file)
(require 'yasnippet)
(yas-global-mode 1)
;; disable yas in term mode because it breaks tab
(add-hook 'term-mode-hook (lambda () (yas-minor-mode -1)))
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"))

;; helm configuration
;; ---

(setq helm-ff-transformer-show-only-basename nil
      helm-adaptive-history-file             "~/.emacs.d/data/helm-history"
      helm-yank-symbol-first                 t
      helm-move-to-line-cycle-in-source      t
      helm-buffers-fuzzy-matching            t
      helm-ff-auto-update-initial-value      t)

(autoload 'helm-descbinds      "helm-descbinds" t)
(autoload 'helm-eshell-history "helm-eshell"    t)
(autoload 'helm-esh-pcomplete  "helm-eshell"    t)

(global-set-key (kbd "C-h a")    #'helm-apropos)
(global-set-key (kbd "C-h i")    #'helm-info-emacs)
(global-set-key (kbd "C-h b")    #'helm-descbinds)

(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "TAB")     #'helm-esh-pcomplete)
              (define-key eshell-mode-map (kbd "C-c C-l") #'helm-eshell-history)))

(global-set-key (kbd "C-x b")   #'helm-mini)
(global-set-key (kbd "C-x C-b") #'helm-buffers-list)
(global-set-key (kbd "C-x C-m") #'helm-M-x)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x C-r") #'helm-recentf)
(global-set-key (kbd "C-x r l") #'helm-filtered-bookmarks)
(global-set-key (kbd "M-y")     #'helm-show-kill-ring)
(global-set-key (kbd "M-s o")   #'helm-swoop)
(global-set-key (kbd "M-s /")   #'helm-multi-swoop)

(require 'helm-config)
(helm-mode t)
(helm-adaptative-mode t)

(global-set-key (kbd "C-x c!")   #'helm-calcul-expression)
(global-set-key (kbd "C-x c:")   #'helm-eval-expression-with-eldoc)
(define-key helm-map (kbd "M-o") #'helm-previous-source)

(global-set-key (kbd "M-s s")   #'helm-ag)
