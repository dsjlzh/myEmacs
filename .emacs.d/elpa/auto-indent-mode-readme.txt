* About auto-indent-mode
Provides auto-indentation minor mode for Emacs.  This allows the
following:

  - Return automatically indents the code appropriately (if enabled)

  - Pasting/Yanking indents the appropriately

  - Killing line will take off unneeded spaces (if enabled)

  - On visit file, indent appropriately, but DONT SAVE. (Pretend like
    nothing happened, if enabled)

  - On save, optionally unttabify, remove trailing white-spaces, and
    definitely indent the file (if enabled).

  - TextMate behavior of keys if desired (see below)

  - Deleting the end of a line will shrink the whitespace to just one
    (if desired and enabled)

  - Automatically indent balanced parenthetical expression, or sexp, if desired
    `auto-indent-current-pairs' or `auto-indent-next-pair' is set
    to be true (disabled by default).  This is not immediate but occurs
    after a bit to allow better responsiveness in emacs.

  - Attempts to set the indentation level (number of spaces for an
    indent) for a major-mode.

All of these options can be customized. (customize auto-indent)
* Installing auto-indent-mode

To use put this in your load path and then put the following in your emacs
file:

  (setq auto-indent-on-visit-file t) ;; If you want auto-indent on for files
  (require 'auto-indent-mode)


If you (almost) always want this on, add the following to ~/.emacs:


   (auto-indent-global-mode)



Excluded modes are defined in `auto-indent-disabled-modes-list'

If you only want this on for a single mode, you would add the following to
~/.emacs


  (add-hook 'emacs-lisp-mode-hook 'auto-indent-minor-mode)



You could always turn on the minor mode with the command
`auto-indent-minor-mode'
* Auto-indent and repositories
auto-indent-mode will now be more conservative when it determines
that you are in a repository.  It will only indent the local area you
are editing.  This can be changed to be conservative everywhere by:

  (setq auto-indent-indent-style 'conservative)


You can revert to the old behavior of aggressive by:


  (setq auto-indent-indent-style 'aggressive)



* Setting the number of spaces for indenting major modes
While this is controlled by the major mode, as a convenience,
auto-indent-mode attempts to set the default number of spaces for an
indentation for specific major mode.

This is done by:
1. Making local variables of all the variables specified in
   `auto-indent-known-indent-level-variables' and setting them to
   auto-indent's `auto-indent-assign-indent-level'
2. Looking to see if major mode variables
   `major-mode-indent-level' and `major-mode-basic-offset' variables
   are present.  If either of these variables are present,
   `auto-indent-mode' sets these variables to the default
   `auto-indent-assign-indent-level'.

* TextMate Meta-Return behavior
If you would like TextMate behavior of Meta-RETURN going to the
end of the line and then inserting a newline, as well as
Meta-shift return going to the end of the line, inserting a
semi-colon then inserting a newline, use the following:


  (setq auto-indent-key-for-end-of-line-then-newline "<M-return>")
  (setq auto-indent-key-for-end-of-line-insert-char-then-newline "<M-S-return>")
  (require 'auto-indent-mode)
  (auto-indent-global-mode)


This may or may not work on your system.  Many times emacs cannot
distinguish between M-RET and M-S-RET, so if you don't mind a
slight redefinition use:


  (setq auto-indent-key-for-end-of-line-then-newline "<M-return>")
  (setq auto-indent-key-for-end-of-line-insert-char-then-newline "<C-M-return>")
  (require 'auto-indent-mode)
  (auto-indent-global-mode)


If you want to insert something other than a semi-colon (like a
colon) in a specific mode, say colon-mode, do the following:


  (add-hook 'colon-mode-hook (lambda () (setq auto-indent-eol-char ":")))

* Notes about autopair-mode and yasnippet compatibility
If you wish to use this with autopairs and yasnippet, please load
this library first.
* Using specific functions from auto-indent-mode

Also if you wish to just use specific functions from this library
that is possible as well.

To have the auto-indentation-paste use:


  (autoload 'auto-indent-yank "auto-indent-mode" "" t)
  (autoload 'auto-indent-yank-pop "auto-indent-mode" "" t)

  (define-key global-map [remap yank] 'auto-indent-yank)
  (define-key global-map [remap yank-pop] 'auto-indent-yank-pop)

  (autoload 'auto-indent-delete-char "auto-indent-mode" "" t)
  (define-key global-map [remap delete-char] 'auto-indent-delete-char)

  (autoload 'auto-indent-kill-line "auto-indent-mode" "" t)
  (define-key global-map [remap kill-line] 'auto-indent-kill-line)




However, this does not honor the excluded modes in
`auto-indent-disabled-modes-list'


* Making certain modes perform tasks on paste/yank.
Sometimes, like in R, it is convenient to paste c:\ and change it to
c:/.  This can be accomplished by modifying the
`auto-indent-after-yank-hook'.

The code for changing the paths is as follows:


  (defun kicker-ess-fix-path (beg end)
    "Fixes ess path"
    (save-restriction
      (save-excursion
        (narrow-to-region beg end)
        (goto-char (point-min))
        (when (looking-at "[A-Z]:\\\\")
          (while (search-forward "\\" nil t)
            (replace-match "/"))))))

  (defun kicker-ess-turn-on-fix-path ()
    (interactive)
    (when (string= "S" ess-language)
      (add-hook 'auto-indent-after-yank-hook 'kicker-ess-fix-path t t)))
  (add-hook 'ess-mode-hook 'kicker-ess-turn-on-fix-path)


Another R-hack is to take of the ">" and "+" of a command line
copy. For example copying:

 >
 > availDists <- c(Normal="rnorm", Exponential="rexp")
 > availKernels <- c("gaussian", "epanechnikov", "rectangular",
 + "triangular", "biweight", "cosine", "optcosine")


Should give the following code on paste:


 availDists <- c(Normal="rnorm", Exponential="rexp")
 availKernels <- c("gaussian", "epanechnikov", "rectangular",
 "triangular", "biweight", "cosine", "optcosine")


This is setup by the following code snippet:


  (defun kicker-ess-fix-code (beg end)
    "Fixes ess path"
    (save-restriction
      (save-excursion
        (save-match-data
          (narrow-to-region beg end)
          (goto-char (point-min))
          (while (re-search-forward "^[ \t]*[>][ \t]+" nil t)
            (replace-match "")
            (goto-char (point-at-eol))
            (while (looking-at "[ \t\n]*[+][ \t]+")
              (replace-match "\n")
              (goto-char (point-at-eol))))))))

  (defun kicker-ess-turn-on-fix-code ()
    (interactive)
    (when (string= "S" ess-language)
      (add-hook 'auto-indent-after-yank-hook 'kicker-ess-fix-code t t)))
  (add-hook 'ess-mode-hook 'kicker-ess-turn-on-fix-code)


* Auto-indent and org-mode
Auto-indent does not technically turn on for org-mode.  Instead the
following can be added/changed:

1. `org-indent-mode' is turned on when `auto-indent-start-org-indent'
   is true.
2. The return behavior is changed to newline and indent in code blocks
   when `auto-indent-fix-org-return' is true.
3. The backspace behavior is changed to auto-indent's backspace when
   `auto-indent-delete-backward-char' is true.  This only works in
   code blocks.
4. The home beginning of line behavior is changed to auto-indent's
   when `auto-indent-fix-org-move-beginning-of-line' is true.
5. The yank/paste behavior is changed to auto-indent in a code block
   when `auto-indent-fix-org-yank' is true.
6. The auto-filling activity in source-code blocks can break your code
   depending on the language.  When `auto-indent-fix-org-auto-fill' is
   true, auto-filling is turned off in`org-mode' source blocks.
* FAQ
** Why isn't my mode indenting?
Some modes are excluded for compatability reasons, such as
text-modes.  This is controlled by the variable
`auto-indent-disabled-modes-list'
** Why isn't my specific mode have the right number of spaces?
Actually, the number of spaces for indentation is controlled by the
major mode. If there is a major-mode specific variable that controls
this offset, you can add this variable to
`auto-indent-known-indent-level-variables' to change the indentation
for this mode when auto-indent-mode starts.

See:

- [[http://www.pement.org/emacs_tabs.htm][Understanding GNU Emacs and tabs]]
- [[http://kb.iu.edu/data/abde.html][In Emacs how can I change tab sizes?]]
