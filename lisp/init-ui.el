;;; init-ui.el --- UI settings -*- lexical-binding: t; -*-

;; Theme
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-soft t))

;; Fonts
(use-package emacs
  :ensure nil
  :if (display-graphic-p)
  :config
  (if *is-windows*
      (progn
        ;; English / code font
        (set-face-attribute 'default nil
                            :font "Consolas"
                            :height 105)

        ;; Chinese / Japanese fonts
        (dolist (charset '(kana han cjk-misc bopomofo))
          (set-fontset-font t charset
                            (font-spec :family "Microsoft YaHei")))

        ;; Symbols
        (set-fontset-font t 'symbol
                          (font-spec :family "Segoe UI Symbol")))
    (set-face-attribute 'default nil
                        :font "Source Code Pro"
                        :height 110)))

(provide 'init-ui)

;;; init-ui.el ends here
