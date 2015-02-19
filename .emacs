;; Add vendor packages to load path
(defvar mv/vendor-dir (expand-file-name "vendor" user-emacs-directory))
(add-to-list 'load-path mv/vendor-dir)
(dolist (project (directory-files mv/vendor-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Setup keyboard for right [del] behavior
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Enable C-x C-u (upcase-region) and C-x C-l (downcase-region)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Tomorrow theme
(require 'color-theme-tomorrow)
(color-theme-tomorrow-night)

;; Our color theme makes markdown headings unreadable
(setq-default frame-background-mode 'dark)

;; Don't save abbreviations
(setq save-abbrevs nil)

;; No backupfiles
(setq make-backup-files nil)

;; No splash screen
(setq inhibit-startup-message t)

;; Just follow version controlled symlinks
(setq vc-follow-symlinks t)

;; No more annoying beeps
(setq visible-bell 1)

;; Visual feedback on selections
(setq-default transient-mark-mode t)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Remove trailing whitespace
(defun mv/delete-trailing-blank-lines ()
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'mv/delete-trailing-blank-lines)

;; Auto fill
(setq-default fill-column 78)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Show line and column numbers
(line-number-mode 1)
(column-number-mode 1)

;; Ido mode
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Ido mode vertically
(require 'ido-vertical-mode)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)

;; Smex
(require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; undo-tree mode
(require 'undo-tree)
(global-undo-tree-mode 1)

;; Unified diffs in diff-mode
(setq diff-switches '("-u"))

;; neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-window-width 30)
(setq neo-banner-message nil)
(setq neo-dont-be-alone t)

;; Auto completion
(require 'auto-complete-config)
(defvar mv/ac-dict-dir (expand-file-name "dict" user-emacs-directory))
(add-to-list 'ac-dictionary-directories mv/ac-dict-dir)
(ac-config-default)

;; Default tab width
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

;; No tab characters
(setq-default indent-tabs-mode nil)

;; Stroustrup C style for Java
(defun mv/c-style ()
  (c-set-style "stroustrup"))
(add-hook 'java-mode-hook 'mv/c-style)

;; C# mode
(defun mv/csharp-mode ()
  (java-mode)
  (setq mode-name "C#")
  (set-variable 'tab-width 4)
  (set-variable 'indent-tabs-mode t)
  (set-variable 'c-basic-offset 4)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'case-label 0)
)

;; OCaml tuareg mode
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

;; No indentation after 'in' keywords
(add-hook 'tuareg-mode-hook
          '(lambda () (setq tuareg-in-indent 0)))

;; Use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;; Prolog mode
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                              auto-mode-alist))

;; Stratego mode
(autoload 'stratego-mode "stratego")
(setq auto-mode-alist (cons '("\.str$" . stratego-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.strs$" . stratego-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.sdf$" . stratego-mode) auto-mode-alist))

;; RELAX NG Compact Syntax mode
(autoload 'rnc-mode "rnc-mode")
(setq auto-mode-alist (cons '("\\.rnc\\'" . rnc-mode) auto-mode-alist))

;; ESS mode configuration
(defvar mv/ess-lisp (expand-file-name "ess/lisp" mv/vendor-dir))
(when (file-directory-p mv/ess-lisp)
  (add-to-list 'load-path mv/ess-lisp))
(autoload 'r-mode "ess-site.el" "ESS" t)
(add-to-list 'auto-mode-alist '("\\.R$" . r-mode))
(setq ess-ask-for-ess-directory nil)
(setq ess-eval-visibly 'nowait)
(setq inferior-R-args "--no-save --no-restore ")
(setq ess-history-directory "~/.R/")
(require 'comint)
(define-key comint-mode-map [C-up] 'comint-previous-matching-input-from-input)
(define-key comint-mode-map [C-down] 'comint-next-matching-input-from-input)
(setq comint-input-ring-size 10000)

;; Polymode
(defvar mv/polymodes (expand-file-name "polymode/modes" mv/vendor-dir))
(when (file-directory-p mv/polymodes)
  (add-to-list 'load-path mv/polymodes))
(require 'poly-R)
(require 'poly-markdown)
(require 'poly-noweb)
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; Make poly-markdown+r-mode play nice with ESS evaluation
;; https://github.com/vitoshka/polymode/issues/6
(defun Rmd-setup ()
  (setq paragraph-start "```\\|\\s-*$")
  (setq paragraph-separate "```\\|\\s-*$"))
(add-hook 'poly-markdown+r-mode-hook 'Rmd-setup)

;; Configure python.el for IPython
(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "")
(setq python-shell-prompt-regexp "In \\[[0-9]+\\]: ")
(setq python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: ")
(setq python-shell-completion-setup-code "from IPython.core.completerlib import module_completion")
(setq python-shell-completion-module-string-code "';'.join(module_completion('''%s'''))\n")
(setq python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;; Flycheck, only for Python
(autoload 'flycheck-mode "flycheck" nil t)
(add-hook 'python-mode-hook 'flycheck-mode)

;; JavaScript js2-mode
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js2-indent-switch-body t)

;; web-mode for web templates
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))
(add-hook 'web-mode-hook (lambda () (auto-complete-mode t)))

;; CoffeeScript mode
(require 'coffee-mode)

;; CSS mode
(autoload 'css-mode "css-mode")
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(add-hook 'css-mode-hook 'cssm-leave-mirror-mode)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level '4)

;; Less CSS mode
(require 'less-css-mode)

;; YAML mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
 '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; Markdown mode
(setq auto-mode-alist (cons '("\.md$" . markdown-mode) auto-mode-alist))

;; Load custom per-host files
(let ((host (car (split-string (system-name) "\\."))))
  (defvar mv/host-file (expand-file-name (format "hosts/%s.el" host)
                                         user-emacs-directory)))
(setq custom-file mv/host-file)
(if (file-exists-p mv/host-file)
    (load mv/host-file))
