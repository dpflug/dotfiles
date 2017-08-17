(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (gruvbox-dark-hard)))
 '(custom-safe-themes
   (quote
    ("8d3c5e9ba9dcd05020ccebb3cc615e40e7623b267b69314bdb70fe473dd9c7a8" default)))
 '(package-selected-packages
   (quote
    (gruvbox-theme nix-mode nixos-options pretty-mode ox-pandoc better-defaults pandoc pandoc-mode arduino-mode ox-html5slide ox-impress-js ox-tiddly ox-epub haxe-mode sly sly-quicklisp go-mode elpy direnv scad-mode scad-preview cdlatex picolisp-mode web-mode systemd sprunge smart-tabs-mode slime sicp rust-mode pkgbuild-mode paredit ox-reveal org-preview-html ob-ipython multiple-cursors minizinc-mode markdown-mode magit lua-mode lispy landmark json-mode haskell-mode gnuplot-mode gnuplot flymd flycheck-flow evil-tutor evil-numbers ein clojurescript-mode clojure-mode cedit)))
 '(send-mail-function (quote mailclient-send-it))
 '(tool-bar-mode nil)
 '(weechat-button-buttonize-emails t)
 '(weechat-button-buttonize-nicks t)
 '(weechat-button-buttonize-rfc t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; I like arrows on my line wrapping.
(set-language-environment "UTF-8")
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

; While we're prettying things up
(global-prettify-symbols-mode 1)

;Lua mode
(add-to-list 'auto-mode-alist '("\.lua\\'" . lua-mode))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;PKGBUILD mode
(add-to-list 'auto-mode-alist '("/PKGBUILD" . pkgbuild-mode))
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)

;ELPA setup
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

; Include some better defaults
(require 'better-defaults)
; But I don't like ido mode
(ido-mode 0)

;ParEdit
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(defun enable-paredit-mode ()
  (interactive)
  (paredit-mode +1))
(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook           'enable-paredit-mode)

;And highlight parens, etc
(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;Slime setup
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(require 'slime)
(cond ((file-accessible-directory-p "/usr/share/doc/HyperSpec")
       (setq common-lisp-hyperspec-root "/usr/share/doc/HyperSpec/"))
      ((file-accessible-directory-p "/usr/local/lisp/CLHS6/HyperSpec")
       (setq common-lisp-hyperspec-root "/usr/local/lisp/CLHS6/HyperSpec/")))
;(slime-setup) - Take care of in init.local.d now.

;Tramp setup
; Avoids issues with zsh causing it to hang. No benefit to using zsh within tramp.
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

; Set up smart tabs
(eval-after-load 'smart-tabs
  '(smart-tabs-insinuate 'c 'c++ 'java 'javascript 'cperl 'python 'ruby 'nxml))

; Web mode setup
(add-to-list 'auto-mode-alist '("\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.tpl\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.jsx?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.s?css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\.xml\\'" . web-mode))
(autoload 'web-mode "web-mode.el" "Major mode for web development, supporting HTML, CSS, templates, and more" t)
(setq web-mode-enable-engine-detection t)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-markup-indent-offset 2)


; #### This appears to be no longer needed. ####
;This is the default browse-url-default-browser with the addition of support for
;; ;browse-url-generic-program. Why is this not in here by default?
;; (defun browse-url-default-browser (url &rest args)
;;   "Find a suitable browser and ask it to load URL.
;; Default to the URL around or before point.

;; When called interactively, if variable `browse-url-new-window-flag' is
;; non-nil, load the document in a new window, if possible, otherwise use
;; a random existing one.  A non-nil interactive prefix argument reverses
;; the effect of `browse-url-new-window-flag'.

;; When called non-interactively, optional second argument NEW-WINDOW is
;; used instead of `browse-url-new-window-flag'."
;;   (apply
;;    (cond
;;     ((not (null browse-url-generic-program))
;;      'browse-url-generic)
;;     ((memq system-type '(windows-nt ms-dos cygwin))
;;      'browse-url-default-windows-browser)
;;     ((memq system-type '(darwin))
;;      'browse-url-default-macosx-browser)
;;     ((browse-url-can-use-xdg-open) 'browse-url-xdg-open)
;;     ((executable-find browse-url-gnome-moz-program) 'browse-url-gnome-moz)
;;     ((executable-find browse-url-mozilla-program) 'browse-url-mozilla)
;;     ((executable-find browse-url-firefox-program) 'browse-url-firefox)
;;     ((executable-find browse-url-chromium-program) 'browse-url-chromium)
;;     ((executable-find browse-url-galeon-program) 'browse-url-galeon)
;;     ((executable-find browse-url-kde-program) 'browse-url-kde)
;;     ((executable-find browse-url-netscape-program) 'browse-url-netscape)
;;     ((executable-find browse-url-mosaic-program) 'browse-url-mosaic)
;;     ((executable-find browse-url-xterm-program) 'browse-url-text-xterm)
;;     ((locate-library "w3") 'browse-url-w3)
;;     (t
;;      (lambda (&rest ignore) (error "No usable browser found"))))
;;    url args))

;Pull in local settings, if the file exists
(load "~/.emacs.d/init.local.el" 'ignore-unexisting)
