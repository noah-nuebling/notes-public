

**Translation Files**

(Should maybe do this more frequently than publishing updates [Nov 2025])

Core:
    Mac Mouse Fix.xcloc

        Prep/Other:
            - If **MMF UI** added/changed: 
                - [x] Consider updating `testTakeScreenshots_Localization()` to cover the new UI before running `./run uploadstrings`
                - [x] Make sure `testTakeScreenshots_Localization()` doesn't cut off tall menus on small M1 MBA screen 
                    - Nothing's cut off as of [Dec 2025]
            - If Xcloc Editor has changed:
                - [x] Upload new Xcloc Editor (at "https://github.com/noah-nuebling/mf-xcloc-editor/releases/latest/download/XclocEditor.zip") before running `./run uploadstrings` [Dec 2025]

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

        - [ ] Publish App update
            - See `MMF - Update Checklist - Template.md`
                - [ ] If you update existing release instead of creating a new one – still don't forget to run:
                    - >>> z mac-mouse-fix-update-feed; ./update;
                    - (Otherwise Sparkle signature will break)

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            - [x] >>> z mac-mouse-fix-website; ./run importstrings --xcloc-path ...
                - >>> ./run importstrings2 --only-comment-mismatches --xcloc-path ...
                - [x] Review mismatches
        
        - Update website
            - [ ] `pnpm dev`
                - [ ] Review
            - [ ] `pnpm upload`

Add credits
    - [ ] Add credits to the Acknowledgements
        - To stop _buildmd.py from failing, the []({urls}) need to match in all languages:
            - [ ] Manually add the new entry to all the translations of `2: translations`.
            - [ ] Update the surrounding urls
                - >>> ./run updateackurls;
    - [ ] Add credits to Update Notes

Update Translation Guide
- [ ] Run uploadstrings on the master branch 
    - >>> ./run uploadstrings --only-update-locale xx [--recycle-screenshots]
    -> (Will run func testTakeScreenshots_Localization() automatically)
    -> If new UI added (or anything in the app changed that affects all locales), omit `--only-update-locale`.
        - (Tip: Maybe on a second computer cause this takes a while if you update all the locales.)
        - (Note: If this gets annoying, look into automating with GitHub Actions runner.)

Other:
    - [ ] Send 10 MMF licenses to translator (?)

Review: 
    Updated things:
        - [ ] Built app                         (See: https://github.com/noah-nuebling/mac-mouse-fix/releases/download/<version>/MacMouseFixApp.zip / Xcode > Archive)              // Caution: If it's a prerelease you can't use `/latest/` as the <version> ((I think))
        - [ ] Markdown docs (Readme.md etc.)    (See: https://github.com/noah-nuebling/mac-mouse-fix/tree/master/Markdown/LocalizedDocuments/<locale>)
            - [ ] Documentation screenshots
        - [ ] Website                           (See: https://macmousefix.com/<locale>)
        
        - [ ] Translation Files                 (See: https://github.com/noah-nuebling/mac-mouse-fix-localization-file-hosting/releases/download/arbitrary-tag/MacMouseFixTranslations.<locale>.zip)
            - (Which can be downloaded from the [Translation Guide](https://github.com/noah-nuebling/mac-mouse-fix/issues/1638))
        - [ ] Localization screenshots (Contained in the translation files.)

    - [ ] Send translators a review request

    REFERENCE: 
        MMF - Translation Checklists Overview [Dec 2025].md