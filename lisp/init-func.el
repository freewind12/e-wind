;;; usefull function
(defun c++-compile-single-file ()
  "Set compile-command for current C++ file to compile to ./bin/
Compile current C++ file to ./bin/ with same name (without extension).
Saves the buffer first if modified.
Creates ./bin/ if it doesn't exist.
Only compiles if source is newer than existing executable or executable missing."
  (interactive)
  (when (derived-mode-p 'c++-mode)
    (when (buffer-modified-p)
      (save-buffer))
    (let* ((src-file (buffer-file-name))
           (dir (file-name-directory src-file))
           (basename (file-name-sans-extension
                      (file-name-nondirectory src-file)))
           (bin-dir (expand-file-name "bin" dir))
           (executable (expand-file-name basename bin-dir)))
      ;; 创建 bin 目录（如不存在）
      (unless (file-directory-p bin-dir)
        (make-directory bin-dir t))
      ;; 判断是否需要重新编译
      (let* ((exec-exists (file-exists-p executable))
             (exec-time (when exec-exists
                          (file-attribute-modification-time
                           (file-attributes executable))))
             (src-time (file-attribute-modification-time
                        (file-attributes src-file)))
             (need-compile (or (not exec-exists)
                               (time-less-p exec-time src-time))))

        (if need-compile
            (let ((compile-cmd (format "g++ -g -o %s %s"
                                       (shell-quote-argument executable)
                                       (shell-quote-argument src-file))))
              ;; 设置 compile-command 方便后续 recompile
              (setq-local compile-command compile-cmd)

              ;; 同步执行编译，输出到 *compilation* 缓冲区
              (let ((ret (shell-command compile-cmd "*compilation*" "*compilation*")))
                ;; 启用编译错误解析模式
                (with-current-buffer "*compilation*"
                  (compilation-mode)
                  (goto-char (point-min)))

                (if (zerop ret)
                    (progn
                      (message "✅ Compilation successful: %s" executable)
                      executable)   ; 返回可执行文件路径
                  (progn
                    (message "❌ Compilation failed")
		    (pop-to-buffer "*compilation*")
                    nil))))        ; 返回 nil（失败）
          (progn
            (message "⏭️ Executable is up to date: %s" executable)
            executable))))))        ; 返回已有可执行文件路径

(defun c++-run (executable)
  (interactive)
  (if (and executable (file-exists-p executable))
      (async-shell-command executable "*c++-run*" "*c++-run*")
    (message "No valid executable to run")))

(defun c++-compile-run ()
  (interactive)
  (let ((exec (c++-compile-single-file)))
    (c++-run exec)))

(use-package cc-mode
  :bind
  (:map c++-mode-map
	("C-c <f5>" . c++-compile-run)))

(defun python-run()
  (interactive)
  (when (derived-mode-p 'python-mode)
    (when (buffer-modified-p)
      (save-buffer))
      (let* ((src-file (buffer-file-name))
	     (cmd (concat "python3 " src-file)))
	(async-shell-command cmd "*python-run*" "*python-run*"))))

(use-package python
  :bind
  (:map python-mode-map
	("C-c <f5>" . python-run)))


(provide 'init-func)
