macOS 26 Tahoe - MMF Issues
    (Formerly _dailynote_2025.06.27.md)

Beta 2:
    - MMF Views:
        - Buttons Tab
            - Line underneath button-group-rows is has wrong color
                - [x] Fix 
                    - Fixed for MMF 2 in ac5113c96 [Aug 28 2025]
            - When scrolling line underneath button-group-rows out-of-view, the line gets duplicated over and over [Tahoe Beta 3] [Jul 12 2025]
                - [ ] Fix
            - '+'-field has bad color
                - [x] Fixed in e71c97531c70056b54dedb05112970f1c799a2b5
                - Note: [Aug 2025] In MMF 2 it looks fine - there we're just using NSBoxPrimary IIRC. (Why did we ever move away from that?)
            - Minus-Buttons are too wide. 
                - [x] Feedback FB18750469
                - Couldn't fix. They render at a wider width than they are set to in IB.
                - Update: [Aug 2025] [Beta 8] You can fix it using NSSegmentedControl with one segment. It looks just as we desire!
                    - See `Repro-Buttons-Too-Wide` project.
                    - See `RemapTableButton *` in the MMF source code
                    - See followup feedback: FB19958973
                - [ ] Use NSSegmentedControl if Apple doesn't fix it
            - Keycap Symbols for " Exclusive Keys" don't show up in popupbuttons.
                - This works under Sequoia
                - [x] Feedback FB18785755
                - [x] Update: Apple Fixed in Beta 5
            - Text while capturing shortcut doesn't line up perfectly with text in popup button (It did under Sequoia)
            - Popup buttons text stays black even when the row they are on is selected, and has a dark-blue background. (Very low contrast.) (This is easier to test in MMF 2)
                - [x] Feedback FB19948784
            - [ ] The 'Launchpad' option needs to be renamed
                - Think we worked on that in the `tahoe-symbols` branch
        - General Tab
            - Enabled Switch plays very janky animation on startup
            - [x] Feedback FB18794304 (It's a bug in NSSwitch that I couldn't find any workaround for.)
            - Fixed now [Sep 2 2025] but now the Switch jankily switches to glass while holding down left click on it
                - [ ] Fix
        - Menu Bar Item
            - The Icon next to 'Scrolling' is squished.
            - [x] Fix 0d26e9bb66cb3368adbdd930212303e98a002c59
        - LicenseSheet
            - Back Button jankily shrinks in width when clicked
                - [x] Update: Fixed! Had to set set .prefersCompactControlSizeMetrics earlier in the lifecycle.
                - Couldn't fix. Seems to be an Apple Issue [Jun 27 2025]
        - Accessibility Sheet
            - MMF Icon and Accessibility Icon are both round instead of Square!
        - Toasts
            - Looks outdated. Little dark now (Update: ... color does match menus)
            - [ ] Fix
    - General
        - App Icon
            - [ ] Liquid Glassify
        - Menu Bar Item
            - Update the icon. (Remember the outline is based on the battery icon outline, which is now more bright and vibrant under Tahoe)
            - [ ] Update
        - All NSPopUpButtons
            - When the pbutton has an item selected that has an image, that looks bad – image is rendered too close to text. (This doesn't happen on macOS Sequoia.)
            - [x] Feedback 
        - All dialogs
            - Our custom labels / controls are centered (should be left-aligned on Tahoe)
            - Dialogs I can think of:
                - `Enabling Failed`, `Buttons > Restore Defaults`, 
            - [ ] Fix
        - All Menus
            - We can add SFSymbols
                - (See branch `tahoe-symbols`)
            - [ ] Do it

        - All Sheets
            - Sheet corner radius is too large – looks "non-concentric" with bottom-right button.
                - [x] Feedback FB18774823
                - Apple Issue. Same can be observed in Apple's sheets, e.g. `Safari > Export as PDF...` or `Safari > Print...`. 
                - Places with "Big" buttons (which are rounded under Tahoe) look better. E.g. `Safari > Export Browsing Data to File...` or `MMF > Buttons > Restore Defaults...`
                - Under Sequoia both normal and large buttons looked pretty 'concentric' with sheet corners, but under Tahoe only rounded buttons do – this is a bit ironic since they emphasized "concentricity" so much in the WWDC.
                - Sidenote: WWDC talk (https://developer.apple.com/videos/play/wwdc2025/310/) says you can round any-size buttons with .borderShape property, but that doesn't seem available as of Tahoe Beta 2
                    - Update: You can use KVC and set @"bordershape" to @2
        - Buttons
            - You can no longer drag off a button after mouse-downing on it to cancel the button-activation.
                - [x] Update: Fixed in Tahoe Beta 3
            - ? Big Buttons no longer feel very big. They just feel like rounded versions of normal buttons. Much smaller than under Sequoia.
            - When using `.prefersCompactControlSizeMetrics`, checkboxes are too low vs their labels (not aligned)
                - [x] Feedback FB18774315
            - Horizontal margins are smaller than Sequoia when using .prefersCompactControlSizeMetrics
                - [x] Feedback FB18733456
        - Text Fields
            - Contrast is too low
                - [x] Feedback FB18733624
        - Logical 'child' elements are not lined up with their parents
            - This is mostly due to checkboxes being fatter under Tahoe
            - NSView.prefersCompactControlSizeMetrics is necessary to fix this (As long as we rely on interface builder – since that won't let us define version-specific margins.)
        - Main Window
            - Doesn't animate in nor out.
                - [x] Feedback FB18749603
                - Animate OUT:
                    - Seems like it can be fixed by disabling our `-applicationShouldTerminateAfterLastWindowClosed: YES` override – But I feel like that's something Apple should solve
                - Animate IN: 
                    - Apple Problem. Notes.app also doesn't have an IN animation. (Except if the window is opened while the app is already running)
            - When opening the window, I often observed it flash at a larger size first [Sep 2 2025]
                - [ ] Fix
                - (Idea: Maybe related to the selected-tab-restoration?)
                - (I think I only saw this on feature-strings-catalog?)
        - Bad menubar performance
            - Clicking "Window" menubar jankily flashes the glassy background first, before loading-in content
            - Moving cursor around to different menubar items lags and doesn't feel responsive.
                - Fixed in Beta 3 (Update: Nope, still happens. Maybe only happens when system is under load)
            - [x] Feedback FB18793256

Non-Tahoe Specific issues:
    - Enabling-Failed dialog
        - Shouldn't even exist on Tahoe (Outdated since like macOS 13 or so)
        - [x] Fix b9e4de5c87243ac8f8f37907f24aeeb9a424d5de
    - Enabling-timed-out Toast:
        - Shows up behind sheets
        - Shouldn't even exist on Tahoe (Outdated since like macOS 13 or so)
        - [x] Fix b9e4de5c87243ac8f8f37907f24aeeb9a424d5de
    - Some of the hints look 1 px too far to the left.
        - [x] Investigate – This was an optical illusion
    - Thank-you section is not centered
        - [x] Fix
    - Free-country section is cut off in Chinese
        - [x] Fix
    - When app enables after accessiblity is granted, the animation is janky
        - [ ] Fix 
        - I can't always reproduce this. I think it happens, when the expand animation starts while the sheet is in its dismiss animation.
    - Text on the TrialNotification is cut off in Chinese
        - [ ] Fix
    - Margin under "Keyboard Shortcut..." menuItem is too small
        - [x] Fix cfc6dc5b24fc982217354187347316376dd8d3f3
    
    Unrelated stuff I might wanna address now
        - [x] Maybe remove SnapKit while we're at it?
        - [x] Look into ignoring drawing tablet (Done in commit: fb20ca2fd58d98a984f157f842fcf2f97d892b22)
        - [x] Broken scroll-cancellation in iPad apps. (Done in commit: 03f35ce941472ed8ec36e6fe3ccb07496bd53982)
        - [x] Look into improving twoFinger clickAndDrag performance (Done in commit: 854ec4cb1b2bf276a49150636efb281d4ed98fcf)


Issues that don't affect MMF (yet)
    - Cannot recreate the look of SwiftUI GroupBox in AppKit because 
        - NSColor does not have matching colors.
            - [x] Confirmed in `nscolor-tester` repo
        - Custom colors cannot support wallpaper tinting.
        - [x] Feedback FB18757582
    - Cannot make borderless popupbuttons (like the ones in System Settings) in AppKit (or SwiftUI)
        - [x] Feedback FB18733624 (In wrong category)
    - Text inside buttons and popUpButtons does not look centered (Doesn't affect us due to `.prefersCompactControlSizeMetrics`)
        - [x] Feedback FB18371756 (In wrong category – not AppKit)
    - SFSymbols exported from SFSymbols.app and then imported into Xcode get rendered at wrong size unless you choose "Export for Xcode 14" or older. (See the readme/notes we wrote in MMF.)
        - [x] Feedback FB18759197 and FB18759496

Non-visual issues: [Sep 2025] (Doesn't belong here)
    - If there's a strange helper not started by launchd, then MMF will just not enable and not kill the strange helper – This sometimes annoyed us while running the automated screenshot stuff.
        - [ ] Fix

Trivia:
    - Based on Xcode view debugger, it seems NSButton is a wrapper around SwiftUI in Tahoe (Ew). That might explain the autolayout jank on the cancel button on the LicenseSheet.
    - The Xcode view debugger doesn't work properly on SwiftUI :| ... I don't wanna be an Apple developer anymore

Where to file feedback?
    Probably under AppKit in Feedback Assistant  (I already reported some of the system-wide issues under macOS – maybe I should resubmit them under AppKit? [Jun 27 2025])

References:
    - WWDC 25 - Build an AppKit app with the new design - https://developer.apple.com/videos/play/wwdc2025/310/