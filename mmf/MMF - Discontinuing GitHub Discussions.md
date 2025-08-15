
# Moving Guides from Discussions to .md files (And probably disabling Discussions entirely)

(Formerly _dailynote_2025.07.30.md)
(This is a subtask of `MMF Localization Todo (Fall 2024)`)

Why disable Discussions:
- IIRC, the idea behind Discussions was that the comments help in these ways:
    - Users can help each other and upvote helpful answers
    - Users can easily ask questions or help each other under the Guides I write
- However, this has not come true. There's only 1 discussion opened every ~2 weeks. Most go unanswered. Most could have been issues. On average, they are lower quality than Issues or emails I receive (the other 2 feedback channels). People rarely comment under my Guides. If they do, it's sometimes off topic. It's rare that users help each other IIRC. 
- The few nuggets of useful information (The rare questions answered by me or Guides written by me, or Good feedback, or instances where users posted answers or helpful solutions) could mostly just be moved to Issues, or md documents. I can just use issues for Q&A and making some information available quickly with low friction. If the information is important enough, I should write a localizable .md file instead. I guess there's a little bit of value lost where people help each other, but they could also do that in Issues, and overall I think the value here is so low, that it's ok to shut down, and funnel everyone's energy into the better communication channels.
- Biggest practical issue with Discussions:
    - They can't be localized, and we wanna localize the Guides, which live in Discussions right now. This is the reason why we're thinking about making changes here at all.

TODO: 
    (Update: Started implementing this in commit fda78fcccc106744b95e5b2967713b651f9d80e7 and earlier)
    
- [x] Identify the content from Discussions that we wanna keep (I think only the things we're linking to) and move them into localizable .md files (or into GitHub Issues)
- [x] Perhaps categorize Guides .md files into something like `Current` `Older Mac Mouse Fix versions` and `Older macOS versions` (Or `Mac Mouse Fix 2`, `macOS 14 Sonoma` or something?). Not sure there are Guides that are "completely outdate" for both MMF 2 and MMF 3 users on all macOS versions.
    - The point is that Guides that only apply to Mac Mouse Fix 2 should not be translated, since MMF 2 isn't localizable. And Guides that apply to older macOS versions should also perhaps not be localized (?) or not cluttering up things for users on newer macOS versions (?).
- [x] Write a "Guides Overview" document that links to all the available Guides
- [x] Turn the Guides into localizable templates (Except some, like the MMF 2 ones, or the Localization Guide itself.)
- [x] Update the content of the Guides for the new structure: Add a language picker, maybe add a link to the Guides overview. Update the 'still have questions?' section at the bottom (maybe templatize it so it can be shared between all the Guides. Maybe take inspiration from Apple (https://support.apple.com/en-us/108900) or GitHub (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent))
- [x] Maybe think of a better name than 'Guides'. Maybe 'Support', 'Documentation', 'Docs'. (Those are what GitHub and Apple are using)
- [ ] Write new version of Guides for Mac Mouse Fix 3 (Captured Buttons Guide, perhaps more)
- [ ] Maybe add link between MMF 3 and MMF 2 Guides
- [ ] Translate to German
    - And polish the English text while you're at it.
- [ ] Make sure the new .xcstrings files are all exported in our .xcloc bundles

- [ ] Maybe write (vibecode?) a script that extracts all the info from Discussions into a text files before we shut it down. Just so it's not completely lost to history.
    - Probably have to use graphQL API (?)

- [ ] Go through version-2 and feature-strings-catalog branches and replace all mac-mouse-fix/discussions links with redirect.macmousefix.com/ links. 
    - (IIRC we have links to Discussions overview, to Guides overview, and to specific Guides. Plus in the Readme we have links to specific Discussion answers I gave.)

- Transition Plan
    - Push MMF 2 and MMF 3 updates containing the new redirect.macmousefix.com links
    - Wait a month or so for ppl to upgrade. Meanwhile maybe pin a "Discussions will be shut down soon" discussion.
    - Shut down discussions and switch the redirect.macmousefix.com links to the new localizable .md files.

See: [This Claude Discussion](https://claude.ai/share/680a78bd-9edb-4300-95ff-afe016841a5b)


---

Low Level TODO:
- Cleanup `Granting Accessibility Access`
    - [ ] Remove help links from accessibility sheet on both version-2 and feature-strings-catalog
    - [ ] Maybe document the reason for the removal 
        - (but the deprecation notice at the top of `Granting Accessibility Access` kinda already does that job. Maybe make a note in the code somehwere?)
        - (Reasoning for removal: I haven't ever seen the bug since we installed the automatic fix in 2.2.2, and there haven't been any (on-topic) comments on the Guide since then.)
- [x] Maybe move `Mac Mouse Fix 2 vs 3.md` into the 3.0.0 release notes.

--- 

Other TODO: [Aug 10 2025]       ((Not sure this TODO belongs here?))
    - [ ] Maybe add `Command-Scroll doesn't work?` to `Readme.md > Questions`. 
        (People ask about this pretty often. I think it's due to Logitech Options interference?)