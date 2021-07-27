;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Adam Sherwood"
      user-mail-address "theherk@gmail.com")

(setq
  doom-font (font-spec :family "Ubuntu Mono Ligaturized" :size 22)
  doom-big-font (font-spec :family "Ubuntu Mono Ligaturized" :size 30)
  doom-variable-pitch-font (font-spec :family "Ubuntu" :size 30))

;; alpha
;; (set-frame-parameter (selected-frame) 'alpha '(90 65))
;; (add-to-list 'default-frame-alist '(alpha 90 65))

;; theme
;; (setq doom-theme 'doom-dracula)
;; (setq doom-theme 'doom-xcode)

(setq org-directory "~/org/")

(setq display-line-numbers-type nil)

;; (add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

(defun theherk/org-link-yank (&optional arg)
  "Extract URL from org-mode link and add it to kill ring."
  (interactive "P")
  (let* ((link (org-element-lineage (org-element-context) '(link) t))
          (type (org-element-property :type link))
          (url (org-element-property :path link))
          (url (concat type ":" url)))
    (kill-new url)
    (message (concat "Copied URL: " url))))
(map! :leader
  :desc "yank org link"
  "m l y" #'theherk/org-link-yank)

(map! :leader
  :desc "toggle wrap"
  "t t" #'toggle-truncate-lines)

;; https://github.com/hlissner/doom-emacs/issues/401
(setq evil-respect-visual-line-mode t)

(setq fancy-splash-image "~/commons/img/bruce-matlocktheartist_200w.png")

(after! sh-script
  (set-company-backend! 'sh-mode nil))
