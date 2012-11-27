(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(scheme-program-name "racket")
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;Python mode
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))

;Lua mode
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;PKGBUILD mode
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

;Marmalade setup
(require 'package)
(add-to-list 'package-archives
  '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;ParEdit
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))

;Slime setup
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(require 'slime)
(slime-setup)

;Setup email
(require 'mu4e)
(setq
 user-mail-address "david@tpflug.com"
 user-full-name "David Pflug"
 message-signature (concat "David Pflug")
 mu4e-maildir "~/Mail"
 mu4e-sent-folder "/Work/[Gmail]/Sent Mail"
 mu4e-drafts-folder "/Work/[Gmail]/Drafts"
 mu4e-trash-folder "/Work/[Gmail]/Trash"
 mu4e-refile-folder "/Work/[Gmail]/All Mail"
 message-kill-buffer-on-exit t)

(setq mu4e-sent-messages-behavior 'delete)
(setq mu4e-maildir-shortcuts
      '( ("/Work/INBOX"               . ?i)
	 ("/Home/[Gmail]/Sent Mail"   . ?s)
         ("/Home/[Gmail]/Trash"       . ?t)
         ("/Home/[Gmail]/All Mail"    . ?a)
	 ("/Work/SMSs"                . ?p)
	 ("/Home/INBOX"               . ?v)))

(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq sendmail-program "/usr/bin/msmtp")

(require 'pgg)
(setq pgg-default-user-id "david@tpflug.com")