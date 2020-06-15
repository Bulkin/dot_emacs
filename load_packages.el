(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
;;        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

(package-initialize)

(defvar used-packages
  '(ace-window
    autopair
    cuda-mode
    dash ;; for solarized-contrast
    egg
    elpy
    fill-column-indicator
    haskell-mode
    jupyter
    multiple-cursors
    paredit
    qml-mode
    slime
    smart-tabs-mode
    sr-speedbar))

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

(global-set-key (kbd "M-O") #'ace-window)

(require 'egg)

(elpy-enable)
(setenv "JUPYTER_CONSOLE_TEST" "1")
(setenv "IPY_TEST_SIMPLE_PROMPT" "1")

(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "--simple-prompt -i")

;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
;; (add-to-list 'python-shell-completion-native-disabled-interpreters
;;              "jupyter")

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

;; haskell-mode
(add-hook 'haskell-mode-hook 'haskell-indent-mode)
;;(add-hook 'haskell-mode-hook 'intero-mode)

;; multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; paredit load hooks
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;; Proper speedbar
(require 'sr-speedbar)
(setq speedbar-use-images nil)

;; org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (jupyter . t)))
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
