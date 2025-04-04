# Scrolling Stops Intermittently
[Apr 2025]

See this GitHub Issue Category:
  https://github.com/noah-nuebling/mac-mouse-fix/issues?q=state%3Aopen%20label%3A%22Scroll%20Stops%20Working%20Intermittently%22

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
