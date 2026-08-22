(use-package flymake
  :ensure nil                     ; 内置，无需安装
  :bind (:map flymake-mode-map
              ("C-c n" . flymake-goto-next-error)
              ("C-c p" . flymake-goto-prev-error)))
(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
	      ("C-c <f2>" . eglot-rename)
	      ))

(provide 'init-kbd)
