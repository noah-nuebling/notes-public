# MMF Post Localization Todo [Mar 2025]
(Formerly `MMF General Todo [Mar 2025].md`)

Small bugs that I should look into before the next release:

- (First thing we should do is finish up the localization stuff, but then we might wanna look into small things:)

<br>

- [x] Look into issue where scrolling stops intermittently
    - See this [note](./bug-investigation/scrolling-stops-intermittently_apr-2025.md)
- [ ] Maybe address inconsistencies/errors we found in SwitchMaster.swift and DisplayLink.m while investigating `scrolling stops intermittently`. (Made notes about them in the source code.)
- [x] Look into Stylus interference - might be easy to fix
    - See this [GitHub Issue](https://github.com/noah-nuebling/mac-mouse-fix/issues/1301)
    - Update: [Aug 2025] Addressed in 3.0.5
- [ ] Look into bug where there are dozens of windows about some url permission error (got an email about that from Brendon recently) - at least write a code comment
    - See this [mail](message:%3C643376E2-ABD0-4D95-83B9-4D0193A3CEEE@icloud.com%3E)
- [ ] Look into scroll and navigate lag  issues on very high polling rate
    - See this [mail](message:%3CCAMbYH-rYhZh-7MLEu+tZ10C1AA2-5vkQK9pS4b8bDdY6APUAAg@mail.gmail.com%3E)
    - See this [mail](message:%3CE4707C72-811C-4111-8D12-64E683334BC9@lozhnikov.com%3E)
    - Update: [Aug 2025] I think I made it better in 3.0.5 by optimizing the ScreenDrawer. But not sure all the issues are fixed.
- [ ] Look into preventing jank when granting accessibility access
    - [ ] Maybe improve MFMessagePort 
      - IIRC the port calling uninitialized modules when accessibilty isn't granted caused crashes 
      - Solution idea was to create whitelist of modules that may be called before accessibility is granted and ignore other messages.
      - Update: [Aug 2025] Another source of jank is when the ax sheet is animating out *while* the general tab is doing it's expand animation. That seems to break the expand animation.
- [x] Look into disabling "if you have problems enabling click here" messages
    - Ideas for updating:
        - Make it trigger later
        - Make it say 'try waiting a bit or restarting the app, if problem persists please file a [Bug Report](...)' 
            - Waiting a bit or restarting the app always fixes issues on newer macOS versions in my experience. Never had to reboot IIRC.
        - Don't link to outdated guide anymore.
        - Maybe reconsider the CPU usage tracking stuff?
- [x] Maybe start implementing 'hotfix' for back/forward not working in VSCode and other apps
    - Got request about that recently: https://github.com/noah-nuebling/mac-mouse-fix/issues/1333
    - Should be quite useful and relatively easy to implement 
      (I think we're already doing something similar to fix zooming delay in Chromium browsers)
    - Done in commit aa2346f710949d1fa9127579b4a68e78ad2216a6!
- [ ] Look into adding 'No Action' / 'Do Nothing' option (See: https://github.com/noah-nuebling/mac-mouse-fix/issues?q=state%3Aopen%20label%3A%22%27Do%20Nothing%27%20Option%22)
    - [Aug 2025] I'm currently doing some of these TODOs before the localization update ships, but not implementing this, because we don't want an unlocalized UI element be so prominent!
- [ ] Maybe implement the mouse-friendly App Switcher SHK which we learned about working on EventLoggerForBrad.
- [ ] Cleanup GitHub repo
    - Delete crowdin.yml (And make sure Crowdin doesn't regenerate it somehow)
    - Delete the Codacity GitHub Marketplace app or what it's called.

[Apr 2025]
- [x] Polish: The 'it had been disabled from the Menu Bar' toast's icon has the wrong color after switching system appearance while the app is open.
    - Fixed in commit 8c49c31f8ff392d4a5a6a8fbcc5df30ea3435696
- [x] Polish: LicenseField: When you enter 413BAFD3-CCD84D9E-8D718567-A804E127413BAFD3-CCD84D9E-8D718567-A804E1 and then undo it / Cmd-X it, the placeholder text gets messed up (Observed [Apr 11 2025], right after merging master into feature-strings-catalog)
    - Fixed in commit 73b760e46768ede3c30786427fe84258a297338a
- [x] Polish: Add 'Activate License' link on the TrialNotification
    - it often annoys me that it's not there (And I think we originally built it like that but turned it off for some reason.)
    - Update: [Aug 2025] Added this in MMF 3.0.5
- [x] Polish: The link to the MMF website still goes to mousefix.org (and is then redirected) instead of going directly to macmousefix.com.
    - ... Actually, I'm pretty sure we fixed that on the feature-strings-catalog branch.

[Jul 2025]
- [x] Feedback Assistant has issue. Evidence:
    - https://github.com/noah-nuebling/mac-mouse-fix/issues/1463 "The form for bugs failed. So writing it manually"
    - https://github.com/noah-nuebling/mac-mouse-fix/issues/1462 "Also the web report have a small error, I cannot submit because it doesn't allow me to enter version :(" 
    - Update: [Aug 2025] I think I addressed this by having a fallback mechanism in case the GitHub API that gives us a list of the MMF releases fails.


[Aug 2025]
- [x] Turn off the superfast scrolling for the MX Master freespinning wheel. (Done in commit: b7cf9cd80660607ed355d0b2996b586a35411249)
- [ ] (I forgot what I wanted to write here.)
- [x] There is weird black jank around the edges of the addField when it bounces after recording a shortcut. (I thought we made it perfect before! But in macOS Sequoia, MMF 3.0.6, the issue is there.)
    - Update: Fixed in b30612d988b4a90a0bd214ccdbbc87be6ab8147f and subsequent commits
- [ ] Maybe, at the bottom of the 'it had been disabled from the Menu Bar' toasts, add 
    "Learn how to **permanently disable** Mac Mouse Fix for Scrolling, in the [Captured Buttons Guide]()"
    -> That should clear up some confusion of users writing feedback requests. 
- [ ] Maybe add 'prefersCompactControlSizeMetrics' in Interface Builder (That's been added in Tahoe Beta 5 IIRC.)

[Not sure when I added these]
- [ ] Make note about: opposite-tick to stop scrolling doesn't work properly in iOS apps and iPhone mirroring (stop-scrolling works with click-and-drag though so our event-generation must be wrong somehow.) 
- [ ] Make note about: opposite-tick feels bad with quick-scroll modifier (Could probably be fixed by bringing up stop-speed of quickscroll which is lower than normal scroll IIRC)
- [ ] Make note about: Swift Scroll and Precise scroll generally feel kinda bad when I try to use them in real situations.