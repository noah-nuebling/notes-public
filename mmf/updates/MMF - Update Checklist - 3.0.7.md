
Context:
    [Feb 2 2025] 
        Copied this over from Obsidian into mac-mouse-fix repo.
        This is a sloppy personal note I use this whenever I publish an MMF update. 
        This is a backup I guess? Maybe I'll use this instead of Obsidian, but probably not. 
        > **Might go out of date.** 
        Some of the points are outdated, 
            - like the ones talking about a 'prefpane' (Early MMF versions used to be a prefpane.)
            - Or some of the ones talking about revoking signing certificates (I don't think that happens anymore since I'm paying for the Apple Developer Program)
        It also contains [[Obsidian Links]] which won't work here. Maybe I should move the linked notes into the mac-mouse-fix repo, too. 

    [Jun 7 2025] 
        Copied this over from mac-mouse-fix repo into notes-public repo.
            Reasoning: This is more like a personal note about my workflow – doesn't really belong into the mac-mouse-fix project.
            Assurances: I've deleted the Xcode and Obsidian copies of this note, and moved all their contents here to `notes-public` [Jun 7 2025]

---

# MMF - Update Checklist - Template

Pushing an update, Make push ready, publishing, releasing, publishing routine

The template: [[MMF - Update Checklist - Template]]

> [!info]
>  On Feb 17 2025 I copied this note from Obsidian into the mac-mouse-fix GitHub repo. Not sure if I'll keep updating this version or the GitHub one. (Update: See [Jun 7 2025] above.)
>  I also `redacted` any sensitive info before publishing.

> [!info]
> When moving to Obsidian I couldn't find this note at first. Searched forever. Turns out it's because NotePlan displays notes based on note title, and Obsidian displays them based on filename. Also, NotePlan uses the **initial title** of the note as filename. When you update the title of the note in NotePlan, the filename doesn't change - keep this in mind when searching for notes in the future.

**App**

- Config file
	- [x] set the right configVersion
	- [x] make sure default_config is the same as config
	- [x] make sure the updating / replacing of the config file actually works

- Licensing
	- [x] Update fallback_licenseinfo_config.json to mac-mouse-fix-website (https://macmousefix.com/licenseinfo/config.json)

- Build Settings
	- Adjust compiler flags 
		- Tips:
			- For `C`, modify Xcode build setting: `Preprocessor Macros`
				- Example: `NDEBUG=1`    (Don't forget "= 1")
			- For `Swift`, modify Xcode build setting: `Active Compilation Conditions`
				- Example: `NDEBUG`        (No need for "=1" like with C)
			- (All this stuff only applies to MMF 3. MMF 2 only has the DEBUG flag and nothing else as of Sep 2024.)
		- [x] Remove development flags such as `FORCE_EXPIRED` 
    		- (We're leaving `NO_FILTER` always-on as of [Jul 2025])
		- [x] Make sure `NDEBUG=1`/`NDEBUG` flag is set on release builds. (That prevents assert() from crashing the app). 
		- [x] Make sure `IS_HELPER` and `IS_MAIN_APP` flags are set correctly.

- Signing
	- [x] Make sure you sign all targets with the 'Noah Nuebling' team, which is associated with the `redacted`.developer@`redacted`.com Apple ID instead of the 'Noah Nbling' team which is associated with my personal-email Apple ID
	- [x] Make sure you're not revoking any old certificates. 
		- See [[MMF - Signing Issues - Jan 2022]]
		- Also see [[MMF - Bug - Mac Mouse Fix will damage your computer]]
		- Hint: Import the code signing identity from Apple Notes into Xcode, it should contain the certificate and prevent creation of new certificates / revoking of old certificate (I hope??)
- Other
	- [x] Set the correct MMF version number and version string in the Xcode project
		- Examples: "3.0.0 Beta 7", 21988
	- [x] Set the correct version string(s) in the prefpane info.plist
	- [x] Make sure Sparkle appcast URLs are correct

- Build & Export
	- [x] **Clean build folder** before final build
		- Note that this will reset the build configuration
		- This is still recommended even when using 'Archive' according to this [SO Post](https://stackoverflow.com/a/19202343/10601702)
	- [x] If not prerelease: Make sure to build the Release configuration
		- So that it's fast, and assert() doesn't crash
	- [x] If prerelease: Make sure to either build Debug configuration, or include 'beta' or 'alpha' (case insensitive) in the short bundle version
		- So that `runningPreRelease()` works right
		- Update: Under MMF 3, using Swift we started using Release configuration because Debug is very very slow.
	- [x] Make sure to build for Apple Silicon / Intel
		- Does that automatically when building for Release. See Xcode > Build Settings > Architectures
		- Doesn't do this automatically when building for Debug (not even when building using the "Archive" option). Choose "Any Mac (Apple Silicon, Intel)" next to the build scheme.
	- [x] Use the "Archive" option to export. (This will still use the build scheme and architecture configured in the Xcode menu bar)
	- [x] Choose 'Direct Distribution' in the Organizer to notarize the app.
	- [x] To get the app bundle after Notarizing, use the 'Export Notarized App' button in the Organizer. 
		- For 3.0.2 I got the app bundle directly from the .xcarchive via Finder, and I think that [broke things](https://github.com/noah-nuebling/mac-mouse-fix/issues/871). 
	- [x] Get dSYMs folder directly from the .xcarchive via Finder.
		- Find the .xcarchive by going to the Xcode Organizer and right-clicking the archive in question.

- Pre-Sparkle (we added sparkle in 2.0.0 iirc)
	- [x] Set the base remote url in the app to [kMFWebsiteAddress]/maindownload/

**Post-archive check**
- [x] Make sure the app launches and works ok.
- [x] Make sure the version numbers shown in the app are correct.

**GitHub**

- [x] Write update notes
  - Writing style:
      - [Jul 2025] Being detailed and honest about documenting exactly what things changed is nice and useful, and interesting to some, but try to put *user impact* first and *technical details* second, so the things people are more likely to care about are more easily accessible / skimmable.
	- Use git log for writing update notes: 
		- You can filter out autogenerated commits like this: 
			- `git log --perl-regexp --author="^(?!github-actions)"`
	- If you want to preserve single linebreaks in update notes, use `\` at the end of the line
		- In GitHub they are automatically preserved 
    		- [x] META TODO → Make it so linebreaks are preserved in the updateNotes without `\`. pandocs `--wrap=preserve` doesn't work for me.
	- Lists with several indentation levels look a little weird with the current css. Better to avoid them. 
		- (Or fix the CSS) Edit: fixed the CSS
	- Links to issues of the form `#94` don't work. `[Normal markdown links](abcd)` do work though.
	- Credit users like this: `@nghlt [on GitHub](https://github.com/nghlt)`
		- Mentions of a `@user` don't work as links in in-app release notes but `[user](link)` won't make them show up as a contributor to the release in GitHub. 
		- TODO: Maybe support @user auto links in in-app release notes.
	- When including images use `<img width="500px" src="<Image URL>">` to set size
		- Setting no width is also okay
		- Setting height explicitly will mess up aspect ratio
	- Make sure to have free line above `- bulleted lists` and `## Headings`
		- Otherwise it won't display properly in the Sparkle Update Window
	- Make sure to include the version string at the top of the content because it looks better in Sparkle. See [2.2.0 release notes](https://github.com/noah-nuebling/mac-mouse-fix/releases/tag/2.2.0)
- [x] Zip the .app before uploading. Name it 'MacMouseFixApp.zip'
- [x] Also upload dSYMs.zip so you can symbolicate crash reports
	- dSYMs folder is inside .xcarchive for the build which you can find from the Xcode Organizer.
- [x] Push local changes after the final build - and before publishing the GH release!
	- So that the GH release links to the correct source code commit with the right build number.
- [x] Update appcasts:
	- Switch to mac-mouse-fix-update-feed folder (Which should have update-feed branch of mac-mouse-fix repo checked out)
	- ((Pull new release tags)) Edit: ./update does that automatically now
	- Run ./update

**Update stuff**
- [x] Update [redirection-service](https://github.com/noah-nuebling/redirection-service/blob/main/index.html) if necessary
	- The redirection-service has an mmf2-latest link which needs to be updated, when we publish a new mmf2 version.

**Other Places** (We don't reallyyy care about these sites, and other ppl update them for us.)
- [x] x Update Mac Update Listing
- [x] x Update Cnet Listing
- [x] x Update alternativeto listing

**Website** (Only relevant pre Sparkle - with Sparkle we don't need to update the Website at all)
/maindownload-app/:
* [x] x Update 'updatenotes-app.zip'
	- Update 'updatenotes-source/updatenotes-app/index.html'
	- Run the 'updatenotes-source/install' script to zip stuff up and put in the right place
- [x] x Update 'maindownload-app/bundleversion-app'
- [x] x Update 'maindownload-app/MacMouseFixApp.zip'

**Testing**

- [x] Test if version downloaded from GitHub download works properly
- [x] Test on older macOS
- [x] Test if updating from the previous version works properly
	- Make sure the previous version has accessibility enabled and works properly before updating
	- Make sure in-app update notes look correct
  - Maybe also check if _German_ in-app update notes look correct. (Our AI update-note-translation system.)
	- Make sure the config is retained after update.
	- Make sure the version numbers showed in the app are correct.
  


  NOTES:
    - Built with Xcode 26 Beta 5 (Beta 6 is latest) – Hope that doesn't have negative consequences!
    - I plan to finally remove the 'ℹ️ Note to Mac Mouse Fix 2 Users' and 'ℹ️ Note to Mac Mouse Fix 3 Buyers' notes from the latest release with this.
        - Reason: The MMF 2 version that introduced mechanism where everyone will see 3.0.0 update before later MMF 3 versions was 2.2.5 - released almost a year ago on [Sep 18 2024]