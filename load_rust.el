(setq racer-cmd "/home/bulkin/.cargo/bin/racer")
(setq racer-rust-src-path "/home/bulkin/src/remote/src_big/rustc-1.9.0/src")

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

(add-hook 'racer-mode-hook #'company-mode)

(global-set-key (kbd "TAB") #'company-indent-or-complete-common) ;
(setq company-tooltip-align-annotations t)

(defun my-rust-hook ()
  (local-set-key "\C-cC" 'compile)
  (local-set-key "\C-c\C-c" 'comment-region)
  (autopair-mode 1)
  (auto-fill-mode 0)
  (fci-mode 1))

(add-hook 'rust-mode-hook 'my-rust-hook)
