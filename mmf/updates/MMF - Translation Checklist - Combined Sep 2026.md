
Also see:
    _dailynote_2026.09.10.md (This is sort of a substep of the steps in here)

Locale addition requests
    - [x] Add Norwegian @Bertil78: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4182846504
    - [x] Add Bengali @Ifty-Rahman: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-5083257598

Submissions (We haven't integrated, yet)
    GitHub
        - Japanese @y-128: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4191409106
        - Japanese update @mei28: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4218636133
        - Vietnamese @quocthangit247: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3876405270
        - French @UYTR5: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3888010759
        - French website @Clementabcd: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3985604493
        - Spanish @manghidev: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3994798838
        - Simplified Chinese Update @djzhao627: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4064750078
        - Ukrainian @denysocheck: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4282037521
        - Turkish update @mstersnd: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4511309127
        - Turkish update @mls0x1: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4801772821
        - Norwegian @Bertil78: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4820887178
    Email
        - Turkish Eren Tomurcuk: message:<OfZ84n5--F-9@tuta.io>
        - Brazilian Portuguese Eduardo Rodriguez: message:<D9DBBC48-47AD-42EC-8BE6-46D611474277@icloud.com>
        - Turkish Samim Kel: message:<CAG9To-p8EkFgxsaF1uLE=L2d-u8fs_dZ7iDxJQ5OB1U3t7vQhw@mail.gmail.com>
        - Ukrainian @denysocheck: message:<78FD2C3A-E753-4DE7-AB3E-76D184334DC2@gmail.com>
    Pull requests:
        Simplified Chinese @JunhangWu: https://github.com/noah-nuebling/mac-mouse-fix/pull/1836

Locale list (for copy-pasting)
    - [xxx] Vietnamese
    - [xxx] French
    - [xxx] Spanish
    - [xxx] Simplified Chinese
    - [xxx] Japanese
    - [xxx] Ukrainian
    - [xxx] Turkish
    - [xxx] Norwegian
    - [xxx] Brazilian Portuguese


Checklist (Based on `MMF - Translation Checklist - Template.md`)

Translations by @mei28: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4218636133

Core:
    Mac Mouse Fix.xcloc

        - Import .xcloc files
            Steps:
                1. >>> z mac-mouse-fix; ./run importstrings --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations French @UYTR5/Mac Mouse Fix.xcloc'
                2. >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations French @UYTR5/Mac Mouse Fix.xcloc'
                3. Update: func applyHardcodedTabWidth()
            - [x] Japanese
            - [x] Vietnamese
            - [x] French
            - [ ] Spanish
            - [ ] Simplified Chinese
            - [ ] Ukrainian
            - [ ] Turkish
            - [ ] Norwegian
            - [ ] Brazilian Portuguese

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            Steps: 
                >>> z mac-mouse-fix-website; ./run importstrings --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations Vietnamese @quocthangit247/Mac Mouse Fix Website.xcloc'
                >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations Vietnamese @quocthangit247/Mac Mouse Fix Website.xcloc'
            - [x] Japanese
            - [x] Vietnamese
            - [x] French
            - [ ] Spanish
            - [ ] Simplified Chinese
            - [ ] Ukrainian
            - [ ] Turkish
            - [ ] Norwegian
            - [ ] Brazilian Portuguese
        
        - Update website
            Steps:
            - [ ] `pnpm dev`
            - [ ] `pnpm upload`

        - Update Markdown files:
            - Run ScreenshotTaker XCUITest in Xcode
                Steps:
                    1. Modify 'onlyUpdateLocales' at the top
                    2. >>> func testTakeScreenshots_Documentation()
                - [x] Japanese
                - [ ] Vietnamese
                - [ ] French
                - [ ] Spanish
                - [ ] Simplified Chinese
                - [ ] Ukrainian
                - [ ] Turkish
                - [ ] Norwegian
                - [ ] Brazilian Portuguese
            - Rebuild the docs
                >>> ./run build-markdown --document '.*(?<!Acknowledgements\.md)$'
                - [x] Japanese
                - [ ] Vietnamese
                - [ ] French
                - [ ] Spanish
                - [ ] Simplified Chinese
                - [ ] Ukrainian
                - [ ] Turkish
                - [ ] Norwegian
                - [ ] Brazilian Portuguese

Add credits
    - Add credits to the Acknowledgements
        Steps:
            1. Add
            2. To stop _buildmd.py from failing, the []({urls}) need to match in all languages:
                - [ ] Manually add the new entry to all the translations of `2: translations`.
                - [ ] Update the surrounding urls
                    - >>> ./run updateackurls;
       - [ ] Japanese
       - [ ] Vietnamese
       - [ ] French
       - [ ] Spanish
       - [ ] Simplified Chinese
       - [ ] Ukrainian
       - [ ] Turkish
       - [ ] Norwegian
       - [ ] Brazilian Portuguese
    - Add credits to Update Notes
        - [ ] Japanese
        - [ ] Vietnamese
        - [ ] French
        - [ ] Spanish
        - [ ] Simplified Chinese
        - [ ] Ukrainian
        - [ ] Turkish
        - [ ] Norwegian
        - [ ] Brazilian Portuguese

Update Translation Guide
- Run uploadstrings on the master branch 
    >>> ./run uploadstrings --only-update-locales ...
    - [x] Japanese
    - [ ] Vietnamese
    - [ ] French
    - [ ] Spanish
    - [ ] Simplified Chinese
    - [ ] Ukrainian
    - [ ] Turkish
    - [ ] Norwegian
    - [ ] Brazilian Portuguese

- [ ] Publish App update
    - See `MMF - Update Checklist - Template.md`

Other:
    - Send 10 MMF licenses to translator (?) (/answer in general)
        - [ ] Japanese
        - [ ] Vietnamese
        - [ ] French
        - [ ] Spanish
        - [ ] Simplified Chinese
        - [ ] Ukrainian
        - [ ] Turkish
        - [ ] Norwegian
        - [ ] Brazilian Portuguese

Review: 
    Don't have time / nerves to do the review steps from `MMF - Translation Checklist - Template.md`

---

Not sure if / when to do this:
    - [ ] Update *all* the screenshots using ./run uploadstrings (so they're on macOS 27, instead of 15)

Later (after 3.1.0 release)

    - [ ] Update Xcode Editor (layout bugs on macOS 27)
            Upload new Xcloc Editor (at "https://github.com/noah-nuebling/mf-xcloc-editor/releases/latest/download/XclocEditor.zip") before running `./run uploadstrings` [Dec 2025]