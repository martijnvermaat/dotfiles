;; EditorConfig
;;
;; This needs EditorConfig core installed:
;;
;;     sudo apt-get install cmake libpcre3-dev
;;     git clone https://github.com/editorconfig/editorconfig-core-c.git
;;     cd editorconfig-core-c
;;     cmake .
;;     sudo make install

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

(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'inferior-python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


;; Javascript auto-completion
;;
;; This needs Tern installed:
;;
;;     npm install -g tern

(autoload 'tern-mode "tern" nil t)

(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(add-hook 'web-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup)))
