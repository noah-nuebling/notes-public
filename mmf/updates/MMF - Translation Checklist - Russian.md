

**Translation Files**

(Should maybe do this more frequently than publishing updates [Nov 2025])

Core:
    Mac Mouse Fix.xcloc

        Prep/Other:
        - [ ] If new UI added – Consider updating `testTakeScreenshots_Localization()` to cover it before running `./run uploadstrings`
        - [ ] Before running testTakeScreenshots_XXX – Don't forget to manually build the 'App' scheme (Command-B)!
            - Because currently, the app is not built automatically to make iterations faster. [Dec 2025]
        - [ ] Probably switch to **lightmode** for the screenshots

        - Import .xcloc files
            - [x] Using Xcode, inside In mac-mouse-fix
            - [ ] Update applyHardcodedTabWidth()

        - Update Markdown files:
            - [ ] Run testTakeScreenshots_Documentation()   
            - [ ] Rebuild all the docs 
                - `./run build-markdown --document '.*' --no-api`
                    - --no-api if you don't wanna wait for Gumroad data downloads.

        - Update Translation Guide
        - [ ] `./run uploadstrings` on the master branch (Will run testTakeScreenshots_Localization())
            - (Tip: Maybe on a second computer cause this takes a while)
            - (Note: If this gets annoying, look into automating with GitHub Actions runner.)
            - (Note: Currently have to manually build 'App' scheme first [Nov 2025]) 
                - (Background: The Localization Screenshot Taker doesn't auto-build to speed up iteration times - but that creates a footgun here – I think at least)

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
    - [ ] Markdown docs (Readme.md etc.)
    - [ ] Website

    - [ ] Send translators a review request