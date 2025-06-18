# App Idea - Rosetta 32
[Jun 3 2025] Like 32Lives but for all apps, like Rosetta2 but for 32 bit apps.

To other people reading this:
    Feel free to steal this idea! That's why I made this public. I mostly just want to play Left 4 Dead 2.

Origin: 
    I wanted to play Left 4 Dead 2 but it's 32 bit only :\, so I talked to Claude and we came up with the idea and plans for a "Rosetta 32" or "32 Bit Revival" app.
    See this Claude conversation: https://claude.ai/share/b077579d-29ba-44e3-944a-4a5feefeb20c (This is src [1])

Development plan: (More details and explanation why this makes sense under "I thought some more about where I'd start with development." in the Claude conversation. [1])
    1. Extract Framework binaries from macOS Mojave and test if they still work on modern macOS – If that doesn't work this whole project is probably too hard.
    2. Do incrementally more sophisticated translation
        1. Get intel Mac Mini, install Mojave, build x86_32 C program with no library dependencies, programmatically translate it to x86_64. Then translate x86_64 to arm64 using Rosetta2 on M1.
        2. Build x86_32 "hello world" C program with depency on libc, programmatically translate both libc and the executable to x86_64 and link them together. Then translate x86_64 to arm64 using Rosetta2. 
           - At this point we might be able to open source this and get people to be excited and maybe even contribute!
        3. Make our x86_32 to x86_64 translation sophisticated enough that it can run Left 4 Dead 2 or some other cool apps.
    3. Build a nice, transparent, easy-to-use macOS app – it would translate 32 bit apps/executables to arm64 (Universal Binary?) and link them against translated 32 bit Mojave framework suite which it would ship. – Then sell for $1.99 on Stripe and make cool website.
    4. Incrementally improve the core x86_32 to x86_64 translator if users report that it doesn't work for one of their apps.

Detailed ideas about all the *auxiliary stuff* – user-facing app, design, website, marketing: (More in the Claude conversation [1] under "I just thought about the details of how to design, sell and market a")
- App: 
    - Overview: The app would do 2 things – 1. ship the translated 32 bit system libraries from Mojave and 2. translate 32 bit apps. 
    - Interface: The interface could probably be very simple and just have a single view. Maybe take inspiration from other simple apps like Gifski. 
    - Libraries UI: The Mojave libs could either be present inside the app bundle or installed into the library. Installing into the library might prevent translated apps from breaking when removing or moving 32BitRevival.app (Not sure you can link to a Framework at a wildcard path?), but would require extra installation / cleanup step for user. On the other hand we might make it transparent/explained to the user that we're shipping 32 Bit Frameworks from Mojave since user's might wonder why the app bundle is so big and why their apps only work as long as 32BitRevival is installed. Explicitly installing the library might make this more transparent / 'tactile' to users. Installing into the library would allow users to uninstall 32BitRevival while still having their apps working (Not sure that has any benefits.) When users try to launch a translated app with no 32 bit frameworks present, it would be ideal if the app could show a dialog about how to install the frameworks using 32BitRevival.app – though this might be very difficult to do technically. Update: Idea: We could also copy the libraries in the App bundles, which would make them independent but also larger in size.
    - Translation UI: 32BitRevival.app could either create a copy of the translated app or modify the input file to be a 'universal binary'. The app could probably somehow mimic Rosetta2's behavior and automatically translate 32 bit when the user tries to launch them for the first time – though the lacking 'transparency' in this approach and having to constantly run a background process (probably) makes me a little uncomfortable. The main GUI would just be a drag and drop target where you can drag an app, and then a 'Revive This App!' button. Raw executables could be handled the same way. Do we need special handling for apps containing multiple executables or folders containing multiple executables? (That seems niche.)
- Command-line-tool/automation: Is there any use in providing a command-line-tool or something else that's programmatically automatable? – I don't really think so. 
- Sales: Sell for $1.99 on Stripe. Make it super cheap and easy to buy.
- Website: Make beautiful website. It can be super short since the pitch is super clear, screenshot of the UI is probably self-explanatory. I'm thinking dark background with rainbow gradient text (seen those a lot lately but I still think they're cool). Maybe put gradient as accent on the word 'Revival' or 'lives' or something. Maybe make gradient shimmer / waver slightly like sunlight in the ocean. (Probably don't have artistic talent to do that). Maybe have cool zoom animation and magazine-style design (?) like GTA 6 website. Maybe mention specific software you can now run again (lots of amazing classic games, MW2, Left 4 Dead 2, probably Audio Plugins, tons more).

Example code: 
- I think my approach ideas are solid but it might be worth researching other similar projects in-depth. Claude mentioned many other projects in [1] E.g. Box86, FEX-Emu, and Wine. Claude also said that Wine already solve the x86_32 -> x86_64 translation (although it claimed a lot of false things.)

Interesting command-line-tools
- lipo                  -> Create universal binary
- install_name_tool     -> Swaps out framework-paths in a mach-o
- otool, objdump, nm    -> Inspect mach-o

Intel x86_64 Instruction Reference:
    - Reference manual: https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
        -> Looks like there are on the order of 1000 instructions [Jun 3 2025] (Based on: I checked the A-L section and it had 240 instructions and there were 3 more sections)
        -> But also looks like there is major overlap between x86_32 and x86_64, which should make translation much easier.

Other interesting links:
    - Apple's macOS 64-bit Transition Guide: 
        - https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/64bitPorting/transition/transition.html
        - [ ] Read


--

Dump of libraries used by COD: Modern Warfare 2 [Jun 4 2025]

    ```
    /S/V/P/C/O/S/L/dyld  otool -L /Users/Noah/Library/Application\ Support/Steam/steamapps/common/Call\ of\ Duty\ Modern\ Warfare\ 2/COD_MW2_SP.app/Contents/MacOS/COD_MW2_SPsub
        /Users/Noah/Library/Application Support/Steam/steamapps/common/Call of Duty Modern Warfare 2/COD_MW2_SP.app/Contents/MacOS/COD_MW2_SPsub:
        /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit (compatibility version 45.0.0, current version 1265.0.0)
        /System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices (compatibility version 1.0.0, current version 48.0.0)
        /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 157.0.0)
        /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa (compatibility version 1.0.0, current version 20.0.0)
        /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices (compatibility version 1.0.0, current version 59.0.0)
        /System/Library/Frameworks/CoreVideo.framework/Versions/A/CoreVideo (compatibility version 1.2.0, current version 1.8.0)
        /System/Library/Frameworks/ForceFeedback.framework/Versions/A/ForceFeedback (compatibility version 1.0.0, current version 1.0.2)
        /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation (compatibility version 300.0.0, current version 1056.0.0)
        /System/Library/Frameworks/GameKit.framework/Versions/A/GameKit (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/Security.framework/Versions/A/Security (compatibility version 1.0.0, current version 55471.0.0)
        /System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration (compatibility version 1.0.0, current version 596.12.0)
        /usr/lib/libcrypto.0.9.8.dylib (compatibility version 0.9.8, current version 50.0.0)
        /usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.5)
        /usr/lib/libcurl.4.dylib (compatibility version 7.0.0, current version 8.0.0)
        /usr/lib/libexpat.1.dylib (compatibility version 7.0.0, current version 7.2.0)
        /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
        @loader_path/libsteam_api.dylib (compatibility version 1.0.0, current version 1.0.0)
        @executable_path/libMilesX86.dylib (compatibility version 0.0.0, current version 0.0.0)
        @executable_path/libBinkMacx86.dylib (compatibility version 0.0.0, current version 0.0.0)
        /usr/lib/libobjc.A.dylib (compatibility version 1.0.0, current version 228.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 120.0.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1197.1.1)
        /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 855.11.0)
        /System/Library/Frameworks/ImageIO.framework/Versions/A/ImageIO (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/CoreGraphics.framework/Versions/A/CoreGraphics (compatibility version 64.0.0, current version 600.0.0)
        /System/Library/Frameworks/CFNetwork.framework/Versions/A/CFNetwork (compatibility version 1.0.0, current version 673.0.3)
    
    /S/V/P/C/O/S/L/dyld  otool -L /Users/Noah/Library/Application\ Support/Steam/steamapps/common/Call\ of\ Duty\ Modern\ Warfare\ 2/COD_MW2_SP.app/Contents/MacOS/COD_MW2_SP
        /Users/Noah/Library/Application Support/Steam/steamapps/common/Call of Duty Modern Warfare 2/COD_MW2_SP.app/Contents/MacOS/COD_MW2_SP:
        /System/Library/Frameworks/GameKit.framework/Versions/A/GameKit (compatibility version 1.0.0, current version 1.0.0, weak)
        /System/Library/Frameworks/StoreKit.framework/Versions/A/StoreKit (compatibility version 1.0.0, current version 232.11.0)
        /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 157.0.0)
        /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit (compatibility version 45.0.0, current version 1265.21.0)
        /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa (compatibility version 1.0.0, current version 20.0.0)
        /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
        /System/Library/Frameworks/Security.framework/Versions/A/Security (compatibility version 1.0.0, current version 55471.14.18)
        /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation (compatibility version 300.0.0, current version 1056.16.0)
        /System/Library/Frameworks/WebKit.framework/Versions/A/WebKit (compatibility version 1.0.0, current version 537.78.2)
        /usr/lib/libcrypto.0.9.8.dylib (compatibility version 0.9.8, current version 0.9.8)
        /System/Library/Frameworks/ForceFeedback.framework/Versions/A/ForceFeedback (compatibility version 1.0.0, current version 1.0.2)
        @loader_path/libsteam_api.dylib (compatibility version 1.0.0, current version 1.0.0, weak)
        /usr/lib/libobjc.A.dylib (compatibility version 1.0.0, current version 228.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 120.0.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1197.1.1)
        /System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices (compatibility version 1.0.0, current version 48.0.0)
        /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 855.17.0)
        /System/Library/Frameworks/CoreGraphics.framework/Versions/A/CoreGraphics (compatibility version 64.0.0, current version 600.0.0)
        /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices (compatibility version 1.0.0, current version 59.0.0)
    
    /S/V/P/C/O/S/L/dyld  otool -L /Users/Noah/Library/Application\ Support/Steam/steamapps/common/Call\ of\ Duty\ Modern\ Warfare\ 2/COD_MW2_SP.app/Contents/MacOS/libMilesX86.dylib
        /Users/Noah/Library/Application Support/Steam/steamapps/common/Call of Duty Modern Warfare 2/COD_MW2_SP.app/Contents/MacOS/libMilesX86.dylib:
        @executable_path/libMilesX86.dylib (compatibility version 0.0.0, current version 0.0.0)
        /System/Library/Frameworks/AudioToolbox.framework/Versions/A/AudioToolbox (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 152.0.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.2.11)
        /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices (compatibility version 1.0.0, current version 44.0.0)
        /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 550.43.0)
        /System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices (compatibility version 1.0.0, current version 38.0.0)
    
    /S/V/P/C/O/S/L/dyld  otool -L /Users/Noah/Library/Application\ Support/Steam/steamapps/common/Call\ of\ Duty\ Modern\ Warfare\ 2/COD_MW2_SP.app/Contents/MacOS/libBinkMacx86.dylib
        /Users/Noah/Library/Application Support/Steam/steamapps/common/Call of Duty Modern Warfare 2/COD_MW2_SP.app/Contents/MacOS/libBinkMacx86.dylib:
        @executable_path/libBinkMacx86.dylib (compatibility version 0.0.0, current version 0.0.0)
        /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/AudioToolbox.framework/Versions/A/AudioToolbox (compatibility version 1.0.0, current version 1.0.0)
        /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon (compatibility version 2.0.0, current version 152.0.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.2.11)
        /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices (compatibility version 1.0.0, current version 44.0.0)
        /System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices (compatibility version 1.0.0, current version 38.0.0)
    
    /S/V/P/C/O/S/L/dyld  otool -L /Users/Noah/Library/Application\ Support/Steam/steamapps/common/Call\ of\ Duty\ Modern\ Warfare\ 2/COD_MW2_SP.app/Contents/MacOS/libsteam_api.dylib
        /Users/Noah/Library/Application Support/Steam/steamapps/common/Call of Duty Modern Warfare 2/COD_MW2_SP.app/Contents/MacOS/libsteam_api.dylib (architecture i386):
        @loader_path/libsteam_api.dylib (compatibility version 1.0.0, current version 1.0.0)
        /usr/lib/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.9.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.2.11)
        /usr/lib/libgcc_s.1.dylib (compatibility version 1.0.0, current version 697.0.0)
        /Users/Noah/Library/Application Support/Steam/steamapps/common/Call of Duty Modern Warfare 2/COD_MW2_SP.app/Contents/MacOS/libsteam_api.dylib (architecture x86_64):
        @loader_path/libsteam_api.dylib (compatibility version 1.0.0, current version 1.0.0)
        /usr/lib/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.9.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.2.11)
        /usr/lib/libgcc_s.1.dylib (compatibility version 1.0.0, current version 697.0.0)
    ```