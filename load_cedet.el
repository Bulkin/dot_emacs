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

(semantic-add-system-include "/usr/msp430/include" 'c-mode)

(setf semantic-idle-scheduler-idle-time 0.5)

(semanticdb-enable-gnu-global-databases 'c-mode t)
(semanticdb-enable-gnu-global-databases 'c++-mode t)

;;(semantic-mode 1)

(require 'buftoggle)

(defvar custom-c-common-hook nil "functions to run after the cedet-hook runs")

(defun my-c-mode-cedet-hook ()
  (autopair-mode 1)
  (auto-fill-mode 0)
  (fci-mode 1)
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
  (local-set-key "\C-ch" 'buftoggle)
  (local-set-key "\C-cC" 'compile)
  (local-set-key "\C-ca" 'align)
  (local-set-key "\C-c\C-d" 'gdb-many-windows)
  (setq paragraph-start "^[  ]*\\(//!\\|//+\\|\\**\\)[  ]*\\([  ]*$\\|@param\\)\\|^\f"))
  ;; (when custom-c-common-hook
  ;;   (message "running custom-c-common-hook")
  ;;   (mapcar 'funcall custom-c-common-hook)))
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
 
(defvar prefer-c-mode nil "Prefer c-mode to c++-mode when opening h-files")

(defun c-c++-header ()
  "Sets either c-mode or c++-mode, whichever is appropriate for
header"
  (interactive)
  (cond ((directory-files default-directory nil ".*c[cpx][px]?")
         (c++-mode))
        ((directory-files default-directory nil ".*\\.c")
         (c-mode))
        (t (if prefer-c-mode 
               (c-mode)
             (c++-mode)))))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-c++-header))


(defadvice align-regexp (around align-regexp-with-spaces activate)
  (let ((indent-tabs-mode nil))
    ad-do-it))

(defadvice align (around align-with-spaces activate)
  (let ((indent-tabs-mode nil))
    ad-do-it))

(defadvice c-lineup-arglist (around my activate)
  "Improve indentation of continued C++11 lambda function opened as argument."
  (setq ad-return-value
        (if (and (equal major-mode 'c++-mode)
                 (ignore-errors
                   (save-excursion
                     (goto-char (c-langelem-pos langelem))
                     ;; Detect "[...](" or "[...]{". preceded by "," or "(",
                     ;;   and with unclosed brace.
                     (looking-at ".*[(,][ \t]*\\[[^]]*\\][ \t]*[({][^}]*$"))))
            0                           ; no additional indent
          ad-do-it)))

;;;; Qt
(load-file "~/.emacs.d/modes/qmake.el")
(add-to-list 'auto-mode-alist '("\\.qml\\'" . qml-mode))
