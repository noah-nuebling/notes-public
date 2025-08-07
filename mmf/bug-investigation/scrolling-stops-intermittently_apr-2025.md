# Scrolling Stops Intermittently
[Apr 2025]

See the GitHub Issue Categories "Scroll Stops Working After macOS Update" and "Scroll Stops Working Intermittently":
  https://github.com/noah-nuebling/mac-mouse-fix/issues?q=state%3Aopen%20label%3A%22Scroll%20Stops%20Working%20Intermittently%22%20%20OR%20label%3A%22Scroll%20Stops%20Working%20After%20macOS%20Update%22


## Interesting stuff I found:

- [1] In this [Apple Forums Thread](https://developer.apple.com/forums/thread/693451?page=22) users seem to have similar issues – without using Mac Mouse Fix, I assume. 
    - So perhaps some, or all, MMF users experiencing this problem are actually experiencing a bug in macOS. Although the reports of fixing the issue by toggling settings inside MMF seems to point against this theory.
- [2] There's a [Reddit Thread](https://www.reddit.com/r/macapps/comments/1icu128/mac_mouse_fix_scroll_not_working/) about this problem.

## Observations / Patterns about reports:

- Several people report that it happens after an update.
- Several people report that it disappears when they turn off Smooth Scrolling in MMF UI, 
    But comes back when they turn it back on. (IIRC) 
    - [ ] (Find out: Do they turn off all scrolling options or just 
        Smooth Scrolling? If the latter, that's actually really important!)
- Several people report that it happens after waking up the computer
- Several people report that it happens after booting the computer (IIRC)
- Several people report that it happens after connecting their mouse (IIRC)
- Some person suspected something about their external display and using it as a Dock? 
- Several people report that they fix it by killing the app in Activity Monitor (IIRC)
- One person reported that it goes away when they enable Logi Options+ alongside MMF
  - Mr Han in [this mail](message:<OSRPR01MB120301C001EAE1A38C819F5919BAE2@OSRPR01MB12030.jpnprd01.prod.outlook.com>)
- One person reported that they fix it by connecting another mouse (IIRC) 
    - (or switching the connection technology on their mouse to/from Bluetooth and back ? – I don't remember)
    - DANGER ZONE: I think I'm confusing things. I think M Dino? Was reporting the mouse-connection-fixes things 
       stuff, but he's experiencing a *different issue*. I think we wrote several things above and below here under 
       the assumption that attaching/detaching mouse affects the bug – I think that might have all be confusion!
    - [ ] Check if there's any pattern in the reports (aside from M Dino) about attaching/detaching mice fixing the issue.
- One person could resolve the issue by moving the app out of the downloads folder 
    - But IIRC others confirmed that the issue happened even though they had the app in the 
       Applications folder, so it might have been a coincidence
- I think I had some reason to believe that the same issue happens under MMF 2 (that would be very interesting for pinpointing the problem) but I don't remember exactly what reason.
- Users report that MOS doesn't have this issue. (Src: Reddit thread [2])
- There are very similar reports (IIRC) from a long time back, but recently they seems to be getting a lot more frequent. 
    - Observed frequency-increase might be a bias cause I'm paying more attention to it now?

## Observations about debug info

- M Dino sent us 2 interesting sysdiagnose reports
    - But they experience an issue where *Click and Drag Gestures* stop working – instead of
       scrolling, which all the other reports talk about.
    - In their 1. report, I could see that something went wrong in the SwitchMaster, but I couldn't see the 
      reason cause the logs in the SwitchMaster weren't detailed enough, yet.
    - In their 2. report, I couldn't really make sense of what I'm looking at, so 
       I asked them more questions and am yet to look at their second report again. [Apr 2025]

## Theories

- Issue in the Switch Master. 
    - Pro: 
        - In M Dino's 1. report, Gestures not activating, seems to have been caused by the SwitchMaster.
        - Switch Master very complicated, I'm not sure if it's thread-safe, and it uses lots of different 
           modules and APIs as 'information sources' which might all cause issues if they're buggy – so 
           it seems generally quite error-prone.
    - Contra: 
         - Switch Master can turn on/off Mac Mouse Fix's effect on the mouse, but I think a bug inside it wouldn't 
           *block* the mousewheel input entirely. ––– It either turns the eventTap off or on, that's it. 
            The tap has to be *on* to block scrolling – so it seems to be doing its job.

- Issue in Apple's CGEventTap
    - Pro:
           - Apple Forums thread about very similar issue [1].
               - The behavior they describe seems to be exactly the same, which is suspicious.
               - Idea: IIRC, some users reported that the issue is immune to the 
                  usual fixes (Restarting MMF, restarting MMF, turning off SmoothScrolling – ?)
                  -> Perhaps those ppl are experiencing the macOS issue, and the other ppl are 
                       experiencing a bug in MMF that just happens to look the same.
           - Users say MOS doesn't have the issue. 
               (Heard this once, I think in Reddit Thread [2] not super confident in this [Mar 2025])
               IIRC MMF listens at the HID level and sends at the session level (to prevent 
                    feedback loops - cause architecture bad)
                On the other hand, MOS, listens at the annotatedSession level, and also posts there 
                    using eventTapProxy (Confirmed this on MOS Master branch on [Mar 2025])
                 -> It conceivable that there's an issue in Apple's CGEventTap API that 
                      only appears in MMF, not MOS, due to this difference
    - Contra:
        - Bug disappears as long as users disable Smooth Scrolling.
            - This is **strong evidence** against the theory I think. 
                (Update: Except if we're dealing with 2 different bugs as described above ?)
                - I double checked, and events seem to be sent using 
                   `CGEventPost(kCGSessionEventTap, ...)` whether smooth scrolling is enabled or not.

- Logic Bug, race condition inside Scroll.m
    - Explanation: Maybe there's a logic bug inside Scroll.m or related modules that 
       causes CGEventTapPost() to simply never be called.
     - Pro:
         - There's a lot that could go wrong here
     - Contra:
         - Seemingly 'environmental' triggers of the bug.
             - Logic bugs inside Scroll.m shouldn't be any more likely after waking up the computer or installing 
                a new macOS update. (... well, except if that causes a state-change in Scroll.m, see below.)
         - Bug also appearing in MMF 2
             - (I'm not super confident of this as of [Apr 3 2025] cause I don't remember the source, but if it's true:)
             - Since, IIRC, most of the code inside Scroll.m and related modules has been heavily modified between 
                MMF 2 and MMF 3, that makes it less likely that the bug stems from here. 
                    (If we're confident that the bug appears in MMF 2, maybe we should investigate exactly which 
                     parts of the Scroll processing haven't changed between MMF 2 and 3 to perhaps find cause of the issue.)

- Logic bug, race condition at Scroll.m *initialization*
    - Explanation: 
        - Maybe the triggers aren't inherently 'environmental', instead it's a race condition where things 
          sometimes break when Scroll.m is initialized or changes state in a certain way. 
          And the 'environmental' factors perhaps just cause Scroll.m to be initialized/change state in that way.
    - Contra:
        - Bug also appearing in MMF 2 (Not sure about this [Apr 2025]) 
           (See above for explanation why this is a counterpoint.)
    - Thought:
       - [ ] Perhaps investigate: 
           - What state inside MMF Helper changes when:
               - Helper is started
               - Attached displays change
               - Attached mice change
               - etc.

- Bug in API that Scroll.m uses
    - Explanation: 
       Some APIs that Scroll.m uses deal with 'environmental' information  which is
       retrieved from potentially buggy APIs. 
    - Brainstorm:
        - (Where does Scroll.m deal with environmental information?)
        - Animation/DisplayLink stuff
        - Getting display under current mouse pointer to link displayLink and scale scrolling acceleration to display size IIRC.
            - Idea: Maybe if the displaySize is reported as 0, we scale all scrolling deltas to 0
               (Update: [Apr 2025] That's not how the alrgorithm works – I double checked)
        - Getting app under mouse pointer to fix zooming in Chromium browsers. 
        - Getting the ScrollConfig 
           - Contra: Not that 'environmental', that's all our own stuff, (I think?) except if Apple's 
             API for loading the config file fails or something?
        - Getting currently pressed modifiers.
        - [ ] TODO: Look at the source code and see if there's something else we missed.

## Theories pt 2

(Halting mental inquiries from above because we discovered crucial point that we should focus on:
**Bug disappears as long as users disable Smooth Scrolling**.)

This means: There must be some state that MMF Helper gets into, such that, either `CGEventPost(kCGSessionEventTap, event)` is never called or that the events it sends don't actually cause any scrolling.
    - What could this state be?
        - Bug seems to only appear/disappear when certain environmental factors change...
            - Perhaps it's about connected displays? 
                - Pro: 
                    - Display changes (from the perspective of MMF) might happen at all of 
                       the 'environmental events' that are reported to trigger the issue: 
                       Restart (after update), wake from sleep, connect display (I think that was reported by some.)
                    - Scroll.m depends on display changes through: 
                        - DisplayLink for animations
                        - Scaling scroll speed to display size
                        - Maybe more (?)

This is a good lead. How can we move forward based on this?
- [ ] Add detailed logging in the areas where the bug might stem from
- [ ] Closely look at the codepath differences between SmoothScrolling off and on.
    - (Aside from Scroll.m, perhaps also take a look inside ScrollConfig.swift, can't think of any 
       other places rn where codepath would differ due to smooth scrolling.)
- [ ] Try more to collect debug logs 
    - from affected users.
        - Problem is that I'm sorta slow/inconsistent to communicate, and it's relatively 
           difficult for users to collect the logs, so it's hard to get responses there.
    - Perhaps install debug build before updating to new macOS version in case we catch issue ourselves.
- [ ] If we think it's a race condition inside Scroll.m, that'll probably go away by itself when we put all the IO 
        stuff on a single thread. In that case it might not be worth it to 'bandaid-fix' the issue in the short term – 
           but we *are* getting a lot of reports about it recently...
        - SIDENOTE: (This doesn't belong here) The new CADisplayLink API is made to be scheduled on your own 
           custom CFRunLoop. So we can put everything, including animations on one IO thread – very nice.
           For macOS 13 and older we can probably create a wrapper around CVDisplayLink that gives us the 
           same interface and keeps all its threading complexity contained. I really wanna implement that.


# Discussion with Claude

Most of the stuff below comes from this conversation with Claude: https://claude.ai/share/399ef397-3115-4653-8e3d-2988ae7e5c44

## Investigation & Theories - Reports about fixes

I investigated all the existing GitHub Issues, and extracted the reported reasons for how people made the issue go away.
    Note: I had kinda forgotten about the 
        "Scroll Stops Working After macOS Update" issues, so I only looked at 
        "Scroll Stops Working Intermittently" issues (Except for one Issue which I had miscategorized – https://github.com/noah-nuebling/mac-mouse-fix/issues/1279)
        However, IIRC, all the "Scroll Stops Working After macOS Update" issues I missed due to this were older, so I didn't miss much I think/hope.


### Gathered Reports


    https://github.com/noah-nuebling/mac-mouse-fix/issues/1112#issuecomment-2398983555

        ```
        I also faced this issue when upgraded to OSX 15.0. Tried several things until it worked again (my last operation was to forget & reconnect my bluetooth mouse).  Yesterday, upgraded to 15.0.1 and same again and after 10+ tries, it finally worked again (this time, forget & reconnect did not do the trick, not a mouse fix quit & start - strangely a disable/enable toggle of MacMouseFix has been the last thing I did).  In all cases, only the scroll was affected. Anything related to the click was OK. Disabling scrolling in MacMouseFix (giving hand back to Mac OSX) allowed to get the scrolling back.
        <...>
        Note that both time this happened for me after a MacOS update - both time, once I successfully managed to have MacMouseFix back to work, MacMouseFixe remains up & running smoothly (ie: hard to reproduce :))
        ```


    https://github.com/noah-nuebling/mac-mouse-fix/issues/1112#issuecomment-2399479588

        ```
        It usually happens on my part after waking up/rebooting but, again, not all the times and it seems to have diminished after the 15.0 update.
        <...>
        @noah-nuebling sorry for the late replay.
        The issue seems to be resolved for me as well. I am sorry but I can't pinpoint since when that is.
        ```


    https://github.com/noah-nuebling/mac-mouse-fix/issues/1121#issuecomment-2372849129

        ```
        1. Disabling and then re-enabling Mac Mouse Fix
        2. Rebooting the computer
        <...>
        Yes, I have tried 1. and 2., and both "fix" the issue temporarily, until it comes back (usually after waking from sleep). A more permanent actual fix would be great.
        <...>
        @noah-nuebling Update (sorry, didn't have time to use the debug version yet): This happens basically all the time on both my private M1 and work M2 Max MBP, always when waking from sleep. I'd day this happens about 7-8 out of 10 times.
        ```

        (This is kinda funny, cause it happens 7/10 he wakes up his computer, (crazy) but he doesn't have *time* to install the debug build – I think this might mean it's quite mentally taxing for people to bother installing the debug build?)

    https://github.com/noah-nuebling/mac-mouse-fix/issues/1224#issue-2744976608

        ```
        On my MAC I had to disable and re-enable several times to make it work again
        ```

    https://github.com/noah-nuebling/mac-mouse-fix/issues/1247#issue-2775748328

        ```
        However, none of the scrolling configuration works.
        I tried to restart the computer, the app, nada.
        <...>
        I will add that it worked in the past, just a few days ago.
        <...>
        For 2 - I tried to disable and enable the tool several times, but saw no difference
        ```

        (Oops I asked a question he already answered, this is hard man)

    https://github.com/noah-nuebling/mac-mouse-fix/issues/1255#issuecomment-2666781738

        ```
        After resume from standby, mouse wheel doesn't work anymore.
        <...>
        no idea when to make the mini sleep but I hit this after not using the computer for a day or two.
        <...>
        Thank you. i haven't observed this happen a second time, so, sorry i cannot provide more input on this issue.
        ```


    https://github.com/noah-nuebling/mac-mouse-fix/issues/1279

        ```
        This happened right after 15.3 upgrade.
        <...>
        After trying couple more apps and rebooting the machine a couple of times, trying Mac Mouse Fix again - it seems to be working again. No idea what the issue was.
        <...>
        I'm able to reproduce this as well after a fresh update and restart.
        <...>
        Update: Just restarting Mac Mouse Fix seems to have worked.
        <...>
        Wish I could reproduce this. This only happened right after MacOS 15.3 upgrade. A couple of reboots later the issue went away.
        <...>
        > You didn't, by any chance, move the app from the Downloads folder to the Applications folder
        Negative, I'm meticulous about keeping apps in Apps folder.
        ```


    https://github.com/noah-nuebling/mac-mouse-fix/issues/1313

        ```
        Since yesterday (previously everything worked fine) smoothness setting causes the scroll to not work at all.
        ```


    https://github.com/noah-nuebling/mac-mouse-fix/issues/1339 (latest issue which we had been discussing)

        ```
        The scrolling functionality of my Logitech M650 mouse sporadically stops working
        <...>
        Restarting the "Mac Mouse Fix" application also resolves the problem, but this is an inconvenient temporary fix.
        <...>
        To answer your question, toggling the "Enable Mac Mouse Fix" switch off and
        on does not resolve the issue. Only quitting and re-launching the app seems
        to restore the scrolling functionality when it's lost.
        ```

### Theories

    Okkkk so based on all this, as far as I can see, users reported 4 fixes:

    * Moving the app from the Downloads to the Applications folder (permanent fix for one user but unrelated for another user – I assume this was just coincidence for that one user)
    * Rebooting the computer
    * Disabling and re-enabling Mac Mouse Fix
    * Quitting and re-opening Mac Mouse Fix
    * Killing Mac Mouse Fix from Activity Monitor (that's not included here but I'm pretty sure I read that somewhere)
    * Forget and reconnect Bluetooth mouse
    * Switching a mouse from Bluetooth to USB connection and back (IIRC there was a report mentioning this over email, but I might be wrong – might have been M Dino, which was a different bug.)

    All of these fixes don't seem to *reliably* fix the issue and often need to be repeated several times to bring about the fix (I think ?)

    ... I'm not sure about this. Only the latest report mentions restarting the "Mac Mouse Fix" app as solution. But there's a possibility, that this was also the solution for the other users, and they just didn't notice it? E.g. they repeated an action like disabling and re-enabling Mac Mouse Fix, and after a few tries they also happened to launch the Mac Mouse Fix app again and that fixed it they just didn't consciously register it? It seems unlikely though. Especially since another person reported, that a 'mouse fix quit & start' didn't 'do the trick' for them - so they were paying attention.

    ---

    This makes me think it's a macOS issue.

    Because, while the fixes are probabilistic, they are (at least relatively) permanent. Most users report something like:

    Update -> broken scrolling -> a few reboots, restarts of MMF, etc -> works again and stays working for a while.
    There was that one guy who reported that it happens to him 7-8/10 times after waking the computer, but several others report that it only happened after an OS update and then permanently went away.

## Investigation & Theories - Restarting main app

It's very weird that that restarting the main 'Mac Mouse Fix' app fixes the issue for some people (Has been explicitly confirmed by egubaidullin: https://github.com/noah-nuebling/mac-mouse-fix/issues/1339#issuecomment-2783030821)

If this is a macOS bug, my only theory is that:
    - since launchd understands the helper as sort of a subthing of the mainApp – it's resetting some state for the helper after the mainApp restarts.

If this is a MMF bug, I have these theories:
    - config.plist gets corrupted
        - Pro: We got report that restarting Helper doesn't reliably fix the issue (From egubaidullin, maybe others?). But the only state that persist beyond restarts of the Helper (I believe) is the config.plist.
        - Contra: But I'm not sure it can be corrupted in a way where smooth scrolling just does *nothing* while non-smooth scrolling still works. (not sure though.)
    - There's a race condition in MMF Helper initialization
        ... and so restarting helper has a chance, but no guarantee, of fixing the issue.
        - Contra: from what I heard, when the issue is fixed, it stays fixed pretty permanently. 
            - Contra Contra: Maybe that's because ppl seldomly restart the helper though? 
            - Contra Contra: Or maybe I'm mixing up different underlying issues, and the "Scroll Stops Working Intermittently" people don't experience a 'permanent fix' like this?
    - Subtheories (about why restarting fixes it):
        - Restarting mainApp might repair config.plist, and then prompt helper to reload it.
        - There's some other XPC happening between mainApp and helper when the mainApp restarts
            Brainstorm:
            - There used to be FSEventStream observation of the config.plist file, but IIRC we turned that off.
            - We use `macmousefix:` URLs for XPC in some cases, but IIRC only the mainApp receives them.
    Weird theory: egubaidullin confirmed that he is always running Mac Mouse Fix in the background. Perhaps mainApp is what *corrupts* the config.plist 
        (Would be sorta plausble since it's much more likely to write to config.plist than Helper app, and also there might be race-conditions if both Helper and mainApp try to write to config.plist ––– I did investigate codebase a little bit and it it looks like writing to config.plist is atomic, and Helper only writes to it when toggling the menubar item. It feels unlikely that it's a racecondition on config.plist, but not sure.)
        We don't know if other affected users also run mainApp all the time -> Should perhaps ask them.
    

### Subtheory – messagePorts

Restarting mainApp sends messages to helper's messagePort that cause bug to be resolved.

Investigation: [Apr 2025] What messages does the helper receive when the mainApp launches/quits:

    Here are the logs that the helper produces when the mainApp quits:


        ```
        Received Message: updateActiveDeviceWithEventSenderID with payload: 4295170361
        Received Message: configFileChanged with payload: (null)
        Loaded config from file: { <contents of config.plist }
        TRM set remaps to config
        Remaps were set to the same value
        ```

    And here are the logs for when the mainApp starts:

        ```
        Received Message: getBundleVersion with payload: (null)
        Received Message: checkAccessibility with payload: (null)
        Received Message: getBundleVersion with payload: (null)
        Received Message: configFileChanged with payload: (null)
        Loaded config from file: { <contents of config.plist> }
        TRM set remaps to config
        Remaps were set to the same value
        ```


## Investigation & Theories - MOS has the same issue

I discovered that Caldis MOS had same issues: 
See this comment: https://github.com/Caldis/Mos/issues/697#issuecomment-2784031685
    Sidenote: Section from MOS Caldis comment I removed:

        Speculation about cause of bug

        I suspected the CVDisplayLink API is involved, since MMF 2, MMF 3 and MOS all use that, but only when smooth scrolling is enabled. However there are some reasons that speak against this:
        - CVDisplayLink is also used by many GUI apps, including Mac Mouse Fix's UI (for animations), and I've never heard of those breaking.
        - Also, @Caldis' fix of toggling accessibility and @mikicvi's report that the SmoothScroll app doesn't have the issue, might not fit with CVDisplayLink being the issue. 
            - On the other hand, I've also seen reports of users on Reddit that said Mac Mouse Fix had the issue but MOS didn't for, so perhaps these observations are down to the sporadic and probabilistic nature of the bug.

        Another idea is that there's something specific about the way that MMF and MOS are using the CVDisplayLink API about the way it interacts with other APIs like  CGEventPost() which triggers the bug. I'm not sure. But it definitely looks to me like there's a bug inside of macOS causing this.

### Theories

So we came to the conclusion that there must be a macOS issue, likely related to CVDisplayLink. 
Evidence for this:
    - MMF2, MMF3 and MOS all experience the issue,
    - Usually happens after a macOS update
    - Restarting Mac Mouse Fix Helper doesn't reliably fix it, but after people fix it it usually stays fixed, at least for a while – suggesting that it's related to some permanent state inside the OS that lasts beyond the lifecycle of Mac Mouse Fix app.
    - For MOS, I've seen reports of reinstalling fixing the issue. This sort of suggests macOS issues I think (but not sure)
    - (Sidenote: For MMF I haven't seen reports of reinstalling or toggling Accessibility fixing the issue – but that might be cause people didn't try/report that.)
However there was also some
evidence against this:
    - MOS only started encountering the issue recently, while in MMF it started in 2024 after macOS 14.4, 14.5, and 14.6 updates (See https://github.com/Caldis/Mos/issues/697#issuecomment-2784031685)
    - It seems to be rarer in MOS (based on the number of GitHub Issues that I can spot – but not sure I'm interpreting that right.)
    - The 'sporadically comes back' pattern has not been reported for MOS as far as I can see. Only the 'after update' pattern.
    - The fact that restarting the main 'Mac Mouse Fix' app fixes the issue for some people

Based on this, my best theory is that there are two issues:
1. Some bug in macOS that happens after updates which affects both MOS and Mac Mouse Fix
2. Some bug that occurs intermittently and only affects Mac Mouse Fix. Might stem from MMF or macOS.

UPDATE: [Aug 2025]
    I haven't been actively thinking about this for a while, but a few days ago  this sprang into my mind:
        >> The culprit HAS to be failure of the code that creates new CVDisplayLinks <<
        > Since the non-smooth scrolling still works, it's obviously about the CVDisplayLink. Since the CVDisplayLink is started/stopped on every scroll, it has to be about creation of the CVDisplayLink. The times when people report the issue occuring coincides with when a new CVDisplayLink is created. (I think)
            > So what we could do is put extra validation into the code that starts the displayLink (-[setUpNewDisplayLinkWithActiveDisplays]) and crash the app if it fails. (Event in release builds.) (That should immediately improve user experience, and give us better chance of diagnostics (in form of crash reports.))
                Validation ideas: Validate that we're running on the right thread, validate the return codes, validate the created displayLink. (But keep in mind that over-validation could make things less robust for users.)
        > How did I not think of this earlier??? It seems so obvious now. I'm slightly retarded.
    Update 2: I checked inside MOS, and they also don't have any recovery mechanism in case CVDisplayLinkCreateWithActiveCGDisplays() or CVDisplayLinkSetOutputCallback() fails! That supports our theory.

## Pre-Claude conclusion

Here are some earlier learnings/conclusions I noted down in a daily note:
- Found some potential issues in SwitchMaster and DisplayLink which we could try to fix in next release with Beta phase
    - Made notes in the source code
- Had ideas and stuff about IOThread
    - Made notes in GlobalEventTapThread.m
- Had ideas about improving debugging workflow. 
    - Made notes inside [here](../error-logging-improvement-ideas_oct-2024.md#learnings-from-trying-the-short-term-solution-apr-8-2025)

## Post-Claude conclusion

-> The theory with the two underlying issues is also how we categorized the reports on GitHub when they first started occuring ca. 1 year ago -> We didn't really get smarter -> This was probably a waste of time -> We should just focus on getting friggin logs, so we're not speculating into the void and wasting time.
-> LEARN FROM THIS: The chance is very slim to actually solving the issue like this – just theorizing about lots of eyewitness reports of (potentially different underlying) issues.
    You just need logs or reproduction steps to have any real chance of making progress. Anything that doesn't get you closer to that is pretty much a waste of time.
    Meta: 
        We sorta set our minds to "I'll solve this now!" but that was almost a month ago, and I haven't received any logs so far (except kindly from M Dino, but that was a different issue). But since we were 'focusing on the issue' we just spent a lot of time speculating and theorizing, cause we didn't have any hard data to go off of. This is a difficult situation with my psychology, cause I usually like to 'tunnel-vision' or 'hyperfocus' on specfic topics. Not sure how to deal with that. Maybe best thing is to create 'passive' ways for users to provide logs where I don't have to interact with them in real-time, and then I can look at the logs later, when I stop being hyperfocused on something else.
        On the other hand, before we did self reflection, we were quite confused. We were investigating M Dino's issue, IIRC not being aware that it's a totally different issue (Maybe cause they were the only person who sent us logs, I guess it was good to learn more about the log investigation process in general, since it was the first batch of sysdiagnose logs we received ever IIRC.). I also totally forgot about the "Scroll Stops Working After macOS Update" issue category. So I guess it makes sense to reflect to the point where you understand the framework of what's going on and which reports are at least plausibly the same issue, and what to focus on. But in this case, to find that out, we would've just had to look at the GitHub issue categories that we made last year: "Scroll Stops Working After macOS Update", and "Scroll Stops Working After macOS Update" - That already encodes all the actually valuable info we ended up extracting from pattern-analyzing the reports now.