(define-derived-mode  nyquist-mode lisp-mode "Nyquist lisp mode"
  (setq-mode-local nyquist-mode inferior-lisp-program "/home/bulkin/bin/run-nyquist"))

(add-to-list 'auto-mode-alist '("\\.ny\\'" . nyquist-mode))

(add-hook 'nyquist-mode-hook (lambda () (slime-mode 0)))
