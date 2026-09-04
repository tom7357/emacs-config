;;; init-ui.el --- UI settings -*- lexical-binding: t; -*-
;; gruvbox-theme
(use-package gruvbox-theme 
    :init (load-theme 'gruvbox-dark-soft t))

(use-package smart-mode-line 
    :init 
    (setq sml/no-confirm-load-theme t) 
    (setq sml/theme 'respectful) 
    (sml/setup))

(use-package emacs
  :ensure nil
  :if (display-graphic-p)
  :config
  (if *is-windows*
      (progn
        ;; 英文/代码字体
        (set-face-attribute 'default nil
                            :font "Consolas"
                            :height 105)

        ;; 中文、日文
        (dolist (charset '(kana han cjk-misc bopomofo))
          (set-fontset-font t charset
                            (font-spec :family "Microsoft YaHei")))

        ;; 符号
        (set-fontset-font t 'symbol
                          (font-spec :family "Segoe UI Symbol")))
    (set-face-attribute 'default nil
                        :font "Source Code Pro"
                        :height 110)))


(provide 'init-ui)
