;;(setq racer-cmd "/home/bulkin/.cargo/bin/racer")
;;(setq racer-rust-src-path "/home/bulkin/src/remote/src_big/rustc-1.9.0/src")

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

(add-hook 'racer-mode-hook #'company-mode)

;;(global-set-key (kbd "TAB") #'company-indent-or-complete-common) ;
(setq company-tooltip-align-annotations t)

(require 'polymode)

;;; define polymode
;; (defcustom pm-host/rust
;;   (pm-bchunkmode "rust" :mode 'rust-mode)
;;   "Rust host chunkmode"
;;   :group 'hostmodes
;;   :type 'object)

;; (defcustom  pm-inner/glsl
;;   (pm-hbtchunkmode "glsl"
;;                    :head-reg  "r#\""
;;                    :tail-reg  "\"#"
;;                    :mode 'glsl-mode)
;;   "GLSL typical chunk."
;;   :group 'innermodes
;;   :type 'object)

;; (defcustom pm-poly/rust-glsl
;;   (pm-polymode-one "rust-glsl"
;;                    :hostmode 'pm-host/rust
;;                    :innermode 'pm-inner/glsl)
;;   "GLSL typical polymode."
;;   :group 'polymodes
;;   :type 'object)

;; (define-polymode poly-rust-glsl-mode pm-poly/rust-glsl)

(defun my-rust-hook ()
  (local-set-key "\C-cC" 'compile)
  (local-set-key "\C-c\C-c" 'comment-region)
                                        ;(autopair-mode 1)
  (electric-pair-local-mode 1)
  (setq electric-pair-pairs '((?\{ . ?\})))

  (auto-fill-mode 0)
  (fci-mode 1))

(add-hook 'rust-mode-hook 'my-rust-hook)

