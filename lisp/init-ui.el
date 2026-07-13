(use-package modus-themes
  :ensure t
  :init
  (load-theme 'modus-vivendi t)
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs t
	modus-themes-mixed-fonts t
	modus-themes-variable-pitch-ui t
	modus-themes-org-blocks 'gray-background))
(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t
	sml/theme 'respectful)
  (sml/setup))
(provide 'init-ui)
