;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

(setq gc-cons-threshold most-positive-fixnum)

(push '(scroll-bar-mode . nil) default-frame-alist)
(push '(tool-bar-mode . nil) default-frame-alist)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;;; early-init.el ends here
