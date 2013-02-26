Usage:
  (require 'flymake-python-pyflakes)
  (add-hook 'python-mode-hook 'flymake-python-pyflakes-load)

To use "flake8" instead of "pyflakes", add this line:
  (setq flymake-python-pyflakes-executable "flake8")

Uses flymake-easy, from https://github.com/purcell/flymake-easy
