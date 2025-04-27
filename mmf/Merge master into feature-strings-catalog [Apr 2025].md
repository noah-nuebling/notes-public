# Merging master into feature-strings-catalog branch [Apr 2025]

Post-merge-todos: 
        (Copied (and then extended) from commit message 0a3d69731535082522ac69732edaa80ba65ffada)
    - [x] Looks like there's still some stuff in the project.pbxproj that has 10.14.4 as deployment target.
        -> Check and probably update to 10.15.0
    - [x] Uncomment .h imports until it compiles (we commented some out since we weren't sure they were needed.)
    - [x] Looks like **setupBasicCocoaLumberjackLogging** is not called anywhere after merge?
        -> Investigate
            Result: We replaced it with +setUpDDLog 
                - [x] Merge changes into setUpDDLog and delete setupBasicCocoaLumberjackLogging
                - [x] Delete occurences of `import CocoaLumberjackSwift`. The import is done by Logging.swift now.
    - [x] Address all "MERGE TODO:" comments in the source code.
    - [x] Double-check if any UI strings changed in master since master and feature-strings-catalog diverged
        -> Cause I think we just deleted all the UIStrings from master during the merge
    - [x] Search for comments mentioning feature-strings-catalog,
        -> Reasoning: to catch cases where we 'backported' stuff from feature-strings-catalog to master
        I saw one such cases where git just duplicated the backported code – maybe there are other such cases
    - [x] Looks like getMFRedirectionServiceLink() is not called anywhere after merge
        -> Investigate
        -> Result: Functionality was moved into Links.m
    - [x] Replace custom local bcase() macros we wrote in last commit with the proper ones defined in SharedUtility.h
    - [x] Delete/clean up MFDataClassImpls and MFDataClassImplementations
        - Those files are empty and I think they're duplications of each other.
    - [x] Make any other changes to get the program to compile and run bug-free
        - Maybe we should make a list with the functionalities where the merge was the most complicated, and we could test if we introduced any bugs there?
            - Complicated merge: Licensing system
            - Complicated merge: ... (I forgot, there were more)
            - -> Update: Too lazy to do this. I think wel'll find any bugs naturally during further development.
    - [ ] Merge EventLoggerForBrad side project
        - IIRC we postponed merging this into MMF just because that required us to change some code that feature-strings-catalog also changed – so we wanted to wait until master and feature-strings-catalog were merged. 
    - /Move over/cleanup/get overview of/ utilities from recent 'side projects' (Before we forget about them)
        Overview – merging of recent side projects:
            - [ ] objc-playground-2024
                - Contains block-based KVO wrapper
            - [x] xcode-localization-screenshot-fix
                - DONE: Nothing to merge but some interesting stuff left in that repo. Made note about that inside mac-mouse-fix > `Automatic Localization Screenshots.md`
            - EventLoggerForBrad
                - We already moved over some stuff and it's split between SharedUtility.h and EventLoggerForBradMacros.h – maybe other files?
        -> I think it would be nice to merge everything useful into MMF now, and then we can forget about those other repos

## Commits 

    (Trying to see if any UI strings changed in master since master and feature-strings-catalog diverged)

First commit that only feature-strings-catalog has (not master)
    77958a595 
        Date: [Jun 24 2024]
        (Found with `git log master..feature-strings-catalog --oneline`)


oldest common commit between features-strings-catalog and master
    5b85b74f23983c1b2b662a3571c869310e71bdbc 
        Date: [Jun 25 2024]
            (This date doesn't make sense with 77958a595 being [Jun 24 2024], I think? We had a bunch of different branches for localization stuff so maybe we merged them in a weird way.?)
        Found with:
            `git log --perl-regexp --author="^(?!github-actions)" --graph <branchname>`                             (to find commits from each branch from before the merge)
            `git merge-base 76d2204bf38202f44daa262a9d53346a5a1fab1e 0238020f56ddc0778605de23341876b631abebd8`      (To find oldest common ancestor)

strings files that have changed on master since it diverged from features-strings-catalog

    M       Localization/de.lproj/Localizable.strings
    M       Localization/en.lproj/Localizable.strings
    M       Localization/ko.lproj/Localizable.strings
    M       Localization/vi.lproj/Localizable.strings
    M       Localization/zh-HK.lproj/Localizable.strings
    M       Localization/zh-Hans.lproj/Localizable.strings
    M       Localization/zh-Hant.lproj/Localizable.strings

        -> Found with
            `git diff --name-status 5b85b74f23983c1b2b662a3571c869310e71bdbc..master`

    Changes to de
        +/* First draft: **There was an issue with the licensing server**\n\nPlease try again later.\n\nIf the issue persists, please reach out to me [here](mailto:noah.n.public@gmail.com). */
        +"license-toast.server-response-invalid" = "**Es gab ein Problem beim Lizenzserver**\n\nBitte versuche es später noch einmal.\n\nWenn das Problem weiterhin besteht, kontaktiere mich bitte [hier](mailto:noah.n.public@gmail.com).";
    Changes to other languages:
        "license-toast.server-response-invalid" was added but not translated.

## LicenseSheetController.swift merge conflic resolution

    What happened on **master** branch?

        - [Feb 1 2025] Improvements to the licensing code
            - Task.detached now has @MainActor annotation
            - Comment added above Task.detached dispatch
            - Comment added next to `guard let tabViewController = MainAppState.shared` about observed crash

        - [Oct 6 2024] - [Nov 5 2024] May commits
            - Made isProcessing @Atomic
            - Under 'server validation', we cleaned up/improved the whole logic and now use the new rewritten Licensing module with async/await and stuff
                - Here's what the code changed to: <see below>
            - displayUserFeedback was updated a lot, what I can see
                - Small comments added & Swift force-unwrapping removed
                - args changed: 
                    - Removed: LicenseREason,
                    - Added: licenseTypeInfo, licenseTypeInfoOverride,
                    - Renamed: success -> isValidLicense, userChangedKey->isActivation
                - The following sections have changed a lot:
                    - Everythin above /// Show server error  (formerly /// Show message)
                        - Most significant restructuring I can see is that license-toast.free-country code is in the isValidLicense==false branch now, controlled by licenseTypeInfoOverride instead of licenseReason
                        - Also MFLicenseTypeRequiresValidLicenseKey() validation
                        - Added `assert(licenseTypeInfo != nil)` validation
                    - Added `case kMFLicenseErrorCodeServerResponseInvalid:` 
              
        - [Feb 28 2024] Setup toast notifications if MMF takes too long
            - (Last common commit with feature-strings-catalog)


    What happened on **feature-strings-catalog** branch?

        - [Aug 29 2029] Removed 'First draft:'s from localizer hints
            - What commit msg says

        - [Aug 11 2024] Rewrote attributeStringByTrimmingWhitespace:
            - x Changed stringByTrimmingWhiteSpace() to stringByRemovingAllWhiteSpace() 

        - [Jul 30 2024] Refactor & cleanup of toast notification code
            - MOved stuff into LicenseToasts instead of using local displayUserFeedback() helper and ToastNotificationController. 

        - [Feb 28 2024] Setup toast notifications if MMF takes too long
            - Changed toast duration automatic <-> -1 (which is the same thing)
            - (Last common commit)


# Src code

What displayUserFeedback() code changed to after [Nov 5 2024] commit:
```
    fileprivate func displayUserFeedback(isValidLicense: Bool, licenseTypeInfo: MFLicenseTypeInfo?, licenseTypeInfoOverride: MFLicenseTypeInfo?, error: NSError?, key: String, isActivation: Bool) {
        
        /// Validate
        if (isValidLicense) {
            assert(licenseTypeInfo != nil)
        }
        
        if isValidLicense /** server says the license is valid */ {
            
            /// Dismiss
            LicenseSheetController.remove()
            
            /// Validate:
            ///     license is one of the licenseTypes that requires entering a valid license key.
            if !MFLicenseTypeRequiresValidLicenseKey(licenseTypeInfo) {
                DDLogError("Error: Will display default 'license has been activated' message but license has type that doesn't require valid license key (how can you 'activate' a license without a license key?) Type of the license: \(type(of: licenseTypeInfo))")
                assert(false)
            }
            
            let message: String
            if isActivation {
                message = NSLocalizedString("license-toast.activate", comment: "First draft: Your license has been **activated**! 🎉")
            } else {
                message = NSLocalizedString("license-toast.already-active", comment: "First draft: This license is **already activated**!")
            }

            ToastNotificationController.attachNotification(withMessage: NSAttributedString(coolMarkdown: message)!,
                                                           to: MainAppState.shared.window!, /// Is it safe to force-unwrap this?
                                                           forDuration: kMFToastDurationAutomatic)
            
        } else /** server failed to validate license */ {
            
            /// Show message
            var message: String = ""
            
            if let override = licenseTypeInfoOverride {
                
                switch override {
                case is MFLicenseTypeInfoFreeCountry:
                    message = NSLocalizedString("license-toast.free-country", comment: "First draft: This license __could not be activated__ but Mac Mouse Fix is currently __free in your country__!")
                case is MFLicenseTypeInfoForce:
                    message = "FORCE_LICENSED flag is active"
                default: /// Default case: I think this can only happen if we forget to update this switch-statement after adding a new override.
                    assert(false)
                    DDLogError("Mac Mouse Fix appears to be licensed due to an override, but the specific override is not known:\n\(override)")
                    message = "This license could not be activated but Mac Mouse Fix appears to be licensed due to some special condition that I forgot to write a message for. (Please [report this](https://noah-nuebling.github.io/mac-mouse-fix-feedback-assistant/?type=bug-report) as a bug. Thank you!)"
                }
                
            } else {
            
            /// Show server error
        
            if let error = error {
                
                if error.domain == NSURLErrorDomain {
                    message = NSLocalizedString("license-toast.no-internet", comment: "First draft: **There is no connection to the internet**\n\nTry activating your license again when your computer is online.")
                } else if error.domain == MFLicenseErrorDomain {
                    
                    switch error.code as MFLicenseErrorCode {
                        
                    case kMFLicenseErrorCodeInvalidNumberOfActivations:
                        
                        let nOfActivations = (error.userInfo["nOfActivations"] as? Int) ?? -1
                        let maxActivations = (error.userInfo["maxActivations"] as? Int) ?? -1
                        let messageFormat = NSLocalizedString("license-toast.activation-overload", comment: "First draft: This license has been activated **%d** times. The maximum is **%d**.\n\nBecause of this, the license has been invalidated. This is to prevent piracy. If you have other reasons for activating the license this many times, please excuse the inconvenience.\n\nJust [reach out](mailto:noah.n.public@gmail.com) and I will provide you with a new license! Thanks for understanding.")
                        message = String(format: messageFormat, nOfActivations, maxActivations)
                    
                    case kMFLicenseErrorCodeServerResponseInvalid:
                        
                        /// Sidenote:
                        ///     We added this localizedStringKey on the master branch inside .strings files, while we already replaced all the .strings files with .xcstrings files on the feature-strings-catalog branch. -- Don't forget to port this string over, when you merge the master changes into feature-strings-catalog! (Last updated: Oct 2024)
                        let messageFormat = NSLocalizedString("license-toast.server-response-invalid", comment: "First draft: **There was an issue with the licensing server**\n\nPlease try again later.\n\nIf the issue persists, please reach out to me [here](mailto:noah.n.public@gmail.com).")
                        message = String(messageFormat)
                        
                        do {
                            /// Log extended debug info to the console.
                            ///     We're not showing this to the user, since it's verbose and confusing and the error is on Gumroad's end and should be resolved in time.
                            
                            /// Clean up debug info
                            ///     The HTTPHeaders in the urlResponse contain some perhaps-**sensitive information** which we wanna remove, before logging.
                            ///     (Specifically, there seems to be some 'session cookie' field that might be sensitive - although we're not consciously using any session-stuff in the code - we're just making one-off POST requests to the Gumroad API without authentication, so it's weird. But better to be safe about this stuff if I don't understand it I guess.)
                            var debugInfoDict = error.userInfo
                            if let urlResponse = debugInfoDict["urlResponse"] as? HTTPURLResponse {
                                debugInfoDict["urlResponse"] = (["url": (urlResponse.url ?? ""), "status": (urlResponse.statusCode)] as [String: Any])
                            }
                            /// Log debug info
                            var debugInfo: String = ""
                            dump(debugInfoDict, to:&debugInfo)
                            DDLogError("Received invalid Gumroad server response. Debug info:\n\n\(debugInfo)")
                        }
                        
                    case kMFLicenseErrorCodeGumroadServerResponseError:
                        
                        if let gumroadMessage = error.userInfo["message"] as? String {
                            
                            switch gumroadMessage {
                            case "That license does not exist for the provided product.":
                                let messageFormat = NSLocalizedString("license-toast.unknown-key", comment: "First draft: **'%@'** is not a known license key\n\nPlease try a different key")
                                message = String(format: messageFormat, key)
                            default:
                                let messageFormat = NSLocalizedString("license-toast.gumroad-error", comment: "First draft: **An error with the licensing server occured**\n\nIt says:\n\n%@")
                                message = String(format: messageFormat, gumroadMessage)
                            }
                        }
                        
                    default:
                        assert(false)
                        message = "" /// Note: Don't need error handling for this i guess because it will only happen if we forget to implement handling for one of our own MFLicenseError codes.
                    }
                    
                } else {
                    let messageFormat = NSLocalizedString("license-toast.unknown-error", comment: "First draft: **An unknown error occurred:**\n\n%@")
                    message = String(format: messageFormat, error.description) /// Should we use `error.localizedDescription` `.localizedRecoveryOptions` or similar here?
                }
                
            } else {
                message = NSLocalizedString("license-toast.unknown-reason", comment: "First draft: Activating your license failed for **unknown reasons**\n\nPlease write a **Bug Report** [here](https://noah-nuebling.github.io/mac-mouse-fix-feedback-assistant/?type=bug-report)")
            }
            }
            
            assert(message != "")
            
            /// Display Toast
            ///     Notes:
            ///     - Why are we using `self.view.window` here, and `MainAppState.shared.window` in other places? IIRC `MainAppState` is safer and works in more cases whereas self.view.window might be nil in more edge cases IIRC (e.g. when the LicenseSheet is just being loaded or sth? I don't know anymore.)
            ToastNotificationController.attachNotification(withMessage: NSAttributedString(coolMarkdown: message)!,
                                                           to: self.view.window!, /// Note: (Oct 2024) Might not wanna force-unwrap this
                                                           forDuration: kMFToastDurationAutomatic)
            
        }
    }
```

What 'server validation' code changed to after [Nov 5 2024] commit
```
                /// Ask server
    
                Task.detached(priority: .userInitiated, operation: {
                    
                    /// Get licenseConfig
                    /// Notes:
                    /// - Instead of getting the licenseConfig every time, we could also use cached LicenseConfig, if we update it once on app start. The `URLSession` class that `LicenseConfig.get()` uses internally also has built-in caching. Maybe we should use that?
                    ///     Update: (Oct 2024) GetLicenseConfig.get() now internally uses `inMemoryCache`. See implementation for more.
                    let licenseConfig = await GetLicenseConfig.get()
                    
                    /// Determine if this is a licenseKey *activation* or just a *check*
                    ///     We activate if this is a a fresh licenseKey, different from the key that was already activated and stored. Meaning that the user changed the licenseKey in the textbox before they clicked "Activate License"
                    let isActivation = isDifferent
                    
                    /// Ask licenseServer
                    ///     Note: (Nov 2024) If the licenseServer responds with a clear "yes"/"no" to the question "is this licenseValid", then the cache will get overriden with the server's response, which I think is desirable? (So we don't keep using old cached values after activating a new license.)
                    let (state, serverError) = await GetLicenseState.licenseStateFromServer(key: key,
                                                                                            incrementActivationCount: isActivation, /// Increasing the activationCount (aka usageCount) is the main difference between activating and checking a license
                                                                                            licenseConfig: licenseConfig)
                    /// Determine success
                    /// Notes:
                    ///     (The following note is outdated as of Oct 2024 because we're now directly using the lower-level function to talk the licenseServer, instead of using the higher-level function that applies freeCountry overrides and stuff.)
                    ///     - By checking for valueFreshness we filter out the case where there's no internet but the cache still tells us it's licensed
                    ///         The way things are currently set up this leads to weird behaviour when activating a license without internet in freeCountries: If the cache says it's licensed, users will get the no internet error, but if the cache says it's not licensed. Users will get the it's free in your country message. This is because the freeCountry overrides inside activateLicense only take effect if isLicensed is false. This is slightly weird but it's such a small edge case that I don't think it matters. Although it hints that it might be more logical to change the logic for applying the freeCountry overrides.
                    let isValidLicense = state?.isLicensed ?? false
                    
                    /// Store new licenseKey
                    if isActivation && isValidLicense {
                        
                        /// Validate
                        if !MFLicenseTypeRequiresValidLicenseKey(state?.licenseTypeInfo) {
                            DDLogError("Error: Will store licenseKey but license has type that doesn't appear to require valid license key. (Doesn't make sense) License state: \(state ?? "<nil>")")
                            assert(false)
                        }
                        
                        /// Store
                        SecureStorage.set("License.key", value: key)
                    }
                    /// Get licenseState override
                    ///     Explanation: Even if the server says the license is not valid, there might be special conditions that render the app activated regardless - and we wanna tell the user about this.
                    let licenseStateOverride = isValidLicense ? nil : await GetLicenseState.licenseStateFromOverrides()
                
                    /// Validate
                    if let override = licenseStateOverride {
                        assert(override.isLicensed == true)
                    }
                    
                    /// Dispatch to mainThread because UI stuff needs to be controlled by main
                    DispatchQueue.main.async {
                    
                        /// Display user feedback
                        self.displayUserFeedback(isValidLicense: isValidLicense,
                                                licenseTypeInfo: state?.licenseTypeInfo,
                                                licenseTypeInfoOverride: licenseStateOverride?.licenseTypeInfo,
                                                error: serverError,
                                                key: key,
                                                isActivation: isActivation)
                        
                        /// Wrap up
                        onComplete()
                    }
                    
                })
            }
```