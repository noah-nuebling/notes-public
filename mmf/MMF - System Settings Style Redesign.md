

[Aug 2025] I plan to make minimal changes to MMF for macOS Tahoe release, but ca. 1 year later I'd like to **rewrite the UI in System Settings / SwiftUI style** since I think that looks more natural on macOS Tahoe.

Inspiration:
    - Hyperspace app settings - By John Siracusa – looks very competently designed, and has similar elements to what we wanna do
    - Ice Cubes – Pretty new SwiftUI app, with nice design (although feels janky to use due to SwiftUI I think [Aug 2025])
    - System Settings
    - Xcode 26 Settings

Experiments:
    - `swiftui-test-tahoe-beta` project 
        - -> Here we reimplemented scrolling screen in SwiftUI, pure objc+AppKit and interface builder+AppKit
    - `modernize-update-alert` branch on our Sparkle fork 
        - -> Implemented this in pure objc+AppKit and developed a few new techniques. 

Plan so far: [Aug 2025]
    
    Use pure objc+AppKit
        Pros: 
            - It's not really less expressive to write than SwiftUI after you've written a few macros for the repetitive boilerplate
            - Can always very easily drop into lower level AppKit
            - View hierarchy debugger works (SwiftUI doesn't)
            - We've already written all our animations for AppKit (Which is the only part where SwiftUI is meaningfully more expressive)
            - It's much less cumbersome and more flexible than using Interface Builder! (Unexpected) (It's because you can just define a margin once in your macro instead of maintaining 30 autolayout constraints in IB)
        See the `swiftui-test-tahoe-beta` and `modernize-update-alert` experiments, where we brought these things into experience.
    
    Alternative: Pure objc+UIKit+Catalyst
        Pros:
            - May enable an iPad port of MMF down the line (Hinges on them also opening up HIDDriverKit I think.)
            - With iPadOS 26/macOS 26, the Mac and iPad are closer than ever. UIKit on the Mac might deliver an experience just as good as AppKit. I heard AppKit and Catalyst can't be told apart anymore.
        Cons:
            - May be much harder than an AppKit rewrite. I have no clue how Catalyst works or what the challenges are 
                    (Also think of hacky things like the ResizingTabWindow, which probably won't work on iPad, or the reverse engineered animation APIs and so on... Probably not an easy port to UIKit.)
    