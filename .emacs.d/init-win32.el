;;;; emacs setting for win32 platform

;; 启动时自动最大化
(defun w32-restore-frame ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))

(defun w32-maximize-frame ()
  "Maximize the current frame"
  (interactive)
  (w32-send-sys-command 61488))

(run-with-idle-timer 0.5 nil 'w32-maximize-frame)

;; Full Screen
(defun toggle-full-screen ()
  "Toggles full-screen mode for Emacs window on Win32."
  (interactive)
  (shell-command "emacs_fullscreen.exe --topmost"))

(global-set-key [f11] 'toggle-full-screen)

;; cygwin-mount
;; exec-path
(if (file-directory-p "c:/cygwin/bin")
	(add-to-list 'exec-path "c:/cygwin/bin"))
(setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH")))

(require 'cygwin-mount)
(setq cygwin-mount-build-mount-table-asynch t)
(cygwin-mount-activate)

(add-hook 'comint-output-filter-functions
		  'Shell-strip-ctrl-m nil t)
(add-hook 'comint-output-filter-functions
		  'comint-watch-for-password-prompt nil t)
;;       (setq explicit-shell-file-name "bash.exe")
;;       ;; For subprocesses invoked via the shell
;;       ;; (e.g., "shell -c command")
;;       (setq shell-file-name explicit-shell-file-name)
(put 'upcase-region 'disabled nil)

;; open a bash shell buffer
(defun cygwin-shell ()
  "Run cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin/bin/bash")
		(shell-file-name explicit-shell-file-name)
		(explicit-bash-args '("-login" "-i")))
    (call-interactively 'shell))
  (rename-buffer "cygwin-shell"))

;; bash shell script using utf-8 codec
;; (add-hook 'sh-mode-hook '(lambda ()
;; 						   (set-buffer-file-coding-system 'utf-8-unix)))

;; must use ipython-script.py to start ipython on emacs for windows
(setq py-python-command-args '("-i" "D:/Python27/Scripts/ipython-script.py"))

;; batch-mode
(require 'batch-mode)

;; include path
(defconst cedet-win32-include-dirs
  (list "C:/cygwin/lib/gcc/i686-pc-cygwin/4.5.3/include"
	    "D:/Program Files/Microsoft Visual Studio 10.0/VC/include"
	    "C:/Program Files/Microsoft SDKs/Windows/v7.1A/Include"))

(mapc (lambda (dir)
		(semantic-add-system-include dir 'c++-mode)
		(semantic-add-system-include dir 'c-mode))
	  cedet-win32-include-dirs)

;; checking C/C++ mode for VC
(defun flymake-vc-init ()
  (flymake-simple-make-init-impl 'flymake-create-temp-inplace t t
								 (file-name-nondirectory buffer-file-name)
								 'flymake-get-vc-cmdline))

(defun flymake-get-vc-cmdline (source base-dir)
  (list "vcl" (list "/W3" (concat base-dir source))))
;;;; need create vcl.bat in system path
;; @echo off
;; @call "D:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86
;; cl /c /EHsc /nologo /Od /Oy- /RTC1 %1 %2 %3 %4 %5 %6 %7 %8 %9

(add-to-list 'flymake-allowed-file-name-masks
			 '("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-vc-init))

(provide 'init-win32)
