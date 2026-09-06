;;; init-os.el --- OS-specific settings -*- lexical-binding: t; -*-

;; Windows
(when (and *is-windows*
           (boundp 'w32-get-true-file-attributes))
  (setq w32-get-true-file-attributes nil
        w32-pipe-read-delay 0
        w32-pipe-buffer-size (* 64 1024)))

;; macOS
(when *is-mac*
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        ns-use-native-fullscreen t))

;; Linux / macOS selection encoding
(unless *is-windows*
  (set-selection-coding-system 'utf-8))

(provide 'init-os)

;;; init-os.el ends here
