;; Python auto-completion
;;
;; This needs Jedi and python-epc installed:
;;
;;     pip install epc jedi
;;
;; or:
;;
;;     pip install -r ~/.emacs.d/vendor/emacs-jedi/requirements.txt
;;
;; Hint: If using virtualenvwrapper, add this to the postmkvirtualenv hook:
;;
;;     echo pip install epc jedi >> ~/.virtualenvs/postmkvirtualenv

;; Dependency of emacs-epc
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-ctable")

;; Dependency of auto-complete
(add-to-list 'load-path "~/.emacs.d/vendor/popup-el")

;; Dependency of auto-complete
(add-to-list 'load-path "~/.emacs.d/vendor/fuzzy-el")

;; Dependency of emacs-jedi
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-deferred")

;; Dependency of emacs-jedi
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-epc")

;; Dependency of emacs-jedi
(add-to-list 'load-path "~/.emacs.d/vendor/auto-complete")

;; Jedi.el
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-jedi")

(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
