;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Adam Sherwood"
      user-mail-address "theherk@gmail.com")

(setq doom-font (font-spec :family "Ubuntu Mono" :size 22 :weight 'light)
      doom-big-font (font-spec :family "Ubuntu" :size 30 :weight 'normal))

(setq doom-theme 'doom-dracula)

(setq org-directory "~/org/")

(setq display-line-numbers-type nil)

(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

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
