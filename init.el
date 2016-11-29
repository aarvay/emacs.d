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

(use-package flx-ido
  :ensure t
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (flx-ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

(use-package hl-line
  :init (global-hl-line-mode 1)
  :config
  (set-face-background hl-line-face "color-238"))

(use-package highlight-numbers
  :ensure t
  :defer t
  :init (add-hook 'prog-mode-hook 'highlight-numbers-mode))

(use-package drag-stuff
  :ensure t
  :bind (("ESC <up>" . drag-stuff-up)
	 ("ESC <down>" . drag-stuff-down)))

(use-package powerline
  :ensure t
  :init (powerline-default-theme))

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
    (setq alchemist-goto-elixir-source-dir "~/.asdf/installs/elixir/1.3.4/")
    (setq alchemist-goto-erlang-source-dir "~/.asdf/installs/erlang/ref-OTP-19.1.2/")))

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
  (setq emmet-preview-default nil))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  :diminish (projectile-mode))

(use-package rust-mode
  :ensure t
  :mode (("\\.rs\\'" . rust-mode)))

(use-package toml-mode
  :ensure t
  :mode (("\\.toml\\'" . toml-mode)))

;;; init.el ends here
