(use-package flymake
  :ensure nil                     ; 内置，无需安装
  :bind (:map flymake-mode-map
              ("C-c n" . flymake-goto-next-error)
              ("C-c p" . flymake-goto-prev-error)))


(provide 'init-kbd)
