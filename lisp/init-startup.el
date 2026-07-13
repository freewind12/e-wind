;; basic configuration
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen 1)
;; 语法高亮
(global-font-lock-mode 1)
;; 行号设置
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
;; 括号设置
(show-paren-mode 1)
(electric-pair-mode t)
;; 字体与大小
(cond
 ((eq system-type 'windows-nt)              ; Windows
  (set-face-attribute 'default nil :family "Consolas" :height 200))
 ((eq system-type 'darwin)                  ; macOS
  (set-face-attribute 'default nil :family "SF Mono" :height 200))
 (t                                        ; Linux 或其他
  (set-face-attribute 'default nil :family "WenQuanYi Micro Hei Mono" :height 200)))
;; 导航
(fido-mode 1)
(fido-vertical-mode 1)
;; 快捷键提示
(which-key-mode 1)

(provide 'init-startup)
