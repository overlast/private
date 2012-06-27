;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (browse-kill-ring browse-kill-ring-default-keybindings)
;;;;;;  "browse-kill-ring" "browse-kill-ring/browse-kill-ring.el"
;;;;;;  (20458 39554))
;;; Generated autoloads from browse-kill-ring/browse-kill-ring.el

(autoload 'browse-kill-ring-default-keybindings "browse-kill-ring" "\
Set up M-y (`yank-pop') so that it can invoke `browse-kill-ring'.
Normally, if M-y was not preceeded by C-y, then it has no useful
behavior.  This function sets things up so that M-y will invoke
`browse-kill-ring'.

\(fn)" t nil)

(autoload 'browse-kill-ring "browse-kill-ring" "\
Display items in the `kill-ring' in another buffer.

\(fn)" t nil)

;;;***

;;;### (autoloads (minibuf-isearch-backward minibuf-isearch-backward-reverse
;;;;;;  minibuf-isearch-reverse-fire-keys minibuf-isearch-fire-keys)
;;;;;;  "minibuf-isearch" "minibuf-isearch/minibuf-isearch.el" (20458
;;;;;;  52109))
;;; Generated autoloads from minibuf-isearch/minibuf-isearch.el

(defvar minibuf-isearch-fire-keys '("") "\
*Executing keys of minibuf-isearch.")

(custom-autoload 'minibuf-isearch-fire-keys "minibuf-isearch" t)

(defvar minibuf-isearch-reverse-fire-keys '("\362") "\
*Executing keys of minibuf-isearch with prefix argument.")

(custom-autoload 'minibuf-isearch-reverse-fire-keys "minibuf-isearch" t)

(autoload 'minibuf-isearch-backward-reverse "minibuf-isearch" "\
Start backward incremental searching on minibuffer history with prefix.

\(fn &optional ARGS)" t nil)

(autoload 'minibuf-isearch-backward "minibuf-isearch" "\
Start backward incremental searching on minibuffer history.

\(fn &optional ARGS)" t nil)

(mapcar (lambda (keymap) (mapcar (lambda (key) (define-key keymap key 'minibuf-isearch-backward)) minibuf-isearch-fire-keys) (mapcar (lambda (key) (define-key keymap key 'minibuf-isearch-backward-reverse)) minibuf-isearch-reverse-fire-keys)) (delq nil (list (and (boundp 'minibuffer-local-map) minibuffer-local-map) (and (boundp 'minibuffer-local-ns-map) minibuffer-local-ns-map) (and (boundp 'minibuffer-local-completion-map) minibuffer-local-completion-map) (and (boundp 'minibuffer-local-must-match-map) minibuffer-local-must-match-map))))

;;;***

;;;### (autoloads nil nil ("auto-complete-clang/auto-complete-clang.el"
;;;;;;  "auto-complete/auto-complete-config.el" "auto-complete/auto-complete-pkg.el"
;;;;;;  "auto-complete/auto-complete.el" "auto-save-buffers/auto-save-buffers.el"
;;;;;;  "el-get/el-get-install.el" "el-get/el-get.el" "perlbrew-mode/perlbrew.el"
;;;;;;  "popup/popup-test.el" "popup/popup.el" "set-perl5lib/set-perl5lib.el")
;;;;;;  (20458 56292 202160))

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here