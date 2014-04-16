(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;; Used packages:
;;    egg
;;    elpy
;;    smart-tabs-mode

;; (require 'egg)

(elpy-enable)
(elpy-use-ipython)
(setq python-shell-interpreter-args "--colors Linux --no-autoindent")

;;(require 'python-mode)

(smart-tabs-insinuate 'c 'c++)
