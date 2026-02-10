(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
;;        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

(package-initialize)

(use-package dired-du
  :ensure)

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

(use-package tramp-hlo :ensure
  :vc (:fetcher github :repo jsadusk/tramp-hlo  :rev main)
  :config (tramp-hlo-setup))

(use-package ido-completing-read+
  :ensure)

;;(use-package ido-imenu :ensure) -- where did this come from?

(use-package smartparens
  :ensure smartparens
  :hook (prog-mode text-mode markdown-mode)
  :config
  ;; load default config
  (require 'smartparens-config))

(defvar used-packages
  '(ace-window
    autopair
    cmake-mode
    counsel
    cuda-mode
    darktooth-theme
    dash ;; for solarized-contrast
    eglot
    go-mode
    fill-column-indicator
    haskell-mode
    jupyter
    lua-mode
    lsp-mode
    magit
    meson-mode
    multiple-cursors
    ;; paredit
    ;; lispy
    ;; smartparens
    plantuml-mode
    qml-mode
    qt-pro-mode
    rustic
    slime
    smart-tabs-mode
    sr-speedbar
    typescript-mode
    vue-mode))

(unless
    (cl-reduce (lambda (x y) (and x y))
            (mapcar (lambda (x) (package-installed-p x))
                    used-packages))
  (message "Refreshing packages")
  (package-refresh-contents)
  (message "Installing missing packages")
  (dolist (p used-packages)
    (unless (package-installed-p p)
      (package-install p))))

(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))

(smart-tabs-insinuate 'c 'c++)

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
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

;; multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; paredit load hooks
;; (require 'paredit)
;; (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
;; (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
;; (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
;; (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
;; (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
;; (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
;; (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
;; ;; fix paredit overriding RET in minibuffer
;; (define-key paredit-mode-map (kbd "RET") nil)
;; (define-key paredit-mode-map (kbd "C-j") 'paredit-newline)

;; lispy load hooks
;; (require 'lispy)
;; (add-hook 'emacs-lisp-mode-hook       (lambda () (lispy-mode 1)))
;; (add-hook 'eval-expression-minibuffer-setup-hook (lambda () (lispy-mode 1)))
;; (add-hook 'ielm-mode-hook             (lambda () (lispy-mode 1)))
;; (add-hook 'lisp-mode-hook             (lambda () (lispy-mode 1)))
;; (add-hook 'lisp-interaction-mode-hook (lambda () (lispy-mode 1)))
;; (add-hook 'scheme-mode-hook           (lambda () (lispy-mode 1)))
;; (defun conditionally-enable-lispy ()
;;   (when (eq this-command 'eval-expression)
;;     (lispy-mode 1)))
;; (add-hook 'minibuffer-setup-hook 'conditionally-enable-lispy)
;; (define-key lispy-mode-map (kbd "M-o") nil)

(require 'smartparens-config)

;; Proper speedbar
(require 'sr-speedbar)
(setq speedbar-use-images nil)

;; org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (jupyter . t)))
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

;;(add-to-list 'native-comp-deferred-compilation-deny-list ".*jupyter.*")

(setq org-babel-python-command "ipython3")
(setq org-display-remote-inline-images 'cache)
(setq org-image-actual-width '(800))
(setq org-src-window-setup 'other-window)
;; List of additional LaTeX packages
;; (add-to-list 'org-export-latex-packages-alist '("" "cmap" t))
;; (add-to-list 'org-export-latex-packages-alist '("english,russian" "babel" t))

;; general lsp
(setq gc-cons-threshold (* 64 1024 1024))
(setq read-process-output-max (* 1024 1024))

;;; rust
(require 'yasnippet)
(defun my-rust-hook ()
  (local-set-key "\C-cC" 'compile)
  (local-set-key "\C-c\C-c" 'comment-region)
  (electric-pair-local-mode 1)
  (setq electric-pair-pairs '((?\{ . ?\})))
  (auto-fill-mode 0)
  (yas-minor-mode 1)
  (fci-mode 1))

(add-hook 'rustic-mode-hook 'my-rust-hook)
(setq rustic-lsp-client 'eglot)

(use-package eglot-x
  :ensure t
  :config
  (with-eval-after-load 'eglot (require 'eglot-x))
  :vc (:fetcher github :repo nemethf/eglot-x))


;;; c++
(add-to-list 'auto-mode-alist '("\\.cuh?\\'" . c++-mode))
;; (require 'lsp-mode)
;; (add-hook 'c-mode-hook 'lsp)
;; (add-hook 'c++-mode-hook 'lsp)
;; (lsp-register-client
;;  (make-lsp-client :new-connection
;;                   (lsp-tramp-connection "clangd")
;;                      :major-modes '(c++-mode c-mode)
;;                      :remote? t
;;                      :server-id 'clangd-remote))
(setq lsp-clients-clangd-args '("--fallback-style=WebKit"))

;; use eglot instead of lsp for better tramp performance
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'go-mode 'eglot-ensure )

(defun clangd-switch-source-header ()
  (interactive)
  (let* ((res
          (jsonrpc-request (eglot--current-server-or-lose)
                           :textDocument/switchSourceHeader
                           (eglot--TextDocumentIdentifier)))
         (related-file (eglot--uri-to-path res)))
    (message "Opening %s" res)
    (if (string= "" related-file)
        '()
      (find-file related-file))))

(defun my-c-hook ()
  ;;(local-set-key "\C-ch" 'ff-find-other-file)
  (local-set-key "\C-ch" 'clangd-switch-source-header)
  (local-set-key "\C-cC" 'compile)
  (local-set-key "\C-ca" 'align)
  (local-set-key "\C-c\C-f" 'counsel-imenu)
  ;;(add-to-list cc-search-directories (concat (project-root (project-current t)) "/include"))
  ;;(local-set-key [tab] (lambda () (interactive) (eglot-format (point-at-bol) (point-at-eol))))
  (autopair-mode 1)
  (auto-fill-mode 0)
  (yas-minor-mode 1)
  (fci-mode 1))

(add-hook 'eglot-managed-mode-hook
          (lambda ()
            ;; Show flymake diagnostics first.
            (setq eldoc-documentation-functions
                  (cons #'flymake-eldoc-function
                        (remove #'flymake-eldoc-function eldoc-documentation-functions)))
            ;; Show all eldoc feedback.
            (setq eldoc-documentation-strategy #'eldoc-documentation-compose)))

(add-hook 'c-mode-hook (lambda ()
                         (let ((lsp-enable-indentation nil))
                           (my-c-hook))))
(add-hook 'c++-mode-hook 'my-c-hook)

(defun lsp-restart ()
  (interactive)
  (setq lsp--session nil)
  (let ((lsp-sesh (lsp-session)))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (bound-and-true-p lsp-mode)
          (message "Reloading lsp-mode in %s" (buffer-name))
          (revert-buffer t (not (buffer-modified-p))))))))


;;; plantuml
(setq plantuml-jar-path "/usr/share/plantuml/lib/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)


;;; magit
(use-package magit-ido :ensure t)
(setq magit-completing-read-function 'magit-ido-completing-read)

;; magit faster over tramp
;; 1. Disable buffer iteration for remote repositories
(defun my/magit-save-repository-buffers-maybe (orig-fun &optional arg)
  "Skip magit-save-repository-buffers for remote repositories."
  (if (file-remote-p default-directory)
      ;; Just save the current buffer if modified, don't scan all buffers
      (when (and (buffer-modified-p)
                 (buffer-file-name))
        (save-buffer))
    (funcall orig-fun arg)))

(advice-add 'magit-save-repository-buffers :around #'my/magit-save-repository-buffers-maybe)

;; 2. Disable auto-revert for magit buffers on remote
(add-hook 'magit-mode-hook
          (lambda ()
            (when (file-remote-p default-directory)
              (auto-revert-mode -1))))

;; 3. Reduce status refresh frequency
(setq magit-refresh-status-buffer nil)  ; Manual refresh with 'g'

;; 4. Remove expensive status sections for remote repos
(defun my/magit-optimize-for-tramp ()
  "Remove slow sections when viewing remote repositories."
  (when (file-remote-p default-directory)
    ;; Remove untracked files (requires git ls-files)
    (remove-hook 'magit-status-sections-hook 'magit-insert-untracked-files t)
    ;; Remove recent commits (requires git log)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent t)
    ;; Remove diff stats
    (remove-hook 'magit-status-sections-hook 'magit-insert-diff-filter-header t)))

;;(add-hook 'magit-status-mode-hook #'my/magit-optimize-for-tramp)

;; 5. Increase process timeout for slow git operations
(setq magit-process-timeout 30)

;; 6. Disable diff refinement (syntax highlighting of intra-line changes)
;;(setq magit-diff-refine-hunk nil)

;; 7. Use --no-pager and reduce git output
(setq magit-git-global-arguments
      '("--no-pager" "-c" "core.preloadindex=true" "-c" "color.ui=false"))

;; 8. Cache git directory lookups
;; (setq magit-credential-cache-daemon-socket nil)  ; Disable if causing issues

;; Prevent TRAMP from creating temp files for every git command
;;(setq magit-tramp-pipe-stty-settings "stty -inlcr -onlcr -echo kill '^U' erase '^H'")
;;(setq tramp-process-connection-type nil)  ; Use pipes instead of ptys

(setq remote-file-name-inhibit-locks t
      tramp-use-scp-direct-remote-copying t
      remote-file-name-inhibit-auto-save-visited t)

(connection-local-set-profile-variables 'remote-direct-async-process '((tramp-direct-async-process . t)))
(connection-local-set-profiles '(:application tramp :protocol "scp") 'remote-direct-async-process)
(setq magit-tramp-pipe-stty-settings 'pty)

;;; ai
(use-package ai-code :ensure t
  ;; :straight (:host github :repo "tninja/ai-code-interface.el") ;; if you want to use straight to install, no need to have MELPA setting above
  :config
  ;; use codex as backend, other options are 'claude-code, 'gemini, 'github-copilot-cli, 'opencode, 'grok, 'cursor, 'kiro, 'claude-code-ide, 'claude-code-el
  (ai-code-set-backend 'codex)
  ;; Enable global keybinding for the main menu
  (global-set-key (kbd "C-c a") #'ai-code-menu)
  ;; Optional: Use eat if you prefer, by default it is vterm
  ;;(setq ai-code-backends-infra-terminal-backend 'eat) ;; for openai codex, github copilot cli, opencode, grok, cursor-cli; for claude-code-ide.el, you can check their config
  ;; Optional: Enable @ file completion in comments and AI sessions
  (ai-code-prompt-filepath-completion-mode 1)
  ;; Optional: Turn on auto-revert buffer, so that the AI code change automatically appears in the buffer
  (global-auto-revert-mode 1)
  (setq auto-revert-interval 1) ;; set to 1 second for faster update
  ;; (global-set-key (kbd "C-c a C") #'ai-code-toggle-filepath-completion)
  ;; Optional: Set up Magit integration for AI commands in Magit popups
  (with-eval-after-load 'magit
    (ai-code-magit-setup-transients)))
