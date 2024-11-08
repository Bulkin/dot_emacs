(use-package auto-virtualenvwrapper
  :ensure
  :hook (python-mode-hook . auto-virtualenvwrapper-activate))


;; Run python and pop-up its shell.
;; Kill process to solve the reload modules problem.
(defun my-python-shell-run ()
  (interactive)
  (when (get-buffer-process "*Python*")
    (set-process-query-on-exit-flag (get-buffer-process "*Python*") nil)
    (kill-process (get-buffer-process "*Python*"))
    ;; If you want to clean the buffer too.
    ;;(kill-buffer "*Python*")
    ;; Not so fast!
    (sleep-for 0.5))
  ;;(run-python (python-shell-parse-command) nil nil)
  (my-python-mode-hook)
  (run-python (python-shell-calculate-command) t nil)
  (python-shell-send-buffer)
  ;; Pop new window only if shell isnt visible
  ;; in any frame.
  (unless (get-buffer-window "*Python*" t) 
    (python-shell-switch-to-shell)))

(defun my-python-shell-run-region ()
  (interactive)
  (python-shell-send-region (region-beginning) (region-end))
  (python-shell-switch-to-shell))

(eval-after-load "python"
  '(progn
     (define-key python-mode-map (kbd "C-c C-C") 'my-python-shell-run)
     (define-key python-mode-map (kbd "C-c C-r") 'my-python-shell-run-region)))

(defcustom venv-dir-name
  '("venv")
  "Directory names for automatic venv discovery"
  :type '(repeat string)
  :group 'python)

(defun find-venv ()
  (let* ((path (or (buffer-file-name) "/")) ; buffer-file-name is nil for interactive shells?
         (dir (cl-some (lambda (marker)
                         (let ((newpath (locate-dominating-file path marker)))
                           (when newpath (cons marker newpath))))
                       venv-dir-name)))
    (when dir
      (let ((pythonpath (expand-file-name (car (file-expand-wildcards
                                                (concat (cdr dir) "/"
                                                        (car dir)
                                                        "/lib/python3*/site-packages"))))))
        (tramp-file-name-localname (tramp-dissect-file-name pythonpath))))))

(defun my-python-mode-hook ()
  (let ((venv (print (find-venv))))
    (setq eglot-workspace-configuration
          `(:python (:venvPath ,venv
                               :pythonPath ,venv)))
    (make-local-variable 'process-environment)
    (push (concat "PYTHONPATH=" (find-venv)) process-environment)))

;; Should be implemented by auto-virtualenvwrapper
;; (add-hook 'python-mode-hook #'my-python-mode-hook)
