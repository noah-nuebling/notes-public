

Overview [Sep 2026]:
    Streamlined version of `MMF - Translation Checklist - Template.md` making it faster to process several submissions at once.
    Also skips the review steps, so we can upload new build at https://github.com/noah-nuebling/mac-mouse-fix/issues/1638 once a month as promised. [Sep 2026]

Also see: 
    - Translating Mac Mouse Fix (GitHub Issue) https://github.com/noah-nuebling/mac-mouse-fix/issues/1638
    - MMF - Combined Translation Checklist - Sep 2026.md (The combined template is based on that)
    - MMF - Translation Checklist - Template.md (Older version)
    - MMF - Update Checklist - Template.md

---

Preparation
    - [x] Update `testTakeScreenshots_Localization` if there's new UI to cover in the `./run uploadstrings` screenshots [Sep 2026]
    - [x] Upload new Xcloc Editor update if necessary before `./run uploadstrings`. (mf-xcloc-editor repo has a checklist for that (`PublishingUpdates.md`) [Sep 2026])

    LocaleAdditionRequests (for copy-pasting below)
        None

    TranslationSubmissionsList (for copy-pasting below)
        - [xxx] Spanish by @manghidev
        - [xxx] Italian by @Lombae
        
    LocaleList (for copy-pasting below)
        - [xxx] it
        - [xxx] es
    
    LocaleListCommaSeparated (for copy-pasting below)
        it,es

Update:
    Add locale requests:
        (Requires lots of updates in different places, not sure of all of them right now, should be rare [Sep 2026])
        N/A

    Mac Mouse Fix.xcloc

        - Import .xcloc files
            Steps:
                1. >>> z mac-mouse-fix; ./run importstrings --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix.xcloc'
                2. If new locale: Update func applyHardcodedTabWidth(), and maybe run the app. (Minimal review so we can do this regularly) [Sep 2026]
                - [ ] it
                - [ ] es

        - Add credits to the Acknowledgements
            Steps:
                1. Add credits to 
                Markdown/Templates/Acknowledgements.md
                   - [ ] Spanish by @manghidev
                   - [ ] Italian by @Lombae
                2. >>> ./run syncstrings (Updates .xcstrings)
                3. Update the translations via Claude Code:
                    Claude Code prompt:
                    The translator credits at Markdown/Templates/Acknowledgements.md have been updated. To stop `./run build-markdown` from failing, the []({urls}) need to match in all languages. Please go to Acknowledgements.xcstrings, update all the translations (following existing style if possible) and set their "state" to "reviewed".

    Markdown files:
        - [ ] Rebuild markdown & take screenshots
            >>> ./run build-markdown --document '.*(?<!Acknowledgements\.md)$' --recycle-screenshots --take-screenshots-for-locales [all|it,es]
                (This runs `testTakeScreenshots_Documentation`)
                (Background: We skip Acknowledgements.md since we don't want to wait for Gumroad data downloads – The GitHub Actions runner will later regenerate Acknowledgements.md with the latest data)

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            >>> z mac-mouse-fix-website; ./run importstrings                    --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix Website.xcloc'
            - [ ] it
            - [ ] es

        - Update website
            Steps:
            - [ ] >>> pnpm dev
            - [ ] >>> pnpm upload
                

    Update Translation Guide
        >>> ./run uploadstrings --recycle-screenshots [--only-update-locales it,es]
        (This runs `testTakeScreenshots_Localization`)
        -> If new UI added (or anything in the app changed that affects all locales), omit `--only-update-locales`.
            - (Note: If this gets annoying, look into automating with GitHub Actions runner.)

Other:
    - Send 10 MMF licenses to translator (?) (/answer in general) (Maybe ask them how they want to be credited exactly, if possible)
        - [ ] Spanish by @manghidev
        - [ ] Italian by @Lombae

Post reply at https://github.com/noah-nuebling/mac-mouse-fix/issues/1638
    - [ ] Export app
        - Choose 'App - Release' scheme, and 'Any Mac', then Archive > Organizer > Distribute App > Export Notarized App
    - [ ] Reply
        - Keep it short, nice. Point people to the places where they can check their work (copy from messages above). Try to keep calm.