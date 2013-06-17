;;;; emacs setting for linux platform

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

(run-with-idle-timer 0.5 nil 'linux-maximize-frame)

;; Full Screen
(global-set-key [f11] 'linux-fullscreen)

(provide 'init-linux)
