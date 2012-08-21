;======================================================================
; @overlast's configure file of Emacs GNU Emacs 23.4.1 or later
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
    (lambda (s) (goto-char (point-max)) (eval-print-last-sexp))
  )
)
(setq el-get-sources
 '(el-get
   (:name auto-save-buffers
          :description "auto-save-buffers: Saving the buffers automaticaly every N seconds."
          :type http
          :url "http://0xcc.net/misc/auto-save/auto-save-buffers.el"
          :load-path (".")
          )
   (:name minibuf-isearch
          :description "minibuf-isearch: Incremental search for mini buffer."
          :type http
          :url "http://www.sodan.org/~knagano/emacs/minibuf-isearch/minibuf-isearch.el"
          :load-path (".")
          )
   (:name set-perl5lib
          :description "set-perl5lib"
          :type http
          :url "http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el"
          :load-path (".")
          )
   (:name perlbrew
          :description "perlbrew"
          :type git
          :url "https://github.com/kentaro/perlbrew.el.git"
          :load-path (".")
          )
   (:name perlbrew-mini
          :description "perlbrew-mini"
          :type git
          :url "git://github.com/dams/perlbrew-mini.el.git"
          :load-path (".")
          )
   (:name color-theme-mirror
          :description "An Emacs-Lisp package with more than 50 color themes for your use. For questions about color-theme"
          :type http-tar
          :options ("xfz")
          :url "http://mirror.yongbok.net/nongnu/color-theme/color-theme-6.6.0.tar.gz"
          :load "color-theme.el"
          :features "color-theme"
          :post-init (lambda ()
                       (color-theme-initialize)
                       (setq color-theme-is-global t)
                       )
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

; Automatic spell checker
; http://www.clear-code.com/blog/2012/3/20.html
(setq-default flyspell-mode t)
(setq ispell-dictionary "american")

; Allow chmod 755 when you save a script has '#!**' in first line
; http://www.clear-code.com/blog/2012/3/20.html
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

; Adding directory name if there are some filenames which have same name.
; http://www.clear-code.com/blog/2012/3/20.html
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

; Color Setting
; http://gnuemacscolorthemetest.googlecode.com/svn/html/index-c.htm
(el-get 'sync '(color-theme-mirror))
(require 'color-theme)
(color-theme-dark-laptop)

;======================================================================
; browse-kill-ring
; http://www.yumi-chan.com/emacs/emacs_el_medium.html
;======================================================================
(el-get 'sync '(browse-kill-ring))
(require 'browse-kill-ring)
(global-set-key "\M-y" 'browse-kill-ring)
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

(el-get 'sync '(session))
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(when (require 'session nil t)
  (setq session-initialize '(de-saveplace session keys menus places)
        session-globals-include '((kill-ring 50)
                                  (session-file-alist 500 t)
                                  (file-name-history 10000)
                                  )
        )
  (add-hook 'after-init-hook 'session-initialize)
  (setq session-undo-check -1) ; Redume cursor position when you close the file.
  )

;======================================================================
; Setting about languages and charactor encodings
;======================================================================
;(require 'un-define)
;(set-language-environment "Japanese")
;(set-terminal-coding-system 'utf-8)
;(set-keyboard-coding-system 'utf-8)
;(set-buffer-file-coding-system 'utf-8)
;(setq default-buffer-file-coding-system 'utf-8)
;(prefer-coding-system 'utf-8)
;(set-default-coding-systems 'utf-8)
;(setq file-name-coding-system 'utf-8)

;======================================================================
; auto-save-buffers
; http://0xcc.net/misc/auto-save/
;======================================================================

(el-get 'sync '(auto-save-buffers))
(require 'auto-save-buffers)
(run-with-idle-timer 5 t 'auto-save-buffers)

;======================================================================
; minibuff-isearch
; http://www.sodan.org/~knagano/emacs/minibuf-isearch/
;======================================================================

(el-get 'sync '(minibuf-isearch))
(require 'minibuf-isearch nil t)

;======================================================================
; Auto Complete Mode
; http://cx4a.org/software/auto-complete/manual.ja.html
;======================================================================

(el-get 'sync '(auto-complete))
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;======================================================================
; FlyMake
; http://www.emacswiki.org/emacs-zh/FlyMake
; http://d.hatena.ne.jp/sugyan/20120103/1325601340
;======================================================================

(require 'flymake)

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
     (add-hook 'c++-mode-hook
               '(lambda ()
                  (setq-default tab-width 2 indent-tabs-mode nil) ; Set tab width and replace indent tabs to spaces
                  (define-key c++-mode-map "\C-cd" 'flymake-display-err-minibuf)
                  (c-toggle-auto-hungry-state 1) ; inserting newline and indent when you push ';'
                  (define-key c-mode-base-map "\C-m" 'newline-and-indent) ; inserting newline and indent when you push '\n'
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
     (add-hook 'c-mode-hook
               '(lambda ()
                  (setq-default tab-width 2 indent-tabs-mode nil) ; Set tab width and replace indent tabs to spaces
                  (define-key c-mode-map "\C-cd" 'flymake-display-err-minibuf)
                  (c-toggle-auto-hungry-state 1) ; inserting newline and indent when you push ';'
                  (define-key c-mode-base-map "\C-m" 'newline-and-indent) ; inserting newline and indent when you push '\n'
                  (flymake-mode t)
                  ))
     ))

; Perl mode
; http://ash.roova.jp/perl-to-the-people/emacs-cperl-mode.html
; http://d.hatena.ne.jp/antipop/20110413/1302671667
; http://search.cpan.org/dist/Project-Libs/lib/Project/Libs.pm
; http://d.hatena.ne.jp/sugyan/20120227/1330343152

(autoload 'cperl-mode "cperl-mode" nil t)
(defalias 'perl-mode 'cperl-mode) ; show preference for cperl-mode
(setq auto-mode-alist
      (append '(("\\.\\(cgi\\|t\\|psgi\\)$" . cperl-mode))
              auto-mode-alist))
(eval-after-load "cperl-mode"
  '(progn
     ; https://github.com/kentaro/perlbrew.el/blob/master/perlbrew.el
     ; https://github.com/dams/perlbrew-mini.el
     (el-get 'sync '(perlbrew-mini))
     (require 'perlbrew-mini)
     (perlbrew-mini-use "perl-5.16.1")

     ; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
     (el-get 'sync '(set-perl5lib))
     (require 'set-perl5lib)

     (defvar flymake-perl-err-line-patterns
       '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))
     (defconst flymake-allowed-perl-file-name-masks
       '("\\([Pp][Llm]\\|cgi\\|t\\|psgi\\)$" flymake-perl-init))

     (defun flymake-perl-init ()
       (let* ((temp-file (flymake-init-create-temp-buffer-copy
                          'flymake-create-temp-inplace))
              (local-file (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
         (list (perlbrew-mini-get-current-perl-path)
               (list "-MProject::Libs" "-wc" local-file))))

     (defun flymake-perl-load ()
       (interactive)
       ; http://d.hatena.ne.jp/sugyan/20100705/1278306885
       (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
         (setq flymake-check-was-interrupted t))
       (ad-activate 'flymake-post-syntax-check)
       (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
       (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
       (set-perl5lib)
       (flymake-mode t)
       )

     (add-hook 'cperl-mode-hook (lambda ()
                                  ; Set tab width and replace indent tabs to spaces
;                                  (setq indent-tabs-mode nil)
;                                  (setq cperl-font-lock t)
;                                  (cperl-set-style "PerlStyle")

;                                  (setq cperl-close-paren-offset -4)
;                                  (setq cperl-continued-statement-offset 4)
;                                  (setq cperl-indent-level 4)
;                                  (setq cperl-indent-parens-as-block t)
;                                  (setq cperl-tab-always-indent t)
;                                  (setq cperl-label-offset -4)
;                                  (setq cperl-highlight-variables-indiscriminately t)

                                  ; http://d.hatena.ne.jp/IMAKADO/20081129/1227893458
;                                  (el-get 'sync '(perl-completion))
;                                  (require 'perl-completion)

                                  ; http://d.hatena.ne.jp/sugyan/20120103/1325523629
;                                  (interactive)

;                                  (defvar ac-source-my-perl-completion
;                                    '((candidates . plcmp-ac-make-cands)))
;                                  (add-to-list 'ac-sources 'ac-source-my-perl-completion)

;                                  (perl-completion-mode t)
                                  (flymake-perl-load)
                                  ))
     ))


;; emacs-lisp-mode
(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (setq-default tab-width 2 indent-tabs-mode nil) ; Set tab width and replace indent tabs to spaces
   ))
