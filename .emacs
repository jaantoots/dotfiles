(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; Use mouse in terminal
(require 'mwheel)
(require 'mouse)
(xterm-mouse-mode t)
(mouse-wheel-mode t)
(global-set-key [mouse-4] 'next-line)
(global-set-key [mouse-5] 'previous-line)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(calendar-week-start-day 1)
 '(column-number-mode t)
 '(global-magit-file-mode t)
 '(indent-tabs-mode nil)
 '(org-special-ctrl-a/e t)
 '(package-selected-packages
   (quote
    (flycheck auctex cdlatex magit markdown-mode org-ref)))
 '(show-trailing-whitespace t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-latex-sedate-face ((t (:foreground "brightmagenta"))))
 '(magit-diff-added ((t (:background "brightgreen" :foreground "#22aa22"))))
 '(magit-diff-added-highlight ((t (:background "brightgreen" :foreground "#22aa22"))))
 '(magit-diff-context ((t (:foreground "brightgreen"))))
 '(magit-diff-removed ((t (:background "brightgreen" :foreground "#aa2222"))))
 '(magit-diff-removed-highlight ((t (:background "brightgreen" :foreground "#aa2222"))))
 '(magit-dimmed ((t (:foreground "brightgreen"))))
 '(magit-hash ((t (:foreground "brightyellow"))))
 '(magit-log-date ((t (:foreground "brightgreen"))))
 '(magit-log-graph ((t (:foreground "brightgreen"))))
 '(magit-refname ((t (:foreground "brightgreen")))))

;; Use helm
(require 'helm-config)

;; helm-bibtex
(setq bibtex-completion-library-path "~/dphil/sync/papers")
(setq bibtex-completion-notes-path "~/dphil/notes/papers.org")
(setq bibtex-completion-bibliography "~/dphil/notes/references.bib")

;; org-ref
(require 'org-ref)
(setq reftex-default-bibliography '("~/dphil/notes/references.bib"))
(setq org-ref-bibliography-notes "~/dphil/notes/papers.org"
      org-ref-default-bibliography '("~/dphil/notes/references.bib")
      org-ref-pdf-directory "~/dphil/sync/papers/")

;; open pdf with system pdf viewer (works on mac)
(setq bibtex-completion-pdf-open-function
      (lambda (fpath)
	(start-process "open" "*open*" "open" fpath)))
