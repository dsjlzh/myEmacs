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

;; batch-mode
(require 'batch-mode)

(provide 'init-win32)
