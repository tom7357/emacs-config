;;; init-kbd.el --- Keybindings -*- lexical-binding: t; -*-
(use-package emacs :config (defalias 'yes-or-no-p 'y-or-n-p))

(global-set-key (kbd "M-]") #'flymake-goto-next-error)
(global-set-key (kbd "M-[") #'flymake-goto-prev-error)

(provide 'init-kbd)
