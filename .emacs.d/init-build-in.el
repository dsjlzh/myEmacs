;;;; emacs setting only depending on build-in packages

;; (require 'trace)

;; global keymaps
(global-set-key [f2] 'info)
(global-set-key [f5] 'compile)
(global-set-key [f10] 'toggle-menu-bar-mode-from-frame)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-w" 'backward-kill-word)
(defalias 'qrr 'query-replace-regexp)

;; newline-withoug-break-of-line
(defun newline-without-break-of-line ()
  "1. remove to end of the line.
  2. insert newline with index"
  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))

(global-set-key (kbd "<C-return>") 'newline-without-break-of-line)

;;用C-z i快速打开~/.emacs文件。
(defun open-init-file ()
  (interactive)
  (find-file "~/.emacs"))

(global-set-key "\C-zi" 'open-init-file)

;;用C-z k快速打开自定义的按键说明文件
(defun open-key-info-file ()
  (interactive)
  (split-window-horizontally)
  (find-file-other-window "~/.emacs.d/emacskeys.txt")
  (outline-mode)
  (hide-body))

(global-set-key "\C-zk" 'open-key-info-file)

;; change dir to home
(setq default-directory "~/")

(setq initial-scratch-buffer nil)
;; (setq initial-buffer-choice default-directory)
(setq next-line-add-newlines t)
;;使用y or n提问
(fset 'yes-or-no-p 'y-or-n-p)
;;关闭开启画面
(setq inhibit-startup-message t)
;; 自动的在文件末增加一新行
(setq require-final-newline t)
;; 当光标在行尾上下移动的时候，始终保持在行尾。
(setq track-eol t)
;; 显示行号
(global-linum-mode 1)

;; set margins
;; (add-hook 'window-configuration-change-hook
;;           (lambda ()
;;             (set-window-margins (car (get-buffer-window-list (current-buffer) nil t)) 2 2)))

;;默认进入text-mode，而不是没有什么功能的fundamental-mode
(setq default-major-mode 'text-mode)
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
;; turn on orgstruct
;; (add-hook 'text-mode-hook 'turn-on-orgstruct)
;; (add-hook 'text-mode-hook 'turn-on-orgtbl)

;;设定语言环境为utf-8
(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))
(prefer-coding-system 'utf-8)

;;打开一个新的shell
(defun newshell (name)
  (interactive "sBuffer name: ")
  (shell name))

;; move line up or down ;; replace by move-text package
;; (defun move-line-up ()
;;   (interactive)
;;   (transpose-lines 1)
;;   (forward-line -2))

;; (defun move-line-down ()
;;   (interactive)
;;   (forward-line 1)
;;   (transpose-lines 1)
;;   (forward-line -1))

;; (global-set-key (kbd "M-<up>") 'move-line-up)
;; (global-set-key (kbd "M-<down>") 'move-line-down)

;; copy line from above
(autoload 'copy-from-above-command "misc"
  "Copy characters from previous nonblank line, starting just above point.
   \(fn &optional arg)"
  'interactive)

(defun copy-line-up()
  (interactive)
  (scroll-up 1)
  (copy-line-down)
  (forward-line -1))

(defun copy-line-down()
  (interactive)
  (forward-line 1)
  (open-line 1)
  (copy-from-above-command))

(global-set-key (kbd "C-M-<up>") 'copy-line-up)
(global-set-key (kbd "C-M-<down>") 'copy-line-down)

;; pan movement
(defun my-pan-up ()
  (interactive)
  (scroll-up 1))

(defun my-pan-down ()
  (interactive)
  (scroll-down 1))

(defun my-pan-left ()
  (interactive)
  (scroll-left 2))

(defun my-pan-right ()
  (interactive)
  (scroll-right 2))

(global-set-key '[S-up]     'my-pan-up)
(global-set-key '[S-down]   'my-pan-down)
(global-set-key '[S-left]   'my-pan-left)
(global-set-key '[S-right]  'my-pan-right)

;; swap-buffer
(defun my-swap-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 'VISIBLE-OK)))

(global-set-key "\M-t"  'my-swap-buffer)

;; swap-window
(setq swap-windows-p t)
(defun my-swap-window ()
  "Switch to the previous window"
  (interactive)
  (if swap-windows-p
      (progn
		(message "previous window")
		(setq swap-windows-p nil)
		(select-window (previous-window)))
    (progn
      (message "next windows")
      (setq swap-windows-p t)
      (select-window (next-window)))))

(global-set-key (kbd "<C-tab>") 'my-swap-window)

;; set font
;; http://emacser.com/torture-emacs.htm by qiang
(defun qiang-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))

(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))

(defun qiang-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-font-size)
  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl)                         ; for find if
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts)
                            :size chinese-font-size)))

    ;; Set the default English font
    ;;
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    (message "Set English Font to %s" en-font)
    (set-face-attribute
     'default nil :font en-font)

    ;; Set Chinese font
    ;; Do not use 'unicode charset, it will cause the english font setting invalid
    (message "Set Chinese Font to %S" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        zh-font))))

(if (not (eq system-type 'cygwin))
    (qiang-set-font
     '("Consolas" "Monaco" "DejaVu Sans Mono" "Monospace" "Courier New") ":pixelsize=15"
     '("Hiragino Sans GB" "MicroSoft YaHei" "文泉驿等宽微米黑" "黑体" "宋体" "新宋体") 16))

;; Smart copy, if no region active, it simply copy the current whole line
(defadvice kill-line (before check-position activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode js-mode
                                latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1)))))

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive (if mark-active (list (region-beginning) (region-end))
                 (message "Copied line")
                 (list (line-beginning-position)
                       (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; Copy line from point to the end, exclude the line break
(defun qiang-copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (point)
                  (line-end-position))
  ;; (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(global-set-key (kbd "M-k") 'qiang-copy-line)

;; comment-dwim
(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(global-set-key "\M-;" 'qiang-comment-dwim-line)

;; Auto format code yanked
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-lisp-mode
                     lisp-mode
                     clojure-mode
                     scheme-mode
                     haskell-mode
                     ruby-mode
                     rspec-mode
                     python-mode
                     c-mode
                     c++-mode
                     objc-mode
                     latex-mode
                     js-mode
                     plain-tex-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))

;; transparent, set alpha
(set-frame-parameter (selected-frame) 'alpha '(nil nil))
(set-frame-parameter (selected-frame) 'frame-alpha-lower-limit 50)
(set-frame-parameter (selected-frame) 'screen-gamma 2.7)

;; you can define your alpha-list to set the transform
(setq alpha-list '((100 100) (75 75)))

(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))                ;; head value will set to
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))
    )
  )

(global-set-key [f12] 'loop-alpha)

;; Calendar
(require 'calendar)
(defun insdate-insert-current-date (&optional omit-day-of-week-p)
  "Insert today's date using the current locale.
  With a prefix argument, the date is inserted without the day of
  the week."
  (interactive "P*")
  (insert (calendar-date-string (calendar-current-date) nil
								omit-day-of-week-p)))

(global-set-key "\C-zd" `insdate-insert-current-date)

;; auto-fill mode
(global-set-key "\C-zf" `fill-region)

(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(global-set-key "\C-zu" `unfill-paragraph)


;; file associate
(add-to-list 'auto-mode-alist '("\\.idc\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . shell-script-mode))

;; cc-mode hook
(defun my-c++-mode-hook ()
  (setq tab-width 4)
  (define-key c++-mode-map "\C-m" 'reindent-then-newline-and-indent)
  (define-key c++-mode-map "\C-ce" 'c-comment-edit)
  (setq c++-auto-hungry-initial-state 'none)
  (setq c++-delete-function 'backward-delete-char)
  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)
  (setq c-continued-statement-offset 4)
  (setq c++-empty-arglist-indent 4))

(defun my-c-mode-hook ()
  (setq tab-width 4)
  (define-key c-mode-map "\C-m" 'reindent-then-newline-and-indent)
  (define-key c-mode-map "\C-ce" 'c-comment-edit)
  (setq c-auto-hungry-initial-state 'none)
  (setq c-delete-function 'backward-delete-char)
  (setq c-tab-always-indent t)
  ;; BSD-ish indentation style
  (setq c-basic-offset 4)
  (setq c-continued-statement-offset 4)
  (setq c-brace-offset -4)
  (setq c-argdecl-indent 0)
  (setq c-label-offset -4))

;; Add all of the hooks...
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c-mode-hook 'my-c-mode-hook)

;; Activate semantic
(semantic-mode t)
(global-ede-mode t)

;; (require 'semantic/sb)
;; (require 'semantic/bovine/c)
;; (require 'semantic-tag-folding)

;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
;; (semantic-load-enable-semantic-debugging-helpers)

;; * This enables the use of Exuberant ctags if you have it installed.
;;   If you use C++ templates or boost, you should NOT enable it.
;; (semantic-load-enable-all-exuberent-ctags-support)
;;   Or, use one of these two types of support.
;;   Add support for new languages only via ctags.
;; (semantic-load-enable-primary-exuberent-ctags-support)
;;   Add support for using ctags as a backup parser.
;; (semantic-load-enable-secondary-exuberent-ctags-support)
;; Enable SRecode (Template management) minor-mode.
;; (global-srecode-minor-mode 1)

(setq semanticdb-project-roots (list (expand-file-name "/")))

(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))

(mapc (lambda (dir)
		(semantic-add-system-include dir 'c++-mode)
		(semantic-add-system-include dir 'c-mode))
	  cedet-user-include-dirs)

;; (let ((include-dirs cedet-user-include-dirs))
;;   (when (eq system-type 'windows-nt)
;;     (setq include-dirs (append include-dirs cedet-win32-include-dirs)))
;;   (mapc (lambda (dir)
;;           (semantic-add-system-include dir 'c++-mode)
;;           (semantic-add-system-include dir 'c-mode))
;;         include-dirs))

;; if you want to enable support for gnu global
;; (when (cedet-gnu-global-version-check t)
;;   (require 'semanticdb-global)
;;   (semanticdb-enable-gnu-global-databases 'c-mode)
;;   (semanticdb-enable-gnu-global-databases 'c++-mode))

;; enable ctags for some languages:
;; Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;; (if (eq system-type 'windows-nt)
;;     (setq semantic-ectag-program "C:/cygwin/usr/local/bin/ctags.exe"))
;; (when (cedet-ectag-version-check)
;;   (semantic-load-enable-primary-exuberent-ctags-support))

(defadvice push-mark (around semantic-mru-bookmark activate)
  "Push a mark at LOCATION with NOMSG and ACTIVATE passed to `push-mark'.
If `semantic-mru-bookmark-mode' is active, also push a tag onto
the mru bookmark stack."
  (semantic-mrub-push semantic-mru-bookmark-ring
                      (point)
                      'mark)
  ad-do-it)

(defun semantic-ia-fast-jump-back ()
  (interactive)
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
         (alist (semantic-mrub-ring-to-assoc-list ring))
         (first (cdr (car alist))))
    (if (semantic-equivalent-tag-p (oref first tag) (semantic-current-tag))
        (setq first (cdr (car (cdr alist)))))
    (semantic-mrub-switch-tags first)))

(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-cg" 'semantic-ia-fast-jump)
  (local-set-key "\C-cu" 'semantic-ia-fast-jump-back)
  ;; (local-set-key (kbd "C-c , -") 'semantic-tag-folding-fold-block)
  ;; (local-set-key (kbd "C-c , =") 'semantic-tag-folding-show-block)
  ;; (local-set-key (kbd "C-c , _") 'semantic-tag-folding-fold-all)
  ;; (local-set-key (kbd "C-c , +") 'semantic-tag-folding-show-all)
  )

(add-hook 'c-mode-common-hook 'my-cedet-hook)
(add-hook 'c++-mode-common-hook 'my-cedet-hook)

(setq tags-table-list
      '("~/.emacs.d" "~/tmp"))

;; code folding
(dolist (hook '(c-mode-hook
				c++-mode-hook
				lua-mode-hook
				python-mode-hook))
  (add-hook hook (lambda () (hs-minor-mode t))))

(global-set-key [f1] 'hs-toggle-hiding)

;; abbrev-mode
(setq save-abbrevs t)
(setq abbrev-file-name "~/.emacs.d/abbrev_defs")
(if (file-exists-p abbrev-file-name)
    (quietly-read-abbrev-file))
(setq default-abbrev-mode t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Windows move
(global-set-key (kbd "<M-S-up>")     'windmove-up)
(global-set-key (kbd "<M-S-down>")   'windmove-down)
(global-set-key (kbd "<M-S-left>")   'windmove-left)
(global-set-key (kbd "<M-S-right>")  'windmove-right)

;;;; iimage mode
;; (autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
;; (autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)
;; -- Display images in org mode
;; enable image mode first
;; (iimage-mode)
;; add the org file link format to the iimage mode regex
;; (add-to-list 'iimage-mode-image-regex-alist
;; (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex "\\)\\]")  1))

;;;; add a hook so we can display images on load
;; (add-hook 'org-mode-hook '(lambda () (org-turn-on-iimage-in-org)))

;; function to setup images for display on load
(defun org-turn-on-iimage-in-org ()
  "display images in your org file"
  (interactive)
  (turn-on-iimage-mode)
  (set-face-underline-p 'org-link nil))

;; function to toggle images in a org bugger
(defun org-toggle-iimage-in-org ()
  "display images in your org file"
  (interactive)
  (if (face-underline-p 'org-link)
      (set-face-underline-p 'org-link nil)
    (set-face-underline-p 'org-link t))
  (call-interactively 'iimage-mode))

;;启用ibuffer支持，增强*buffer*
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; artist-mode
(defun my-artist-mode-hook ()
  (progn (local-set-key "\C-c \C-SPC" 'artist-key-set-point)))

(add-hook 'artist-mode-hook 'my-artist-mode-hook)

;; enable features
(put 'narrow-to-region 'disabled nil)

;; (eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
(require 'tramp)
(setq password-cache nil)
(setq tramp-persistency-file-name "~/.emacs.d/my_tramp")
(setq tramp-default-method "plink")
(setq tramp-default-user "gerald"
	  tramp-default-host "my162")
(add-to-list 'tramp-default-user-alist
			 '(nil ".*mydev\\'" "lizhixin")
			 '(nil ".*my1.*\\'" "gerald"))

;; (add-to-list 'tramp-remote-path "/bin")

;; (setq libutil-project
;;       (ede-cpp-root-project "libutil"
;;                             :file "~/projects/libutil/configure.in"
;;                             :system-include-path '("/home/meteor1113/projects/include"
;;                                                    "/home/meteor1113/projects/common"
;;                                                    "/home/meteor1113/projects/libutil/pub")))

;;;; package management
(when (> emacs-major-version 23)
  (require 'package)
  (package-initialize)
  ;; add the user-contributed repository
  (add-to-list 'package-archives
			   '("tromey" . "http://tromey.com/elpa/"))
  (add-to-list 'package-archives
			   '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives
			   '("melpa" . "http://melpa.milkbox.net/packages/")
			   'APPEND))

(provide 'init-build-in)
