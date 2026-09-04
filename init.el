(add-to-list 'load-path
             (expand-file-name "lisp" user-emacs-directory))

(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(require 'init-const)
(require 'init-kbd)
(require 'init-startup)
(require 'init-ui)
(require 'bookkeeping)
(require 'init-elpa)
(require 'init-package)

;; Machine-specific settings.
(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file nil 'nomessage)))

;;; init.el ends here
