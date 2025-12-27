

**Translation Files**

Vyacheslav's email: 
    message:<5B439E71-E2EC-4774-ADB7-0D3F39D951FA@gmail.com>

Core:
    Mac Mouse Fix.xcloc

        Prep/Other:
        - If **new UI added** 
            – [x] Consider updating `testTakeScreenshots_Localization()` to cover it before running `./run uploadstrings`
        - If Xcloc Editor has updated
            - [x] Upload new Xcloc Editor (at "https://github.com/noah-nuebling/mf-xcloc-editor/releases/latest/download/XclocEditor.zip") before running `./run uploadstrings` [Dec 2025]
        - Before **testTakeScreenshots_XXX()** 
            - [x] Probably switch to **lightmode** for the screenshots
            - [x] Probably do `testTakeScreenshots_Localization()` on large monitor (tall menus on action table are cut off on M1 MBA [Dec 2025]) (Could perhaps solve by programmatically moving window up?)

        - Import .xcloc files
            - [x] >>> z mac-mouse-fix; ./run importstrings --xcloc-path ...
                - >>> ./run importstrings2 --only-comment-mismatches --xcloc-path ...
                - [x] Review mismatches
            - [x] Update: func applyHardcodedTabWidth()

        - Update Markdown files:
            - [x] Run ScreenshotTaker XCUITest in Xcode
                - >>> func testTakeScreenshots_Documentation()
                - Tip: Modify 'onlyUpdateLocales' at the top for quick update. [Dec 2025]
            - [x] Rebuild all the docs
                - >>> ./run build-markdown --document '.*(?<!Acknowledgements\.md)$'
                    - Skip Acknowledgements.md since we don't want to wait for Gumroad data downloads – The GitHub Actions runner will later regenerate Acknowledgements.md with the latest data.

        - Update Translation Guide
        - [ ] Run uploadstrings on the master branch 
            - >>> ./run uploadstrings --only-update-locale xx
            -> (Will run func testTakeScreenshots_Localization() automatically)
            -> If new UI added (or anything in the app changed that affects all locales), omit `--only-update-locale`.
                - (Tip: Maybe on a second computer cause this takes a while if you update all the locales.)
                - (Note: If this gets annoying, look into automating with GitHub Actions runner.)

        - [ ] Publish App update
            - See `MMF - Update Checklist - Template.md`
                - [ ] If you update existing release instead of creating a new one – still don't forget to run:
                    - >>> z mac-mouse-fix-update-feed; ./update;
                    - (Otherwise Sparkle signature will break)

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            - [ ] >>> z mac-mouse-fix-website; ./run importstrings --xcloc-path ...
                - >>> ./run importstrings2 --only-comment-mismatches --xcloc-path ...
                - [ ] Review mismatches
        
        - Update website
            - [ ] `pnpm dev`
                - [ ] Review
            - [ ] `pnpm upload`

Add credits
    - [ ] Add credits to the Acknowledgements
    - [ ] Add credits to Update Notes

Other:
    - [ ] Send 10 MMF licenses to translator (?)

Review: 
    Updated things:
        - [ ] Built app                         (See: https://github.com/noah-nuebling/mac-mouse-fix/releases/download/xxx/MacMouseFixApp.zip / Xcode > Archive)
        - [ ] Markdown docs (Readme.md etc.)    (See: https://github.com/noah-nuebling/mac-mouse-fix/tree/master/Markdown/LocalizedDocuments)
            - [ ] Documentation screenshots
        - [ ] Website                           (See: https://macmousefix.com/)
        
        - [ ] Translation Files                 (See: https://github.com/noah-nuebling/mac-mouse-fix-localization-file-hosting/releases/download/arbitrary-tag/MacMouseFixTranslations.xxx.zip)
            - (Which can be downloaded from the [Translation Guide](https://github.com/noah-nuebling/mac-mouse-fix/issues/1638))
        - [ ] Localization screenshots (Contained in the translation files.)

    - [ ] Send translators a review request

    REFERENCE: 
        MMF - Translation Checklists Overview [Dec 2025].md