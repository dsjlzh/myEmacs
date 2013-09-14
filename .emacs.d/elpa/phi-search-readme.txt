Add following expression in your init file :

  (require 'phi-search)

and bind command "phi-search"

  (global-set-key (kbd "C-s") 'phi-search)

In *phi-search* buffer, following commands are available.

- [C-s] phi-search-again-or-next

  Move to the next matching item. If query is blank, use the last
  query.

- [C-r] phi-search-again-or-previous

  Similar to phi-search-again-or-next, but move to the previous item.

- [RET] phi-search-complete

  Finish searching.

- [C-g] phi-search-abort

  Finish searching, and move back to the original position.

For more details, see "Readme".
