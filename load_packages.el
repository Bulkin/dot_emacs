(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
;;        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

(package-initialize)

(defvar used-packages
  '(autopair
    cuda-mode
    dash ;; for solarized-contrast
    egg
    elpy
    fill-column-indicator
    qml-mode
    smart-tabs-mode))

(unless
    (reduce (lambda (x y) (and x y))
            (mapcar (lambda (x) (package-installed-p x))
                    used-packages))
  (message "Refreshing packages")
  (package-refresh-contents)
  (message "Installing missing packages")
  (dolist (p used-packages)
    (unless (package-installed-p p)
      (package-install p))))


(require 'egg)

(elpy-enable)
(elpy-use-ipython)
(setq python-shell-interpreter-args "--colors Linux --no-autoindent")

;;(require 'python-mode)

(smart-tabs-insinuate 'c 'c++)

(add-hook 'python-mode-hook 'fci-mode)

;; elpy fixes
(defadvice elpy-rpc--open (around native-rpc-for-tramp activate)
  (interactive)
  (let ((elpy-rpc-backend
         (if (ignore-errors (tramp-tramp-file-p (elpy-project-root)))
             "jedi")))
     (message "Using elpy backend: %s for %s" elpy-rpc-backend (elpy-project-root))
     ad-do-it))

(require 'autopair)
;; (autopair-global-mode)
;; fix autopair in sldb
(add-hook 'sldb-mode-hook #'(lambda () (setq autopair-dont-activate t)))
(add-hook 'lisp-mode-hook #'(lambda () (setq autopair-dont-activate t)))
(add-hook 'slime-repl-mode-hook
		  #'(lambda () (setq autopair-dont-activate t)))

