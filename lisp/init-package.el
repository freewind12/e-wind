;; 安装 eglot-jdtls 包
;; (use-package dape
;;   :ensure t)
;; (add-to-list 'load-path "~/.emacs.d/lisp/eglot-jdtls/")
;; (require 'eglot-jdtls)
;; 
;; ;; 加载并配置 eglot-jdtls
;; (setq eglot-jdtls-config
;;       `(:cmd ("java" "-jar" ,(expand-file-name "~/.emacs.d/jdtls/plugins/org.eclipse.equinox.launcher_1.8.0.v20260804-1928.jar")
;;               "-configuration" ,(expand-file-name "~/.emacs.d/jdtls/config_linux/config.ini")
;;               "-data" ,(expand-file-name "~/.emacs.d/jdtls/workspace"))))

;; 实用包
(use-package drag-stuff
  :bind (("<M-up>" . drag-stuff-up)
	 ("<M-down>" . drag-stuff-down)))

;; eglot
(use-package eglot
  :ensure t                     ; eglot 是内置包，无需安装
  :defer t
  :hook ((c-mode c++-mode python-mode java-mode java-ts-mode) . eglot-ensure)  ; 进入 C/C++ 文件时自动启动
  :config
  ;; 配置 clangd 为 C/C++ 的 LSP 服务器
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode)
                 . ("clangd"
                    "-background-index"          ; 后台索引，提升性能
                    "--clang-tidy"               ; 开启 clang-tidy 检查（可选）
		    ;; 使用 fallback 风格，并设置缩进为4空格或在根目录配置.clang-format
                    ;;"--fallback-style={IndentWidth: 4, UseTab: Never}"
		    "--query-driver=/usr/bin/gcc,/usr/bin/g++")))
  ;;(add-to-list 'eglot-ignored-server-capabilities
  ;;             :documentOnTypeFormattingProvider)
  ;; 如果使用 compile_commands.json 且不在根目录，可以添加：
  ;; "--compile-commands-dir=build"
  (add-to-list 'eglot-server-programs
	       '(python-mode . ("pylsp")))
;;  (add-to-list 'eglot-server-programs
;;	       '((java-mode java-ts-mode) . (eglot-jdtls-server . eglot-jdtls-cmd)))
  )
;; 补全前端
;; Company 补全框架
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)   ; Emacs 启动完成后全局启用
  :custom
  ;; 基本行为
  (company-idle-delay 0.3)                   ; 输入后 n 秒自动弹出
  (company-minimum-prefix-length 1)          ; 输入 1 个字符后触发补全
  (company-selection-wrap-around t)          ; 选择到末尾后循环到开头

  ;; 后端设置（重要：将 company-capf 放在最前面，优先使用 LSP 补全）
  (company-backends '((company-capf          ; 优先从 Eglot 获取补全
                       company-dabbrev-code  ; 代码中的单词补全（备用）
                       company-dabbrev)      ; 所有缓冲区的单词补全（最后备用）
                      company-files))        ; 文件路径补全（独立后端）

  ;; 界面显示
  (company-tooltip-align-annotations t)      ; 对齐提示信息（如参数签名）
  (company-tooltip-limit 10)                 ; 最多显示 10 个候选
  (company-require-match nil)                ; 允许输入不匹配的文本（不强制选择）

  :config
  ;; 可选：让 company 在终端中也能工作（如果使用图形界面可忽略）
  ;; (setq company-frontends '(company-pseudo-tooltip-frontend))
  )

;; c风格语言配置
(add-hook 'c-mode-common-hook
	  (lambda ()
            (c-set-style "k&r")
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)))

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

(provide 'init-package)
