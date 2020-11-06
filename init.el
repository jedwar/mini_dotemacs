;;; init.el --- Emacs Initialization and Configuration
;; Copyright (C) 2018-2020 Jimmy Aguilar Mena

;; Author: Jimmy Aguilar Mena
;; Version: 0.1
;; Package-Requires: (())
;; Keywords:
;; URL:
;;; Commentary:
;;; Code:

(setq package-quickstart t)

(setq-default auto-revert-verbose nil)	;; not show message when file changes
(global-auto-revert-mode t)		;; Autoload files changed in disk

(setq-default display-line-numbers-widen t) ;; keep line numbers inside a narrow
(global-display-line-numbers-mode t)	;; line numbers on the left

(global-display-fill-column-indicator-mode t)

(savehist-mode t)			;; Historial
(auto-compression-mode t)		;; Uncompress on the fly

(size-indication-mode t)		;; Muestra el el tamanno en modeline
(delete-selection-mode t)		;; Sobreescribe seleccion al pegar

(prefer-coding-system 'utf-8)	        ;; Encoding
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(column-number-mode t)			;; Numero de la columna
(line-number-mode t)			;; Numero de linea modeline

(save-place-mode t)                     ;; Remember point in files

(setq-default vc-follow-symlinks t	    ;; Open links not open
	      ;;tab-always-indent complete  ;; make tab key do indent only
	      initial-scratch-message ";; Welcome Jimmy!!"
	      ring-bell-function #'ignore
	      user-full-name "Jimmy Aguilar Mena"
	      inhibit-startup-message t
	      inhibit-startup-screen t
	      ;;tab-width 4		    ;; Tabulador a 4
	      ;;indent-tabs-mode t	    ;; Indent with tabs
	      ;;fill-column 80		    ;; default is 70
	      make-backup-files nil	    ;; Sin copias de seguridad
	      create-lockfiles nil	    ;; No lock files, good for tramp
	      visible-bell nil		    ;; Flash the screen (def)
	      display-line-numbers-width 4  ;; Minimum line number width
	      confirm-kill-processes nil    ;; no ask kill processes on exit
	      read-key-delay 0.01
	      recenter-redisplay nil
	      ;;recenter-positions '(top middle bottom)
	      line-move-visual nil
	      backward-delete-char-untabify-method nil ;; Don't untabify on backward delete

	      ;; split-width-threshold 160  ;; Limite para split vertical
	      ;; kill-whole-line t
	      ;; load-prefer-newer t
	      ;; mark-even-if-inactive nil	    ;; no mark no region
	      next-screen-context-lines 5           ;; Lines of continuity when scrolling
	      fast-but-imprecise-scrolling t
	      scroll-error-top-bottom t	    ;; Move cursor before error scroll
	      scroll-preserve-screen-position t	  ;; Cursor keeps screen pos
	      scroll-margin 1		    ;; Margen al borde
	      scroll-step 1		    ;; Scroll step (better conservatively)
	      scroll-conservatively 1000
	      window-combination-resize t   ;; Windows resize proportional
	      x-wait-for-event-timeout nil  ;; Espera por eventos en X
	      jit-lock-stealth-load 60
	      jit-lock-stealth-time 4
	      inhibit-default-init t	    ;; Avoid emacs default init
	      term-suppress-hard-newline t  ;; Text can resize
	      echo-keystrokes 0.01	    ;; Muestra binds in echo area
	      confirm-kill-emacs nil        ;; No confirm exit emacs
	      disabled-command-function nil
	      auto-save-default nil         ;; No autosave
	      auto-save-list-file-name nil
	      ;; minibuffer interaction
	      minibuffer-message-timeout 1
	      read-quoted-char-radix 16     ;; Read number of chars with C-q
	      kill-buffer-query-functions nil

	      eval-expression-print-length nil
	      eval-expression-print-level nil
	      tab-bar-show 1
	      suggest-key-bindings t
	      )

;; These two must be enabled/disabled together
;; (setq enable-recursive-minibuffers t) ;; Enable nesting in minibuffer
;; (minibuffer-depth-indicate-mode 1)    ;; Mostrar nivel de nesting en minibuffer

(fido-mode t)
(setq completion-auto-help nil)
;; show choices verticall
;; (setq icomplete-separator "\n")
;; (setq icomplete-hide-common-prefix nil)
;; (setq icomplete-in-buffer t)

(ffap-bindings)

;;__________________________________________________________
;; Config file not here to not track it
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))

(load custom-file)

;; Personal Lisp dir
(defvar mylisp-dir (expand-file-name "lisp" user-emacs-directory))

(unless (file-exists-p mylisp-dir)
  (make-directory mylisp-dir)
  (message "Creating %s" mylisp-dir))

(add-to-list 'load-path "~/.emacs.d/lisp/")


;;__________________________________________________________
;; The Colors (I want to change this for a real theme, there are maaaaany)

(load-theme 'simple-16)
(set-face-attribute 'default t :font "Hack")

(defmacro named-color (colorname)
  "Get color by name COLORNAME from `my/colors' alist."
  (simple-16-theme-color colorname))


;;__________________________________________________________
;; I don't want confirm exit, not write yes-not either
(defalias 'yes-or-no-p 'y-or-n-p) ;; Reemplazar "yes" por "y" en el prompt

;;__________________________________________________________
;; Show paren mode
(setq-default show-paren-delay 0
	      blink-matching-paren nil)
(show-paren-mode t)	  ;; Highlight couple parentesis

;;__________________________________________________________
;; Isearch

(setq search-nonincremental-instead nil  ;; No incremental if enter & empty
      lazy-highlight-initial-delay 0
      isearch-allow-scroll t 	         ;; Permit scroll can be 'unlimited
      isearch-lazy-count t
      isearch-yank-on-move 'shift)       ;; Copy text from buffer with meta

;;__________________________________________________________
;; ssh
(setq-default compilation-scroll-output 'first-error
	      tramp-auto-save-directory "~/.emacs.d/tramp-autosave-dir"
	      tramp-default-method "rsync"
	      ;;tramp-default-method "ssh"
	      ;;tramp-change-syntax 'simplified
	      tramp-use-ssh-controlmaster-options nil
	      tramp-completion-reread-directory-timeout t
	      tramp-persistency-file-name "~/.emacs.d/tramp")
;;(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

(defun my/term-mode-hook () "My term mode hook."
       (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
       (setq-local mouse-yank-at-point t)
       (setq-local transient-mark-mode nil)
       (display-line-numbers-mode -1)
       (display-fill-column-indicator-mode -1)
       (auto-fill-mode -1))

(add-hook 'term-mode-hook 'my/term-mode-hook)

;;__________________________________________________________
;; minibuffers

;; (setq minibuffer-eldef-shorten-default t)

(defun my/minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my/minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000)
  (garbage-collect))

(add-hook 'minibuffer-setup-hook #'my/minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my/minibuffer-exit-hook)

;;__________________________________________________________
;; gdb rectangles

(setq gdb-many-windows nil
      gdb-show-main t)

;;__________________________________________________________
;;	Seleccionar con el mouse

(xterm-mouse-mode t) ;; mover el cursor al click
(defun track-mouse (e))
(setq-default mouse-sel-mode t ;; Mouse selection
	      mouse-scroll-delay 0
	      mouse-wheel-scroll-amount '(5 ((shift) . 1) ((control)))
	      mouse-wheel-progressive-speed nil)

(set-mouse-color "white")		;; Flechita del mouse en blanco

(if (fboundp 'mouse-wheel-mode)
    (mouse-wheel-mode t))		;; scrolling con el mouse

(defun my/scroll-up-command (&optional arg)
  (interactive "^P")
  (if arg
      (scroll-up-command arg)
    (scroll-up-command 1)))

(defun my/scroll-down-command (&optional arg)
  (interactive "^P")
  (if arg
      (scroll-down-command arg)
    (scroll-down-command 1)))

(defun gcm-scroll-up ()
  (interactive)
  (scroll-down 1))

(global-set-key [remap scroll-up-command] 'my/scroll-up-command)
(global-set-key [remap scroll-down-command] 'my/scroll-down-command)

;;__________________________________________________________
;; My program's mode hooks

(defun my/prog-mode-hook () "Some hooks only for prog mode."
       ;;(electric-indent-mode t)	    ;; On by default
       (electric-pair-mode t)		    ;; Autoannadir parentesis
       (which-function-mode t)		    ;; Shows the function in spaceline

       ;;(define-key global-map (kbd "RET") 'newline-and-indent)
       (electric-indent-local-mode t)
       (setq show-trailing-whitespace t)

       (defun smart-beginning-of-line ()
	 "Move point to first non-whitespace character or beginning-of-line."
	 (interactive)
	 (let ((oldpos (point)))
	   (back-to-indentation)
	   (and (= oldpos (point))
		(beginning-of-line))))

       (global-set-key (kbd "C-a") 'smart-beginning-of-line))

(add-hook 'prog-mode-hook #'my/prog-mode-hook)


;;__________________________________________________________
;; C common mode (for all c-like languajes)

(defvar c-ms-space-for-alignment t
  "Control ms-space-for-alignment.")
(make-variable-buffer-local 'c-ms-space-for-alignment)

(defun ms-space-for-alignment ()
  "Make the current line use tabs for indentation and spaces for alignment.

It is intended to be called from the hook
`c-special-indent-hook'.  It assumes that `indent-tabs-mode' is
non-nil and probably assumes that `c-basic-offset' is the same as
`tab-width'."
  (save-excursion
    (let* ((indent-pos (progn (back-to-indentation) (point)))
	   (indent-col (current-column))
	   (syn-elt (car c-syntactic-context))
	   (syn-sym (c-langelem-sym syn-elt)))
      (when (memq syn-sym '(arglist-cont-nonempty
			    stream-op
			    template-args-cont)) ;; <==============
	(let* ((syn-anchor (c-langelem-pos syn-elt))
               (anchor-col (progn (goto-char syn-anchor)
				  (back-to-indentation)
				  (current-column))))
	  ;;
	  (goto-char indent-pos)
	  (delete-horizontal-space)
	  (insert-char ?\t (/ anchor-col tab-width))
	  (insert-char ?\  (- indent-col (current-column)))))))
  (when (= (current-column) 0)
    (back-to-indentation)))

(defun c-toggle-ms-space-for-alignment (&optional arg)
  "Toggle align with spaces."
  (interactive "P")
  (setq c-ms-space-for-alignment
	(c-calculate-state arg c-ms-space-for-alignment))
  (if c-ms-space-for-alignment
      (when (and c-ms-space-for-alignment
		 indent-tabs-mode
		 (= c-basic-offset tab-width))
	(add-hook 'c-special-indent-hook #'ms-space-for-alignment nil t))
    (remove-hook 'c-special-indent-hook #'ms-space-for-alignment t)))

;;====================

(defun my/c-semi&comma ()
  (assq 'class-close c-syntactic-context)
  )

(c-add-style "mylinux"
	     '("linux"
	       (tab-width . 4)
	       (c-basic-offset . 4)
	       (indent-tabs-mode . t)
	       (fill-column . 80)
	       (c-hanging-semi&comma-criteria . my/c-semi&comma)
	       (c-cleanup-list empty-defun-braces ;; {}
			       brace-else-brace   ;; } else {
			       brace-elseif-brace ;; } else if {
			       ;;defun-close-semi   ;; };
			       )
	       (c-hanging-braces-alist (brace-list-open)
				       (brace-entry-open)
				       (substatement-open after)
				       (block-close . c-snug-do-while)
				       (arglist-cont-nonempty)
				       (class-open . (after))
				       (class-close . (before)))
	       (c-offsets-alist (inline-open . 0)
				(comment-intro . 0))))

(setq-default c-default-style
	      '((java-mode . "java")
		(awk-mode . "awk")
		(other . "mylinux")))

(defun my/c-mode-common-hook () "My hook for C and C++."
       (c-toggle-auto-newline 1)
       (c-toggle-cpp-indent-to-body 1)
       (c-toggle-ms-space-for-alignment 1)
       (message "Loaded my/c-mode-common"))

(add-hook 'c-mode-common-hook 'my/c-mode-common-hook)

;;__________________________________________________________
;; sh mode

(defvaralias 'sh-basic-offset 'tab-width)
(defun my/sh-mode-hook () "My term mode hook."
       (setq-local indent-tabs-mode t))

(add-hook 'sh-mode-hook 'my/sh-mode-hook)

;;__________________________________________________________
;; Move split keybindings
(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)

;;__________________________________________________________
;; Undo
(global-set-key [remap undo] 'undo-only)
(global-set-key (kbd "C-M-_") 'undo-redo)


;;__________________________________________________________
;; Winner mode
(setq winner-dont-bind-my-keys t)
(winner-mode t)
(global-set-key (kbd "C-x w r")  'winner-undo)
(global-set-key (kbd "C-x w u")  'winner-redo)

;;__________________________________________________________
;; Abbrev mode
(abbrev-mode t)

;;__________________________________________________________
;; ibuffer
(defalias 'list-buffers 'ibuffer)
(global-set-key [list-buffers] 'ibuffer)

;;__________________________________________________________
;; dired

(defun my/dired-hook () "My dired hook."
       (setq-default dired-recursive-copies 'top   ;; Always ask recursive copy
		     dired-recursive-deletes 'top  ;; Always ask recursive delete
		     dired-dwim-target t	   ;; Copy in split mode with p
		     dired-auto-revert-buffer t
		     ;;dired-x-hands-off-my-keys nil
		     )
       (require 'dired-x)
       (put 'dired-find-alternate-file 'disabled nil)
       (define-key dired-mode-map (kbd "RET")
	 'dired-find-alternate-file)   ; was dired-advertised-find-file
       (define-key dired-mode-map (kbd "^")    ; was dired-up-directory
	 (lambda () (interactive) (find-alternate-file ".."))))

(add-hook 'dired-load-hook 'my/dired-hook)

(provide 'init)
;;; init.el ends here
