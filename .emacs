(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(calendar-week-start-day 1)
 '(column-number-mode t)
 '(exec-path-from-shell-check-startup-files nil)
 '(indent-tabs-mode nil)
 '(ispell-dictionary "en_GB-ise-w_accents")
 '(ispell-program-name "aspell")
 '(ns-right-alternate-modifier (quote none))
 '(org-special-ctrl-a/e t)
 '(package-selected-packages
   (quote
    (org-ref helm-bibtex helm gnuplot-mode less-css-mode jade-mode lua-mode exec-path-from-shell markdown-mode json-mode cdlatex auctex flycheck magit use-package)))
 '(show-trailing-whitespace t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-latex-sedate-face ((t (:foreground "brightmagenta")))))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Use mouse in terminal
(require 'mwheel)
(require 'mouse)
(xterm-mouse-mode t)
(mouse-wheel-mode t)
(global-set-key [mouse-4] 'next-line)
(global-set-key [mouse-5] 'previous-line)

;; Using MELPA
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; Use helm
(require 'helm-config)

;; helm-bibtex
(setq bibtex-completion-library-path '("~/dphil/sync/papers"))
(setq bibtex-completion-notes-path "~/dphil/notes/papers.org")
(setq bibtex-completion-bibliography "~/dphil/notes/references.bib")

;; org-ref
(require 'org-ref)
(setq reftex-default-bibliography '("~/dphil/notes/references.bib"))
(setq org-ref-bibliography-notes "~/dphil/notes/papers.org"
      org-ref-default-bibliography '("~/dphil/notes/references.bib")
      org-ref-pdf-directory "~/dphil/sync/papers")

;; open pdf with system pdf viewer (works on mac)
(setq bibtex-completion-pdf-open-function
  (lambda (fpath)
    (start-process "open" "*open*" "open" fpath)))

;; Use packages
(setq use-package-always-ensure t)
(use-package magit)
(use-package flycheck
  :config (global-flycheck-mode))
(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))
