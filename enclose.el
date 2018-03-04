;;; enclose.el

(defun enclose-next (open close)
  "Enclose next word/s-exp with 'open and 'close."
  (let ((end (condition-case nil
                 (scan-sexps (point) 1)
               (error (point)))))
    (save-excursion
      (when end (goto-char end))
      (insert close))
    (insert open)))

(defun enclose-prev (open close)
  "Enclose previous word/s-exp with 'open and 'close."
  (let ((start (third (syntax-ppss))))
    (insert close)
    (save-excursion
      (if start (goto-char start) (backward-char))
      (insert open))))

(defun enclose-delete (&optional offset)
  "Delete enclosed parentheses"
  (interactive)
  (save-excursion
    (if offset (forward-char offset))
    (cond ((looking-at "\\s(")
           (let ((end (scan-sexps (point) 1)))
             (save-excursion
               (when end
                 (goto-char end)
                 (delete-backward-char 1)))
             (delete-char 1)))
          ((looking-at "\\s)")
           (let ((start
                  (save-excursion (third (syntax-ppss (+ (point) 1))))))
             (delete-char 1)
             (save-excursion
               (when start
                 (goto-char start)
                 (delete-char 1)))
             ))
          (t (delete-char 1)))))

(defun enclose-backward-delete (&optional offset)
  "Delete enclosed parentheses at backward"
  (interactive)
  (let ((off (or offset 0)))
    (enclose-delete (- off 1))))

(defun enclose-next-round-parentheses ()
  "do 'enclose with ( and )"
  (interactive)
  (enclose-next "(" ")"))

(defun enclose-next-curly-parentheses ()
  "do 'enclose with { and }"
  (interactive)
  (enclose-next "{" "}"))

(defun enclose-next-square-parentheses ()
  "do 'enclose with [ and ]"
  (interactive)
  (enclose-next "[" "]"))

(defun enclose-next-string-quote ()
  "do 'enclose with \"s"
  (interactive)
  (enclose-next "\"" "\""))

(defun enclose-prev-round-parentheses ()
  "do 'enclose with ( and ) backward"
  (interactive)
  (enclose-prev "(" ")"))

(defun enclose-prev-curly-parentheses ()
  "do 'enclose with { and } backward"
  (interactive)
  (enclose-prev "{" "}"))

(defun enclose-prev-square-parentheses ()
  "do 'enclose with [ and ] backward"
  (interactive)
  (enclose-prev "[" "]"))

(global-set-key (kbd "M-(") 'enclose-next-round-parentheses)
(global-set-key (kbd "M-)") 'enclose-prev-round-parentheses)
(global-set-key (kbd "M-[") 'enclose-next-square-parentheses)
(global-set-key (kbd "M-]") 'enclose-prev-square-parentheses)
;; Override paragraph movement
(global-set-key (kbd "M-{") 'enclose-next-curly-parentheses)
(global-set-key (kbd "M-}") 'enclose-prev-curly-parentheses)
(global-set-key (kbd "M-\"") 'enclose-next-string-quote)
(global-set-key (kbd "<C-M-backspace>") 'enclose-backward-delete)
(global-set-key (kbd "C-M-d") 'enclose-delete)

(provide 'enclose)
