;; nasl-mode.el
;;
;; A major mode for writing Nasl code.
;; Copyright (C) 2003,2005,2006 Andrew Ross
;;
;; Based very closely on awk-mode.el as shipped with GNU Emacs 21.2
;; Copyright (C) 1988,94,96,2000  Free Software Foundation, Inc.
;;
;; It should be sufficient to drop this into your Emacs site-lisp
;; directory (/usr/share/emacs/site-lisp on most linux distributions)
;; and add a line:
;;
;; (require 'nasl-mode)
;;
;; ...to your .emacs file.  All files with a .nas extension should
;; then be associated with nasl mode automatically.  I am *not* an
;; elisp hacker, though, so YMMV.

(defvar nasl-mode-syntax-table nil
  "Syntax table in use in Nasl-mode buffers.")

(if nasl-mode-syntax-table ()
  (setq nasl-mode-syntax-table (make-syntax-table))
  ; Operator characters are "punctuation"
  (modify-syntax-entry ?!  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?*  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?+  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?-  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?/  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?~  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?:  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?.  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?,  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?\; "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?=  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?<  "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?>  "."  nasl-mode-syntax-table)
  ; Underscores are allowed as "symbol constituent"
  (modify-syntax-entry ?_  "_"  nasl-mode-syntax-table)
  ; Backslash escapes; pound sign starts comments
  (modify-syntax-entry ?\\ "\\" nasl-mode-syntax-table)
  (modify-syntax-entry ?\# "<"  nasl-mode-syntax-table)
  (modify-syntax-entry ?\n ">#"  nasl-mode-syntax-table)
  ; Square brackets act as parenthesis
  (modify-syntax-entry ?\[ "(]"  nasl-mode-syntax-table)
  (modify-syntax-entry ?]  ")"  nasl-mode-syntax-table)
  ; nessus nasl
  (modify-syntax-entry ?| "."  nasl-mode-syntax-table)
  (modify-syntax-entry ?$ "w"  nasl-mode-syntax-table)
  (modify-syntax-entry ?^ "w"  nasl-mode-syntax-table)
)

(defconst nasl-font-lock-keywords
  (eval-when-compile
    (list
     (cons (regexp-opt '("parents" "me" "arg") 'words)
	   'font-lock-variable-name-face)
     (regexp-opt '("and" "break" "continue" "else" "elsif" "for" "foreach"
		   "forindex" "func" "if" "nil" "or""return" "var" "while")
		 'words)
     (list (regexp-opt '("append" "bind" "call" "caller" "chr" "closure"
			 "cmp" "compile" "contains" "delete" "die" "find"
			 "int" "keys" "num" "pop" "rand" "setsize" "size"
			 "split" "sprintf" "streq" "substr" "subvec" "typeof"
			 "include")
		       'words)
	      1 'font-lock-builtin-face)))
  "Nasl-specific syntax to be hilighted.")

(define-derived-mode nasl-mode perl-mode "Nasl"
  "Major mode for editing Nasl code.
This is a Perl mode variant customized for Nasl's syntax.  It shares most of
perl-mode's features.  Turning on Nasl mode runs `nasl-mode-hook'."
  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-start-skip) "#+ *")
  (set (make-local-variable 'c-assignment-op-regexp) "nevermatch")
  (setq font-lock-defaults '(nasl-font-lock-keywords nil nil ((?_ . "w")))))

(provide 'nasl-mode)

;; Set us up to load by default for .nas files
(setq auto-mode-alist (append '(("\\.nasl$" . nasl-mode))
			            auto-mode-alist))
