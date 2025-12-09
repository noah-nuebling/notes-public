

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
            - [x] Probably switch to **lightmode** for the screenshots

        - Import .xcloc files
            - [x] Using Xcode, inside In mac-mouse-fix
            - [x] Update applyHardcodedTabWidth()

        - Update Markdown files:
            - [x] Run ScreenshotTaker XCUITest in Xcode
                - >>> func testTakeScreenshots_Documentation()
                - Tip: Modify 'onlyUpdateLocales' at the top for quick update. [Dec 2025]
            - [x] Rebuild all the docs
                - >>> ./run build-markdown --document '.*' --no-api
                    - --no-api if you don't wanna wait for Gumroad data downloads for Acknowledgements.md – The GitHub Actions runner will later regenerate Acknowledgements.md with the latest data.

        - Update Translation Guide
        - [x] Run uploadstrings on the master branch 
            - >>> ./run uploadstrings --only-update-locale xx
            -> (Will run func testTakeScreenshots_Localization() automatically)
            -> If new UI added (or anything in the app changed that affects all locales), omit `--only-update-locale`.
                - (Tip: Maybe on a second computer cause this takes a while if you update all the locales.)
                - (Note: If this gets annoying, look into automating with GitHub Actions runner.)

        - Publish App update
            - 

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            - [ ] Using Xcode, inside mac-mouse-fix-website
        
        - Update website
            - [ ] `pnpm upload`

Add credits
    - [x] Add credits to the Acknowledgements
    - [ ] Add credits to Update Notes

Other:
    - [ ] Send 10 MMF licenses to translator (?)
    

Review: 
    - [ ] Built app
    - [ ] Localization screenshots
    - [ ] Documentation screenshots
    - [ ] Markdown docs (Readme.md etc.)
    - [ ] Website

    - [x] Send translators a review request