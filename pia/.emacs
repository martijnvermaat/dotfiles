;; XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Setup keyboard for right [del] behavior
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Compile with F12
(defun silent-compile ()
  (interactive)
  (compile "make")
  (delete-other-windows)
)
(global-set-key [f12] 'silent-compile)

;; Turn of font-lock mode for Emacs
(cond ((not running-xemacs)
       (global-font-lock-mode t)
))

;; Nicer font in emacs-gtk
(cond
 ((string-match "gtk" (emacs-version))
  (set-default-font "Bitstream Vera Sans Mono-11")
))

;; Show tabs for buffers
;;(tabbar-mode t)

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
(autoload 'nuke-trailing-whitespace "nuke-trailing-whitespace" nil t)
(add-hook 'mail-send-hook 'nuke-trailing-whitespace)
(add-hook 'write-file-hooks 'nuke-trailing-whitespace)

(setq-default tab-width 4)
(setq-default c-basic-offset 4)

(setq-default indent-tabs-mode nil)

(defun doe-maar-stroustrup-doen ()
  (c-set-style "stroustrup"))
(add-hook 'java-mode-hook 'doe-maar-stroustrup-doen)

;;(defun java-indent-four ()
;;  (set-variable 'tab-width 4)
;;  (set-variable 'c-basic-offset 4))
;;(add-hook 'java-mode-hook 'java-indent-four)

;; No backupfiles
(setq make-backup-files nil)

(put 'upcase-region 'disabled nil)

;; Use mouse scrolling
;;(mouse-wheel-mode 1)
(cond (window-system (mwheel-install)))

;; Scrollbar right
(cond (window-system (set-scroll-bar-mode 'right)))

;;(line-number-mode 1)
(column-number-mode 1)

;; OCaml tuareg mode
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

;; no indentation after `in' keywords
(add-hook 'tuareg-mode-hook
          '(lambda () (setq tuareg-in-indent 0)))

;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;;(if (and (boundp 'window-system) window-system)
;;    (when (string-match "XEmacs" emacs-version)
;;          (if (not (and (boundp 'mule-x-win-initted) mule-x-win-initted))
;;            (require 'sym-lock))
;;          (require 'font-lock)))

;; Python mode
(setq auto-mode-alist
      (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist
      (cons '("python" . python-mode)
            interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

;; Prolog mode
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                              auto-mode-alist))

;; Javascript mode
(autoload 'javascript-mode "javascript" "Major mode for editing Javascript programs" t)
(setq auto-mode-alist
      (cons '("\\.js$" . javascript-mode) auto-mode-alist))
(custom-set-variables
 '(load-home-init-file t t))
(custom-set-faces)

;; C# mode
(defun poor-mans-csharp-mode ()
  (java-mode)
  (setq mode-name "C#")
  (set-variable 'tab-width 8)
  (set-variable 'indent-tabs-mode t)
  (set-variable 'c-basic-offset 8)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'case-label 0)
)

;; Stratego mode
(autoload 'stratego-mode "stratego")
(setq auto-mode-alist (cons '("\.str$" . stratego-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.strs$" . stratego-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.sdf$" . stratego-mode) auto-mode-alist))

;; Proof General
(cond (running-xemacs
       (load-file "/opt/ProofGeneral/generic/proof-site.el")
       ))

;; CSS mode
(autoload 'css-mode "css-mode")
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(add-hook 'css-mode-hook 'cssm-leave-mirror-mode)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level '4)

;; RELAX NG Compact Syntax mode
(autoload 'rnc-mode "rnc-mode")
(setq auto-mode-alist
(cons '("\\.rnc\\'" . rnc-mode) auto-mode-alist))