;;; document
;; pdf
(use-package pdf-tools
  :ensure t
  :defer t
  :mode ("\\.pdf\\'" . pdf-view-mode)   ; 自动关联 PDF 文件
  :hook (pdf-view-mode . (lambda ()
			   (display-line-numbers-mode -1)
			   (pdf-view-themed-minor-mode 1)
			   (pdf-view-roll-minor-mode 1)
			   ))
  :config
  (setq pdf-view-midnight-colors nil)
  ;;(setq pdf-view-midnight-colors
  ;;	(cons (face-foreground 'default nil)
  ;;            (face-background 'default nil)))
  ;; 安装或更新 epdfinfo 后端（首次使用必须执行）
  (pdf-tools-install)
  ;; 基本显示设置
  (setq pdf-view-display-size 'fit-width)   ; 默认适应宽度
  ;; 可选：使用缓存以加速
  (setq pdf-cache-image-size '(512 . 512))

  ;; 可选：与 Evil 兼容（如果使用 Evil）
  ;; (evil-set-initial-state 'pdf-view-mode 'normal)

  ;; 常用快捷键绑定（在 pdf-view-mode 下）
  (bind-keys :map pdf-view-mode-map
             ("j" . pdf-view-next-page-command)      ; 下一行（实际是下一页）
             ("k" . pdf-view-previous-page-command)  ; 上一行
             ("C-s" . isearch-forward)              ; 搜索
             ("H" . pdf-view-fit-height-to-window)   ; 适应高度
             ("W" . pdf-view-fit-width-to-window)    ; 适应宽度
             ("+" . pdf-view-enlarge)               ; 放大
             ("-" . pdf-view-shrink)                ; 缩小
             ("0" . pdf-view-scale-reset)           ; 重置缩放
             ("a h" . pdf-annot-add-highlight-markup-annotation) ; 高亮
             ("a u" . pdf-annot-add-underline-markup-annotation)  ; 下划线
             ("a s" . pdf-annot-add-strikeout-markup-annotation)  ; 删除线
             ("a t" . pdf-annot-add-text-annotation) ; 添加文本框
             ("r" . pdf-view-revert-buffer)          ; 刷新
             ("q" . kill-this-buffer)               ; 关闭
             )
  )

;; epub
(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode)
  :defer t)

(provide 'init-doc)
