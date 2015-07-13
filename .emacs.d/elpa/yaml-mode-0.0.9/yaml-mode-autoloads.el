;;; yaml-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "yaml-mode" "../../../../.emacs.d/elpa/yaml-mode-0.0.9/yaml-mode.el"
;;;;;;  "92f599868f74a658fb9e407306e00544")
;;; Generated autoloads from ../../../../.emacs.d/elpa/yaml-mode-0.0.9/yaml-mode.el

(let ((loads (get 'yaml 'custom-loads))) (if (member '"yaml-mode" loads) nil (put 'yaml 'custom-loads (cons '"yaml-mode" loads))))

(autoload 'yaml-mode "yaml-mode" "\
Simple mode to edit YAML.

\\{yaml-mode-map}

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

;;;***

;;;### (autoloads nil nil ("../../../../.emacs.d/elpa/yaml-mode-0.0.9/yaml-mode-autoloads.el"
;;;;;;  "../../../../.emacs.d/elpa/yaml-mode-0.0.9/yaml-mode.el")
;;;;;;  (21907 6480 865493 56000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; yaml-mode-autoloads.el ends here
