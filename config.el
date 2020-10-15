;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq system-time-locale "C")

;;; code:
;; Prefer horizontal split first
(setq split-width-threshold 0)
(setq split-height-threshold nil)

;; relative line number
(setq-default display-line-numbers-type 'relative
              display-line-numbers-current-absolute t
              display-line-numbers-width 4
              display-line-numbers-widen t)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Fix ledger mode completion after ledger mode update
(add-hook 'ledger-mode-hook
          (lambda ()
            (setq-local tab-always-indent 'complete)
            (setq-local completion-ignore-case t)
            (setq-local ledger-complete-in-steps t)
            (setq-local ledger-accounts-file "~/personalFinance/accounts.dat")
            ))

;; ledger mode
(setq ledger-post-amount-alignment-column 68)

;; org mode
;; org global settings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; org habit
(require 'org-habit)
(setq org-habit-show-habits-only-for-today nil)

;; org capture template
(setq org-default-notes-file "~/org/refile.org")
(setq org-capture-templates
      '(("t" "todo" entry (file "~/org/refile.org")
            "* TODO %?\n\n" :clock-in nil :clock-resume t)
        ("n" "note" entry (file "~/org/refile.org")
              "* %? :NOTE:\n%U\n%a\n\n" :clock-in t :clock-resume t)
        ("m" "MEETING" entry (file+datetree "~/org/refile.org")
          "* MEETING with %? :MEETING:\n\n** Agenda\n \n** FOLLOW\n\n" :clock-in t :clock-resume t)
        ("s" "Schedule" entry (file+datetree "~/org/refile.org")
          "* SCHE with %? :MEETING:\n SCHEDULED: %^T \n** Agenda\n \n** TBD\n\n" :clock-resume t)
        ("d" "Date" entry (file+datetree "~/org/date.org")
         "* Date at %u  :DATE:\n\n%?" :clock-in nil :clock-resume t)
        ))

;; org todo settings
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "PENDING(p)" "|" "CANCELED(c)" "DONE(d)")
                          (sequence "SCHE" "|" "MEETING")
                          (sequence "SOMEDAY(o)" "|" "FINALLY(f)")
                          (sequence "FOLLOW" "|" "FOLLOWED")
                          ))
(setq org-log-done 'time)

;; org project
(setq org-stuck-projects '("+Project/-DONE-CANCELED" ("TODO") nil ""))

;; org agenda view
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-hide-tags-regexp "FDL\\|Project\\|Life")
(setq org-agenda-compact-blocks t)
(setq org-agenda-start-day "0d")
(setq org-agenda-files (quote ("~/org")))
(setq org-tags-exclude-from-inheritance '("Project"))
(setq org-tags-column 60)

(setq org-agenda-custom-commands
      '(
        ("w" "Work agenda"
          (
          (agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'todo '("PENDING" "NEXT")))
                    (org-agenda-span 1)
                    (org-agenda-use-time-grid nil)
                    ))
          (todo "PENDING"
                ((org-agenda-overriding-header "Pending tasks")))
          (todo "FOLLOW"
                ((org-agenda-overriding-header "Meeting follow up")))
          (stuck ""
                 ((org-agenda-overriding-header "Stuck projects")))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled tasks")
                  (org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'scheduled 'deadline))
                  ))
          (tags "Project/-DONE-CANCELED"
                ((org-agenda-overriding-header "All active projects")
                  (org-agenda-sorting-strategy '(priority-down))))
          (tags-todo "REFILE"
                ((org-agenda-overriding-header "Tasks to refile")
                  (org-tags-match-list-sublevels nil)))
          )
          ((org-agenda-tag-filter-preset '("-LIFE" "-ARCHIVE" "-RPA")))
        )
        ("r" "RPA"
          (
          (agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'todo '("PENDING" "NEXT")))
                    (org-agenda-span 1)
                    (org-agenda-use-time-grid nil)
                    ))
          (todo "PENDING"
                ((org-agenda-overriding-header "Pending tasks")))
          (todo "FOLLOW"
                ((org-agenda-overriding-header "Meeting follow up")))
          (stuck ""
                 ((org-agenda-overriding-header "Stuck projects")))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled tasks")
                  (org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'scheduled 'deadline))
                  ))
          (tags "Project/-DONE"
                ((org-agenda-overriding-header "All active projects")
                  (org-agenda-sorting-strategy '(priority-down))))
          (tags-todo "REFILE"
                ((org-agenda-overriding-header "Tasks to refile")
                  (org-tags-match-list-sublevels nil)))
          )
          ((org-agenda-tag-filter-preset '("-LIFE" "-ARCHIVE" "-FDL")))
        )
        ("l" "Life agenda"
          (
           (agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'todo '("SOMEDAY")))
                   (org-agenda-span 1)
                   ))
          (todo "SOMEDAY"
                ((org-agenda-overriding-header "Someday maybe...")))
          )
          ((org-agenda-tag-filter-preset '("+LIFE")))
        )))

;; org archive
(setq org-archive-location "~/org/archived.org::datetree/")

;; org bullet
;;(setq org-bullets-bullet-list '("☰" "☲" "☵" "☷"))
;; Updated with org-superstar
(setq org-superstar-headline-bullets-list '("☰" "☲" "☵" "☷"))

;; doom-modeline
(setq doom-modeline-major-mode-icon t)

;; popup
(after! popup
  (set-popup-rules!
    '(("Agenda" :ignore t)
      ("Ledger" :ignore t)))
  )

;; org export
(after! org
  (add-to-list 'org-export-backends 'latex))

;; font setup
(setq doom-font (font-spec :family "PragmataPro Mono" :size 22))
(setq doom-themes-enable-bold nil)
(setq doom-theme 'doom-nord)
(set-face-bold-p 'bold nil)

;; proxy setup
(setq url-proxy-services
      '(("http"  . "http://127.0.0.1:8888")
        ("https" . "http://127.0.0.1:8888")))
