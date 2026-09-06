;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

(add-to-list 'load-path
             (expand-file-name "lisp" user-emacs-directory))

;; Customize writes into a separate file.
(setq custom-file
      (locate-user-emacs-file "custom.el"))

(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

(require 'init-const)
(require 'init-os)

;; package / use-package must be initialized before modules using use-package
(require 'init-elpa)

(require 'init-kbd)
(require 'init-startup)
(require 'init-ui)
(require 'bookkeeping)
(require 'init-package)

;; Machine-specific settings.
(let ((local-file (locate-user-emacs-file "local.el")))
  (when (file-exists-p local-file)
    (load local-file nil 'nomessage)))

;;; init.el ends here
