(use-package flymake
  :ensure nil                     ; 内置，无需安装
  :bind (:map flymake-mode-map
              ("C-c n" . flymake-goto-next-error)
              ("C-c p" . flymake-goto-prev-error)))
(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
	      ("C-c <f2>" . eglot-rename)
	      ;;("C-c e c a" . eglot-code-action)
	      ))

(use-package dape
  :ensure nil
  :bind (:map dape-repl-mode-map
	      ("<f10>" . dape-next)
	      ("<f11>" . dape-step-in)
	      ("<f12>" . dape-step-out)
	      ))

(provide 'init-kbd)
