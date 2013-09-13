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
  (define-key c-mode-base-map (kbd "M-o") 'eassist-switch-h-cpp))
  ;; (define-key c-mode-base-map (kbd "M-m") 'eassist-list-methods))

(add-hook 'c-mode-common-hook 'my-eassist-hook)
(add-hook 'c++-mode-common-hook 'my-eassist-hook)

;; lua-mode
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;; nasl-mode
(require 'nasl-mode)

;; yara-mode
(require 'yara-mode)

;; jdee
(add-to-list 'load-path (expand-file-name "~/.emacs.d/jdee/lisp"))
(autoload 'jde-mode "jde" "JDE mode" t)
(setq auto-mode-alist
	  (append '(("\\.java\\'" . jde-mode)) auto-mode-alist))

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
(defun bind-my-icicles-keys ()
  "Replace some default Icicles minibuffer bindings with others."
  (dolist (map (append (list minibuffer-local-completion-map
  							 minibuffer-local-must-match-map)
  					   (and (fboundp 'minibuffer-local-filename-completion-map)
  							(list minibuffer-local-filename-completion-map))))
  	(when icicle-mode
  	  (define-key map (icicle-kbd "f11") 'previous-history-element)
  	  (define-key map (icicle-kbd "f12") 'next-history-element))))

(add-hook 'icicle-mode-hook 'bind-my-icicles-keys)
(icy-mode t)

;; autopair
(require 'autopair)
(autopair-global-mode t)

;; flymake
(autoload 'flymake-find-file-hook "flymake" "" t)
(setq flymake-gui-warnings-enabled nil)
(setq flymake-log-level 0)

(defun flymake-display-current-error ()
  "Display errors/warnings under cursor."
  (interactive)
  (let ((ovs (overlays-in (point) (1+ (point)))))
    (catch 'found
      (dolist (ov ovs)
        (when (flymake-overlay-p ov)
          (message (overlay-get ov 'help-echo))
          (throw 'found t))))))

(defun flymake-goto-next-error-disp ()
  "Go to next error in err ring, then display error/warning."
  (interactive)
  (flymake-goto-next-error)
  (flymake-display-current-error))

(defun flymake-goto-prev-error-disp ()
  "Go to previous error in err ring, then display error/warning."
  (interactive)
  (flymake-goto-prev-error)
  (flymake-display-current-error))

(defvar flymake-mode-map (make-sparse-keymap))
(define-key flymake-mode-map (kbd "<f6>") 'flymake-goto-next-error-disp)
(define-key flymake-mode-map (kbd "<S-f6>") 'flymake-goto-prev-error-disp)
(define-key flymake-mode-map (kbd "<C-f6>") 'flymake-display-err-menu-for-current-line)

(or (assoc 'flymake-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
          (cons (cons 'flymake-mode flymake-mode-map)
                minor-mode-map-alist)))

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
(setq ropemacs-enable-autoimport t)
(setq ropemacs-autoimport-modules t)
(setq ropemacs-use-pop-to-buffer t)
(setq ropemacs-enable-shortcuts nil)
(setq ropemacs-global-prefix "C-c C-p")
(pymacs-load "ropemacs" "rope-")

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

;; (defun my-python-mode-hook ()
;;   (define-key python-mode-map (kbd "M-m") 'eassist-list-methods))

;; (add-hook 'python-mode-hook 'my-python-mode-hook)

;;;; org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(add-hook 'org-mode-hook 'turn-on-auto-fill)

(defun my-org-mode-hook()
  (local-set-key "\C-cl" 'org-store-link)
  (local-set-key "\C-cc" 'org-capture)
  (local-set-key "\C-ca" 'org-agenda)
  (local-set-key "\C-cb" 'org-iswitchb)
  ;; org-edit-special default key is conflict with icicle-occur
  (local-set-key "\C-z'" 'org-edit-special))

(add-hook 'org-mode-hook 'my-org-mode-hook)

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
(global-set-key [M-f12] 'my-theme-cycle)

(defun toggle-night-color-theme ()
  "Switch to/from night color scheme."
  (interactive)
  (require 'color-theme)
  (if (eq (frame-parameter (next-frame) 'background-mode) 'dark)
	  (color-theme-snapshot) ; restore default (light) colors
	;; create the snapshot if necessary
	(when (not (commandp 'color-theme-snapshot))
	  (fset 'color-theme-snapshot (color-theme-make-snapshot)))
	(color-theme-dark-laptop)))

(global-set-key [C-f12] 'toggle-night-color-theme)

;;;; yasnippet
(require 'yasnippet)
;; (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets/")
(yas-global-mode 1)

;; ecb activate
(ecb-activate)
(ecb-toggle-ecb-windows)
(global-set-key [f9] 'ecb-toggle-ecb-windows)

;; save-visited-files
(setq save-visited-files-location "~/.emacs.d/emacs-visited-files")
(turn-on-save-visited-files-mode)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; iy-go-to-char
(require 'iy-go-to-char)
(add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos)
(global-set-key (kbd "C-c f") 'iy-go-to-char)
(global-set-key (kbd "C-c F") 'iy-go-to-char-backward)
(global-set-key (kbd "C-c ;") 'iy-go-to-char-continue)
(global-set-key (kbd "C-c ,") 'iy-go-to-char-continue-backward)

(require 'move-text)
(move-text-default-bindings)

;; key-combo
;; (require 'key-combo)
;; (key-combo-mode t)
;; (key-combo-load-default)

;; key-chord
;; (require 'key-chord)
;; (key-chord-mode t)
;; (key-chord-define-global ",."     "<>\C-b")
;; (key-chord-define-global "hj"     'undo)
;; (key-chord-define-global [?h ?j]  'undo)  ; the same
;; (key-chord-define-global "jk"     'dabbrev-expand)
;; (key-chord-define-global "cv"     'reindent-then-newline-and-indent)
;; (key-chord-define-global "4r"     "$")

;; dired-single
;; (defun my-dired-init ()
;;   "Bunch of stuff to run for dired, either immediately or when it's
;;    loaded."
;;   ;; <add other stuff here>
;;   (define-key dired-mode-map [return] 'dired-single-buffer)
;;   (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
;;   (define-key dired-mode-map "^"
;; 	(function
;; 	 (lambda nil (interactive) (dired-single-buffer "..")))))

;; ;; if dired's already loaded, then the keymap will be bound
;; (if (boundp 'dired-mode-map)
;; 	;; we're good to go; just add our bindings
;; 	(my-dired-init)
;;   ;; it's not loaded yet, so add our bindings to the load-hook
;;   (add-hook 'dired-load-hook 'my-dired-init))

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
