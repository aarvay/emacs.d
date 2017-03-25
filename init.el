;;; init.el --- aarvay/emacs.d

;;; Commentary:
;; aarvay's custon Emacs configuration

;;; Code:

;; Don't load outdated byte code
(setq load-prefer-newer t)

;; Increase GC threshold.
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

;; use-package.el is no longer needed at runtime
(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

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
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

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

;; Set the path variable
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package solarized-theme
  :ensure t
  :init
  (setq solarized-distinct-fringe-background t)
  (setq solarized-high-contrast-mode-line t)
  (setq solarized-use-less-bold t)
  (setq x-underline-at-descent-line t)
  (load-theme 'solarized-light t))

(use-package ivy
  :ensure t
  :demand
  :bind ("C-c C-r" . ivy-resume)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t . ivy--regex-fuzzy)))
  (use-package swiper
    :ensure t
    :bind ("C-s" . swiper))
  (use-package counsel
    :ensure t
    :bind (("M-x" . counsel-M-x)
           ("C-x C-f" . counsel-find-file)
           ("C-h f" . counsel-describe-function)
           ("C-h v" . counsel-describe-variable)))
  :diminish ivy-mode)

(use-package smex
  :ensure t)

(use-package flx
  :ensure t)

(use-package avy
  :ensure t
  :bind(("C-'" . avy-goto-char-timer)
        ("M-g g" . avy-goto-line)))

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
  :bind ("C-c f" . sp-up-sexp)
  :config
  (use-package smartparens-config
    :config
    (show-smartparens-global-mode t))
  :diminish smartparens-mode)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package elixir-mode
  :ensure t
  :pin melpa
  :config
  (use-package alchemist
    :ensure t
    :config
    (progn
      (setq alchemist-goto-erlang-source-dir "~/.asdf/installs/erlang/19.2")
      (setq alchemist-goto-elixir-source-dir "~/.asdf/installs/elixir/1.4.2"))
    :diminish alchemist-mode))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.eex\\'" . web-mode)
         ("\\.css\\'"    . web-mode)
         ("\\.scss\\'"   . web-mode))
  :config
  (setq web-mode-enable-auto-pairing t
        web-mode-enable-auto-closing t
        web-mode-enable-auto-indentation t
        web-mode-enable-css-colorization t)
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

(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode)
  :config
  (setq js2-basic-offset 2)
  (add-hook 'js2-mode-hook (lambda() (setq-local mode-name "JavaScript"))))

(use-package rjsx-mode
  :ensure t
  :mode (("\\.jsx\\'" . rjsx-mode)
         ("components\\/.*\\.js\\'" . rjsx-mode))
  :config
  (add-hook 'rjsx-mode-hook (lambda() (setq-local mode-name "JSX"))))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (add-to-list 'projectile-globally-ignored-directories "_build")
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

(use-package flycheck
  :ensure t
  :pin melpa
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :diminish (flycheck-mode))

;;; init.el ends here
