;;---------------------auto complete-------------------
;; http://blog.csdn.net/killiori/article/details/5721868
(require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "/home/hjz/.emacs.d//ac-dict")
(ac-config-default)

;; Show 0.5 second later
(setq ac-auto-show-menu 0.5)

;; 20 lines
(setq ac-menu-height 20)

(define-key ac-completing-map "\M-/" 'ac-stop)

;; Examples
(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline 'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")

;; After do this, isearch any string, M-: (match-data) always
;; return the list whose elements is integer
(global-auto-complete-mode 1)
(setq ac-dwim t)
;; (setq ac-candidate-max ac-candidate-menu-height)

;; 不让回车的时候执行`ac-complete', 因为当你输入完一个
;; 单词的时候, 很有可能补全菜单还在, 这时候你要回车的话,
;; 必须要干掉补全菜单, 很麻烦, 用M-j来执行`ac-complete'
;; (define-key ac-complete-mode-map "<return>"   'nil)
;; (define-key ac-complete-mode-map "RET"        'nil)
;; (define-key ac-complete-mode-map "M-j"        'ac-complete)
;; (define-key ac-complete-mode-map "<C-return>" 'ac-complete)

(define-key ac-complete-mode-map "/M-n"        'ac-next)
(define-key ac-complete-mode-map "/M-p"        'ac-previous)

(set-default 'ac-sources
			 '(ac-source-semantic
			   ac-source-yasnippet
			   ac-source-abbrev
			   ac-source-words-in-buffer
			   ;; ac-source-words-in-all-buffer
			   ac-source-imenu
			   ;; ac-source-files-in-current-dir
			   ;; ac-source-filename
			   ))

;; Complete member name by C-c . for C++ mode.
(add-hook 'c++-mode
		  (lambda ()
			(add-to-list 'ac-sources 'ac-source-semantic-raw)))

(defun semantic-and-gtags-complete ()
  (interactive)
  (auto-complete '(ac-source-semantic-raw ac-source-gtags)))

(add-hook 'c++-mode-hook
		  (lambda ()
			(local-set-key (kbd "C-z .") 'semantic-and-gtags-complete)))

;; Complete file name by C-c /
(global-set-key (kbd "C-z /") 'ac-complete-filename)

(defun ac-complete-semantic-self-insert (arg)
  (interactive "p")
  (self-insert-command arg)
  (ac-complete-semantic))

(defun my-c-mode-cedet-hook ()
  (local-set-key "." 'ac-complete-semantic-self-insert)
  (local-set-key ":" 'ac-complete-semantic-self-insert)
  (local-set-key ">" 'ac-complete-semantic-self-insert))
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)


(dolist (command `(backward-delete-char-untabify delete-backward-char))
  (add-to-list 'ac-trigger-commands command))
;; if you want enable auto-complete at org-mode, uncomment this line
(add-to-list 'ac-trigger-commands 'org-self-insert-command)

  ;; (defun ac-start-use-sources (sources)
  ;;   (interactive)
  ;;   (let ((ac-sources sources))
  ;;     (call-interactively 'ac-start)))

  ;; (defvar ac-trigger-edit-commands
  ;;   `(self-insert-command
  ;;     delete-backward-char
  ;;     backward-delete-char
  ;;     backward-delete-char-untabify)
  ;;   "*Trigger edit commands that specify whether `auto-complete' should start or not when `ac-completing'."))

;; (eval-after-load "cc-mode"
;;   '(progn
;;      (dolist (command '(c-electric-backspace
;;                         c-electric-backspace-kill))
;;        (add-to-list 'ac-trigger-commands command)
;;        (add-to-list 'ac-trigger-edit-commands command))))

;; (eval-after-load "autopair"
;;   '(progn
;;      (dolist (command '(autopair-insert-or-skip-quote
;;                         autopair-backspace
;;                         autopair-extra-skip-close-maybe))
;;        (add-to-list 'ac-trigger-commands command))

;;      (defun ac-trigger-command-p ()
;;        "Return non-nil if 'this-command' is a trigger command."
;;        (or
;;         (and
;;          (memq this-command ac-trigger-commands)
;;          (let* ((autopair-emulation-alist nil)
;;                 (key (this-single-command-keys))
;;                 (beyond-autopair (or (key-binding key)
;;                                      (key-binding (lookup-key local-function-key-map key)))))
;;            (memq beyond-autopair ac-trigger-edit-commands)))
;;         (and ac-completing
;;              (memq this-command ac-trigger-edit-commands))))))

;; (defun ac-settings-4-lisp ()
;;   "Auto complete settings for lisp mode."
;;   (setq ac-omni-completion-sources '(("//<featurep/s+'" ac+-source-elisp-features)
;;                                      ("//<require/s+'"  ac+-source-elisp-features)
;;                                      ("//<load/s+/'"    ac-source-emacs-lisp-features)))
;;   (ac+-apply-source-elisp-faces)
;;   (setq ac-sources
;;         '(ac-source-yasnippet
;;           ac-source-symbols
;;           ;; ac-source-semantic
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ;; ac-source-imenu
;;           ac-source-files-in-current-dir
;;           ac-source-filename)))

;; (defun ac-settings-4-java ()
;;   (setq ac-omni-completion-sources (list (cons "//." '(ac-source-semantic))
;;                                          (cons "->" '(ac-source-semantic))))
;;   (setq ac-sources
;;         '(;;ac-source-semantic
;;           ac-source-yasnippet
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-files-in-current-dir
;;           ac-source-filename)))

;; (defun ac-settings-4-c ()
;;   (setq ac-omni-completion-sources (list (cons "//." '(ac-source-semantic))
;;                                          (cons "->" '(ac-source-semantic))))
;;   (setq ac-sources
;;         '(ac-source-yasnippet
;;           ac-source-c-keywords
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-files-in-current-dir
;;           ac-source-filename)))

;; (defun ac-settings-4-cpp ()
;;   (setq ac-omni-completion-sources
;;         (list (cons "//." '(ac-source-semantic))
;;               (cons "->" '(ac-source-semantic))))
;;   (setq ac-sources
;;         '(ac-source-yasnippet
;;           ac-source-c++-keywords
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-files-in-current-dir
;;           ac-source-filename)))

;; (defun ac-settings-4-text ()
;;   (setq ac-sources
;;         '(;;ac-source-semantic
;;           ac-source-yasnippet
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-imenu)))

;; (defun ac-settings-4-eshell ()
;;   (setq ac-sources
;;         '(;;ac-source-semantic
;;           ac-source-yasnippet
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-files-in-current-dir
;;           ac-source-filename
;;           ac-source-symbols
;;           ac-source-imenu)))

;; (defun ac-settings-4-ruby ()
;;   (require 'rcodetools-settings)
;;   (setq ac-omni-completion-sources
;;         (list (cons "//." '(ac-source-rcodetools))
;;               (cons "::" '(ac-source-rcodetools)))))

;; (defun ac-settings-4-html ()
;;   (setq ac-sources
;;         '(;;ac-source-semantic
;;           ac-source-yasnippet
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-files-in-current-dir
;;           ac-source-filename)))

;; (defun ac-settings-4-tcl ()
;;   (setq ac-sources
;;         '(;;ac-source-semantic
;;           ac-source-yasnippet
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-files-in-current-dir
;;           ac-source-filename)))

;; (defun ac-settings-4-awk ()
;;   (setq ac-sources
;;         '(;;ac-source-semantic
;;           ac-source-yasnippet
;;           ac-source-abbrev
;;           ac-source-words-in-buffer
;;           ac-source-words-in-all-buffer
;;           ac-source-files-in-current-dir
;;           ac-source-filename)))


(provide 'auto-complete-settings)
