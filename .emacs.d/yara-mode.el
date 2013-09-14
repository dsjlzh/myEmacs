;; yara-mode.el
;;
;; A major mode for writing Yara code.
;; Copyright (C) 2003,2005,2006 Andrew Ross
;;
;; Based very closely on awk-mode.el as shipped with GNU Emacs 21.2
;; Copyright (C) 1988,94,96,2000  Free Software Foundation, Inc.
;;
;; It should be sufficient to drop this into your Emacs site-lisp
;; directory (/usr/share/emacs/site-lisp on most linux distributions)
;; and add a line:
;;
;; (require 'yara-mode)
;;
;; ...to your .emacs file.  All files with a .nas extension should
;; then be associated with yara mode automatically.  I am *not* an
;; elisp hacker, though, so YMMV.

(defvar yara-mode-syntax-table nil
  "Syntax table in use in Yara-mode buffers.")

(if yara-mode-syntax-table ()
  (setq yara-mode-syntax-table (make-syntax-table (standard-syntax-table)))
  ; Operator characters are "punctuation"
  (modify-syntax-entry ?$ "'"  yara-mode-syntax-table)
  (modify-syntax-entry ?!  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?*  ". 23b"  yara-mode-syntax-table)
  (modify-syntax-entry ?+  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?-  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?/  ". 124"  yara-mode-syntax-table)
  (modify-syntax-entry ?~  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?:  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?.  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?,  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?\; "."  yara-mode-syntax-table)
  (modify-syntax-entry ?=  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?<  "."  yara-mode-syntax-table)
  (modify-syntax-entry ?>  "."  yara-mode-syntax-table)
  ; Underscores are allowed as "symbol constituent"
  (modify-syntax-entry ?_  "."  yara-mode-syntax-table)
  ; Backslash escapes; pound sign starts comments
  (modify-syntax-entry ?\\ "\\" yara-mode-syntax-table)
  (modify-syntax-entry ?\n ">"  yara-mode-syntax-table)

  ; Square brackets act as parenthesis
  (modify-syntax-entry ?{ "(}" yara-mode-syntax-table)
  (modify-syntax-entry ?} "){" yara-mode-syntax-table)
  ; yara
  (modify-syntax-entry ?| "."  yara-mode-syntax-table)
)

(defconst yara-font-lock-keywords
  (eval-when-compile
    (list
     (cons (regexp-opt '("parents" "me" "arg" "rule") 'words)
	   'font-lock-variable-name-face)
     (regexp-opt '("and" "break" "continue" "else" "elsif" "for" "foreach"
		   "forindex" "func" "if" "nil" "or""return" "var" "while" "of" "at"
		   "condition" "strings" "meta")
		 'words)
     (list (regexp-opt '("append" "bind" "call" "caller" "chr" "closure"
			 "cmp" "compile" "contains" "delete" "die" "find"
			 "int" "keys" "num" "pop" "rand" "setsize" "size"
			 "split" "sprintf" "streq" "substr" "subvec" "typeof"
			 "include" "any" "them")
		       'words)
	      1 'font-lock-builtin-face)))
  "Yara-specific syntax to be hilighted.")

(define-derived-mode yara-mode c-mode "Yara"
  "Major mode for editing Yara code.
This is a Perl mode variant customized for Yara's syntax.  It shares most of
perl-mode's features.  Turning on Yara mode runs `yara-mode-hook'."
  ;; (set (make-local-variable 'comment-start) "/*")
  ;; (set (make-local-variable 'comment-end) "*/")
  ;; (set (make-local-variable 'comment-start-skip) "\\(//+\\|/\\*+\\)\\s *")
  ;; (set (make-local-variable 'c-assignment-op-regexp) "nevermatch")
  (setq font-lock-defaults '(yara-font-lock-keywords nil nil ((?_ . "w")))))

(provide 'yara-mode)

;; Set us up to load by default for .nas files
(setq auto-mode-alist (append '(("\\.yar$" . yara-mode))
			            auto-mode-alist))
