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

;; Whenever a file changes and the corresponding buffer has no unsaved
;; changes, revert it's content
(global-auto-revert-mode 1)

;; No splash screen
(setq inhibit-startup-message t)

;; Just typing y or n should be enough
(fset 'yes-or-no-p 'y-or-n-p)

;; Kill a buffer with a live process attached to it
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))

;; Rewire C-x k as C-x # if the buffer is from an emacsclient
(add-hook 'server-switch-hook
          (lambda ()
            (when (current-local-map)
              (use-local-map (copy-keymap (current-local-map))))
            (when server-buffer-clients
              (local-set-key (kbd "C-x k") 'server-edit))))

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

;; Minor mode to aid in finding common writing problems
(require 'writegood-mode)

;; Show line and column numbers
(line-number-mode 1)
(column-number-mode 1)

;; Regexp replace with interactive visual feedback
(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)

;; Ido mode
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Ido really everywhere
(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)

;; Ido mode vertically
(require 'ido-vertical-mode)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)

;; Smex
(require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Show the equivalent key-binding when M-x command has one
(setq suggest-key-bindings 4)

;; Unique buffer names
(require 'uniquify)

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

;; For all practical purposes, multi-term is better than term or ansi-term
(require 'multi-term)
(setq multi-term-dedicated-select-after-open-p t)

;; Mappings in ~/.inputrc are not picked up here, so we redefine them
(defun term-send-history-search-backward ()
  (interactive)
  (term-send-raw-string "\e[A"))
(defun term-send-history-search-forward ()
  (interactive)
  (term-send-raw-string "\e[B"))
(add-to-list 'term-bind-key-alist '("<up>" . term-send-history-search-backward))
(add-to-list 'term-bind-key-alist '("<down>" . term-send-history-search-forward))

;; Moving by word doesn't actually send this action to the terminal program,
;; so we also rebind these keys
(add-to-list 'term-bind-key-alist '("C-<left>" . term-send-backward-word))
(add-to-list 'term-bind-key-alist '("C-<right>" . term-send-forward-word))

;; Split the screen, create a new dedicated multi-term buffer, and focus
(defun multi-term-open (&optional program)
  (interactive)
  (split-window-sensibly)
  (other-window 1)
  (let ((multi-term-program (or program multi-term-program)))
    (multi-term))
  (set-window-dedicated-p (selected-window) t))
(global-set-key (kbd "C-c m") 'multi-term-open)

;; A custom shell can be entered by using the C-u prefix for C-x multi-term,
;; but we use IPython so often let's dedicate a function to it
(defun run-ipython ()
  (interactive)
  (multi-term-open "ipython"))
(global-set-key (kbd "C-c p") 'run-ipython)

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

;; json-mode
(require 'json-mode)
(setq json-reformat:indent-width 2)

;; JavaScript js2-mode
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js2-indent-switch-body t)
(setq js2-basic-offset 2)

;; php-mode
(require 'php-mode)

;; web-mode for web templates
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jinja2?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(setq web-mode-engines-alist '(("jinja" . "\\.jinja2\\'")))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))
(add-hook 'web-mode-hook (lambda () (auto-complete-mode t)))
(setq web-mode-code-indent-offset 2)

;; Flycheck, but opt-in
(autoload 'flycheck-mode "flycheck" nil t)
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'js2-mode-hook 'flycheck-mode)
(add-hook 'coffee-mode-hook 'flycheck-mode)
(add-hook 'go-mode-hook 'flycheck-mode)
(add-hook 'sh-mode-hook 'flycheck-mode)
(add-hook 'rust-mode-hook 'flycheck-mode)

;; Convince Flycheck it's useful in web-mode, but only for JSX
(add-hook 'web-mode-hook
          (lambda () (when (equal web-mode-content-type "jsx")
                       (flycheck-mode)
                       (flycheck-add-mode 'javascript-eslint 'web-mode))))

;; CoffeeScript mode
(require 'coffee-mode)
(setq coffee-tab-width 2)

;; go-mode
;; Works best after installing github.com/rogpeppe/godef
(require 'go-mode-autoloads)
(add-hook 'before-save-hook 'gofmt-before-save)

;; rust-mode
(require 'rust-mode)
(add-hook 'rust-mode-hook 'electric-pair-mode)

;; cargo-minor-mode
(require 'cargo)
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;; flycheck-rust needs an additional setup hook
(require 'flycheck-rust)
(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)

;; We should move from auto-complete to company for everything, but for now we
;; use company for racer-mode (it only supports company)
(require 'company)
(require 'racer)
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)
(add-hook 'racer-mode-hook 'company-mode)
(define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

;; Elixir mode
(require 'elixir-mode)

;; Colorize color names
(require 'rainbow-mode)

;; CSS mode
(autoload 'css-mode "css-mode")
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(add-hook 'css-mode-hook 'cssm-leave-mirror-mode)
(add-hook 'css-mode-hook 'rainbow-mode)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level '4)

;; Less CSS mode
(require 'less-css-mode)

;; YAML mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; TOML mode
(require 'toml-mode)

;; Markdown mode
(require 'markdown-mode)
(setq auto-mode-alist (cons '("\.md$" . markdown-mode) auto-mode-alist))

;; Nix mode
(require 'nix-mode)

;; Terraform mode
(require 'terraform-mode)
(setq terraform-indent-level 4)

;; ag.el
(require 'ag)
(setq ag-highlight-search t)
(setq ag-reuse-buffers t)

;; Our own Org mode version (if available; install with 'make autoloads')
(defvar mv/org-mode (expand-file-name "org-mode/lisp" mv/vendor-dir))
(when (file-regular-p (expand-file-name "org-loaddefs.el" mv/org-mode))
  (add-to-list 'load-path mv/org-mode)
  (require 'org))

;; Run sh and Python from Org mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh . t)
   (python . t)))

;; Disable prompt for running code blocks from Org mode
(setq org-confirm-babel-evaluate nil)

;; Simple presentation mode for Org mode
(require 'epresent)

;; Magit mode
(defvar mv/magit (expand-file-name "magit/lisp" mv/vendor-dir))
(when (file-directory-p mv/magit)
  (add-to-list 'load-path mv/magit))
(require 'magit)

;; These are also bound by magit-file-mode, but it might be useful to even
;; have them when we're not visiting a file.
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

;; The default C-tab doesn't work in gnome-terminal
(define-key magit-mode-map (kbd "`") 'magit-section-cycle)

;; Apparently this is how we receive s-tab
(define-key magit-mode-map (kbd "<backtab>") 'magit-section-cycle-global)

;; More magit configuration
(global-magit-file-mode t)
(setq magit-popup-show-common-commands nil)
(setq magit-process-popup-time 10)
(setq magit-completing-read-function 'magit-ido-completing-read)
(setq magit-push-always-verify nil)
(setq magit-diff-refine-hunk t)
(setq magit-fetch-arguments '("--prune"))
(setq magit-log-arguments '("--graph" "--color" "--decorate" "-n256"))

;; Git time machine
(require 'git-timemachine)

;; Show git info in the gutter
(require 'git-gutter)
(global-git-gutter-mode t)
(add-hook 'git-gutter:update-hooks 'magit-after-revert-hook)
(add-hook 'git-gutter:update-hooks 'magit-not-reverted-hook)

;; Predefine some modes for It's All Text!
;;(add-to-list 'auto-mode-alist '("^github\\.com[^/]+\\.txt$" . markdown-mode))
(add-to-list 'auto-mode-alist '("itsalltext/github\\.com" . markdown-mode))

;; Pastebin (sorry, can't remember the name sprunge)
(require 'sprunge)
(defalias 'pastebin-buffer 'sprunge-buffer)
(defalias 'pastebin-region 'sprunge-region)

;; Load custom per-host files
(let ((host (car (split-string (system-name) "\\."))))
  (defvar mv/host-file (expand-file-name (format "hosts/%s.el" host)
                                         user-emacs-directory)))
(setq custom-file mv/host-file)
(if (file-exists-p mv/host-file)
    (load mv/host-file))
