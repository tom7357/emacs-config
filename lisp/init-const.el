;;; init-const.el --- Constants and OS detection -*- lexical-binding: t; -*-

(defconst *is-mac*
  (eq system-type 'darwin))

(defconst *is-linux*
  (eq system-type 'gnu/linux))

(defconst *is-windows*
  (memq system-type '(ms-dos windows-nt cygwin)))

(provide 'init-const)

;;; init-const.el ends here
