
(Formerly _dailynote_2025.10.19.md)

While translating the German .xcloc file and then submitting it: (Simulating the localizer experience)

    Notes on localizer experience:
        - Xcode
            - Takes a while to download
            - Shows (useless) sidebar by default after opening the .xcloc file (on my macOS Tahoe install - I don't remember it doing that when testing last year in 2024?)
        - The quicklook window is cumbersome to work with with (no kb shortcut, hard to resize, resets position, becomes blank when editing the string)
        - No universal search (can only search in a single file) (at least I couldn't get it to work.) (That's pretty bad I think.)
        - Can't directly control the string state (just automatically changes to 'translated' if you do any edits) (This is pretty bad)

        - It's a bit easy to loose the Finder window after using 'Compress xcloc files.xcloc' (Maybe the NSAlert should have a 'Reveal in Finder' button?)

        - Very long localizable string (`software.libraries`) in Acknowledgements.md was hard to audit - should be shorter. Should generally avoid very long strings in .xcloc file.

    TODOs:
        - [xxx] Mark all the 'pluralizable' strings as ok or don't translate (they shouldn't be translated)
            - -> Can't mark them as don't translate without also marking the pluralized variants themselves (at least in the Xcode UI) - just leaving it as is.
        - [xxx] Orphaning
            - "in deinem Land kostenlos" -> kostenlos is orphaned.
            - "deaktiviert worden" -> worden is orhpaned.
            - "for which Mac Mouse Fix was enabled" comment -> Should be "previously enabled"
            - -> Seems to be a bug in macOS or orphaning doesn't work in German?
        - [x] 
            - Note 2: "&nbsp;" Creates a "non-breaking space" character which prevents the menu bar icon from ending up on a separate line from the text "Menu Bar". 
            - should be
            - Note 2: "&nbsp;" Creates a "non-breaking space" character which prevents the menu bar icon from ending up "orphaned" on a separate line from the "Menu Bar" text.
        - [x] Remove Swift Markdown from Acknowledgements
            - [x] Shorten or remove `10: software.libraries` from Acknowledgements.
        - [x] Remove "I landed on"
        - [x] Improve thankyou messages (See _dailynote_2025.10.20.md)
        - [ ] Maybe write feedback to Apple about lacking Xcode .xcloc editing experience (See above) [Oct 20 2025]
        
        
        Other:
        - [ ] Remove the 'Ask the community' string from MMF.