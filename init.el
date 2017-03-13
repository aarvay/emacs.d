;;; init.el --- Emacs configuration of aarvay

;; Don't load outdated byte code
(setq load-prefer-newer t)

;; Increase GC threshold.
(setq gc-cons-threshold 20000000)

;; Setup package.el with use-package
(require 'package)
(setq package-archives
      '(("melpa-stable" . "https://stable.melpa.org/packages/")
        ("elpa" . "http://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 10)
        ("elpa" . 5)
        ("melpa" . 0)))
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Keep emacs custom settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Place all auto-saves and backups in tmp
(setq temporary-file-directory (expand-file-name "~/.emacs.d/tmp"))
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Allow being lazy when replying yes or now
(defalias 'yes-or-no-p 'y-or-n-p)

;; Auto refresh buffers, dired, and be quiet about it
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

;; Startup stuff
(setq inhibit-startup-message t
      initial-scratch-message nil
      initial-major-mode 'org-mode)
(fset 'display-startup-echo-area-message 'ignore)

;; Get rid of the scroll bar, tool bar, and menu bar.
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Editor behaviour stuff
(set-default 'truncate-lines t)
(delete-selection-mode 1)
(transient-mark-mode 1)
(setq-default indent-tabs-mode nil
              tab-width 2
              column-number-mode t
              ring-bell-function #'ignore
              cursor-type 'bar)

;; utf-8 all the things
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Bind meta to cmd
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil))

(require 'diminish)
(require 'bind-key)

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light t)
  (setq solarized-distinct-fringe-background t)
  (setq solarized-use-less-bold t))

(use-package ido
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package ido-ubiquitous
  :ensure t
  :pin melpa
  :config
  (ido-ubiquitous-mode 1))

(use-package flx-ido
  :ensure t
  :config
  (flx-ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

(use-package ido-vertical-mode
  :ensure t
  :config
  (ido-vertical-mode 1)
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))

(use-package smex
  :ensure t
  :bind ("M-x" . smex))

(use-package hl-line
  :init (global-hl-line-mode 1))

(use-package highlight-numbers
  :ensure t
  :defer t
  :init (add-hook 'prog-mode-hook 'highlight-numbers-mode))

(use-package drag-stuff
  :ensure t
  :bind (("M-<up>" . drag-stuff-up)
	 ("M-<down>" . drag-stuff-down)))

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

(use-package smartparens
  :ensure t
  :init
  (smartparens-global-mode)
  (show-smartparens-global-mode)
  :bind ("C-c f" . sp-up-sexp)
  :config
  (require 'smartparens-config)
  :diminish (smartparens-mode))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package elixir-mode
  :ensure t
  :pin melpa)

(use-package alchemist
  :ensure t
  :pin melpa
  :config
  (progn
    (setq alchemist-goto-elixir-source-dir "~/.asdf/installs/elixir/1.4.2")
    (setq alchemist-goto-erlang-source-dir "~/.asdf/installs/erlang/19.2")))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.eex\\'" . web-mode))
  :config
  (progn
    (setq web-mode-markup-indent-offset 2
	  web-mode-css-indent-offset 2
	  web-mode-code-indent-offset 2)))

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'web-mode-hook 'emmet-mode)
  (add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2)))
  (setq emmet-preview-default nil))

(use-package js
  :init
  (setq js-indent-level 2 ))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  :diminish (projectile-mode))

(use-package rust-mode
  :ensure t
  :mode (("\\.rs\\'" . rust-mode))
  :config
  (setq rust-format-on-save t))

(use-package toml-mode
  :ensure t
  :mode (("\\.toml\\'" . toml-mode)))

(use-package expand-region
  :ensure t
  :bind ("C-c w" . er/expand-region))

(use-package multiple-cursors
  :ensure t
  :bind (("C-c e" . mc/edit-lines)
	 ("C-c m" . mc/mark-next-like-this)
	 ("C-c C-m" . mc/mark-all-like-this)))

;;; init.el ends here
