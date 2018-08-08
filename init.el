(package-initialize)

(require 'org)
(require 'ob-tangle)

;; Store the auto generated config in a separate file
(setq custom-file (expand-file-name "auto-generated.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Load the loader.org file which contains the emacs config
(setq init-dir (file-name-directory (or load-file-name (buffer-file-name))))
(org-babel-load-file (expand-file-name "loader.org" init-dir))

