;; Disable the startup screen
(setq inhibit-startup-message t)

;; Disable the toolbar, menu bar and scroll bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Highlght the current line
(global-hl-line-mode t)

;; Line number mode
(global-linum-mode t)

;; Set the command key to use mac meta
(setq mac-command-modifier 'meta)

;; Use y/y instead of Yes/No
(fset 'yes-or-no-p 'y-or-n-p)

;; Automatically update buffers if file content on the disk has changed.
(global-auto-revert-mode t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable the the blinking cursor
(blink-cursor-mode -1)

;; store recent opened files and display a list in the initial buffer
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq initial-buffer-choice 'recentf-open-files)

;; start emacs maximized
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

(defun indent-whole-buffer ()
  "indent and format the whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(global-set-key (kbd "C-c n") 'indent-whole-buffer)

;; Require and initialize `package`.
(require 'package)
(package-initialize)

;; Add melpa to the list of of package providers
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

;; Install use-package if it is not already installed
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

;; Store emacs generated code in a seperate customs file
(setq custom-file "~/.emacs.d/custom-file.el")
(when (file-exists-p custom-file)
  (load-file custom-file))


;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; unbind the right option modifier so that I can use #
(setq-default mac-right-option-modifier nil)

;; package configurations ;;

(use-package nimbus-theme
  :ensure t
  :config
  (load-theme 'nimbus))

(use-package helm
  :ensure t
  :diminish helm-mode
  :bind (("M-x" . 'helm-M-x)
	 ("C-x r b" . 'helm-filtered-bookmarks)
	 ("C-x C-f" . 'helm-find-files)
	 ("C-x C-b" . 'helm-mini))
  :config
  (helm-mode 1)
  :custom
  (helm-split-window-in-side-p t)
  (helm-split-window-default-side 'below))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :custom (magit-section-visibility-indicator nil))

(use-package company
  :ensure t
  :diminish company-mode
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.3))

(use-package paredit
  :ensure t
  :hook (prog-mode . paredit-mode)
  :bind ("M-[" . paredit-wrap-sexp))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

(use-package cider
  :ensure t
  :config
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
  :custom (nrepl-log-messages t))

(use-package clj-refactor
  :ensure t
  :config
  (add-hook 'clojure-mode-hook (lambda () (clj-refactor-mode 1)))
  (cljr-add-keybindings-with-prefix "\C-cr")
  :custom
  (cljr-warn-on-eval nil)
  (cljr-auto-sort-ns t)
  (cljr-favor-private-functions nil))

(use-package aggressive-indent
  :ensure t
  :diminish aggressive-indent-mode
  :config (global-aggressive-indent-mode 1))

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package all-the-icons
  :ensure t)

(use-package powerline
  :ensure t
  :config (powerline-default-theme))

(use-package diminish
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package terraform-mode
  :ensure t)

(use-package jsonnet-mode
  :ensure t)

(use-package feature-mode
  :ensure t)

(use-package ess
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))

(use-package helm-projectile
  :ensure t
  :bind ("M-t" . helm-projectile-find-file)
  :config
  (helm-projectile-on))

(use-package window-numbering
  :ensure t
  :config
  (window-numbering-mode))


;; Org setup
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(add-hook 'org-mode-hook 'org-indent-mode)
(eval-after-load 'org-indent '(diminish 'org-indent-mode))
