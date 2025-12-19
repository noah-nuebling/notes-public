

**Translation Files**

(Should maybe do this more frequently than publishing updates [Nov 2025])

Core:
    Mac Mouse Fix.xcloc

        Prep/Other:
        - If **new UI added** 
            – [x] Consider updating `testTakeScreenshots_Localization()` to cover it before running `./run uploadstrings`
        - If Xcloc Editor has updated
            - [ ] Upload new Xcloc Editor (at "https://github.com/noah-nuebling/mf-xcloc-editor/releases/latest/download/XclocEditor.zip") before running `./run uploadstrings` [Dec 2025]
        - Before **testTakeScreenshots_XXX()** 
            - [ ] Probably switch to **lightmode** for the screenshots
            - [ ] Probably do `testTakeScreenshots_Localization()` on large monitor (tall menus on action table are cut off on M1 MBA [Dec 2025]) (Could perhaps solve by programmatically moving window up?)

        - Import .xcloc files
            - [ ] >>> z mac-mouse-fix; ./run importstrings --xcloc-path ...
                - >>> ./run importstrings2 --xcloc-path ... --only-comment-mismatches
                - [ ] Review mismatches
            - [ ] Update applyHardcodedTabWidth()

        - Update Markdown files:
            - [ ] Run ScreenshotTaker XCUITest in Xcode
                - >>> func testTakeScreenshots_Documentation()
                - Tip: Modify 'onlyUpdateLocales' at the top for quick update. [Dec 2025]
            - [ ] Rebuild all the docs
                - >>> ./run _buildmd --document '.*(?<!Acknowledgements\.md)$'
                    - Skip Acknowledgements.md since we don't want to wait for Gumroad data downloads – The GitHub Actions runner will later regenerate Acknowledgements.md with the latest data.

        - Update Translation Guide
        - [ ] Run uploadstrings on the master branch 
            - >>> ./run uploadstrings --only-update-locale xx
            -> (Will run func testTakeScreenshots_Localization() automatically)
            -> If new UI added (or anything in the app changed that affects all locales), omit `--only-update-locale`.
                - (Tip: Maybe on a second computer cause this takes a while if you update all the locales.)
                - (Note: If this gets annoying, look into automating with GitHub Actions runner.)

        - Publish App update
            - 

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            - [ ] >>> z mac-mouse-fix-website; ./run importstrings --xcloc-path ...
                - >>> ./run importstrings2 --xcloc-path ... --only-comment-mismatches
                - [ ] Review mismatches
        
        - Update website
            - [ ] `pnpm upload`

Add credits
    - [ ] Add credits to the Acknowledgements
    - [ ] Add credits to Update Notes

Other:
    - [ ] Send 10 MMF licenses to translator (?)

Review: 
    - [ ] Built app                         (See: https://github.com/noah-nuebling/mac-mouse-fix/releases/download/.../MacMouseFixApp.zip / Xcode > Archive)
    - [ ] Localization screenshots          (See: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638)
    - [ ] Markdown docs (Readme.md etc.)    (See: https://github.com/noah-nuebling/mac-mouse-fix/tree/master/Markdown/LocalizedDocuments)
        - [ ] Documentation screenshots         
    - [ ] Website                           (See: https://macmousefix.com/)

    - [ ] Send translators a review request

    (See `MMF - Translation Checklists Overview [Dec 2025].md` for previous review requests)