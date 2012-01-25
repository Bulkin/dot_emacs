(if (boundp 'cedet-info-dir)
    (add-to-list 'Info-default-directory-list cedet-info-dir))

(if (boundp 'cedet-lib)
    (load-file cedet-lib))

(require 'semantic)
(require 'semantic/sb)
(require 'semantic/analyze/refs)

;; (semantic-mode 1)

(global-ede-mode t)

(if (boundp 'semantic-load-enable-excessive-code-helpers)
    ; Add-on CEDET
    (progn
      (semantic-load-enable-excessive-code-helpers)
	  ; TODO: should already be enabled by previous line
      (global-semantic-idle-completions-mode)
      (global-semantic-tag-folding-mode))
   ; Integrated CEDET
  (setq semantic-default-submodes
        '(global-semanticdb-minor-mode
          global-semantic-idle-scheduler-mode
          global-semantic-idle-summary-mode
          global-semantic-idle-completions-mode
          global-semantic-decoration-mode
          global-semantic-highlight-func-mode
          global-semantic-stickyfunc-mode)))

(if (boundp 'semantic-ia) (require 'semantic-ia))
(if (boundp 'semantic-gcc) (require 'semantic-gcc))

;; cedet
;; (semantic-load-enable-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
;; (semantic-load-enable-gaudy-code-helpers)
;; (require 'semantic-ia)
;; (require 'semantic-gcc)
;; semantic dirs
(semantic-add-system-include "/opt/cuda/include" 'c++-mode)
(semantic-add-system-include "/usr/lib64/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4" 'c++-mode)
(semantic-add-system-include "/usr/include/qt4" 'c++-mode)
(add-to-list 'auto-mode-alist (cons "/opt/cuda/include" 'c++-mode))
(add-to-list 'auto-mode-alist (cons "/usr/include/qt4" 'c++-mode))
(add-to-list 'auto-mode-alist (cons "/usr/lib64/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4" 'c++-mode))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file "/usr/include/qt4/Qt/qconfig.h")

(setf semantic-idle-scheduler-idle-time 0.5)

(require 'eassist)

(defun my-c-mode-cedet-hook ()
  (semantic-mode 1)
  (autopair-mode 1)
  (setq indent-tabs-mode t)
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-cd" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)
  (local-set-key "\C-cc" 'semantic-ia-describe-class)
  (local-set-key "\C-cg" 'semantic-ia-fast-jump)
  (local-set-key "\C-cb" 'semantic-mrub-switch-tag)
  (local-set-key "\C-ct" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-ci" 'semantic-decoration-include-visit)
  (local-set-key "\C-cr" 'semantic-symref-symbol)
  (local-set-key "\C-ch" 'eassist-switch-h-cpp)
  (local-set-key "\C-cC" 'compile)
  (local-set-key "\C-c\C-d" 'gdb-many-windows))
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)

(defvar prefer-c-mode t "Prefer c-mode to c++-mode when opening h-files")
(defun c-c++-header ()
  "Sets either c-mode or c++-mode, whichever is appropriate for
header"
  (interactive)
  (cond ((directory-files default-directory nil ".*c[cpx][px]?")
         (c++-mode))
        ((directory-files default-directory nil ".*\.c")
         (c-mode))
        (t (if prefer-c-mode 
               (c-mode)
             (c++-mode)))))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-c++-header))
