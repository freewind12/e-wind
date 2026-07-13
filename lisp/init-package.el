;; eglot
(use-package eglot
  :ensure nil                     ; eglot 是内置包，无需安装
  :defer t
  :hook ((c-mode c++-mode python-mode) . eglot-ensure)  ; 进入 C/C++ 文件时自动启动
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

(provide 'init-package)
