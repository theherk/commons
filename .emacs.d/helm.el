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

(require 'helm-projectile)
(setq helm-projectile-sources-list (cons 'helm-source-projectile-files-list
                                         (remove 'helm-source-projectile-files-list 
                                              helm-projectile-sources-list)))
(helm-projectile-on)

(define-key projectile-mode-map (kbd "C-c p /")
  #'(lambda ()
      (interactive)
      (helm-ag (projectile-project-root))))

(define-key org-mode-map (kbd "C-x c o h") #'helm-org-headlines)
