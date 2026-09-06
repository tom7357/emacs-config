;;; init-package.el --- Package configuration -*- lexical-binding: t; -*-

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 2)
  (company-selection-wrap-around t)
  (company-tooltip-limit 10))

(use-package move-dup
  :ensure t
  :bind
  (("M-<up>"   . move-dup-move-lines-up)
   ("M-<down>" . move-dup-move-lines-down)
   ("C-c d"    . move-dup-duplicate-down)))


(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.5))

(provide 'init-package)

;;; init-package.el ends here
