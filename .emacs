;; (setq debug-on-error t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode nil)
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40")
 '(fill-column 80)
 '(menu-bar-mode nil)
 '(py-shell-name "python")
 '(save-place t nil (saveplace))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80)))
 '(tool-bar-mode nil))
 '(column-number-mode t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(py-number-face ((t (:inherit font-lock-constant-face))))
 '(py-variable-name-face ((t (:inherit font-lock-variable-name-face))))
 '(semantic-unmatched-syntax-face ((t nil))))

(if (eq system-type 'windows-nt)
    (menu-bar-mode t))

;;;; server mode
(server-mode t)

;;;; cedet
;; (add-to-list 'load-path "~/.emacs.d/cedet/contrib/")
(load-file "~/.emacs.d/cedet/common/cedet.elc")
(load-file "~/.emacs.d/cedet/contrib/semantic-tag-folding.el")
(global-ede-mode t)
;; Activate semantic
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)

(setq semanticdb-project-roots (list (expand-file-name "/")))
(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))

(if (eq system-type 'windows-nt)
    (defconst cedet-win32-include-dirs
      (list "C:/cygwin/lib/gcc/i686-pc-cygwin/4.5.3/include"
	    "C:/Program Files/Microsoft Visual Studio 9.0/VC/include"
	    "C:/Program Files/Microsoft SDKs/Windows/v7.0/Include")))

;; (require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs cedet-win32-include-dirs)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))

;; if you want to enable support for gnu global
(when (cedet-gnu-global-version-check t)
  (require 'semanticdb-global)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))

;; enable ctags for some languages:
;; Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
(if (eq system-type 'windows-nt)
    (setq semantic-ectag-program "C:/cygwin/usr/local/bin/ctags.exe"))
(when (cedet-ectag-version-check)
  (semantic-load-enable-primary-exuberent-ctags-support))

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

(setq tags-table-list
      '("~/.emacs.d" "~/tmp" ))

;; (setq libutil-project
;;       (ede-cpp-root-project "libutil"
;;                             :file "~/projects/libutil/configure.in"
;;                             :system-include-path '("/home/meteor1113/projects/include"
;;                                                    "/home/meteor1113/projects/common"
;;                                                    "/home/meteor1113/projects/libutil/pub")))

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
  (local-set-key [S-F9] 'semantic-ia-fast-jump-back)
  (local-set-key [M-F12] 'eassist-switch-h-cpp)
  (local-set-key [M-S-F9] 'semantic-analyze-proto-impl-toggle)
  (local-set-key (kbd "M-n") 'semantic-ia-complete-symbol-menu)
  (local-set-key (kbd "C-c , -") 'semantic-tag-folding-fold-block)
  (local-set-key (kbd "C-c , =") 'semantic-tag-folding-show-block)
  (local-set-key (kbd "C-c , _") 'semantic-tag-folding-fold-all)
  (local-set-key (kbd "C-c , +") 'semantic-tag-folding-show-all)
  )

(add-hook 'c-mode-common-hook 'my-cedet-hook)
(add-hook 'c++-mode-common-hook 'my-cedet-hook)

(defun my-c-mode-cedet-hook ()
  (if (not (eq system-type 'cygwin))
      (progn (local-set-key "." 'semantic-complete-self-insert)
	     (local-set-key ">" 'semantic-complete-self-insert))))

(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)

;; change dir to home
(cd "~/")

;; add .emacs.d to load-path
(add-to-list 'load-path "~/.emacs.d/")

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
;; Emacs才是世界上最强大的IDE － 智能的改变光标形状
;; http://emacser.com/cursor-change.htm
(require 'cursor-change)
(cursor-change-mode 1)

;; Function keys
; 折叠代码快捷键
(global-set-key [f1] 'hs-toggle-hiding)
(global-set-key [f2] 'info)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [f4] 'toggle-menu-bar-mode-from-frame)
(global-set-key [f6] 'ecb-toggle-ecb-windows)
(global-set-key [f7] `fill-region)
(global-set-key [f8] 'auto-fill-mode)
(global-set-key [f9] 'semantic-ia-fast-jump)
(global-set-key [f10] 'loop-alpha)
(global-set-key [f11] 'toggle-full-screen)
(global-set-key [f12] 'my-theme-cycle)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(defalias 'qrr 'query-replace-regexp)

;; move line up or down
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; copy line from above
(autoload 'copy-from-above-command "misc"
  "Copy characters from previous nonblank line, starting just above point.
   \(fn &optional arg)"
  'interactive)

(global-set-key (kbd "C-M-<up>") 'copy-from-above-command)
(global-set-key (kbd "C-M-<down>") (lambda ()
				     (interactive)
				     (forward-line 1)
				     (open-line 1)
				     (copy-from-above-command)))

;; pan movement
(global-set-key '[S-up]     'my-pan-down-1)
(global-set-key '[S-down]   'my-pan-up-1)
(global-set-key '[S-left]   'my-pan-right-2)
(global-set-key '[S-right]  'my-pan-left-2)

(defun my-pan-up-1 ()
  (interactive)
  ;; (next-line 1)
  (scroll-up 1))

(defun my-pan-down-1 ()
  (interactive)
  ;; (previous-line 1)
  (scroll-down 1))

(defun my-pan-left-2 ()
  (interactive)
  (forward-char 2)
  (scroll-left 2))

(defun my-pan-right-2 ()
  (interactive)
  (backward-char 2)
  (scroll-right 2))

;; swap-buffer
(global-set-key "\M-t"  'my-swap-buffer)
(defun my-swap-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 'VISIBLE-OK)))

;; Calendar
(require 'calendar)
(defun insdate-insert-current-date (&optional omit-day-of-week-p)
  "Insert today's date using the current locale.
  With a prefix argument, the date is inserted without the day of
  the week."
  (interactive "P*")
  (insert (calendar-date-string (calendar-current-date) nil
				omit-day-of-week-p)))

(global-set-key "\C-x\M-d" `insdate-insert-current-date)

;; auto fill mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;; package management
(when (> emacs-major-version 23)
  (require 'package)
  (package-initialize)
  ;; add the user-contributed repository
  (add-to-list 'package-archives
	       '("elpa" . "http://tromey.com/elpa/"))
  (add-to-list 'package-archives
	       '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.milkbox.net/packages/")
	       'APPEND))

;; auto-complete
(require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict/")
(ac-config-default)
(setq ac-auto-show-menu 0.5)
(define-key ac-completing-map "\M-/" 'ac-stop)

;; Icicles
;; (add-to-list 'load-path "~/.emacs.d/icicles")
(require 'icicles)
(icy-mode t)

;; autopair
(require 'autopair)
(autopair-global-mode)

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
;; (add-to-list 'load-path "~/.emacs.d/python-mode/")
(setq py-install-directory "~/.emacs.d/python-mode/")
(setq py-load-pymacs-p t)
(setq py-smart-operator-mode-p nil)
(setq py-prepare-autopair-mode-p t)
(setq py-set-complete-keymap-p t)
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(require 'python-mode)

(add-to-list 'load-path "~/.emacs.d/python-mode/completion/")
;; (setq ac-sources '(ac-source-pycomplete))
;; or before the other sources using
(require 'auto-complete-pycomplete)
;; (add-to-list 'ac-sources 'ac-source-pycomplete)
(defun py-load-pycomplete ()
  "Load Pymacs based pycomplete."
  (interactive)
  (let* ((path (getenv "PYTHONPATH"))
         (py-install-directory (cond ((string= "" py-install-directory)
                                      (py-guess-py-install-directory))
                                     (t (py-normalize-directory py-install-directory))))
         (pycomplete-directory (concat (expand-file-name py-install-directory) "completion")))
    (if (py-install-directory-check)
        (progn
          ;; If the Pymacs process is already running, augment its path.
          (when (and (get-process "pymacs") (fboundp 'pymacs-exec))
            (pymacs-exec (concat "sys.path.insert(0, '" pycomplete-directory "')")))
          (require 'pymacs)
          (setenv "PYTHONPATH" (concat
                                pycomplete-directory
                                (if path (concat path-separator path))))
          (add-to-list 'load-path pycomplete-directory)
          (require 'pycomplete)
          (add-hook 'python-mode-hook 'py-complete-initialize))
      (error "`py-install-directory' not set, see INSTALL"))))

(py-load-pycomplete)

;; C++ and C mode...
(add-to-list 'auto-mode-alist '("\\.idc\\'" . c-mode))

(defun my-c++-mode-hook ()
  (setq tab-width 4)
  (define-key c++-mode-map "\C-m" 'reindent-then-newline-and-indent)
  (define-key c++-mode-map "\C-ce" 'c-comment-edit)
  (setq c++-auto-hungry-initial-state 'none)
  (setq c++-delete-function 'backward-delete-char)
  (setq c++-tab-always-indent t)
					;  (setq c-indent-level 4)
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
					;  (setq c-indent-level 4)
  (setq c-basic-offset 4)
  (setq c-continued-statement-offset 4)
  (setq c-brace-offset -4)
  (setq c-argdecl-indent 0)
  (setq c-label-offset -4))

;; Add all of the hooks...
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c-mode-hook 'my-c-mode-hook)

;;;; ECB
(require 'ecb-autoloads)
(require 'ecb)
(setq stack-trace-on-error t)

;;;; lua-mode
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;;;; 代码折叠
(dolist (hook '(c-mode-hook
		c++-mode-hook
		lua-mode-hook
		python-mode-hook))
  (add-hook hook (lambda () (hs-minor-mode t))))

;;;; from http://emacser.com/torture-emacs.htm by qiang
;; set font
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
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        zh-font))))

(if (not (eq system-type 'cygwin))
    (qiang-set-font
     '("Consolas" "Monaco" "DejaVu Sans Mono" "Monospace" "Courier New") ":pixelsize=14"
     '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "宋体" "新宋体")))

;;;; 启动时自动最大化
(defun w32-restore-frame ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))

(defun w32-maximize-frame ()
  "Maximize the current frame"
  (interactive)
  (w32-send-sys-command 61488))

(defun linux-fullscreen ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_FULLSCREEN" 0))
  )

(defun linux-maximize-frame ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  )

(defun my-maximize-frame ()
     (if (eq system-type 'windows-nt)
	 (w32-maximize-frame))
     (if (eq system-type 'gnu/linux)
	 (linux-maximize-frame))
     )

(my-maximize-frame)

;; Full Screen
(defun toggle-full-screen ()
  "Toggles full-screen mode for Emacs window on Win32."
  (interactive)
  (if (eq system-type 'windows-nt)
      (shell-command "emacs_fullscreen.exe --topmost"))
  (if (eq system-type 'gnu/linux)
      (linux-fullscreen)))

;;;; Smart copy, if no region active, it simply copy the current whole line
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

;;;; comment-dwim
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

;;;; Auto format code yanked
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
;;;;

;;;; highlight-symbol
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-remove-all)
(global-set-key [(control meta f3)] 'highlight-symbol-query-replace)

;;;; nasl-mode
(require 'nasl-mode)

;;;; org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;;; iimage mode
(autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
(autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)
;; -- Display images in org mode
;; enable image mode first
(iimage-mode)
;; add the org file link format to the iimage mode regex
(add-to-list 'iimage-mode-image-regex-alist
	     (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex "\\)\\]")  1))

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

;;;; org-remember
(org-remember-insinuate)
(setq org-directory "e:/Gerald/orgfiles")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map "\C-cr" 'org-remember)
(setq org-remember-templates
      '(("Todo" ?t "* TODO %? %^g\n %i\n " (concat org-directory "/newgtd.org") "Office")
	("Book" ?b "\n* %^{Book Title} %t :READING: \n%[l:/booktemp.txt]\n" (concat org-directory "book.org"))
	("Private" ?p "\n* %^{topic} %T \n%i%?\n" (concat org-directory "/privnotes.org"))
	))

;;;; turn on orgstruct
;; (add-hook 'text-mode-hook 'turn-on-orgstruct)
;; (add-hook 'text-mode-hook 'turn-on-orgtbl)

;;;; color-theme
;; (add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
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

;;;; yasnippet
;; (add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
;; (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets/")
(yas-global-mode 1)

;;;; cygwin-mount
(if (eq system-type 'windows-nt)
    (progn
      ;; (setq py-shell-name "ipython")
      ;; exec-path
      (if (file-directory-p "c:/cygwin/bin")
      	  (add-to-list 'exec-path "c:/cygwin/bin"))
      (setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH")))

      (require 'cygwin-mount)
      (cygwin-mount-activate)

      (add-hook 'comint-output-filter-functions
      		'Shell-strip-ctrl-m nil t)
      (add-hook 'comint-output-filter-functions
      		'comint-watch-for-password-prompt nil t)
      (setq explicit-shell-file-name "bash.exe")
      ;; For subprocesses invoked via the shell
      ;; (e.g., "shell -c command")
      (setq shell-file-name explicit-shell-file-name)
      (put 'upcase-region 'disabled nil)
))

;;;; transparent, set alpha
(set-frame-parameter (selected-frame) 'alpha '(100 100))
;; you can define your alpha-list to set the transform
(setq alpha-list '((75 65) (100 100)))

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

;;;; evernote-mode
;; (add-to-list 'load-path "~/.emacs.d/evernote-mode-0_41/")
(require 'evernote-mode)
(setq evernote-username "dsjlzh") ; optional: you can use this username as default.
(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; option
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)

;;;; abbrev-mode
(setq save-abbrevs t)
(setq abbrev-file-name "~/.emacs.d/abbrev_defs")
(if (file-exists-p abbrev-file-name)
    (quietly-read-abbrev-file))
(setq save-abbrevs t)
(setq default-abbrev-mode t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
