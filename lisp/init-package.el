;; 实用包
(use-package drag-stuff
  :ensure t
  :bind (("<M-up>" . drag-stuff-up)
	 ("<M-down>" . drag-stuff-down)))

(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window))

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
  (add-to-list 'eglot-server-programs
	       '(python-mode . ("pylsp")))
  (add-to-list 'eglot-server-programs
               `((java-mode java-ts-mode)
                 . ("/mnt/d/IDE/lsp/jdtls/bin/jdtls"
                    :initializationOptions
                    (:bundles ["/mnt/d/IDE/dap/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.2.jar"]))))
  )
;; dape debug 工具
(use-package dape
  :ensure t
  ;; 将 dape 的命令绑定到 C-x C-a 前缀键
  :bind-keymap ("C-x C-a" . dape-global-map)
  :config
  ;; 启用全局断点模式，可以用鼠标设置断点
  (dape-breakpoint-global-mode)

  ;; --- C/C++ 配置 (使用 CodeLLDB) ---
  ;; 假设 CodeLLDB 解压在 ~/.emacs.d/debug-adapters/codelldb/
  (add-to-list 'dape-configs
               `(codelldb
                 modes (c-mode c++-mode)
                 command "codelldb"
                 :type "lldb"
                 :request "launch"
                 :program my-dape-cpp-program ; 自动使用当前文件编译出的可执行文件
                 :cwd dape-cwd-fn))
  
  ;; --- Python 配置 (使用 debugpy) ---
  ;; dape 已内置对 debugpy 的支持，确保 python3 已安装 debugpy 模块即可
  ;; 可直接使用内置配置，或自定义如下：
  (add-to-list 'dape-configs
             `(debugpy
               modes (python-mode python-ts-mode)
               command ,(expand-file-name "~/.local/share/pipx/venvs/debugpy/bin/python")
               command-args ("-m" "debugpy.adapter")
               :type "executable"
               :request "launch"
               :program (lambda () (buffer-file-name))
               :cwd dape-cwd-fn
               :justMyCode nil
	       :redirectOutput t
	       ))
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
;;(add-hook 'c-mode-hook (lambda () (setq-local dape-default-config codelldb)))
;;(add-hook 'c++-mode-hook (lambda () (setq-local dape-default-config codelldb)))

;;; git
;; 在行号边缘显示git修改标记
(use-package diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  (diff-hl-flydiff-mode 1))
;; magit 功能丰富的git工具
(use-package magit
    :ensure t
    :bind ("C-x g" . magit-status))

;(require 'init-doc)

;; 词库
(use-package pyim-basedict
  :ensure t
  :config (pyim-basedict-enable))

;; input method
(use-package pyim
  :ensure t
  :demand t
  :config
  ;; 基本设置
  (setq default-input-method "pyim")
  (setq pyim-default-scheme 'quanpin)
  (setq pyim-page-length 9)
  (setq pyim-page-tooltip 'posframe)

  ;; 拼音搜索
  (pyim-isearch-mode 1)

  ;; 启动时加载词库
  (add-hook 'emacs-startup-hook
            #'(lambda () (pyim-restart-1 t)))

  :bind
  (;;("M-j" . pyim-convert-code-at-point)
   ;;("C-;" . pyim-delete-word-from-personal-buffer)
   ))
(provide 'init-package)
