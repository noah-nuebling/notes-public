

**Translation Files**

MULTIPLE LANGUAGES:
    (Apply this to all the langs we added recently [Dec 2025])
    - [ ] 🇧🇷 Brazilian Portuguese
    - [ ] 🇫🇷 French
    - [ ] 🇹🇷 Turkish
    - [ ] 🇨🇿 Czech
    - [ ] 🇷🇺 Russian
    - [ ] 🇨🇳 Chinese (Added website translation recently)

(Should maybe do this more frequently than publishing updates [Nov 2025])

Core:
    Mac Mouse Fix.xcloc

        Prep/Other:
        - If **new UI added** 
            – [x] Consider updating `testTakeScreenshots_Localization()` to cover it before running `./run uploadstrings`
        - Before **testTakeScreenshots_XXX()** 
            - [x] Before running, don't forget to manually build the 'App' scheme (Command-B)!
                - Because currently, the app is not built automatically to make iterations faster. [Dec 2025]
            - [x] Probably switch to **lightmode** for the screenshots

        - Import .xcloc files
            - [x] Using Xcode, inside In mac-mouse-fix
            - [x] Update applyHardcodedTabWidth()

        - Update Markdown files:
            - [x] Run testTakeScreenshots_Documentation()
            - [x] Rebuild all the docs 
                - ./run build-markdown --document '.*' --no-api
                    - --no-api if you don't wanna wait for Gumroad data downloads.

        - Update Translation Guide
        - [ ] `./run uploadstrings` on the master branch (Will run testTakeScreenshots_Localization())
            - (Tip: Maybe on a second computer cause this takes a while)
            - (Note: If this gets annoying, look into automating with GitHub Actions runner.)
            - (Note: Currently have to manually build 'App' scheme first [Nov 2025] – See "Before **testTakeScreenshots_XXX()**" above) [Dec 2025]

        - Publish App update
            - [ ] 

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

    - [ ] Send translators a review request