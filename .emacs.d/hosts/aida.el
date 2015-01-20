;; EditorConfig
;;
;; This needs EditorConfig core installed:
;;
;;     sudo apt-get install cmake libpcre3-dev
;;     git clone https://github.com/editorconfig/editorconfig-core-c.git
;;     cd editorconfig-core-c
;;     cmake .
;;     sudo make install

(add-to-list 'load-path "~/.emacs.d/vendor/editorconfig")
(load "editorconfig")


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

;; Dependency of emacs-jedi
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-python-environment")

;; Jedi.el
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-jedi")

(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'inferior-python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


;; Javascript auto-completion
;;
;; This needs Tern installed:
;;
;;     npm install -g tern

;; Dependency of tern-auto-complete (already added above)
;(add-to-list 'load-path "~/.emacs.d/vendor/auto-complete")

(add-to-list 'load-path "~/.emacs.d/vendor/tern")
(autoload 'tern-mode "tern" nil t)

(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup)
     (auto-complete-mode t)))
