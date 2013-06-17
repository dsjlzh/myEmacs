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
 '(ecb-key-map (quote ("C-z" (t "fh" ecb-history-filter) (t "fs" ecb-sources-filter) (t "fm" ecb-methods-filter) (t "fr" ecb-methods-filter-regexp) (t "ft" ecb-methods-filter-tagclass) (t "fc" ecb-methods-filter-current-type) (t "fp" ecb-methods-filter-protection) (t "fn" ecb-methods-filter-nofilter) (t "fl" ecb-methods-filter-delete-last) (t "ff" ecb-methods-filter-function) (t "p" ecb-nav-goto-previous) (t "n" ecb-nav-goto-next) (t "lc" ecb-change-layout) (t "lr" ecb-redraw-layout) (t "lw" ecb-toggle-ecb-windows) (t "lt" ecb-toggle-layout) (t "s" ecb-window-sync) (t "r" ecb-rebuild-methods-buffer) (t "a" ecb-toggle-auto-expand-tag-tree) (t "x" ecb-expand-methods-nodes) (t "h" ecb-show-help) (t "gl" ecb-goto-window-edit-last) (t "g1" ecb-goto-window-edit1) (t "g2" ecb-goto-window-edit2) (t "gc" ecb-goto-window-compilation) (t "gd" ecb-goto-window-directories) (t "gs" ecb-goto-window-sources) (t "gm" ecb-goto-window-methods) (t "gh" ecb-goto-window-history) (t "ga" ecb-goto-window-analyse) (t "gb" ecb-goto-window-speedbar) (t "md" ecb-maximize-window-directories) (t "ms" ecb-maximize-window-sources) (t "mm" ecb-maximize-window-methods) (t "mh" ecb-maximize-window-history) (t "ma" ecb-maximize-window-analyse) (t "mb" ecb-maximize-window-speedbar) (t "e" eshell) (t "o" ecb-toggle-scroll-other-window-scrolls-compile) (t "\\" ecb-toggle-compile-window) (t "/" ecb-toggle-compile-window-height) (t "," ecb-cycle-maximized-ecb-buffers) (t "." ecb-cycle-through-compilation-buffers))))
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
(add-to-list 'load-path "~/.emacs.d/icicles-ext")

(load "init-build-in" 'noerror)
(load "init-site" 'noerror)
(if (eq system-type 'windows-nt)
	(load "init-win32" 'noerror))
(if (eq system-type 'gnu/linux)
	(load "init-linux" 'noerror))
