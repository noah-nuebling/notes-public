MMF Refactor - 'No more dispatch queues' [Sep 2026]

# 1

```
claude --resume 8301be61-72af-4708-b613-221ca4657f2c
```

Commit before the refactor: 
    bf4b108d4dcc2bfaa3b89cd8800d37dfc72e383d

# 2

Remove (almost) all GCD stuff systematically

Find GCD stuff to remove using:

```
(?<!_MFNSBox|No more )dispatch(?! |_once|_compiler_barrier|Semaphore)|\.sync|\.async
```
(Use 'No External/Vendored' filter in Xcode)

-> Replace with GlobalEventTapThread / mainThread / MFCFRunLoopPerform
-> Maybe add thread asserts (assertIOThread()) where appropriate (Everywhere?)
-> Remove all the `_Unsafe` variants and other stuff that's no longer necessary
    - _Unsafe variant was often the direct call and the public one was the deferred call, so callsites can't all be unified
-> Remove the `start(params:` stuff
    - Exists to avoid races by injecting caller code onto the Animator's queue

Anticipated to be complicated: 
    - Anything that does blocking wait (now affects everything instead of just one queue?)
    - ModifiedDragOutputTwoFingerSwipe.m dispatch_group_leave stuff
    - PointerFreeze timing stuff

Maybe also replace unrelated uses of 'dispatch'. Ideas:
    - hand off, offload, 
    - route, handle, select

# 3

- Move event handling stuff off of mainThread to GlobalEventTapThread.
    - (CFRunLoopGetCurrent(), CFRunLoopGetMain()) (No occurrences of NSRunLoop, it seems)
    - doOnMain

Question: What things should stay on main? (non event-processing stuff)
    Config.m, DeviceManager.m
    -> Probably just move them to GlobalEventTapThread to avoid synchronization? 
        (But stuff has to be drawn on main and at least needs to access Config.m, so there'd have to be some synchronization?)



# 3.5

Other stuff that's sneakily on other threads

Old: ('sneakily on main')
    - NSWorkspace.sessionDidBecomeActiveNotification and NSWorkspace.sessionDidResignActiveNotification (due to `queue: nil`)
    - displayReconfigurationCallback is posted on main by CVDisplayLink API (says Claude)
    - Licensing's lockDown() runs from a @MainActor Task.
        - (All the stuff in licensing module needs extra testing since it only runs rarely / won't be caught in normal tests)
    - Config.m asserts main

Updated plan: (These things will still be on other threads after refactor)
    On main:
        - MenuBarItem
        - PointerFreeze and/or ScreenDrawer
        - Licensing
    On other threads/queues:
        - UnixSignals -> on its own dispatch_queue
    Everything else on GlobalEventTapThread

# 3.7

Might need locking (due to access from both IOThread and mainThread)

- Config.m
    - Also note the caches (`+[Config updateDerivedStates]`)
- SwitchMaster.swift (didn't have dispatch_xxx before so won't show up in regex) (Can probably isolate to IOThread and async from main, since main never reads its state)
- Licensing stuff
    - TrialCounter (handleUse() called from IOThread, but main licensing logic running on @MainActor)
- HelperState
    - (Claude says: `activeDevice is written from the input path and falls back to data owned by main` Don't fully understand -> look at this)
- MFMessagePort
- Probably more...


# 4

Cleanup docs and comments talking about GlobalEventTapThread (which we'll implement now)

Names for the unified thread idea in MMF source code that I'm aware of: 
    (unified to: all lowercase, with spaces between all words)
- unified output event thread
- unified input thread
- global event tap thread
- io thread
- event thread
```
unified( |'|-){0,2}output( |'|-){0,2}event( |'|-){0,2}thread|unified( |'|-){0,2}input( |'|-){0,2}thread|global( |'|-){0,2}event( |'|-){0,2}tap( |'|-){0,2}thread|io( |'|-){0,2}thread|event( |'|-){0,2}thread
```

Bonus: 
    - Comments that don't use an identifiable name for GlobalEventTapThread
        - 'like to move all the input handling' comment

# 4.5

Minor cleanup
    - Maybe remove 'atomic' stuff that's no longer needed

# 5

- At end, rename 'GlobalEventTapThread' to IOThread or something

# 6

Do TODOs from GlobalEventTapThread.m. Add autoreleasepool, use thread_policy_set to increase priority.
    (Also do thread_policy_set on the other 2 threads - main and CVDisplayLink, possibly)

# 7 

Post-refactor polish

- drawPuppetCursor: might make IOThread wait for main every frame in a way that's slow
- PointerFreeze might not need sync dispatch at all (can be async API) (currently freezeAtPosition: blocks until it's hidden the pointer / drawn the puppet for the first time)
    - -> If so can live completely on main (if that helps performance) (the usleep can't block main tho, otherwise flicker comes back) (Claude says `The warp should probably stay on the IOThread.` in case main is more busy, which it probably is.)
- There seems to be (unrelated) bug where twoFingerSwipe frozen pointer jumps towards middle of the screen on `becameInUse`

# 8

More detailed implementation plans for tricky parts: 
- twoFingerSwipe > momentumScroll-waiting needs to turn into a continuation to not block IOThread - will cause reentrancy races that we have to deal with at entry points.
- PointerFreeze should probably be owned by IOThread only dispatching to mainThread for ScreenDrawer.
- In DisplayLink, use runLoopSource instead of blocks to dispatch frame-workload to IOThread - that should give natural coalescing like probably CADisplayLink also does it

# 9 

Some more concerns by Claude
    - IOThread would be using some AppKit APIs like NSScreen.mainScreen.
        -> I'm pretty sure that any NSScreen APIs that are actually unsafe to call off main crashes at runtime, and that these are safe, but not 100%
    - (HelperUtility appUnderMousePointerWithEvent:) can 'block for seconds if the app is hung', fixed by `AXUIElementSetMessagingTimeout`
        - (Why have I never experienced any issues due to this, ever?)

# 10 

Concerns coming up during refactor

- MFCFRunLoopPerform_sync could cause deadlocks.


