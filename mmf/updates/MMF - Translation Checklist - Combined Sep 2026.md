
Also see:
    _dailynote_2026.09.10.md (This is sort of a substep of the steps in here)

Locale addition requests
    - [x] Add Norwegian @Bertil78: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4182846504
    - [x] Add Bengali @Ifty-Rahman: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-5083257598

Submissions (We haven't integrated, yet)
    GitHub
        - Japanese @y-128: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4191409106
        - Japanese update @mei28: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4218636133
        - Vietnamese @quocthangit247: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3876405270
        - French @UYTR5: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3888010759
        - French website @Clementabcd: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3985604493
        - Spanish @manghidev: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-3994798838
        - Simplified Chinese Update @djzhao627: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4064750078
        - Ukrainian @denysocheck: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4282037521
        - Turkish update @mstersnd: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4511309127
        - Turkish update @mls0x1: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4801772821
        - Norwegian @Bertil78: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4820887178
    Email
        - Turkish Eren Tomurcuk: message:<OfZ84n5--F-9@tuta.io>
        - Brazilian Portuguese Eduardo Rodriguez: message:<D9DBBC48-47AD-42EC-8BE6-46D611474277@icloud.com>
        - Turkish Samim Kel: [mail](message:<CAG9To-p8EkFgxsaF1uLE=L2d-u8fs_dZ7iDxJQ5OB1U3t7vQhw@mail.gmail.com>)
        - Ukrainian @denysocheck: message:<78FD2C3A-E753-4DE7-AB3E-76D184334DC2@gmail.com>
    Pull requests:
        - Simplified Chinese @JunhangWu: https://github.com/noah-nuebling/mac-mouse-fix/pull/1836

Locale list (for copy-pasting)
    - [xxx] Vietnamese
    - [xxx] French
    - [xxx] Spanish
    - [xxx] Simplified Chinese
    - [xxx] Japanese
    - [xxx] Ukrainian
    - [xxx] Turkish
    - [xxx] Norwegian
    - [xxx] Brazilian Portuguese


Checklist (Based on `MMF - Translation Checklist - Template.md`)

Translations by @mei28: https://github.com/noah-nuebling/mac-mouse-fix/issues/1638#issuecomment-4218636133

Core:
    Mac Mouse Fix.xcloc

        - Import .xcloc files
            Steps:
                1. >>> z mac-mouse-fix; ./run importstrings                            --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations (Turkish) Samim Kel/Mac Mouse Fix.xcloc'
                2. >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations (Turkish) Samim Kel/Mac Mouse Fix.xcloc'
                3. Update: func applyHardcodedTabWidth()
            - [x] Japanese
            - [x] Vietnamese
            - [x] French
            - [x] Spanish
            - [x] Simplified Chinese
            - [x] Ukrainian
            - [ ] Turkish
            - [ ] Norwegian
            - [ ] Brazilian Portuguese

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            Steps: 
                >>> z mac-mouse-fix-website; ./run importstrings                    --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations (Turkish) Samim Kel/Mac Mouse Fix Website.xcloc'
                >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations (Turkish) Samim Kel/Mac Mouse Fix Website.xcloc'
            - [x] Japanese
            - [x] Vietnamese
            - [x] French
            - [x] Spanish
            - [xxx] Simplified Chinese
            - [x] Ukrainian
            - [ ] Turkish
            - [ ] Norwegian
            - [ ] Brazilian Portuguese
        
        - Update website
            Steps:
            - [ ] `pnpm dev`
            - [ ] `pnpm upload`

        - Update Markdown files:
            - Run ScreenshotTaker XCUITest in Xcode
                Steps:
                    1. Modify 'onlyUpdateLocales' at the top
                    2. >>> func testTakeScreenshots_Documentation()
                - [x] Japanese
                - [ ] Vietnamese
                - [ ] French
                - [ ] Spanish
                - [ ] Simplified Chinese
                - [ ] Ukrainian
                - [ ] Turkish
                - [ ] Norwegian
                - [ ] Brazilian Portuguese
            - Rebuild the docs
                >>> ./run build-markdown --document '.*(?<!Acknowledgements\.md)$'
                - [x] Japanese
                - [ ] Vietnamese
                - [ ] French
                - [ ] Spanish
                - [ ] Simplified Chinese
                - [ ] Ukrainian
                - [ ] Turkish
                - [ ] Norwegian
                - [ ] Brazilian Portuguese

Add credits
    - Add credits to the Acknowledgements
        Steps:
            1. Add
            2. To stop _buildmd.py from failing, the []({urls}) need to match in all languages:
                - [ ] Manually add the new entry to all the translations of `2: translations`.
                - [ ] Update the surrounding urls
                    - >>> ./run updateackurls;
       - [ ] Japanese
       - [ ] Vietnamese
       - [ ] French
       - [ ] Spanish
       - [ ] Simplified Chinese
       - [ ] Ukrainian
       - [ ] Turkish
       - [ ] Norwegian
       - [ ] Brazilian Portuguese
    - Add credits to Update Notes
        - [ ] Japanese
        - [ ] Vietnamese
        - [ ] French
        - [ ] Spanish
        - [ ] Simplified Chinese
        - [ ] Ukrainian
        - [ ] Turkish
        - [ ] Norwegian
        - [ ] Brazilian Portuguese

Update Translation Guide
- Run uploadstrings on the master branch 
    >>> ./run uploadstrings --only-update-locales ...
    - [x] Japanese
    - [ ] Vietnamese
    - [ ] French
    - [ ] Spanish
    - [ ] Simplified Chinese
    - [ ] Ukrainian
    - [ ] Turkish
    - [ ] Norwegian
    - [ ] Brazilian Portuguese

- [ ] Mark the root nodes of all the Localizable strings (whose children are translated) as translated


- [ ] Publish App update
    - See `MMF - Update Checklist - Template.md`

Other:
    - Send 10 MMF licenses to translator (?) (/answer in general)
        - [ ] Japanese
        - [ ] Vietnamese
        - [ ] French
        - [ ] Spanish
        - [ ] Simplified Chinese
        - [ ] Ukrainian
        - [ ] Turkish
        - [ ] Norwegian
        - [ ] Brazilian Portuguese

Review: 
    Don't have time / nerves to do the review steps from `MMF - Translation Checklist - Template.md`

---

Not sure if / when to do this:
    - [ ] Update *all* the screenshots using ./run uploadstrings (so they're on macOS 27, instead of 15)

Later (after 3.1.0 release)

    - [ ] Update Xcode Editor (layout bugs on macOS 27)
            Upload new Xcloc Editor (at "https://github.com/noah-nuebling/mf-xcloc-editor/releases/latest/download/XclocEditor.zip") before running `./run uploadstrings` [Dec 2025]

---

Samim Kel diffs (I won't apply his changes since the strings on GitHub have been looked at by more people, but we can show him the diff and ask him to re-apply, if he wants)
    mac-mouse-fix repo diff:
        ~/m/mac-mouse-fix   *$+  git diff                                                                                 3341ms  Sun Sep 13 23:58:15 2026
        diff --git a/App/UI/Main/mul.lproj/Main.xcstrings b/App/UI/Main/mul.lproj/Main.xcstrings
        index 518beac89..6f55402fd 100644
        --- a/App/UI/Main/mul.lproj/Main.xcstrings
        +++ b/App/UI/Main/mul.lproj/Main.xcstrings
        @@ -1999,7 +1999,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Mac Mouse Fix, uygulama kapatıldığında aktif kalacaktır"
        +            "value" : "Mac Mouse Fix kapatıldığında aktif kalacaktır"
                }
                },
                "uk" : {
        @@ -6169,7 +6169,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Bir düğmeye eylem ataması yapmak için fare imlecinizi '+' alanına getirin ve bir düğmeye tıklayın.\nDilerseniz *Çift Tıklama*, *Tıklama ve Kaydırma* ve daha fazlasını yapabilirsiniz."
        +            "value" : "Bir düğmeye aksiyon ataması yapmak için fare imlecinizi '+' alanına getirin ve bir düğmeye tıklayın.\nDilerseniz *Çift Tıklama*, *Tıklama ve Kaydırma* ve daha fazlasını yapabilirsiniz."
                }
                },
                "uk" : {
        diff --git a/Localization/Localizable.xcstrings b/Localization/Localizable.xcstrings
        index 942fd2adb..73ef32951 100644
        --- a/Localization/Localizable.xcstrings
        +++ b/Localization/Localizable.xcstrings
        @@ -2497,7 +2497,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "%@. Fare Düğmesi"
        +            "value" : "Fare Düğmesi %@'in"
                }
                },
                "uk" : {
        @@ -3908,7 +3908,7 @@
                        "one" : {
                            "stringUnit" : {
                            "state" : "translated",
        -                      "value" : "%2$@ düğmesinin Mac Mouse Fix tarafından yakalanması sona erdi"
        +                      "value" : "%2$@ Mac Mouse Fix tarafından yakalanması sona erdi"
                            }
                        },
                        "other" : {
        @@ -9371,7 +9371,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Uygulamanız **zaten** bu lisans ile **aktif**"
        +            "value" : "Bu lisans **zaten aktif**!"
                }
                },
                "uk" : {
        @@ -9751,7 +9751,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "**İnternet bağlantısı yok**\n\nBilgisayarınızın çevrimiçi olduğuna ve herhangi bir güvenlik duvarının Mac Mouse Fix'in internete bağlanmasına engel olmadığından emin olun.\n\nEğer bu sorununuzu çözmez ise, bana [buradan](%@) ulaşın."
        +            "value" : "**İnternet bağlantısı yok**\n\nBilgisayarınızın internete bağlı olduğundan ve güvenlik duvarının Mac Mouse Fix'i engellemediğinden emin olun.\n\nSorun çözülmezse benimle [buradan](%@) iletişime geçebilirsiniz."
                }
                },
                "uk" : {
        @@ -10017,7 +10017,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "*'%@'** geçerli bir lisans anahtarı değildir\n\nMac Mouse Fix anahtarınızı aldığınız gibi yazdığınızdan emin olun."
        +            "value" : "*'%@'** geçerli bir lisans anahtarı değildir\n\nLütfen başka bir anahtarı deneyin veya elinizdeki anahtarı olduğu gibi yazın."
                }
                },
                "uk" : {
        @@ -16361,7 +16361,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "%@ düğmesine tıkla ve *Sürükle*"
        +            "value" : "%@ düğmesine tıkla ve sürükle"
                }
                },
                "uk" : {
        @@ -16456,7 +16456,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "%@ düğmesine çift tıkla ve *Sürükle*"
        +            "value" : "%@ düğmesine çift tıkla ve sürükle"
                }
                },
                "uk" : {
        @@ -16551,7 +16551,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "%@ düğmesine üç kez tıkla ve *Sürükle*"
        +            "value" : "%@ düğmesine üç kez tıkla ve sürükle"
                }
                },
                "uk" : {
        @@ -16646,7 +16646,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "ve *Sürükle*"
        +            "value" : "ve *sürükle*"
                }
                },
                "uk" : {
        @@ -17026,7 +17026,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "%@ düğmesine tıkla ve *Kaydır*"
        +            "value" : "%@ düğmesine tıkla ve kaydır"
                }
                },
                "uk" : {
        @@ -17121,7 +17121,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "%@ düğmesine çift tıkla ve *Kaydır*"
        +            "value" : "%@ düğmesine çift tıkla ve kaydır"
                }
                },
                "uk" : {
        @@ -17216,7 +17216,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "%@ düğmesine üç kez tıkla ve *Kaydır*"
        +            "value" : "%@ düğmesine üç kez tıkla ve kaydır"
                }
                },
                "uk" : {
        @@ -17311,7 +17311,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "ve *Kaydır*"
        +            "value" : "ve kaydır"
                }
                },
                "uk" : {
        diff --git a/Markdown/Strings/Readme.xcstrings b/Markdown/Strings/Readme.xcstrings
        index 53d6b1af5..9bd95cd14 100644
        --- a/Markdown/Strings/Readme.xcstrings
        +++ b/Markdown/Strings/Readme.xcstrings
        @@ -1181,7 +1181,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "[Swish]({url}) uygulaması, macOS üstünde pencere yönetimi sağlayan favori uygulamamdır. İzleme dörtgeni üzerinde yapılan basit bir kaydırma ile bir pencerenin pozisyonunu yarım, çeyrek veya tam ekran olarak pozisyonlandırabiliyorsunuz.\n\nFakat, Swish sadece İzleme Dörtgeni ile beraber çalışabiliyor. Mac Mouse Fix'i bütün üçüncü parti fareler ile kullanabilirsiniz. Herhangi bir \"Tıkla ve Sürükle\" eylemi ile \"Kaydır ve Yönlendir\" ataması yaparak siz de pencelererinizi basit bir tık ve kaydırma ile pozisyonlandırabilirsiniz.\n\nBir izleme dörtgeninde yapacağınız iki parmakla kaydırma aksiyonu Mac Mouse Fix'deki \"Kaydır ve Yönlendir\" eylemi ile başarılı bir şekilde çalışmaktadır."
        +            "value" : "[Swish]({url}) uygulaması, macOS üstünde pencere yönetimi sağlayan favori uygulamamdır. İzleme dörtgeni üzerinde yapılan basit bir kaydırma ile bir pencerenin pozisyonunu yarım, çeyrek veya tam ekran olarak pozisyonlandırabiliyorsunuz.\n\nFakat, Swish sadece İzleme Dörtgeni ile beraber çalışabiliyor. Mac Mouse Fix'i bütün üçüncü parti fareler ile kullanabilirsiniz. Herhangi bir \"Tıkla ve Sürükle\" aksiyonu ile \"Kaydır ve Yönlendir\" ataması yaparak siz de pencelererinizi basit bir tık ve kaydırma ile pozisyonlandırabilirsiniz.\n\nBir izleme dörtgeninde yapacağınız iki parmakla kaydırma aksiyonu Mac Mouse Fix'deki \"Kaydır ve Yönlendir\" aksiyonu ile başarılı bir şekilde çalışmaktadır."
                }
                },
                "uk" : {
        @@ -1637,7 +1637,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Bir tıklama yaptığınızda, Mac Mouse Fix acaba çift tık mı gerçekleştirilecek diye kontrol edecektir.<br>\nBir butonda bu gecikmeyi kaldırmak için o butona atanmış herhangi bir  \"Çift Tık\" eylemini kaldırın."
        +            "value" : "Bir tıklama yaptığınızda Mac Mouse Fix çift tıklama girdisini kontrol edecektir. <br>\nBir butonda bu gecikmeyi kaldırmak için o butona atanmış herhangi bir  \"Çift Tık\" aksiyonunu kaldırın.\n"
                }
                },
                "uk" : {
        @@ -1702,7 +1702,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "**Tıkla ve Sürükle eylemi ile Exposé'yi açabilir miyim?**"
        +            "value" : "**Tıkla ve Sürükle aksiyonu ile Exposé'yi açabilir miyim?**"
                }
                },
                "uk" : {
        @@ -1767,7 +1767,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Evet! Sadece eylem olarak \"Spaces ve Mission Control\"'ü seçin ve tıkayıp aşağıya kaydırın.\n\nEğer bu çalışmaz ise Mac'inizde Exposé hareketi kapalı olabilir.<br>\nBu hareketi Sistem Ayarları üzerinden veya aşağıdaki komutu Terminal'e yapıştırarak açabilirsiniz.\n\n```\ndefaults write com.apple.Dock showAppExposeGestureEnabled -bool TRUE; killall Dock\n```\n"
        +            "value" : "Evet! Sadece aksiyon olarak \"Spaces ve Mission Control\"'ü seçin ve tıkayıp aşağıya kaydırın.\n\nEğer bu çalışmaz ise Mac'inizde Exposé hareketi kapalı olabilir.<br>\nBu hareketi Sistem Ayarları üzerinden veya aşağıdaki komutu Terminal'e yapıştırarak açabilirsiniz.\n\n```\ndefaults write com.apple.Dock showAppExposeGestureEnabled -bool TRUE; killall Dock\n```\n"
                }
                },
                "uk" : {
        @@ -2418,7 +2418,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Bazı fareler kaydırma tekerleklerini sağa veya sola eğmenize olanak sağlar. Mac Mouse Fix bunu daha kolay ve doğal olarak kontrol etmenizi sağlar. Fakat, şu anda bu butonlar ile diğer eylemleri aktifleştiremezsiniz.\n\nTabii ki bunlar için de tam uyumluluk eklemeyi isterim ama bu çok büyük bir iş ve yakın bir zamanda gelmeyecektir."
        +            "value" : "Bazı fareler kaydırma tekerleklerini sağa veya sola eğmenize olanak sağlar. Mac Mouse Fix bunu daha kolay ve doğal olarak kontrol etmenizi sağlar. Fakat, şu anda bu butonlar ile diğer aksiyonları aktifleştiremezsiniz.\n\nTabii ki bunlar için de tam uyumluluk eklemeyi isterim ama bu çok büyük bir iş ve yakın bir zamanda gelmeyecektir."
                }
                },
                "uk" : {
        @@ -2938,7 +2938,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Lisansınız **size ait bütün Mac'lerde** çalışır.<br>\nBuradaki amaç sizin sadece bir lisans satın aldıktan ve aktifleştirdikten sonra tekrar derdine düşmemenizdir.<br>\nEğer diğer Mac'lerde aynı Apple hesabı ile giriş yaparsanız iCloud sayesinde lisansınız diğer cihazlara da aktarılacaktır!\n\nEğer lisans aktivasyonunda problem yaşıyorsanız [bana bir E-Posta gönderin]({url}).<br>\nBazen cevaplarım gecikebiliyor, bunun için üzgünüm; ama geri dönüş yapacağım!\n\nAma bu konuda sadece bir engel bulunuyor:<br>\nLisanslar herkesle paylaşmak için değil, bir lisans bir kişi için geçerlidir. Herkese açık olarak paylaşılmış lisanslar geçersiz kılınacaktır. (Buradaki herkes örneğin anneniz değil, onunla paylaşmanız tabii ki bir sorun değildir!)"
        +            "value" : "Lisansınız **size ait bütün Mac'lerde** çalışır.<br>\nBuradaki amaç sizin sadece bir lisans satın aldıktan ve aktifleştirdikten sonra tekrar derdine düşmemenizdir.<br>\nEğer diğer Mac'lerde aynı Apple hesabı ile giriş yaparsanız iCloud sayesinde lisansınız diğer cihazlara da aktarılacaktır!\n\nEğer lisans aktivasyonunda problem yaşıyorsanız [bana bir E-Posta gönderin]({url}).<br>\nBazen dönütlerim gecikebilir, bunun için üzgünüm; ama geri dönüş yapacağım!\n\nAma bu konuda sadece bir engel bulunuyor:<br>\nLisanslar herkesle paylaşmak için değil, bir lisans bir kişi için geçerlidir. Herkese açık olarak paylaşılmış lisanslar geçersiz kılınacaktır. (Anne-Babanız ile paylaşabilirsiniz.)"
                }
                },
                "uk" : {
        @@ -4238,7 +4238,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Blender gibi 3D uygulamalarında normalde orta düğme ile Tıkla ve Sürükle eylemiyle yörüngede hareket edebilirsiniz.<br>\nFakat, Mac Mouse Fix üzerinde orta tuşa bir eylem ayarlarsanız bu çalışmayacaktır.\n\nBunu çözmek için 2 yol billiyorum:\n1. Tıkla ve Sürükle komutunu farenizin herhangi bir düğmesine atayın. Bu özellik İzleme Dörtgeninde 2 parmakla kaydırma özelliğini simüle eder. Bu 3D uygulamalarda yörüngede dönme özelliğini sağlar.\n2. Orta düğmenin *yakalanmasını* tüm eylemleri Mac Mouse Fix üzerinden silerek kaldırın. [Buradan]({url}) daha fazla bilgi sahibi olun."
        +            "value" : "Blender gibi 3D uygulamalarında normalde orta düğme ile Tıkla ve Sürükle aksiyonuyla yörüngede hareket edebilirsiniz.<br>\nFakat, Mac Mouse Fix üzerinde orta tuşa bir aksiyon ayarlarsanız bu çalışmayacaktır.\n\nBunu çözmek için 2 yol billiyorum:\n1. Tıkla ve Sürükle komutunu farenizin herhangi bir düğmesine atayın. Bu özellik İzleme Dörtgeninde 2 parmakla kaydırma özelliğini simüle eder. Bu 3D uygulamalarda yörüngede dönme özelliğini sağlar.\n2. Orta düğmenin *yakalanmasını* tüm aksiyonları Mac Mouse Fix üzerinden silerek kaldırın. [Buradan]({url}) daha fazla bilgi sahibi olun."
                }
                },
                "uk" : {
        diff --git a/Markdown/Strings/Support/Guides/CapturedButtonsMMF3.xcstrings b/Markdown/Strings/Support/Guides/CapturedButtonsMMF3.xcstrings
        index 747c84cad..fda35a53b 100644
        --- a/Markdown/Strings/Support/Guides/CapturedButtonsMMF3.xcstrings
        +++ b/Markdown/Strings/Support/Guides/CapturedButtonsMMF3.xcstrings
        @@ -115,7 +115,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "## Bir fare düğmesini 'yakalamak' ne anlama geliyor?\n\nBir fare düğmesinin Mac Mouse Fix tarafından yakalanması artık macOS'in veya diğer uygulamaların o düğmeyi artık göremiyor olması anlamına gelir. Bu düğmenin normalde yapacağı eylemler yakalanmış haldeyken çalışmayacaktır.\n\n**Örnek**: Normalde, farenizin yan tarafında bulunan düğmeler ile Chrome tarayıcıda geri veya ileri gidebilirsiniz. (Düğme 4 ve 5) Bu düğmeler Mac Mouse Fix ile yakalandığında önceki özellik yerine sizin tarafınızdan atanmış olan eylemlerin çalışması sağlanacaktır.\n\n**Mac Mouse Fix neden bunu yapıyor?**: Mac Mouse Fix düğmeleri diğer uygulamalardan gizleyerek atadığınız eylemler dışında uygulamaların yanlışlıkla başka eylemler gerçekleştirmesini engeller.\nÖrnek olarak, Düğme 4'ü masaüstülerinizin arasında geçiş yapmak için kullanıyorken istemsizce **aynı anda** Chrome tarayıcı üzerinden geri dönebilirsiniz."
        +            "value" : "## Bir fare düğmesini 'yakalamak' ne anlama geliyor?\n\nBir fare düğmesinin Mac Mouse Fix tarafından yakalanması artık macOS'in veya diğer uygulamaların o düğmeyi artık göremiyor olması anlamına gelir. Bu düğmenin normalde yapacağı aksiyonlar yakalanmış haldeyken çalışmayacaktır.\n\n**Örnek**: Normalde, farenizin yan tarafında bulunan düğmeler ile Chrome tarayıcıda geri veya ileri gidebilirsiniz. (Düğme 4 ve 5) Bu düğmeler Mac Mouse Fix ile yakalandığında önceki özellik yerine sizin tarafınızdan atanmış olan aksiyonların çalışması sağlanacaktır.\n\n**Mac Mouse Fix neden bunu yapıyor?**: Mac Mouse Fix düğmeleri diğer uygulamalardan gizleyerek atadığınız aksiyonlar dışında uygulamaların yanlışlıkla başka aksiyonlar gerçekleştirmesini engeller.\nÖrnek olarak, Düğme 4'ü masaüstülerinizin arasında geçiş yapmak için kullanıyorken istemsizce **aynı anda** Chrome tarayıcı üzerinden geri dönebilirsiniz."
                }
                },
                "uk" : {
        @@ -247,7 +247,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "## Mac Mouse Fix'in bir düğmeyi yakalamasını nasıl engellerim?\n\nMac Mouse Fix'in bir düğmeyi yakalamasını engellemek için 'Düğmeler' sekmesinde o butona atanmış tüm eylemleri kaldırın.\n'Düğmeler' sekmesindeki bir eylemi, yanındaki '-' düğmesine basarak kaldırabilirsiniz.\n\nÖrneğin, bir sonraki resimde, 'Düğme 4'ün' yakalanmasını engellemek için belirtilmiş olan iki **'-'** düğmesine tıklayabilirsiniz.\n\n{screenshot_2}"
        +            "value" : "## Mac Mouse Fix'in bir düğmeyi yakalamasını nasıl engellerim?\n\nMac Mouse Fix'in bir düğmeyi yakalamasını engellemek için 'Düğmeler' sekmesinde o butona atanmış tüm aksiyonları kaldırın.\n'Düğmeler' sekmesindeki bir aksiyonu, yanındaki '-' düğmesine basarak kaldırabilirsiniz.\n\nÖrneğin, bir sonraki resimde, 'Düğme 4'ün' yakalanmasını engellemek için belirtilmiş olan iki **'-'** düğmesine tıklayabilirsiniz.\n\n{screenshot_2}"
                }
                },
                "uk" : {
        @@ -312,7 +312,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "## Bir düğmenin orijinal fonksiyonunu nasıl geri getirebilirim?\n\nBir düğmenin Mac Mouse Fix yüklemeden önceki haline getirmek için aşağıdakileri yapabilirsiniz:\n\n1. Yukarıda belirtildiği üzere düğmenin **yakalanmasını kapatabilirsiniz**.\n\n2. Direkt **Mac Mouse Fix'i** kapatabilirsiniz. Böylece hiçbir düğme yakalanmayacaktır.\n\n3. **Mac Mouse Fix'te belirli eylemleri düğmeye atayabilirsiniz** - böylece atama yapmış olsanız dahi belirli özellikleri geri getirmiş olursunuz."
        +            "value" : "## Bir düğmenin orijinal fonksiyonunu nasıl geri getirebilirim?\n\nBir düğmenin Mac Mouse Fix yüklemeden önceki haline getirmek için aşağıdakileri yapabilirsiniz:\n\n1. Yukarıda belirtildiği üzere düğmenin **yakalanmasını kapatabilirsiniz**.\n\n2. Direkt **Mac Mouse Fix'i** kapatabilirsiniz. Böylece hiçbir düğme yakalanmayacaktır.\n\n3. **Mac Mouse Fix'te belirli aksiyonları düğmeye atayabilirsiniz** - böylece atama yapmış olsanız dahi belirli özellikleri geri getirmiş olursunuz."
                }
                },
                "uk" : {
        @@ -444,7 +444,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Orijinal Fonksiyon"
        +            "value" : "Orijinal Aksiyonu"
                }
                },
                "uk" : {
        @@ -516,7 +516,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "Mac Mouse Fix üzerindeki Eylem"
        +            "value" : "Mac Mouse Fix üzerindeki aksiyonu"
                }
                },
                "uk" : {
        @@ -1367,7 +1367,7 @@
                "tr" : {
                "stringUnit" : {
                    "state" : "translated",
        -            "value" : "'Kaydır ve Yönlendir'<br> (Herhangi bir düğmeye **tıkla ve kaydır** eylemi ile eklenebilir)"
        +            "value" : "'Kaydır ve Yönlendir'<br> (Herhangi bir düğmeye **tıkla ve kaydır** aksiyonu ile eklenebilir)"
                }
                },
                "uk" : {