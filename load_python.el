;; python
;;(require 'pydb)
(require 'python-mode)
(autoload 'python-mode "python-mode" "Python Mode." t)
(setq py-which-shell "python2")
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . python3-mode))
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; rope
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")

;; Stops from erroring if there's a syntax err
(setq ropemacs-codeassist-maxfixes 3)

;; Configurations
(setq ropemacs-guess-project t)
(setq ropemacs-enable-autoimport t)
(setq ropemacs-autoimport-modules '("os" "shutil" "sys" "logging"
									"subprocess" "threading"
									"django.*"))

(setq ropemacs-enable-shortcuts nil)
(defun python-init  ()
  (local-set-key "\C-cg" 'rope-goto-definition)
  (local-set-key "\C-cf" 'rope-find-occurrences)
  (local-set-key "\C-cd" 'rope-show-doc)
  (setq indent-tabs-mode nil)
  (cond ((file-exists-p ".ropeproject")
		 (rope-open-project default-directory))
		((file-exists-p "../.ropeproject")
		 (rope-open-project (concat default-directory "..")))))
(add-hook 'python-mode-hook 'python-init)
(add-hook 'python2-mode-hook 'python-init)
(add-hook 'python3-mode-hook 'python-init)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

;;(setq ipython-command "/usr/bin/ipython3")
;;(require 'ipython)
;;(push "~/.emacs.d/modes/emacs-for-python" load-path)
;; (load-file "~/.emacs.d/modes/emacs-for-python/epy-init.el")
;;(require 'epy-setup)
;;(require 'epy-python)
;;(require 'epy-completion)
;;(setf python-indent-levels '(0 4 8 12))

