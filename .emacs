(setq debug-on-error nil)

;;;; emacs setting by customize-variable
;; customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(artist-aspect-ratio 2)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/emacs.bmk")
 '(bookmark-default-file "~/.emacs.d/emacs.bmk")
 '(buffers-layout-window-sizes nil)
 '(column-number-mode t)
 '(display-time-mode nil)
 '(ecb-options-version "2.40")
 '(ecb-tip-of-the-day nil)
 '(fill-column 80)
 '(flymake-gui-warnings-enabled nil)
 '(history-length 300)
 '(linum-format " %d ")
 '(menu-bar-mode nil)
 '(outline-minor-mode-prefix "o")
 '(py-indent-tabs-mode nil)
 '(py-smart-indentation nil)
 '(py-tab-indent t)
 '(save-place t nil (saveplace))
 '(scroll-bar-mode nil)
 '(semantic-c-dependency-system-include-path (quote ("D:/Program Files/Microsoft Visual Studio 10.0/VC/include" "D:/Program Files/Microsoft SDKs/Windows/v7.1A/Include" "C:/cygwin/lib/gcc/i686-pc-cygwin/4.5.3/include")))
 '(semantic-default-submodes (quote (global-semantic-highlight-func-mode global-semantic-decoration-mode global-semantic-stickyfunc-mode global-semantic-idle-completions-mode global-semantic-idle-scheduler-mode global-semanticdb-minor-mode global-semantic-idle-summary-mode global-semantic-mru-bookmark-mode global-semantic-idle-local-symbol-highlight-mode)))
 '(semantic-new-buffer-setup-functions (quote ((c-mode . semantic-default-c-setup) (c++-mode . semantic-default-c-setup) (html-mode . semantic-default-html-setup) (java-mode . wisent-java-default-setup) (js-mode . wisent-javascript-setup-parser) (scheme-mode . semantic-default-scheme-setup) (srecode-template-mode . srecode-template-setup-parser) (texinfo-mode . semantic-default-texi-setup) (makefile-automake-mode . semantic-default-make-setup) (makefile-gmake-mode . semantic-default-make-setup) (makefile-makepp-mode . semantic-default-make-setup) (makefile-bsdmake-mode . semantic-default-make-setup) (makefile-imake-mode . semantic-default-make-setup) (makefile-mode . semantic-default-make-setup))))
 '(server-mode t)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80)))
 '(tab-width 4)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bold-italic ((t (:slant italic :weight bold))))
 '(hl-line ((t (:background "SystemHotTrackingColor"))))
 '(italic ((t (:slant italic))))
 '(py-number-face ((t (:inherit font-lock-constant-face))))
 '(py-variable-name-face ((t (:inherit font-lock-variable-name-face)))))

;;允许使用C-z作为命令前缀
(define-prefix-command 'ctl-z-map)
(global-set-key (kbd "C-z") 'ctl-z-map)

;; add .emacs.d to load-path
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/cedet-contrib")
(add-to-list 'load-path "~/.emacs.d/csharp-mode")
(add-to-list 'load-path "~/.emacs.d/icicles-ext")
(add-to-list 'load-path "~/.emacs.d/tramp/lisp/")
(add-to-list 'Info-default-directory-list "~/.emacs.d/tramp/info/")

(load "init-build-in" 'noerror)
(load "init-site" 'noerror)
(if (eq system-type 'windows-nt)
	(load "init-win32" 'noerror))
(if (eq system-type 'gnu/linux)
	(load "init-linux" 'noerror))
(if (eq system-type 'darwin)
	(load "init-osx" 'noerror))
