;;; init-package.el --- Package configuration -*- lexical-binding: t; -*-

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 2)
  (company-selection-wrap-around t)
  (company-tooltip-limit 10))

(provide 'init-package)

;;; init-package.el ends here
