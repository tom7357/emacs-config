;;; bookkeeping.el --- Fast Org-mode bookkeeping for weekly files -*- lexical-binding: t; -*-
(setq inhibit-startup-screen t)
;; ▶ 可自定义
(defgroup book nil
  "Quick bookkeeping in Org."
  :group 'convenience)

;;; bookkeeping.el --- Fast Org-mode bookkeeping for weekly files -*- lexical-binding: t; -*-
(setq inhibit-startup-screen t)
;; ▶ 可自定义
(defgroup book nil
  "Quick bookkeeping in Org."
  :group 'convenience)

(defcustom book-base-dir
  (expand-file-name "~/Bookkeeping/weekly")
  "记账周文件所在目录。"
  :type 'directory)

(defcustom book-categories
  '("食费" "日用品" "交通費" "光熱費" "通信費" "住居費"
    "娯楽" "医療費" "交際費" "教育・自己投資" "保険・税金" "その他")
  "类别列表（按 Weekly Summary 顺序）。"
  :type '(repeat string))

(defcustom book-methods '("cash" "suica" "paypay" "credit" "bank" "nanaco")
  "支付方式列表。"
  :type '(repeat string))

(defcustom book-year-format "%Y"
  "文件所在年份子目录名的格式。默认按当前年。"
  :type 'string)

;; ▶ 内部工具
(require 'org)
(require 'org-table)
(require 'time-date)
(require 'subr-x)

(defun book--iso-week (time)
  (string-to-number (format-time-string "%V" time)))

(defun book--week-year (time)
  "ISO 周年：跨年周能归对。"
  (format-time-string "%G" time))

(defun book--week-range (time)
  "返回本周周一与周日的 (YYYY-MM-DD . YYYY-MM-DD)。周一为一周开始。"
  (let* ((dow (string-to-number (format-time-string "%u" time))) ; 1..7
         (monday (time-subtract time (days-to-time (1- dow))))
         (sunday (time-add monday (days-to-time 6))))
    (cons (format-time-string "%Y-%m-%d" monday)
          (format-time-string "%Y-%m-%d" sunday))))

(defun book--weekday-jp (time)
  (aref ["月" "火" "水" "木" "金" "土" "日"]
        (1- (string-to-number (format-time-string "%u" time)))))

(defun book--ensure-directory (dir)
  (unless (file-directory-p dir)
    (make-directory dir t)))

(defun book--week-file (time)
  "返回本周 Org 文件完整路径，如 .../2025/week-41.org"
  (let* ((wy (book--week-year time))
         (w  (book--iso-week time))
         (dir (expand-file-name (format "%s" wy) book-base-dir)))
    (book--ensure-directory dir)
    (expand-file-name (format "week-%02d.org" w) dir)))

(defun book--title-line (time)
  (pcase-let* ((`(,start . ,end) (book--week-range time))
               (s (format-time-string "%m/%d" (date-to-time start)))
               (e (format-time-string "%m/%d" (date-to-time end)))
               (w (book--iso-week time)))
    (format "#+TITLE: %s年 第%02d週（%s–%s）"
            (book--week-year time) w s e)))

(defun book--daily-heading (daytime)
  "生成一天的标题块字符串。"
  (let* ((w (book--iso-week daytime))
         (day (format-time-string "%Y-%m-%d" daytime))
         (md  (format-time-string "%m-%d" daytime))
         (md4 (replace-regexp-in-string "-" "" md)) ; mmdd
         (jp (book--weekday-jp daytime)))
    (format
     (concat "* %s（%s）\n"
             ":PROPERTIES:\n:week: W%02d\n:END:\n"
             "#+NAME: 明細-%s\n"
             "| 用途 | 類別 | 金額 | 方式 | 備考 | 標籤 |\n\n")
     day jp w md4)))

(defun book--weekly-summary-table (time)
  (let* ((w (book--iso-week time))
         (range (book--week-range time)))
    (concat
     (format "* Weekly Summary\n:PROPERTIES:\n:week: W%02d\n:start: %s\n:end:   %s\n:END:\n"
             w (car range) (cdr range))
     (concat
      "| 類別           | 合計金額 |\n|----------------+---------|\n"
      (mapconcat (lambda (c) (format "| %s |         |" c)) book-categories "\n")
      "\n| 合計           |         |\n\n")
     "#+TBLFM: $2='(my/week-cat-sum $1 \"明細-\")::@>$2=vsum(@2..@-1)\n")))

(defun book--file-template (time)
  "整份周模板。"
  (let* ((base (format "%s\n#+STARTUP: overview\n\n" (book--title-line time)))
         ;; 生成周一到周日
         (dow (string-to-number (format-time-string "%u" time)))
         (monday (time-subtract time (days-to-time (1- dow))))
         (days (mapcar (lambda (i) (time-add monday (days-to-time i))) (number-sequence 0 6))))
    (concat
     base
     (mapconcat #'book--daily-heading days "\n")
     "\n"
     (book--weekly-summary-table time))))

(defun book--ensure-week-file (time)
  "若不存在则创建本周文件；存在则保持不动。返回路径。"
  (let ((f (book--week-file time)))
    (unless (file-exists-p f)
      (with-temp-file f
        (insert (book--file-template time))))
    f))

(defun my/week-cat-sum (cat prefix)
  "在当前 buffer 内，遍历所有以 PREFIX 命名的明細表，只在该表本身范围内累计第2列等于 CAT 的金额（第3列）。"
  (save-excursion
    (goto-char (point-min))
    (let ((sum 0)
          (re (format "^#\\+NAME: %s" (regexp-quote prefix))))
      (while (re-search-forward re nil t)
        ;; 到表体
        (forward-line 1)
        (when (org-at-table-p)
          (let ((tbeg (save-excursion (org-table-begin)))
                (tend (save-excursion (org-table-end))))
            (save-restriction
              (narrow-to-region tbeg tend)
              (goto-char (point-min))
              ;; 逐行匹配这一张表里“類別=CAT”的行
              (while (re-search-forward
                      (format "^|\\s-*[^|]*\\s-*|\\s-*%s\\s-*|\\s-*\\([0-9.]+\\)\\s-*|" (regexp-quote cat))
                      nil t)
                (setq sum (+ sum (string-to-number (match-string 1)))))))))
      sum)))


;; ▶ 插入一条消费
(defun book--today-table-name (time)
  (format "明細-%s" (format-time-string "%m%d" time)))

(defun book--ensure-today-head-and-table (time)
  "确保今天的标题和表存在，返回表名。"
  (save-excursion
    (goto-char (point-min))
    (let* ((h (format "* %s（%s）"
                      (format-time-string "%Y-%m-%d" time)
                      (book--weekday-jp time)))
           (tbl (book--today-table-name time)))
      (unless (save-excursion (re-search-forward (concat "^" (regexp-quote h) "$") nil t))
        (goto-char (point-max))
        (unless (bolp) (insert "\n"))
        (insert (book--daily-heading time)))
      (goto-char (point-min))
      (re-search-forward (format "^#\\+NAME: %s\\s-*$" (regexp-quote tbl)))
      (forward-line 1)
      (unless (org-at-table-p)
        (insert "| 用途 | 類別 | 金額 | 方式 | 備考 | 標籤 |\n"))
      tbl)))

(defun book--week-tag (time)
  (format "W%02d" (book--iso-week time)))

(defun book-insert-expense (&optional time)
  "交互式：在本周文件的今天的表中插入一行。"
  (interactive)
  (let* ((now (or time (current-time)))
         (file (book--ensure-week-file now)))
    (find-file file)
    (let* ((use (read-string "用途: "))
           (cat (completing-read "類別: " book-categories nil t))
           (amt (string-to-number (read-string "金額: ")))
           (method (completing-read "方式: " book-methods nil t))
           (note (read-string "備考: "))
           (tag (format ":%s:%s:%s:" method cat (book--week-tag now))))
      (save-excursion
        (let ((tbl (book--ensure-today-head-and-table now)))
          (goto-char (point-min))
          (re-search-forward (format "^#\\+NAME: %s\\s-*$" (regexp-quote tbl)))
          (forward-line 1)
          (org-table-next-row)
          (insert (format "| %s | %s | %s | %s | %s | %s |\n"
                          use cat amt method note tag))
          (org-table-align)))
      (message "已记账: %s / %s / %.2f" use cat amt))))

;; ▶ org-capture 支持（按 e 快速记账）
(defun book--capture-target ()
  "org-capture target，确保周文件存在并返回 (file . PATH)。"
  (let* ((f (book--ensure-week-file (current-time))))
    (set-buffer (find-file-noselect f))
    (cons 'file f)))

(defun book--capture-insert ()
  "供 org-capture 使用的模板主体：将占位符插入到今天表中。"
  (let ((now (current-time)))
    (save-excursion
      (let ((tbl (book--ensure-today-head-and-table now)))
        (goto-char (point-min))
        (re-search-forward (format "^#\\+NAME: %s\\s-*$" (regexp-quote tbl)))
        (forward-line 1)
        (org-table-next-row)
        (insert (format "| %^{用途} | %^{類別|%s} | %^{金額} | %^{方式|%s} | %^{備考} | :%%\\1:%%\\2:%s: |\n"
                        (mapconcat #'identity book-categories "|")
                        (mapconcat #'identity book-methods "|")
                        (book--week-tag now))))
      (org-table-align))))

;;;###autoload
(defun book-setup ()
  "安装键位与 org-capture 模板。"
  (interactive)
  ;; 快捷键：C-c b 记一笔
  (global-set-key (kbd "C-c b") #'book-insert-expense)
  ;; org-capture 模板（按 e）
  (with-eval-after-load 'org
    (add-to-list 'org-capture-templates
                 `("e" "Expense (weekly table)"
                   plain (function book--capture-target)
                   ,(concat "%(book--capture-insert)") ; 已直接插入表格一行
                   :immediate-finish t))))

(provide 'bookkeeping)
;;; bookkeeping.el ends here
