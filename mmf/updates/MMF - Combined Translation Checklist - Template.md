

Overview [Sep 2026]:
    Streamlined version of `MMF - Translation Checklist - Template.md` making it faster to process several submissions at once.
    Also skips the review steps, so we can upload new build at https://github.com/noah-nuebling/mac-mouse-fix/issues/1638 once a month as promised. [Sep 2026]

Also see: 
    - Translating Mac Mouse Fix (GitHub Issue) https://github.com/noah-nuebling/mac-mouse-fix/issues/1638
    - MMF - Combined Translation Checklist - Sep 2026.md (The combined template is based on that)
    - MMF - Translation Checklist - Template.md (Older version)
    - MMF - Update Checklist - Template.md

Preparation
    - [ ] Update `testTakeScreenshots_Localization` if there's new UI to cover in the `./run uploadstrings` screenshots [Sep 2026]
    - [ ] Upload new Xcloc Editor update if necessary before `./run uploadstrings`. (mf-xcloc-editor repo has a checklist for that (`PublishingUpdates.md`) [Sep 2026])

AdditionRequests

    LocaleAdditionRequests
        <fill in or whatever, Issue, Email, Pull Requests>

    TranslationSubmissionsList
        <fill in or whatever, Issue, Email, Pull Requests>
        
LocaleList (for copy-pasting)
    - [xxx] Locale 1
    - [xxx] Locale 2

Update:

Core:
    Mac Mouse Fix.xcloc

        - Import .xcloc files
            Steps:
                1. >>> z mac-mouse-fix; ./run importstrings                            --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix.xcloc'
                2. >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix.xcloc'
                   - Mark all these as mismatches, don't do further review
                    - Why filter those mismatches? (--no-key-mismatches --no-source-mismatches): I think those are already caught by `./run importstrings` and/or useless.
                3. Update: func applyHardcodedTabWidth()
            <LocaleList>

      - Update Markdown files:
          - Run ScreenshotTaker XCUITest in Xcode
              Steps:
                  1. Modify 'onlyUpdateLocales' at the top
                  2. >>> func testTakeScreenshots_Documentation()
              <LocaleList>
          - [x] Rebuild the docs
              >>> ./run build-markdown --document '.*(?<!Acknowledgements\.md)$'
                  - Skip Acknowledgements.md since we don't want to wait for Gumroad data downloads – The GitHub Actions runner will later regenerate Acknowledgements.md with the latest data

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            Steps: 
                >>> z mac-mouse-fix-website; ./run importstrings                    --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix Website.xcloc'
                >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path '/Users/Noah/Downloads/XXX/Mac Mouse Fix Website.xcloc'
            <LocaleList>

        - Update website
            Steps:
            - [ ] `pnpm dev`
            - [ ] `pnpm upload`

Add credits
    - Add credits to the Acknowledgements
        Steps:
            1. Add
            2. To stop _buildmd.py from failing, the []({urls}) need to match in all languages:
                - [ ] Manually add the new entry to all the translations of `2: translations`.
                - [ ] Update the surrounding urls
                    - >>> ./run updateackurls;
            Add to en:
                <TranslationSubmissionsList>
            Add the same to all other languages:
                <TranslationSubmissionsList>

Update Translation Guide
- Run uploadstrings on the master branch 
    >>> ./run uploadstrings --recycle-screenshots --only-update-locales ...
    (This runs `testTakeScreenshots_Localization`)
    -> If new UI added (or anything in the app changed that affects all locales), omit `--only-update-locale`.
        - (Tip: Maybe on a second computer cause this takes a while if you update all the locales.)
        - (Note: If this gets annoying, look into automating with GitHub Actions runner.)
    <LocaleList>

- [ ] Mark the root nodes of all the 'pluralizable' strings (whose children are translated) as translated

Other:
    - Send 10 MMF licenses to translator (?) (/answer in general)
        <TranslationSubmissionsList>
    - Maybe ask them how they want to be credited exactly, if I can manage.
        <TranslationSubmissionsList>

Post reply at https://github.com/noah-nuebling/mac-mouse-fix/issues/1638
    - [ ] Export app
        - Choose 'App - Release' scheme, 'Any Mac' > Archive > Organizer > Distribute App > Export Notarized App
    - [ ] Reply
        - Keep it short, nice. Point people to the places where they can check their work (copy from messages above). Try not to get crazy or anxious about it.