;;; init-startup.el --- Startup settings -*- lexical-binding: t; -*-

;; 基础设置
(setq inhibit-startup-screen t
      make-backup-files nil
      auto-save-default nil
      ring-bell-function 'ignore)

;; 编码
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; 界面
(menu-bar-mode 1)
(column-number-mode 1)

;; 日常编辑
(global-auto-revert-mode 1)
(auto-save-visited-mode 1)
(delete-selection-mode 1)
(fido-vertical-mode 1)
(recentf-mode 1)
(repeat-mode 1)

(when (display-graphic-p)
  (global-hl-line-mode 1))

;; 编程模式
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'electric-pair-mode)
(add-hook 'prog-mode-hook #'flymake-mode)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(add-hook 'prog-mode-hook #'prettify-symbols-mode)

;; 自定义文件
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

(provide 'init-startup)

;;; init-startup.el ends here
