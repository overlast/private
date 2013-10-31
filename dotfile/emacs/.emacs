;======================================================================
; @overlast's configure file for GNU Emacs 23.4.1 or later
;
; How to use this .emacs file !?
;
; Step 1. Installing .emacs and elisp using github
;   $$ git clone git@github.com:overlast/private.git (Read / Write)
;     or
;   $$ git clone git://github.com/overlast/private.git (Read only)
;
; Step 2. Linking the files from $HOME
;   $$ ln -s private/dotfile/emacs/.emacs ~/
;   $$ ln -s private/dotfile/emacs/.emacs.d ~/
;
; Step 3. Installing other resources
;   $$ cpanm Project::Libs
;
; That's all !! Very easy !!
;
;======================================================================

(setq elpa-dir "~/.emacs.d/elpa")
(add-to-list 'load-path elpa-dir)

(require 'package)

; Add package-archives
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

; Initialize
(package-initialize)

(require 'cl)
(defvar installing-package-list
  '(
    ;; ここに使っているパッケージを書く。
    color-moccur
    flymake-easy
    recentf-ext
    anything
    helm
    popwin
    browse-kill-ring
    auto-complete
    color-theme
    melpa
    wdired
    session
;    zlc
    recentf
    flyspell
    flymake-cursor
    git-gutter
    git-gutter-fringe
    color-theme-solarized
    flymake-python-pyflakes
    ruby-mode
    gud
    google-c-style
    ))
(let ((not-installed (loop for x in installing-package-list
                            when (not (package-installed-p x))
                            collect x)
                     ))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))
    (byte-recompile-directory elpa-dir 0)))

; melpa.el
(require 'melpa)

;======================================================================
; control the messages of byte-compile-warnings
; http://d.hatena.ne.jp/kitokitoki/20100425/p1
;======================================================================

(setq byte-compile-warnings '(free-vars unresolved callargs redefine obsolete noruntime cl-functions interactive-only make-local))

;======================================================================
; el-get.el
; http://www.emacswiki.org/emacs/el-get
;======================================================================

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  (url-retrieve "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
                (lambda (s) (goto-char (point-max)) (eval-print-last-sexp))))

(setq el-get-sources
      '(el-get
        (:name perl-completion
               :description "perl-completion: minor mode provides useful features for editing perl codes"
               :type git
               :url "git://github.com/imakado/perl-completion.git"
               :load-path (".")
               )
        (:name auto-save-buffers
               :description "auto-save-buffers: Saving the buffers automaticaly every N seconds."
               :type http
               :url "http://0xcc.net/misc/auto-save/auto-save-buffers.el"
               :load-path (".")
               )
        (:name set-perl5lib
               :description "set-perl5lib"
               :type http
               ;:url "http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el"
               :url "https://gist.github.com/syohex/1333926/raw/cabc5569d82971dc9fedf3198c4ae1dd858381c3/set-perl5lib.el"
               :load-path (".")
               )
        (:name perlbrew-mini
               :description "perlbrew-mini"
               :type git
               :url "git://github.com/dams/perlbrew-mini.el.git"
               :load-path (".")
               )
        (:name plenv
               :description "plenv"
               :type git
               :url "git://github.com/karupanerura/plenv.el.git"
               :load-path (".")
               )
        (:name ac-python
               :description "ac-python"
               :type http
               :url "http://chrispoole.com/downloads/ac-python.el"
               :load-path (".")
               )
        (:name moccur-edit
               :description "moccur-edit"
               :type http
               :url "http://www.bookshelf.jp/elc/moccur-edit.el"
               :load-path (".")
               )
        (:name direx
               :description "direx"
               :type git
               :url "git://github.com/m2ym/direx-el.git"
               :load-path (".")
               )
        (:name dabbrev-ja
               :description "dabbrev-ja"
               :type http
               :url "http://namazu.org/~tsuchiya/elisp/dabbrev-ja.el"
               :load-path (".")
               )
        (:name dabbrev-highlight
               :description "dabbrev-highlight"
               :type http
               :url "http://www.namazu.org/~tsuchiya/elisp/dabbrev-highlight.el"
          :load-path (".")
          )
        (:name dmacro
               :description "dmacro"
               :type http
               :url "http://www.pitecan.com/papers/JSSSTDmacro/dmacro.el"
          :load-path (".")
          )
        (:name auto-highlight-symbol
               :type github
               :pkgname "emacsmirror/auto-highlight-symbol"
               )
        )
      )
(el-get 'sync)

;======================================================================
; Setting about languages and charactor encodings
;======================================================================

(setq inhibit-startup-message t) ; Don't show the starting message
(define-key global-map "\C-h" 'delete-backward-char) ; Backspace
(setq backup-inhibited t) ; Don't make backup files
(setq delete-auto-save-files t) ; Delete auto save files when you shutdown the Emacs
(setq completion-ignore-case t) ; Completion without recognizing ignore-case
(column-number-mode t) ; Show column(charactor) number of current cursor position
(line-number-mode t) ; Show line number of current cursor position
(setq kill-whole-line t) ; Delete line when you push the key of k only time
(setq require-final-newline t) ; Require newline at final line
(display-time) ; Show the current time at the mode line
(add-hook 'before-save-hook 'delete-trailing-whitespace) ; Delete last tabs and spaces on each lines when you save the buffer
(setq transient-mark-mode t) ; Show selected area
(global-set-key "\C-o" 'dabbrev-expand) ; Activate dinamic abbribiation decode
(global-set-key "\C-x\C-b" 'buffer-menu) ; Use current buffer when you open the buffer menu
(global-set-key "\C-xl" 'goto-line) ; Activate goto-line keybind
(setq history-length t) ; mini buffer history length. if you set t which means infinity.
(global-font-lock-mode t) ; coloring the global words on a buffer
(show-paren-mode 1) ; hilighting the parent bracket
(setq eshell-ask-to-save-history (quote always))
(setq eshell-hist-ignoredups t)
(setq eshell-glob-include-dot-dot nil)
(setq eshell-cmpl-cycle-completions t)
(global-hl-line-mode) ; hilighting cullent line
(setq hl-line-face 'underline) ; hilighting using under line
(savehist-mode 1) ; saving history of mini buffer
(setq recentf-max-saved-items 10000) ; setting length of recent open file list
(add-to-list 'default-frame-alist '(cursor-color . "SlateGray")) ; change the cursor color
(iswitchb-mode 1) ;; open muffer list in mini buffer (C-x b)
(global-auto-revert-mode 1) ;; revert file when a file is change in other buffer
(windmove-default-keybindings)

(global-set-key "\C-xp" (lambda () (interactive) (other-window -1))) ;; Go to previous window with inout C-x p

;======================================================================
;; use ultra rich occur
;; http://www.bookshelf.jp/soft/meadow_50.html#SEC746
;======================================================================

(require 'color-moccur)
;; http://d.hatena.ne.jp/higepon/20060222/1140579843
(setq color-occur-kill-occur-buffer t)
(setq *moccur-buffer-name-exclusion-list*
      '("\.svn" "\.git" "*Completions*" "*Messages*"))

;======================================================================
;; use editable search result of moccur
;; http://www.bookshelf.jp/soft/meadow_50.html#SEC769
;======================================================================

(el-get 'sync '(moccur-edit))
(load "moccur-edit")
(setq moccur-split-word t)

;======================================================================
;; dmacro
;; http://www.pitecan.com/papers/JSSSTDmacro/dmacro.el
;======================================================================

(defconst *dmacro-key* "\C-^" "repeat key setting")
(global-set-key *dmacro-key* 'dmacro-exec)
(el-get 'sync '(dmacro))
(autoload 'dmacro-exec "dmacro" nil t)

;======================================================================
;; zlc
;; http://d.hatena.ne.jp/mooz/20101003/p1
;======================================================================

;(require 'zlc)
;(setq zlc-select-completion-immediately t)
;(let ((map minibuffer-local-map))
;  ;;; like menu select
;  (define-key map (kbd "<down>")  'zlc-select-next-vertical)
;  (define-key map (kbd "<up>")    'zlc-select-previous-vertical)
;  (define-key map (kbd "<right>") 'zlc-select-next)
;  (define-key map (kbd "<left>")  'zlc-select-previous)
;  ;;; reset selection
;  (define-key global-map "\C-c" 'zlc-reset)
;  )

;======================================================================
;; http://namazu.org/~tsuchiya/elisp/dabbrev-ja.el
;======================================================================

(el-get 'sync '(dabbrev-ja))
(require 'dabbrev)
(load "dabbrev-ja")

;======================================================================
;; http://www.namazu.org/~tsuchiya/elisp/dabbrev-highlight.el
;======================================================================

(el-get 'sync '(dabbrev-highlight))
(require 'dabbrev-highlight)

;======================================================================
; Automatic spell checker
; http://www.clear-code.com/blog/2012/3/20.htm
;======================================================================

(setq ispell-program-name "aspell")
(setq ispell-grep-command "grep")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]")))

;======================================================================
; Allow chmod 755 when you save a script has '#!**' in first line
; http://www.clear-code.com/blog/2012/3/20.html
;======================================================================

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;======================================================================
; Adding directory name if there are some filenames which have same name.
; http://www.clear-code.com/blog/2012/3/20.html
;======================================================================

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;======================================================================
; Color Setting
; http://gnuemacscolorthemetest.googlecode.com/svn/html/index-c.html
;======================================================================

(require 'color-theme)
;(color-theme-initialize)
;(color-theme-solarized-dark)
(require 'color-theme-solarized)
(load-theme 'solarized-dark t)

;======================================================================
; git-gutter-fringe.el
; https://github.com/syohex/emacs-git-gutter-fringe
; http://emacs-jp.github.io/packages/vcs/git-gutter.html
;======================================================================

;; You need to install fringe-helper.el
;;(require 'git-gutter-fringe)
(global-git-gutter-mode t)
;; delete window-configuration-change-hook
(setq git-gutter:update-hooks '(after-save-hook after-revert-hook))


;======================================================================
; helm
; http://d.hatena.ne.jp/rubikitch/20100718/anything
;======================================================================

(require 'helm-config)
(setq helm-idle-delay             0.05
      helm-input-idle-delay       0.1
      helm-candidate-number-limit 100)
(helm-mode 1)
(when (require 'helm-config nil t)
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
;  (helm-dired-bindings 1)
)
;; 自動補完を無効
(custom-set-variables '(helm-ff-auto-update-initial-value nil))
;; C-hでバックスペースと同じように文字を削除
(define-key helm-c-read-file-map (kbd "C-h") 'delete-backward-char)
;; TABで任意補完。選択肢が出てきたらC-nやC-pで上下移動してから決定することも可能
(define-key helm-c-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

;======================================================================
; recent.el
;======================================================================

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 20)
(setq recentf-max-saved-items 100)
(define-key global-map "\C-x@" 'helm-recentf)

;======================================================================
; recentf-ext.el
; http://d.hatena.ne.jp/rubikitch/20091224/recentf
;======================================================================

(require 'recentf-ext)

;======================================================================
; wdired
; rでdiredがそのまま編集できる
;======================================================================

(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;======================================================================
; direx
; http://cx4a.blogspot.jp/2011/12/popwineldirexel.html
;======================================================================

(el-get 'sync '(direx))
(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
;(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;======================================================================
; popwin.el
; http://d.hatena.ne.jp/m2ym/20110120/1295524932
; http://d.hatena.ne.jp/hirose31/20110302/1299062869
;======================================================================

(setq pop-up-windows nil)
(require 'popwin nil t)
(when (require 'popwin nil t)
  (setq anything-samewindow nil)
  (setq display-buffer-function 'popwin:display-buffer)
  (push '("anything" :regexp t :height 0.5) popwin:special-display-config)
  (push '("helm" :regexp t :height 0.5) popwin:special-display-config)
  (push '("*Completions*" :height 0.4) popwin:special-display-config)
  (push '("*compilation*" :height 0.4 :noselect t :stick t) popwin:special-display-config)
  (push '("*Kill Ring*" :height 0.4) popwin:special-display-config)
  (push '("*Help*" :height 0.4) popwin:special-display-config)
  (push '("*Compile-Log*" :height 10 :noselect t) popwin:special-display-config)
  )

;======================================================================
; browse-kill-ring
; http://www.yumi-chan.com/emacs/emacs_el_medium.html
;======================================================================

(el-get 'sync '(browse-kill-ring))
(require 'browse-kill-ring)
;(global-set-key "\M-y" 'browse-kill-ring)
(make-face 'separator)
(set-face-bold-p 'separator t)
(setq browse-kill-ring-separator "--------------------------------"
      browse-kill-ring-separator-face 'separator
      browse-kill-ring-quit-action 'save-and-restore
      browse-kill-ring-highlight-current-entry t)
(defvar ctl-y-map (make-keymap))
(fset 'ctl-y-prefix ctl-y-map)
(define-key global-map "\C-y"  'ctl-y-prefix)
(define-key global-map "\C-y\C-y"    'yank)
(define-key global-map "\C-yy"    'browse-kill-ring)

;======================================================================
; Session
; Saving information about kill-ring and files which you opened in mini buffer
; http://0xcc.net/unimag/3/
;======================================================================

(require 'session)
(when (require 'session nil t)
  (add-hook 'after-init-hook 'session-initialize)
  (setq session-initialize '(de-saveplace session keys menus places)
        session-globals-include '((kill-ring 50)
                                    (session-file-alist 500 t)
                                      (file-name-history 10000)))
  (setq session-globals-max-string 100000000)
  (setq history-length t)
  (setq session-undo-check -1) ; Redume cursor position when you close the file.
)
;; http://sakito.jp/moin/moin.cgi/session.el
;; kill-ring 内の重複を排除する
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

;;======================================================================
;; Setting about languages and charactor encodings
;;======================================================================
;;(require 'un-define)
;;(set-language-environment "Japanese")
;;(set-terminal-coding-system 'utf-8)
;;(set-keyboard-coding-system 'utf-8)
;;(set-buffer-file-coding-system 'utf-8)
;;(setq default-buffer-file-coding-system 'utf-8)
;;(prefer-coding-system 'utf-8)
;;(set-default-coding-systems 'utf-8)
;;(setq file-name-coding-system 'utf-8)

;======================================================================
; auto-save-buffers
; http://0xcc.net/misc/auto-save/
;======================================================================

(el-get 'sync '(auto-save-buffers))
(require 'auto-save-buffers)
(run-with-idle-timer 5 t 'auto-save-buffers)

;======================================================================
; Pushy
;======================================================================

;(el-get 'sync '(pushy))
;(require 'pushy)
;(setq pushy-keys
;      (list (cons (kbd "C-<return>") 'pushy-insert-item)    ; 候補を入力
;            ;; (cons (kbd "<ESC>") 'pushy-cleanup)  ; 通常の補完ができなくなるのでいらん
;            (cons (kbd "C-<up>") 'pushy-previous-line)
;            (cons (kbd "C-<down>") 'pushy-next-line)
;            (cons (kbd "C-<prior>") 'pushy-previous-page)
;            (cons (kbd "C-<next>") 'pushy-next-page)))
;(setq pushy-enable-globally nil)
;(put 'eval-expression 'pushy-completion 'enabled)
;(put 'shell-command 'pushy-completion 'enabled)
;(put 'shell-command-on-region 'pushy-completion 'enabled)
;(pushy-mode 1)

;======================================================================
; Auto Complete Mode
; http://cx4a.org/software/auto-complete/manual.ja.html
;======================================================================

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete)
(ac-config-default)

;======================================================================
; Auto Highlight Symbol
; https://github.com/kmmbvnr/emacs-config/blob/master/elisp/auto-highlight-symbol-config.el
;======================================================================

(el-get 'sync '(auto-highlight-symbol))
(require 'auto-highlight-symbol-config)
(global-auto-highlight-symbol-mode t)

;======================================================================
; FlyMake
; http://www.emacswiki.org/emacs-zh/FlyMake
; http://d.hatena.ne.jp/sugyan/20120103/1325601340
;======================================================================

(require 'flymake)
(require 'flymake-cursor)

(set-face-background 'flymake-errline "red4")
(set-face-foreground 'flymake-errline "black")
(set-face-background 'flymake-warnline "yellow")
(set-face-foreground 'flymake-warnline "black")

;; Print error message on mini-buffer
;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (flymake-goto-next-error)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)
          )
        )
      (setq count (1- count)
            )
      )
    )
  )

; makefile mode
; http://d.hatena.ne.jp/kiki114/20101102/1288675441
(setq auto-mode-alist
      (append '(("Makefile\\..*$" . makefile-gmake-mode)
                ("Makefile_.*$" . makefile-gmake-mode)
                ) auto-mode-alist))
(autoload 'c++-mode "makefile-gmake-mode" nil t)
;; remove hook to save \t character
(eval-after-load "makefile-gmake-mode"
  '(progn (
           (remove-hook 'before-save-hook 'delete-trailing-whitespace)
           )
          ))

; C++ mode
; http://d.hatena.ne.jp/suztomo/20080905/1220633281

(autoload 'c++-mode "cc-mode" nil t)
(eval-after-load "cc-mode"
  '(progn
     (defun flymake-cc-init ()
       (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                            'flymake-create-temp-inplace))
              (local-file  (file-relative-name
                            temp-file
                            (file-name-directory buffer-file-name))))
         (list "g++" (list "-Wall" "-pedantic" "-Wextra" "-fsyntax-only" local-file))))
     (push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
     (push '("\\.hpp$" flymake-cc-init) flymake-allowed-file-name-masks)
     (push '("\\.cc$" flymake-cc-init) flymake-allowed-file-name-masks)
     ;; google-c-style

     (require 'google-c-style)
     (add-hook 'c-mode-common-hook 'google-set-c-style)
     (add-hook 'c-mode-common-hook 'google-make-newline-indent)

     (add-hook 'c++-mode-hook
               '(lambda ()
                  (define-key c-mode-base-map "\C-c\C-c" 'comment-region)
                  (define-key c-mode-base-map "\C-c\M-c" 'uncomment-region)
                  (define-key c-mode-base-map "\C-cg"    'gdb)
                  (define-key c-mode-base-map "\C-cc"    'make)
                  (define-key c-mode-base-map "\C-ce"    'c-macro-expand)
                  (define-key c-mode-base-map "\C-ct"    'toggle-source)

                  (setq-default tab-width 2 indent-tabs-mode nil) ; Set tab width and replace indent tabsto spaces
                  (define-key c++-mode-map "\C-cd" 'flymake-display-err-minibuf)
                  (c-toggle-auto-hungry-state 1) ; inserting newline and indent when you push ';'
                  (define-key c-mode-base-map "\C-m" 'newline-and-indent) ; inserting newline and indent hen you push '\n'
                  (flymake-mode t)
                  ))
     ))

;
; C mode
(autoload 'c-mode "cc-mode" nil t)
(eval-after-load "cc-mode"
  '(progn
     (defun flymake-c-init ()
       (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                            'flymake-create-temp-inplace))
              (local-file  (file-relative-name
                            temp-file
                            (file-name-directory buffer-file-name))))
         (list "gcc" (list "-Wall" "-pedantic" "-Wextra" "-fsyntax-only" local-file))))
     (push '("\\.c$" flymake-c-init) flymake-allowed-file-name-masks)

     ;; google-c-style
     (require 'google-c-style)
     (add-hook 'c-mode-common-hook 'google-set-c-style)
     (add-hook 'c-mode-common-hook 'google-make-newline-indent)

     (add-hook 'c-mode-hook
               '(lambda ()

                  (define-key c-mode-base-map "\C-c\C-c" 'comment-region)
                  (define-key c-mode-base-map "\C-c\M-c" 'uncomment-region)
                  (define-key c-mode-base-map "\C-cg"       'gdb)
                  (define-key c-mode-base-map "\C-cc"       'make)
                  (define-key c-mode-base-map "\C-ce"       'c-macro-expand)
                  (define-key c-mode-base-map "\C-ct"        'toggle-source)

                  (setq-default tab-width 2 indent-tabs-mode nil) ; Set tab width and replace indent tabsto spaces
                  (define-key c-mode-map "\C-cd" 'flymake-display-err-minibuf)
                  (c-toggle-auto-hungry-state 1) ; inserting newline and indent when you push ';'
                  (define-key c-mode-base-map "\C-m" 'newline-and-indent) ; inserting newline and indent hen you push '\n'
                  (flymake-mode t)
                  ))
     ))

;;
;; GDB mode
(require 'gud)
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)
(setq gud-tooltip-echo-area nil)

(defun gdb-set-clear-breakpoint ()
  (interactive)
  (if (or (buffer-file-name) (eq major-mode 'gdb-assembler-mode))
      (if (or
           (let ((start (- (line-beginning-position) 1))
                 (end (+ (line-end-position) 1)))
             (catch 'breakpoint
               (dolist (overlay (overlays-in start end))
                 (if (overlay-get overlay 'put-break)
                          (throw 'breakpoint t)))))
           (eq (car (fringe-bitmaps-at-pos)) 'breakpoint))
          (gud-remove nil)
        (gud-break nil))))

(defun gud-kill ()
  "Kill gdb process."
  (interactive)
  (with-current-buffer gud-comint-buffer (comint-skip-input))
  (kill-process (get-buffer-process gud-comint-buffer)))

(add-hook
 'gdb-mode-hook
 '(lambda ()
    (interactive)
    (gud-tooltip-mode t)
    (gud-def gud-break-main "break main" nil "Set breakpoint at main.")

    (define-key gud-mode-map (kbd "C-c b") 'gud-break-main)
    (define-key gud-mode-map (kbd "<f5>") 'gud-run);ブレークポイントに会うまで実行
    (define-key gud-mode-map (kbd "C-c c") 'gud-cont);ブレークポイントに会うまで実行
    (define-key gud-mode-map (kbd "<f6>") 'gud-next);1行進む
    (define-key gud-mode-map (kbd "<f7>") 'gud-step);1行進む.関数に入る
    (define-key gud-mode-map (kbd "<f8>") 'gud-print)
    (define-key gud-mode-map (kbd "<f9>") 'gdb-set-clear-breakpoint)
    (define-key gud-mode-map (kbd "C-c w") 'gud-watch);変数の値を見る
    (define-key gud-mode-map (kbd "C-c t") 'gud-tbreak);一時的なブレークポイント設置
    (define-key gud-mode-map (kbd "C-c u") 'gud-until);現在の行まで実行
    (define-key gud-mode-map (kbd "C-c f") 'gud-finish);step out 現在のスタックフレームを抜ける
    (define-key gud-mode-map (kbd "C-c v") 'gud-pv)
    (define-key gud-mode-map (kbd "C-c r") 'gud-refresh)
 ))

;; Perl mode
;; http://ash.roova.jp/perl-to-the-people/emacs-cperl-mode.html
;; http://d.hatena.ne.jp/antipop/20110413/1302671667
;; http://search.cpan.org/dist/Project-Libs/lib/Project/Libs.pm
;; http://d.hatena.ne.jp/sugyan/20120227/1330343152

(autoload 'cperl-mode "cperl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|psgi\\|t\\|cgi\\)$" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
(defalias 'perl-mode 'cperl-mode) ;; show preference for cperl-mode
(eval-after-load "cperl-mode"
  '(progn
     ;; https://github.com/kentaro/perlbrew.el/blob/master/perlbrew.el
     ;; https://github.com/dams/perlbrew-mini.el
     ;;     (el-get 'sync '(perlbrew-mini))
     ;;     (require 'perlbrew-mini)

     ;; https://github.com/karupanerura/plenv.el
     (el-get 'sync '(plenv))
     (require 'plenv)

     ;; (perlbrew-mini-use-latest)
     ;; (perlbrew-mini-use "perl-5.16.2")

     ;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
     (el-get 'sync '(set-perl5lib))
     (require 'set-perl5lib)

     (defvar flymake-perl-err-line-patterns
       '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

     (defconst flymake-allowed-perl-file-name-masks
       '("\\.\\([pP][Llm]\\|psgi\\|t\\|cgi\\)$" flymake-perl-init))
     (add-to-list 'flymake-allowed-file-name-masks
                  '("\\.t$" flymake-perl-init))


     (defun flymake-perl-init ()
       (let* ((temp-file (flymake-init-create-temp-buffer-copy
                          'flymake-create-temp-inplace))
              (local-file (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
         ;;(list (perlbrew-mini-get-current-perl-path) (list "-MProject::Libs" "-wc" local-file))
         (list (guess-plenv-perl-path) (list "-wc" local-file))
         ))

     (defun flymake-perl-load ()
       (interactive)
       ;; http://d.hatena.ne.jp/sugyan/20100705/1278306885
       (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
         (setq flymake-check-was-interrupted t))
       (ad-activate 'flymake-post-syntax-check)
       (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
       (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
       (set-perl5lib)
       (flymake-mode t)
       )

     (add-hook 'cperl-mode-hook (lambda ()
                                  ;; Set tab width and replace indent tabs to spaces
                                  (setq indent-tabs-mode nil)
                                  (setq cperl-font-lock t)
                                  (cperl-set-style "PerlStyle")

                                  (setq cperl-close-paren-offset -4)
                                  (setq cperl-continued-statement-offset 4)
                                  (setq cperl-indent-level 4)
                                  (setq cperl-indent-parens-as-block t)
                                  (setq cperl-tab-always-indent t)
                                  (setq cperl-label-offset -4)
                                  (setq cperl-highlight-variables-indiscriminately t)

                                  ;; http://d.hatena.ne.jp/IMAKADO/20081129/1227893458
                                  (el-get 'sync '(perl-completion))
                                  (require 'perl-completion)

                                  ;; http://d.hatena.ne.jp/sugyan/20120103/1325523629
                                  (interactive)

                                  (defvar ac-source-my-perl-completion
                                    '((candidates . plcmp-ac-make-cands)))
                                  (add-to-list 'ac-sources 'ac-source-my-perl-completion)

                                  (perl-completion-mode t)
                                  (flymake-perl-load)
                                  ))
     ))

;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            ;; Set tab width and replace indent tabs to spaces
            (setq-default tab-width 2 indent-tabs-mode nil)))

(autoload 'python "python" nil t)
(defalias 'python-mode 'python)
(eval-after-load "python"
  '(progn
     ;; https://github.com/purcell/flymake-python-pyflakes
     (defun flymake-python-load ()
       (interactive)
       (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
         (setq flymake-check-was-interrupted t))
          (ad-activate 'flymake-post-syntax-check)
          (flymake-mode t))
     (add-hook 'python-mode-hook (lambda ()
                                   (require 'flymake-python-pyflakes)
                                   (flymake-python-pyflakes-load)

                                   (setq flymake-python-pyflakes-executable "flake8")
                                   ;; ignore the character counting process for a comment line
                                   (setq flymake-python-pyflakes-extra-arguments '("--ignore=E501"))
                                   (interactive)

                                   (el-get 'sync '(ac-python))
                                   (require 'ac-python)
                                   (add-to-list 'ac-modes 'python-2-mode)
                                   (flymake-python-load)))))

;; flymake-ruby
(autoload 'ruby-mode "ruby-mode" nil t)
(eval-after-load "ruby-mode"
  '(progn
     (defun flymake-ruby-init ()
       (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                            'flymake-create-temp-inplace))
              (local-file  (file-relative-name
                            temp-file
                            (file-name-directory buffer-file-name))))
         (list "ruby" (list "-w" local-file))))
     (push '(".+\\.\\(rb\\|rake\\)$" flymake-ruby-init) flymake-allowed-file-name-masks)
     (push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
     (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
     (defun flymake-ruby-load ()
       (interactive)
       ;; http://d.hatena.ne.jp/sugyan/20100705/1278306885
       (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
         (setq flymake-check-was-interrupted t))
       (ad-activate 'flymake-post-syntax-check)
       (flymake-mode t))
     (add-hook 'ruby-mode-hook (lambda ()
                                 (interactive)
                                 ;; Don't want flymake mode for ruby regions in rhtml files and also on read
                                 (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                                     (flymake-ruby-load))
                                 ))))

;======================================================================
; Flyspell
;======================================================================

;;; activate Flyspell for all input
(defun flyspell-mode-hooks ()
   (flyspell-mode))
(add-hook 'changelog-mode-hook 'flyspell-mode-hooks)
(add-hook 'text-mode-hook 'flyspell-mode-hooks)
(add-hook 'latex-lisp-common-hook 'flyspell-mode-hooks)

;;; activate Flyspell for comment
(defun flyspell-prog-mode-hooks ()
   (flyspell-prog-mode))
(add-hook 'c-mode-common-hook 'flyspell-prog-mode-hooks)
(add-hook 'cperl-mode-hook 'flyspell-prog-mode-hooks)
(add-hook 'emacs-lisp-common-hook 'flyspell-prog-mode-hooks)
(add-hook 'python-mode-hook 'flyspell-prog-mode-hooks)
(add-hook 'ruby-mode-hook 'flyspell-prog-mode-hooks)
