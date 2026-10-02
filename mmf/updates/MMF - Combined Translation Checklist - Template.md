

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
    - [ ] Update `testTakeScreenshots_Localization` if there's new UI to cover in the `./run uploadstrings` screenshots [Sep 2026]
    - [ ] Upload new Xcloc Editor update if necessary before `./run uploadstrings`. (mf-xcloc-editor repo has a checklist for that (`PublishingUpdates.md`) [Sep 2026])

    LocaleAdditionRequests (for copy-pasting below)
        <fill in or whatever, Issue, Email, Pull Requests>

    TranslationSubmissionsList (for copy-pasting below)
        <fill in or whatever, Issue, Email, Pull Requests>
        
    LocaleList (for copy-pasting below)
        - [xxx] Locale 1
        - [xxx] Locale 2
    
    LocaleListCommaSeparated (for copy-pasting below)
        xx,yy

Update:

    Mac Mouse Fix.xcloc

        - Import .xcloc files
            Steps:
                1. >>> z mac-mouse-fix; ./run importstrings --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix.xcloc'
                2. If new locale: Update func applyHardcodedTabWidth(), and maybe run the app. (Minimal review so we can do this regularly) [Sep 2026]
            <LocaleList>

        - Add credits to the Acknowledgements
            Steps:
                1. Add credits to 
                Markdown/Templates/Acknowledgements.md
                    <TranslationSubmissionsList>
                2. >>> ./run syncstrings (Updates .xcstrings)
                3. Update the translations via Claude Code:
                    Claude Code prompt:
                    The translator credits at Markdown/Templates/Acknowledgements.md have been updated. To stop `./run build-markdown` from failing, the []({urls}) need to match in all languages. Please go to Acknowledgements.xcstrings, update all the translations (following existing style if possible) and set their "state" to "reviewed".

    Markdown files:
        - [ ] Rebuild markdown & take screenshots
            >>> ./run build-markdown --document '.*(?<!Acknowledgements\.md)$' --recycle-screenshots --take-screenshots-for-locales [all|<LocaleListCommaSeparated>]
                (This runs `testTakeScreenshots_Documentation`)
                (Background: We skip Acknowledgements.md since we don't want to wait for Gumroad data downloads – The GitHub Actions runner will later regenerate Acknowledgements.md with the latest data)

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            >>> z mac-mouse-fix-website; ./run importstrings                    --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix Website.xcloc'
            <LocaleList>

        - Update website
            Steps:
            - [ ] >>> pnpm dev
            - [ ] >>> pnpm upload
                

    Update Translation Guide
        >>> ./run uploadstrings --recycle-screenshots [--only-update-locales <LocaleListCommaSeparated>]
        (This runs `testTakeScreenshots_Localization`)
        -> If new UI added (or anything in the app changed that affects all locales), omit `--only-update-locales`.
            - (Note: If this gets annoying, look into automating with GitHub Actions runner.)

Other:
    - Send 10 MMF licenses to translator (?) (/answer in general)
        <TranslationSubmissionsList>
    - Maybe ask them how they want to be credited exactly, if possible:
        <TranslationSubmissionsList>

Post reply at https://github.com/noah-nuebling/mac-mouse-fix/issues/1638
    - [ ] Export app
        - Choose 'App - Release' scheme, and 'Any Mac', then Archive > Organizer > Distribute App > Export Notarized App
    - [ ] Reply
        - Keep it short, nice. Point people to the places where they can check their work (copy from messages above). Try to keep calm.