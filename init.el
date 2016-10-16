;;; init.el --- Emacs configuration of aarvay

;; Don't load outdated byte code
(setq load-prefer-newer t)

;; Increase GC threshold. I'm on a modern machine :)
(setq gc-cons-threshold 20000000)

;; Setup package.el with use-package
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("melpa-stable" . "https://stable.melpa.org/packages/")
	("elpa" . "http://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 10)
	("elpa" . 5)
	("melpa" . 0)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'diminish)
(require 'bind-key)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Place all auto-saves and backups in tmp
(setq temporary-file-directory (expand-file-name "~/.emacs.d/tmp"))
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Get rid of the scroll bar, tool bar, and menu bar.
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Startup stuff
(setq ring-bell-function #'ignore
      initial-scratch-message nil
      initial-major-mode 'org-mode
      column-number-mode t
      linum-format " %d ")
(global-linum-mode)

(fset 'display-startup-echo-area-message 'ignore)

(defalias 'yes-or-no-p 'y-or-n-p)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

;; Editor behaviour stuff
(set-default 'truncate-lines t)
(delete-selection-mode 1)
(transient-mark-mode 1)

;; utf-8 all the things
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(server-start) ;; Allow this Emacs process to be a server for client processes.

(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (ido-everywhere t)
  (ido-mode 1))

(use-package hl-line
  :init (global-hl-line-mode 1)
  :config
  (set-face-background hl-line-face "color-238"))

(use-package highlight-numbers
  :ensure t
  :defer t
  :init (add-hook 'prog-mode-hook 'highlight-numbers-mode))

(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (progn
    (delete 'company-dabbrev company-backends)
    (setq company-tooltip-align-annotations t
	  company-tooltip-minimum-width 27
	  company-idle-delay 0
	  company-tooltip-limit 10
	  company-minimum-prefix-length 2
	  company-tooltip-flip-when-above t))
  :diminish company-mode)

(use-package powerline
  :ensure t
  :init (powerline-default-theme))

;;; init.el ends here
