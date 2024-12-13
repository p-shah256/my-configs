(setq user-full-name "Pranchal Shah"
      user-mail-address "p-shah256@proton.me")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq doom-theme 'doom-outrun-electric)

(setenv "SSH_AUTH_SOCK" "/run/user/1000/ssh-agent")

(setq org-directory "~/Documents/org/")
(setq org-hide-emphasis-markers t)


;; Main font configuration
(setq doom-font (font-spec :family "Iosevka Nerd Font Mono" :size 22 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font Mono" :size 20)
      doom-italic-font (font-spec :family "Iosevka Nerd Font Mono" :size 22 :slant 'italic)
      doom-big-font (font-spec :family "Iosevka Nerd Font Mono" :size 28)) ;; For presentations or sharing
(setq doom-themes-enable-italic t)
(setq doom-themes-enable-bold t)
(custom-set-faces!
  '(font-lock-comment-face :slant italic :weight light)
  '(font-lock-variable-name-face :slant italic :weight regular)
  '(font-lock-function-name-face :weight demibold)
  '(font-lock-keyword-face :weight bold)
  '(font-lock-constant-face :weight bold)
  '(font-lock-string-face :weight light :slant italic)
  '(font-lock-type-face :weight demibold))
(set-face-attribute 'italic nil
                    :family "Iosevka Nerd Font Mono"
                    :slant 'italic
                    :weight 'regular)
(setq-default line-spacing 0.12)



(after! which-key
  (setq which-key-idle-delay 0.2))

(use-package! company-statistics
  :after company
  :config
  (company-statistics-mode))

(after! company
  (setq company-idle-delay 0.1)  ; Set the delay to 0.1 seconds
  (setq company-minimum-prefix-length 1))  ; Start completion after 1 character

(use-package! lsp-treemacs
  :after lsp
  :config
  (lsp-treemacs-sync-mode 1))  ;; Auto-sync Treemacs with the current LSP session

(after! treemacs
  (treemacs-follow-mode t))  ;; Enable follow mode
(after! treemacs
  (setq treemacs-file-follow-delay 0.2))  ;; Delay updates by 0.2 seconds


(after! dap-mode
  (require 'dap-node)
  (dap-node-setup))

(map! :n "H" #'centaur-tabs-backward
      :n "L" #'centaur-tabs-forward)

(map! :n "SPC e" #'treemacs)

(after! evil
 (map! :leader
       (:prefix "s"
        :desc "Jump to mark" :n "r" #'counsel-evil-marks)))

(use-package! company-statistics
  :after company
  :config
  (company-statistics-mode))

(after! company
  (setq company-idle-delay 0.1)  ; Set the delay to 0.1 seconds
  (setq company-minimum-prefix-length 1)
  (add-to-list 'company-backends 'company-dabbrev)
)  ; Start completion after 1 character

(after! flycheck
  (setq flycheck-pos-tip-mode t)
  (setq flycheck-popup-tip-mode t))

(after! typescript-mode
  (setq typescript-indent-level 2))

(setq ob-mermaid-cli-path "/run/current-system/sw/bin/mmdc")

(use-package lsp-mode
  :hook
  (typescript-mode . lsp))

(after! lsp-mode
  (setq lsp-clients-clangd-executable "/run/current-system/sw/bin/clangd")
  (setq lsp-clients-clangd-capabilities (lsp-make-client-capabilities))
  (setq lsp-headerline-breadcrumb-enable t)

        ) ;; Customize if needed

(after! cc-mode
  (message "cc-module has been loaded.")
  ;; (setq c-basic-offset 4)
)

(after! lsp-mode
  (setq lsp-pyright-typechecking-mode "basic")) ;; Optional: Pyright type checking

(use-package! lsp-pylsp)

(add-hook 'python-mode-hook #'lsp)

(setq lsp-diagnostics-provider :auto)

(after! lsp-pylsp
  (setq lsp-pylsp-plugins-pylint-enabled t)  ;; Enable pylint
  (setq lsp-pylsp-plugins-flake8-enabled t)  ;; Enable flake8
  (setq lsp-pylsp-plugins-mypy-enabled t))  ;; Enable mypy

(use-package! dockerfile-mode
  :mode (("Dockerfile\\'" . dockerfile-mode)
         ("\\.dockerfile\\'" . dockerfile-mode)
         ("\\dockerfile\\'" . dockerfile-mode)
         ("/Dockerfile\\..*\\'" . dockerfile-mode)))
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(dockerfile-mode . "dockerfile"))
  (add-to-list 'lsp-disabled-clients '(dockerfile-mode . ts-ls)))

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.75))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.25))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.15))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
)
