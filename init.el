;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; require 首先它会查看变量 features 中是否存在所要加载的符号，如果不存在则使用 load 将其载入。
(when (>= emacs-major-version 26)
  (require 'package)
  ;; 在使用 package- 系列函数（例如 (package-install 'dash)) 之前必需调用 (package-initialize)
  (package-initialize)
  (add-to-list 'package-archives
	       '("melpa" . "https://melpa.org/packages/") t)
  )
;; 引入 common lisp 支持 
(require 'cl)

;; add whatever packages you want here
(defvar xingmu/packages '(
			  company
			  monokai-theme
			  hungry-delete
			  ;;smex
			  swiper
			  ;; swiper package depenicy
			  counsel  
			  smartparens
			  js2-mode
			  nodejs-repl
			  ;; 一般只有mac需要安装，用来让emacs找到变量
			  exec-path-from-shell
			  ) "Default packages")

;; package-selected-packages 
(setq package-selected-packages xingmu/packages)

(defun xingmu/packages-installed-p ()
  (loop for pkg in xingmu/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t))
  )

(unless (xingmu/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg xingmu/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg)))
  )

(setq user-emacs-directory "~/.emacs.d/")

;; 定义f1快捷键，打开配置文件 init.el
(defun open-my-init-file ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f12>") 'open-my-init-file)

;; 关闭菜单、滚动条和工具栏
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; 设置光标的默认样式
(setq-default cursor-type 'bar)
;; 显示行号
;; (global-linum-mode 0)
;; 在一万行的org-mode文件中，一旦折叠就光标死硬，Emacs无法使用！至此证实linum方案不可用。
;; 新的行号方案，Emacs26原生自带，2018-10-30
(global-display-line-numbers-mode)
;;行号右对齐，在C-h v中设置, 并且 Saved and Apply。
(setq global-display-line-numbers-width-start t)
;; 禁止生成备份文件
(setq make-backup-files nil)
;; 不知道为什么没有默认选中区域的高亮背景，重置一个
(set-face-attribute 'region nil ':background "yellow")

;; 为emacs-lisp-mode添加钩子，提供elisp括号匹配的功能
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)
;; 输入的时候替换选中区域的内容
(delete-selection-mode t)
;; 高亮当前行
(global-hl-line-mode t)

;; 主题 M+x load-theme monokai
(load-theme 'monokai t)

(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

;; https://emacs.stackexchange.com/questions/2999/how-to-maximize-my-emacs-frame-on-start-up/3017
;; 最大化启动,也可以 `emacs -mm`
;;(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; 全屏启动   也可以 `emacs -fs`，fullboth 相当于同时使用 fullheight fullwidth
;; (add-to-list 'default-frame-alist '(fullscreen . fullboth))

;; 和上面的效果相同
;; Start maximised (cross-platf)
;;(add-hook 'window-setup-hook 'toggle-frame-maximized t)
;; Start fullscreen (cross-platf)
;;(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; 和上面的效果相同
(toggle-frame-maximized)
;;(toggle-frame-fullscreen)

;; 关闭启动界面
(setq inhibit-splash-screen t)
;; 开启最近打开的文件模式
(recentf-mode 1)
(setq recentf-max-saved-item 30)  ;;default 20
(global-set-key "\C-x\C-r" 'recentf-open-files)

;; 对所有文件打开 company-mode 模式
(global-company-mode t)

;; 删除多余的空白
(require 'hungry-delete)
(global-hungry-delete-mode)

;; 自动生成匹配的括号/双引号等
(require 'smartparens-config)
;;(add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
(smartparens-global-mode t)

;;
(require 'nodejs-repl)

;; 当系统为mac的时候，初始化 exec-path-from-shell 库
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; config for js files
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       auto-mode-alist
       ))
;; smex
;;(require 'smex) ; Not needed if you use package.el
;;(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
					; when Smex is auto-initialized on its first run.
;;(global-set-key (kbd "M-x") 'smex)
;;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
;;(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; swiper
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)
(global-set-key (kbd "C-h l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0.08)
 '(company-minimum-prefix-length 1)
 '(custom-safe-themes
   (quote
    ("a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-external-variable ((t (:foreground "dark gray")))))
