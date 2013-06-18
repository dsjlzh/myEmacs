;; exec-path
(add-to-list 'exec-path "/Users/gerald/Library/Python/2.7/bin")
(add-to-list 'exec-path "/user/local/bin")
(setenv "PATH" (concat "/use/local/bin:/Users/gerald/Library/Python/2.7/bin:" (getenv "PATH")))

(defun mac-maximize-frame ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
   nil 'fullscreen 'maximized))

(defun mac-toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(run-with-idle-timer 0.5 nil 'mac-maximize-frame)

;; Full Screen
(global-set-key [f11] 'mac-toggle-fullscreen)

(defconst cedet-osx-include-dirs
  (list "/usr/include"
		"/usr/local/include"
		"/opt/local/include"
		"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/include"
		"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/usr/include "
		"/usr/lib/clang/4.2/include"
		"/usr/llvm-gcc-4.2/include"))

(mapc (lambda (dir)
		(semantic-add-system-include dir 'c++-mode)
		(semantic-add-system-include dir 'c-mode))
	  cedet-osx-include-dirs)

;; objc-mode
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

(provide 'init-osx)
