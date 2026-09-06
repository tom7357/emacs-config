;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

(add-to-list 'load-path
             (expand-file-name "lisp" user-emacs-directory))

(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

(require 'init-const)

;; package / use-package must be initialized before modules using use-package
(require 'init-elpa)

(require 'init-kbd)
(require 'init-startup)
(require 'init-ui)
(require 'bookkeeping)
(require 'init-package)

;; Machine-specific settings.
(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file nil 'nomessage)))

;;; init.el ends here
