(require 'uniquify)

;;; imaxima
(autoload 'imaxima "imaxima" "Maxima frontend" t)
(autoload 'imath "imath" "Interactive Math mode" t)
(setq imaxima-fnt-size "Large")

;; (autoload 'cuda-mode "cuda-mode" "Mode for cuda" t)
;; (setq auto-mode-alist (append (list (cons "\\.cu$" 'cuda-mode)) auto-mode-alist))

;;; add autoload of imaxima and maxima.
(autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
(autoload 'maxima "maxima" "Frontend for maxima" t)
;;; add autoload of imath.
(autoload 'imath-mode "imath" "Imath mode for math formula input" t)
;;; Make the line effective if you want to use maxima mode with imaxima. 
;;(setq imaxima-use-maxima-mode-flag t)


;;; w3m
(autoload 'w3m "w3m" "web browser emacs front-end" t)
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; optional keyboard shortcut
(global-set-key "\C-xm" 'browse-url-at-point)


;;; load slime
(setq inferior-lisp-program "/usr/bin/sbcl")
;; (add-to-list 'load-path "~/.emacs.d/slime")
(require 'slime)
(slime-setup '(slime-fancy slime-asdf))
(set-language-environment "UTF-8")
(setq slime-net-coding-system 'utf-8-unix)
(setq common-lisp-hyperspec-root "/home/bulkin/.emacs.d/HyperSpec/")


;; setup octave-mode
(setq auto-mode-alist
	  (cons '("\\.m$" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook
		  (lambda ()
			(abbrev-mode 0)
			(auto-fill-mode 0)))
(setq octave-block-offset 4)

;;---------- session autoload ----------

(require 'session)
(add-hook 'after-init-hook 'session-initialize)


;;-------------- project ---------------

(defcustom project-root-markers
  '("COPYING")
  "Files or directories that indicate the root of a project."
  :type '(repeat string)
  :group 'project)

(defun project-root-p (path)
  "Check if the current PATH has any of the project root markers."
  (catch 'found
    (dolist (marker project-root-markers)
      (when (file-exists-p (concat path marker))
        (throw 'found marker)))))

(defun project-find-root (path)
  "Search up the PATH for `project-root-markers'."
  (let ((dir (cl-some (lambda (marker) (locate-dominating-file path marker))
                      project-root-markers)))
    (if dir
        (cons 'transient dir))))

(add-to-list 'project-find-functions #'project-find-root t)

;;-------------- python ----------------

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


;;----------      latex       ----------
;; AUCTeX configuration
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(setq-default ispell-dictionary "english")

;; toggle shell escape using C-c C-t C-x
(defun TeX-toggle-escape nil (interactive)
  (setq LaTeX-command
        (if (string= LaTeX-command "latex") "latex -shell-escape" "latex")))
(add-hook 'LaTeX-mode-hook
          (lambda nil
             (define-key LaTeX-mode-map "\C-c\C-t\C-x"
			   'TeX-toggle-escape))) 

(defun guess-TeX-master (filename)
  "Guess the master file for FILENAME from currently open .tex files."
  (let ((candidate nil)
		(filename (file-name-nondirectory filename)))
	(save-excursion
	  (dolist (buffer (buffer-list))
		(with-current-buffer buffer
		  (let ((name (buffer-name))
				(file buffer-file-name))
			(if (and file (string-match "\\.tex$" file))
				(progn
				  (goto-char (point-min))
				  (if (re-search-forward (concat "\\\\input{" filename "}") nil t)
					  (setq candidate file))
				  (if (re-search-forward (concat "\\\\include{" (file-name-sans-extension filename) "}") nil t)
					  (setq candidate file))))))))
	(if candidate
		(message "TeX master document: %s" (file-name-nondirectory candidate)))
	candidate))
(add-hook 'LaTeX-mode-hook
		  (lambda nil 
			(setq TeX-master (guess-TeX-master (buffer-file-name)))))
(add-hook 'LaTeX-mode-hook
		  'TeX-fold-mode)
(add-hook 'LaTeX-mode-hook
		  'TeX-PDF-mode)
;; Reftex
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; Emacs latex mode
(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-isearch-document t)
(autoload 'ebib "ebib" "Ebib, a BibTeX database manager." t)

