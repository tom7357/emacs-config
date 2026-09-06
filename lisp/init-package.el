;;; init-package.el --- Package configuration -*- lexical-binding: t; -*-

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 2)
  (company-selection-wrap-around t)
  (company-tooltip-limit 10))

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode))

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

(use-package treesit
  :ensure nil
  :when (and (fboundp 'treesit-available-p)
             (treesit-available-p))
  :custom
  (treesit-font-lock-level 4)
  :config
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (java . ("https://github.com/tree-sitter/tree-sitter-java"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))))

  (add-to-list 'major-mode-remap-alist
               '(sh-mode . bash-ts-mode))
  (add-to-list 'major-mode-remap-alist
               '(c-mode . c-ts-mode))
  (add-to-list 'major-mode-remap-alist
               '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist
               '(java-mode . java-ts-mode))
  (add-to-list 'major-mode-remap-alist
               '(js-json-mode . json-ts-mode))
  (add-to-list 'major-mode-remap-alist
               '(python-mode . python-ts-mode))
  (add-to-list 'major-mode-remap-alist
               '(js-mode . js-ts-mode)))


(use-package eglot
  :ensure nil
  :hook
  ((c-mode c-ts-mode) . eglot-ensure)
  ((c++-mode c++-ts-mode) . eglot-ensure)
  ((java-mode java-ts-mode) . eglot-ensure)
  :bind
  ("C-c e f" . eglot-format))

(use-package quickrun
  :ensure t
  :defer t
  :bind ("C-c r" . quickrun))

(provide 'init-package)

;;; init-package.el ends here
