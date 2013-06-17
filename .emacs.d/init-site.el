;;;; emacs setting for third-part packages

;; 智能的改变光标形状
;; http://emacser.com/cursor-change.htm
(require 'cursor-change)
(cursor-change-mode 1)

(require 'eassist)
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))

(defun my-eassist-hook ()
  (define-key c-mode-base-map (kbd "M-o") 'eassist-switch-h-cpp)
  (define-key c-mode-base-map (kbd "M-m") 'eassist-list-methods))

(add-hook 'c-mode-common-hook 'my-eassist-hook)
(add-hook 'c++-mode-common-hook 'my-eassist-hook)

;; lua-mode
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;; nasl-mode
(require 'nasl-mode)

;; bat-mode
;; (setq auto-mode-alist
;;       (append
;;        (list (cons "\\.[bB][aA][tT]$" 'bat-mode))
;;        ;; For DOS init files
;;        (list (cons "CONFIG\\."   'bat-mode))
;;        (list (cons "AUTOEXEC\\." 'bat-mode))
;;        auto-mode-alist))

;; (autoload 'bat-mode "bat-mode"
;;   "DOS and WIndows BAT files" t)

;; jdee
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/jdee-2.4.0.1/lisp"))
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/elib-1.0"))
;; (require 'jde)

;; Crosshair
(global-hl-line-mode t)

;; info+
(eval-after-load "info" '(require 'info+))

;; highlight-symbol
(require 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-remove-all)
(global-set-key [(control meta f3)] 'highlight-symbol-query-replace)

;; buffer move
(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; auto-complete
;; (require 'pos-tip)
(require 'auto-complete)
(require 'auto-complete-settings)

;; Icicles
(require 'icicles)
(icy-mode t)

;; autopair
(require 'autopair)
(autopair-global-mode t)

;; flymake
(global-set-key "\C-z\C-e" 'flymake-display-err-menu-for-current-line)
(global-set-key "\C-z\C-n" 'flymake-goto-next-error)
(global-set-key "\C-z\C-p" 'flymake-goto-prev-error)

;; graphviz-dot-mode
(add-hook 'graphviz-dot-mode-hook
		  #'(lambda () (setq autopair-dont-activate t)))
(setq graphviz-dot-auto-indent-on-semi nil)

;; pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;; ropemacs
(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
(setq ropemacs-autoimport-modules t)
(setq ropemacs-use-pop-to-buffer t)
;;(setq ropemacs-enable-shortcuts nil)
;;(setq ropemacs-local-prefix "C-c C-p")

;; python-mode
(add-to-list 'load-path "~/.emacs.d/python-mode")
(setq py-install-directory "~/.emacs.d/python-mode/")
;; (setq python-shell-interpreter "D:/Python27/python.exe")
(setq py-load-pymacs-p t)
(setq py-smart-operator-mode-p nil)
(setq py-prepare-autopair-mode-p t)
(setq py-set-complete-keymap-p t)
(setq ansi-color-for-comint-mode t)
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(require 'python-mode)
(require 'flymake-python-pyflakes)

(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(defun my-python-mode-hook ()
  (define-key python-mode-map (kbd "M-m") 'eassist-list-methods))
(add-hook 'python-mode-hook 'my-python-mode-hook)

;;;; org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;;; org-remember
;; (org-remember-insinuate)
(setq org-directory "~/Dropbox/Org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-remember-templates
      '(("Todo" ?t "* TODO %? %^g\n %i\n " (concat org-directory "/newgtd.org") "Office")
		("Book" ?b "\n* %^{Book Title} %t :READING: \n%[l:/booktemp.txt]\n" (concat org-directory "book.org"))
		("Private" ?p "\n* %^{topic} %T \n%i%?\n" (concat org-directory "/privnotes.org"))))
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map "\C-cr" 'org-remember)

;;;; color-theme
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-blackboard)))

(defun my-theme-set-default () ; Set the first row
  (interactive)
  (setq theme-current my-color-themes)
  (funcall (car theme-current)))

(defun my-describe-theme () ; Show the current theme
  (interactive)
  (message "%s" (car theme-current)))

;; Set the next theme (fixed by Chris Webber - tanks)
(defun my-theme-cycle ()
  (interactive)
  (setq theme-current (cdr theme-current))
  (if (null theme-current)
      (setq theme-current my-color-themes))
  (funcall (car theme-current))
  (message "%S" (car theme-current)))

(setq my-color-themes (list 'color-theme-blackboard 'color-theme-calm-forest
							'color-theme-clarity 'color-theme-dark-green
							'color-theme-dark-laptop 'color-theme-deep-blue
							'color-theme-lethe 'color-theme-hober
							'color-theme-euphoria))

(setq theme-current my-color-themes)
(setq color-theme-is-global nil) ; Initialization
(global-set-key [f12] 'my-theme-cycle)


;;;; yasnippet
(require 'yasnippet)
;; (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets/")
(yas-global-mode 1)

;; ecb activate
(ecb-activate)
(ecb-toggle-ecb-windows)
(global-set-key [f9] 'ecb-toggle-ecb-windows)

;; save-visited-files
;; (defun save-visited-files-mode-fix-ecb ()
;;   (if (and save-visited-files-mode ecb-minor-mode)
;; 	  (ecb-rebuild-methods-buffer)))

;; (add-hook 'auto-save-hook 'save-visited-files-mode-fix-ecb)
(turn-on-save-visited-files-mode)

;; doc-mode
;; (add-hook 'c-mode-common-hook 'doc-mode)

;;;; evernote-mode
;; (require 'evernote-mode)
;; (setq evernote-username "dsjlzh") ; optional: you can use this username as default.
;; (setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; option
;; (global-set-key "\C-cec" 'evernote-create-note)
;; (global-set-key "\C-ceo" 'evernote-open-note)
;; (global-set-key "\C-ces" 'evernote-search-notes)
;; (global-set-key "\C-ceS" 'evernote-do-saved-search)
;; (global-set-key "\C-cew" 'evernote-write-note)
;; (global-set-key "\C-cep" 'evernote-post-region)
;; (global-set-key "\C-ceb" 'evernote-browser)

(provide 'init-site)
