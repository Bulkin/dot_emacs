;; python
;;(require 'pydb)
;;(require 'python-mode)
(autoload 'python-mode "python-mode" "Python Mode." t)
(setq py-which-shell "python2")
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . python3-mode))
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(setq ipython-command "/usr/bin/ipython3")
    
(setq python-shell-interpreter-args "--simple-prompt")

(defun absolute-dirname (path)
  "Return the directory name portion of a path.

If PATH is local, return it unaltered.
If PATH is remote, return the remote diretory portion of the path."
  (if (tramp-tramp-file-p path)
      (elt (tramp-dissect-file-name path) 3)
    path))

(defun run-virtualenv-python (env)
  "Run Python in this virtualenv."
  (interactive "DPath to virtualenv: ")
  (let ((env-root (locate-dominating-file
                   (or env default-directory) "bin/python")))
    (apply 'run-python
           (when env-root
             (list (concat "env LD_PRELOAD=/home/bulkin/src/rli/rlisynt/build/rlisyntlib/librlisynt.so "
                    (absolute-dirname env-root) "bin/python")))
           )))

;; Remove "Warning (python): Python shell prompts cannot be detected."
;;(setq python-shell-unbuffered nil) -- doesn't work

(defun my-restart-python-console ()
  "Restart python console before evaluate buffer or region to
avoid various uncanny conflicts, like not reloding modules even
when they are changed"
  (interactive)
  (kill-process "Python")
  (sleep-for 0.1)
  (kill-buffer "*Python*")
  (elpy-shell-send-region-or-buffer))

(defun python-init  ()
  (local-set-key "\C-c\C-c" 'my-restart-python-console))
(add-hook 'python-mode-hook 'python-init)
(add-hook 'elpy-mode-hook 'python-init)

;; fix ipython prompt? 
(setenv "IPY_TEST_SIMPLE_PROMPT" "1")

(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")
