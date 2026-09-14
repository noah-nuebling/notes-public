
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
            - We assume that @mls0x1 built on top of @mstersnd's work. but not entirely sure. Update: Claude Opus 5 confirmed.
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
                1. >>> z mac-mouse-fix; ./run importstrings                            --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations Norwegian Bokmal @Bertil78/Mac Mouse Fix.xcloc'
                2. >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path '/Users/Noah/Downloads/Mac Mouse Fix Translations Norwegian Bokmal @Bertil78/Mac Mouse Fix.xcloc'
                3. Update: func applyHardcodedTabWidth()
            - [x] Japanese
            - [x] Vietnamese
            - [x] French
            - [x] Spanish
            - [x] Simplified Chinese
            - [x] Ukrainian
            - [x] Turkish
            - [x] Norwegian
            - [ ] Brazilian Portuguese

    Mac Mouse Fix Website.xcloc

        - Import .xcloc files
            Steps: 
                >>> z mac-mouse-fix-website; ./run importstrings                    --xcloc-path 
                >>> ./run importstrings2 --no-key-mismatches --no-source-mismatches --xcloc-path 
            - [x] Japanese
            - [x] Vietnamese
            - [x] French
            - [x] Spanish
            - [xxx] Simplified Chinese
            - [x] Ukrainian
            - [x] Turkish
            - [xxx] Norwegian
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
    
    mac-mouse-fix-website repo diff:
        ./run mfstrings inspect --cols key,fileid,en,tr --sortcol key --diff --pretty
        ~ (1) 04: trackpad.intro.body
        fileid:
            index
        en:
            That's right! Mac Mouse Fix brings all features of an Apple Trackpad - and more - to your **precise** and **ergonomic** third-party mouse. And all interactions feel just as **smooth** and **natural** as they do on a Trackpad.
        tr:
            - Teknoloji gelişiyor. Mac Mouse Fix bir Apple İzleme Dörtgeninin tüm özelliklerini ve daha fazlasını **hassas** ve **ergonomik** üçüncü parti farenize getirir ve tüm hareketler aynı bir izleme dörtgeni kullanırmışcasına **akıcı** ve **doğal** olur.
            + Yanlış duymadınız! Mac Mouse Fix, Apple Trackpad ve daha fazlasının özelliklerini elinizdeki **hassas** ve **ergonomik** yapıdaki farklı marka mouse'lara getiriyor. Aynı zamanda tüm etkileşimler Trackpad'deki kadar **akıcı** ve **doğal** hissettiriyor.

        ~ (2) 06: trackpad.gestures.disclaimer
        fileid:
            index
        en:
            Note: Mac Mouse Fix can bring these Trackpad features to your third-party mouse as described here, only if your mouse has at least 5 buttons. These 5 buttons are typically left-click, right-click, mouse-wheel click, and 2 side-buttons. If your mouse has fewer than 5 buttons, Mac Mouse Fix still provides rich functionality and a great experience, but some features will be less easy to access compared to a 5-button mouse. On certain mice designed to be used with proprietary driver software like Logitech Options, Mac Mouse Fix can't recognize all the buttons at the moment. Mac Mouse Fix does not currently support the Apple Magic Mouse.
        tr:
            - Not: Mac Mouse Fix bu şekilde görülen İzleme Dörtgeni hareketlerini sadece 5 düğmeli fareler ile destekler. Bu 5 düğme tipik olarak sol tık, sağ tık, orta tık ve iki yan düğmedir. Eğer farenizde 5'den az düğme varsa bile Mac Mouse Fix hala zengin bir işlev sunabilir ama bazı özellikler 5 düğmeli farelere göre daha kısıtlı olacaktır. Logitech Options gibi özel sürücüler kullanan farelerde Mac Mouse Fix bütün düğmeleri algılayamayabilir. Mac Mouse Fix şu anda Apple Magic Mouse'u desteklememektedir.
            + Not: Mac Mouse Fix, burada açıklanan Trackpad özelliklerini üçüncü taraf farenize getirebilir, ancak farenizin en az 5 düğmesi olması gerekir. Bu 5 düğme genellikle sol tıklama, sağ tıklama, fare tekerleği tıklama ve 2 yan düğmedir. Farenizde 5'ten az düğme varsa, Mac Mouse Fix yine de zengin işlevsellik ve harika bir deneyim sunar, ancak bazı özelliklere 5 düğmeli bir fareye kıyasla erişmek daha zor olacaktır. Logitech Options gibi özel sürücü yazılımıyla kullanılmak üzere tasarlanmış belirli farelerde, Mac Mouse Fix şu anda tüm düğmeleri tanıyamıyor. Mac Mouse Fix şu anda Apple Magic Mouse'u desteklemiyor.

        ~ (3) 29: scroll.intro.title
        fileid:
            index
        en:
            {accent}.
            Smooth As Butter.
        tr:
            - {accent}
            Yağ Gibi Kaygan.
            + {accent}
            Akıyor.

        ~ (4) 31: scroll.intro.body
        fileid:
            index
        en:
            Scrolling with a third-party mouse on macOS can feel **stuttery** and **hard to control**. Well, not any more! Experience a **refined**, **momentum-based** scrolling algorithm that makes navigating your computer **effortless** and **natural**.
        tr:
            - macOS üzerinde üçüncü parti bir fare ile kaydırma eylemi **teklermiş gibi** ve **zor bir şekilde kontrol ediliyor**. Artık öyle değil! **Zarif** bir şekilde **hızlanma tabanlı** kaydırma algoritması ile bilgisayarınızda gezinmek artık **eforsuz** ve **doğal**.
            + macOS üzerinde üçüncü parti bir fare ile kaydırma aksiyonu **teklermiş gibi** ve **zor bir şekilde kontrol ediliyor**. Artık öyle değil! **Zarif** bir şekilde **hızlanma tabanlı** kaydırma algoritması ile bilgisayarınızda gezinmek artık **eforsuz** ve **doğal**.

        ~ (5) 38: scroll.smoothness.off.body
        fileid:
            index
        en:
            With *Smoothness: Off*, scrolling works as it normally does under macOS - **without any animation** or smoothing. But with one key difference: **One increment of the scroll wheel will scroll a set number of *lines***, rather than just a few pixels, making navigation more consistent and comfortable.

            This is how scrolling also works in most apps on Windows and Linux, as well as older macOS versions.
        tr:
            - *Akıcılık: Kapalı* ile kaydırma macOS'de normalde nasık ise aynı o şekildedir ve herhangi bir animasyon veya akıcılık bulundurmaz Fakat, normalde **bir tık kaydırma eylemi ile birkaç piksel** yerine daha tutarlı ve rahat olan **bir tık kaydırma eylemi ile birkaç satır** kaydırılır.

            Bu seçenek Windows, Linux ve eski macOS sürümlerindeki kaydırma gibi çalışır.
            + *Akıcılık: Kapalı* ile kaydırma macOS'de normalde nasık ise aynı o şekildedir ve herhangi bir animasyon veya akıcılık bulundurmaz Fakat, normalde **bir tık kaydırma aksiyonu ile birkaç piksel** yerine daha tutarlı ve rahat olan **bir tık kaydırma aksiyonu ile birkaç satır** kaydırılır.

            Bu seçenek Windows, Linux ve eski macOS sürümlerindeki kaydırma gibi çalışır.

        ~ (6) 46: customization.intro.title
        fileid:
            index
        en:
            Amazingly {accent2}
            {accent} Intuitive.
        tr:
            - Muhteşem bir şekilde {accent2}
            {accent} bir şekilde Sezgisel.
            + Muhteşem bir şekilde {accent2} {accent} Sezgisel.

        ~ (7) 50: customization.action-table.title
        fileid:
            index
        en:
            **Add Actions** to your mouse
        tr:
            - Farenize **eylemler ekleyin**
            + Farenize **aksiyonlar ekleyin**

        ~ (8) 51: customization.action-table.body
        fileid:
            index
        en:
            To add an action to your mouse:

            1. **Move** the mouse pointer inside the '+'-field. (Shown below)
            2. **Click** the mouse button you want to assign an action to.
            You can also Double Click, Click and Drag, and much more!
            3. **Choose** an action, such as Smart Zoom.

            And that's it!
        tr:
            - Farenize bir eylem eklemek için:

            1. İmlecinizi '+' alanının içine **getirin**. (Aşağıda gösterildiği üzere)
            2. Atama yapamak istediğiniz butona **basın**.
            Aynı zamanda iki tık, tıkla ve kaydır ve daha fazlasını yapabilirsiniz!
            3. Bir eylem **seçin**, örneğin Akıllı Yakınlaştırma.

            Bu kadar!
            + Farenize bir aksiyon eklemek için:

            1. İmlecinizi '+' alanının içine **getirin**. (Aşağıda gösterildiği üzere)
            2. Atama yapamak istediğiniz butona **basın**.
            Aynı zamanda iki tık, tıkla ve kaydır ve daha fazlasını yapabilirsiniz!>
            3. Bir aksiyon **seçin** (örn. Akıllı Yakınlaştırma).

            Bu kadar!    
    
    mac-mouse-fix repo diff:
        ./run mfstrings inspect --cols key,fileid,en,tr --sortcol key --diff --pretty
        ~ (1) 02: terminology
        fileid:
            CapturedButtonsMMF3
        en:
            ## What does 'capturing' a mouse button mean?

            A mouse button that is captured by Mac Mouse Fix can't be seen by other apps or by macOS anymore.
            The functions which this button would normally perform won't work while it's being captured.

            **Example**: Normally you can go backward and forward in Chrome by clicking the side buttons (buttons 4 and 5) of the mouse.
            But when the side buttons are captured by Mac Mouse Fix, this no longer works. Instead, the side buttons will only trigger the actions that you've assigned to them in Mac Mouse Fix.

            **Why does Mac Mouse Fix do this?** Mac Mouse Fix hides buttons from other apps to prevent you from accidentally triggering other functions while using Mac Mouse Fix gestures.
            For example, if you click and drag button 4 to switch between desktops, you would always **simultaneously** go back a page in Chrome.
        tr:
            - ## Bir fare düğmesini 'yakalamak' ne anlama geliyor?

            Bir fare düğmesinin Mac Mouse Fix tarafından yakalanması artık macOS'in veya diğer uygulamaların o düğmeyi artık göremiyor olması anlamına gelir. Bu düğmenin normalde yapacağı eylemler yakalanmış haldeyken çalışmayacaktır.

            **Örnek**: Normalde, farenizin yan tarafında bulunan düğmeler ile Chrome tarayıcıda geri veya ileri gidebilirsiniz. (Düğme 4 ve 5) Bu düğmeler Mac Mouse Fix ile yakalandığında önceki özellik yerine sizin tarafınızdan atanmış olan eylemlerin çalışması sağlanacaktır.

            **Mac Mouse Fix neden bunu yapıyor?**: Mac Mouse Fix düğmeleri diğer uygulamalardan gizleyerek atadığınız eylemler dışında uygulamaların yanlışlıkla başka eylemler gerçekleştirmesini engeller.
            Örnek olarak, Düğme 4'ü masaüstülerinizin arasında geçiş yapmak için kullanıyorken istemsizce **aynı anda** Chrome tarayıcı üzerinden geri dönebilirsiniz.
            + ## Bir fare düğmesini 'yakalamak' ne anlama geliyor?

            Bir fare düğmesinin Mac Mouse Fix tarafından yakalanması artık macOS'in veya diğer uygulamaların o düğmeyi artık göremiyor olması anlamına gelir. Bu düğmenin normalde yapacağı aksiyonlar yakalanmış haldeyken çalışmayacaktır.

            **Örnek**: Normalde, farenizin yan tarafında bulunan düğmeler ile Chrome tarayıcıda geri veya ileri gidebilirsiniz. (Düğme 4 ve 5) Bu düğmeler Mac Mouse Fix ile yakalandığında önceki özellik yerine sizin tarafınızdan atanmış olan aksiyonların çalışması sağlanacaktır.

            **Mac Mouse Fix neden bunu yapıyor?**: Mac Mouse Fix düğmeleri diğer uygulamalardan gizleyerek atadığınız aksiyonlar dışında uygulamaların yanlışlıkla başka aksiyonlar gerçekleştirmesini engeller.
            Örnek olarak, Düğme 4'ü masaüstülerinizin arasında geçiş yapmak için kullanıyorken istemsizce **aynı anda** Chrome tarayıcı üzerinden geri dönebilirsiniz.

        ~ (2) 04: uncapturing
        fileid:
            CapturedButtonsMMF3
        en:
            ## How do I prevent Mac Mouse Fix from capturing a mouse button?

            To prevent Mac Mouse Fix from capturing a mouse button, delete all entries for that mouse button from the 'Buttons' tab.
            You can delete an entry in the 'Buttons' tab by clicking the '-' button on the left.

            For example, in the following image, you could prevent **'Button 4'** from being captured by clicking the two highlighted **'-'** buttons:

            {screenshot_2}
        tr:
            - ## Mac Mouse Fix'in bir düğmeyi yakalamasını nasıl engellerim?

            Mac Mouse Fix'in bir düğmeyi yakalamasını engellemek için 'Düğmeler' sekmesinde o butona atanmış tüm eylemleri kaldırın.
            'Düğmeler' sekmesindeki bir eylemi, yanındaki '-' düğmesine basarak kaldırabilirsiniz.

            Örneğin, bir sonraki resimde, 'Düğme 4'ün' yakalanmasını engellemek için belirtilmiş olan iki **'-'** düğmesine tıklayabilirsiniz.

            {screenshot_2}
            + ## Mac Mouse Fix'in bir düğmeyi yakalamasını nasıl engellerim?

            Mac Mouse Fix'in bir düğmeyi yakalamasını engellemek için 'Düğmeler' sekmesinde o butona atanmış tüm aksiyonları kaldırın.
            'Düğmeler' sekmesindeki bir aksiyonu, yanındaki '-' düğmesine basarak kaldırabilirsiniz.

            Örneğin, bir sonraki resimde, 'Düğme 4'ün' yakalanmasını engellemek için belirtilmiş olan iki **'-'** düğmesine tıklayabilirsiniz.

            {screenshot_2}

        ~ (3) 05: restoring
        fileid:
            CapturedButtonsMMF3
        en:
            ## How can I restore the original functionality of a button?

            To make a button behave like it did before you installed Mac Mouse Fix, you can do the following:

            1. You can **prevent the button from being captured** – as described above.

            2. You can simply **turn off Mac Mouse Fix** – then no buttons will be captured.

            3. You can **assign specific actions to the button in Mac Mouse Fix** – this way you can restore certain functions, *even while the button is being captured*:
        tr:
            - ## Bir düğmenin orijinal fonksiyonunu nasıl geri getirebilirim?

            Bir düğmenin Mac Mouse Fix yüklemeden önceki haline getirmek için aşağıdakileri yapabilirsiniz:

            1. Yukarıda belirtildiği üzere düğmenin **yakalanmasını kapatabilirsiniz**.

            2. Direkt **Mac Mouse Fix'i** kapatabilirsiniz. Böylece hiçbir düğme yakalanmayacaktır.

            3. **Mac Mouse Fix'te belirli eylemleri düğmeye atayabilirsiniz** - böylece atama yapmış olsanız dahi belirli özellikleri geri getirmiş olursunuz.
            + ## Bir düğmenin orijinal fonksiyonunu nasıl geri getirebilirim?

            Bir düğmenin Mac Mouse Fix yüklemeden önceki haline getirmek için aşağıdakileri yapabilirsiniz:

            1. Yukarıda belirtildiği üzere düğmenin **yakalanmasını kapatabilirsiniz**.

            2. Direkt **Mac Mouse Fix'i** kapatabilirsiniz. Böylece hiçbir düğme yakalanmayacaktır.

            3. **Mac Mouse Fix'te belirli aksiyonları düğmeye atayabilirsiniz** - böylece atama yapmış olsanız dahi belirli özellikleri geri getirmiş olursunuz.

        ~ (4) 07: restoring.header.function
        fileid:
            CapturedButtonsMMF3
        en:
            Original Function
        tr:
            - Orijinal Fonksiyon
            + Orijinal Aksiyonu

        ~ (5) 08: restoring.header.action
        fileid:
            CapturedButtonsMMF3
        en:
            Action in Mac Mouse Fix
        tr:
            - Mac Mouse Fix üzerindeki Eylem
            + Mac Mouse Fix üzerindeki aksiyonu

        ~ (6) 17: tips.swish.body
        fileid:
            Readme
        en:
            [Swish]({url}) is my favorite way to manage windows on macOS. With a simple swipe on your trackpad, it lets you position any window so it takes up half, a quarter, or the whole screen.

            Swish is designed for trackpad gestures, but with Mac Mouse Fix you can use it from any third-party mouse! Just go to Mac Mouse Fix and set any button's 'Click and Drag' action to 'Scroll & Navigate' and then you can snap windows with a simple Click and Drag.

            Anything you can do with a two-finger swipe on an Apple trackpad works just as well with the 'Scroll & Navigate' feature in Mac Mouse Fix.
        tr:
            - [Swish]({url}) uygulaması, macOS üstünde pencere yönetimi sağlayan favori uygulamamdır. İzleme dörtgeni üzerinde yapılan basit bir kaydırma ile bir pencerenin pozisyonunu yarım, çeyrek veya tam ekran olarak pozisyonlandırabiliyorsunuz.

            Fakat, Swish sadece İzleme Dörtgeni ile beraber çalışabiliyor. Mac Mouse Fix'i bütün üçüncü parti fareler ile kullanabilirsiniz. Herhangi bir "Tıkla ve Sürükle" eylemi ile "Kaydır ve Yönlendir" ataması yaparak siz de pencelererinizi basit bir tık ve kaydırma ile pozisyonlandırabilirsiniz.

            Bir izleme dörtgeninde yapacağınız iki parmakla kaydırma aksiyonu Mac Mouse Fix'deki "Kaydır ve Yönlendir" eylemi ile başarılı bir şekilde çalışmaktadır.
            + [Swish]({url}) uygulaması, macOS üstünde pencere yönetimi sağlayan favori uygulamamdır. İzleme dörtgeni üzerinde yapılan basit bir kaydırma ile bir pencerenin pozisyonunu yarım, çeyrek veya tam ekran olarak pozisyonlandırabiliyorsunuz.

            Fakat, Swish sadece İzleme Dörtgeni ile beraber çalışabiliyor. Mac Mouse Fix'i bütün üçüncü parti fareler ile kullanabilirsiniz. Herhangi bir "Tıkla ve Sürükle" aksiyonu ile "Kaydır ve Yönlendir" ataması yaparak siz de pencelererinizi basit bir tık ve kaydırma ile pozisyonlandırabilirsiniz.

            Bir izleme dörtgeninde yapacağınız iki parmakla kaydırma aksiyonu Mac Mouse Fix'deki "Kaydır ve Yönlendir" aksiyonu ile başarılı bir şekilde çalışmaktadır.

        ~ (7) 20: restoring.row4.action
        fileid:
            CapturedButtonsMMF3
        en:
            'Scroll & Navigate'<br>(Can be assigned to **clicking and dragging** a button)
        tr:
            - 'Kaydır ve Yönlendir'<br> (Herhangi bir düğmeye **tıkla ve kaydır** eylemi ile eklenebilir)
            + 'Kaydır ve Yönlendir'<br> (Herhangi bir düğmeye **tıkla ve kaydır** aksiyonu ile eklenebilir)

        ~ (8) 24: questions.click-delay.body
        fileid:
            Readme
        en:
            When you click, Mac Mouse Fix might wait to see if you're going to double click.<br>
            To remove the delay for a button, delete any 'Double Click' actions for that button.
        tr:
            - Bir tıklama yaptığınızda, Mac Mouse Fix acaba çift tık mı gerçekleştirilecek diye kontrol edecektir.<br>
            Bir butonda bu gecikmeyi kaldırmak için o butona atanmış herhangi bir  "Çift Tık" eylemini kaldırın.
            + Bir tıklama yaptığınızda Mac Mouse Fix çift tıklama girdisini kontrol edecektir. <br>
            Bir butonda bu gecikmeyi kaldırmak için o butona atanmış herhangi bir  "Çift Tık" aksiyonunu kaldırın.


        ~ (9) 27: questions.app-expose
        fileid:
            Readme
        en:
            **Can I open App Exposé through a Click and Drag Gesture?**
        tr:
            - **Tıkla ve Sürükle eylemi ile Exposé'yi açabilir miyim?**
            + **Tıkla ve Sürükle aksiyonu ile Exposé'yi açabilir miyim?**

        ~ (10) 28: questions.app-expose.body
        fileid:
            Readme
        en:
            Yes! Just choose the 'Spaces & Mission Control' Action and then Click and Drag *down*.

            If this doesn't work, it's likely because the 'App Exposé' trackpad gesture is disabled on your Mac.<br>
            You can enable the gesture under System Settings or by running the following command in the terminal:

            ```
            defaults write com.apple.Dock showAppExposeGestureEnabled -bool TRUE; killall Dock
            ```
        tr:
            - Evet! Sadece eylem olarak "Spaces ve Mission Control"'ü seçin ve tıkayıp aşağıya kaydırın.

            Eğer bu çalışmaz ise Mac'inizde Exposé hareketi kapalı olabilir.<br>
            Bu hareketi Sistem Ayarları üzerinden veya aşağıdaki komutu Terminal'e yapıştırarak açabilirsiniz.

            ```
            defaults write com.apple.Dock showAppExposeGestureEnabled -bool TRUE; killall Dock
            ```

            + Evet! Sadece aksiyon olarak "Spaces ve Mission Control"'ü seçin ve tıkayıp aşağıya kaydırın.

            Eğer bu çalışmaz ise Mac'inizde Exposé hareketi kapalı olabilir.<br>
            Bu hareketi Sistem Ayarları üzerinden veya aşağıdaki komutu Terminal'e yapıştırarak açabilirsiniz.

            ```
            defaults write com.apple.Dock showAppExposeGestureEnabled -bool TRUE; killall Dock
            ```


        ~ (11) 38: questions.tilt-wheel.body
        fileid:
            Readme
        en:
            Some mice let you tilt the scroll wheel left or right to scroll horizontally. Mac Mouse Fix will make this feel more natural and easy to control. However, it's not currently possible to trigger other actions, such as switching between desktops, by tilting the scroll wheel. I'd love to implement this feature at some point, but it's a ton of work and it won't be coming soon.
        tr:
            - Bazı fareler kaydırma tekerleklerini sağa veya sola eğmenize olanak sağlar. Mac Mouse Fix bunu daha kolay ve doğal olarak kontrol etmenizi sağlar. Fakat, şu anda bu butonlar ile diğer eylemleri aktifleştiremezsiniz.

            Tabii ki bunlar için de tam uyumluluk eklemeyi isterim ama bu çok büyük bir iş ve yakın bir zamanda gelmeyecektir.
            + Bazı fareler kaydırma tekerleklerini sağa veya sola eğmenize olanak sağlar. Mac Mouse Fix bunu daha kolay ve doğal olarak kontrol etmenizi sağlar. Fakat, şu anda bu butonlar ile diğer aksiyonları aktifleştiremezsiniz.

            Tabii ki bunlar için de tam uyumluluk eklemeyi isterim ama bu çok büyük bir iş ve yakın bir zamanda gelmeyecektir.

        ~ (12) 46: questions.license-sharing.body
        fileid:
            Readme
        en:
            Your license works on **all your Macs**. <br>
            The goal is that you can just buy a license, activate it, and never have to worry about it again. <br>
            If you log in with the same Apple Account, the license will even sync automatically to your other devices via iCloud!

            If you encounter problems activating your license, you can [send me an email]({url}). <br>
            I sometimes take a while to answer. I'm sorry about this. But I will get back to you!

            There is one restriction: <br>
            Licenses are not meant to be shared publicly. One license is meant for one person. Publicly shared licenses might be invalidated. (Sharing with your mom is ok.)
        tr:
            - Lisansınız **size ait bütün Mac'lerde** çalışır.<br>
            Buradaki amaç sizin sadece bir lisans satın aldıktan ve aktifleştirdikten sonra tekrar derdine düşmemenizdir.<br>
            Eğer diğer Mac'lerde aynı Apple hesabı ile giriş yaparsanız iCloud sayesinde lisansınız diğer cihazlara da aktarılacaktır!

            Eğer lisans aktivasyonunda problem yaşıyorsanız [bana bir E-Posta gönderin]({url}).<br>
            Bazen cevaplarım gecikebiliyor, bunun için üzgünüm; ama geri dönüş yapacağım!

            Ama bu konuda sadece bir engel bulunuyor:<br>
            Lisanslar herkesle paylaşmak için değil, bir lisans bir kişi için geçerlidir. Herkese açık olarak paylaşılmış lisanslar geçersiz kılınacaktır. (Buradaki herkes örneğin anneniz değil, onunla paylaşmanız tabii ki bir sorun değildir!)
            + Lisansınız **size ait bütün Mac'lerde** çalışır.<br>
            Buradaki amaç sizin sadece bir lisans satın aldıktan ve aktifleştirdikten sonra tekrar derdine düşmemenizdir.<br>
            Eğer diğer Mac'lerde aynı Apple hesabı ile giriş yaparsanız iCloud sayesinde lisansınız diğer cihazlara da aktarılacaktır!

            Eğer lisans aktivasyonunda problem yaşıyorsanız [bana bir E-Posta gönderin]({url}).<br>
            Bazen dönütlerim gecikebilir, bunun için üzgünüm; ama geri dönüş yapacağım!

            Ama bu konuda sadece bir engel bulunuyor:<br>
            Lisanslar herkesle paylaşmak için değil, bir lisans bir kişi için geçerlidir. Herkese açık olarak paylaşılmış lisanslar geçersiz kılınacaktır. (Anne-Babanız ile paylaşabilirsiniz.)

        ~ (13) bew-ni-FnZ.title
        fileid:
            Main
        en:
            Mac Mouse Fix stays enabled after you quit the app
        tr:
            - Mac Mouse Fix, uygulama kapatıldığında aktif kalacaktır
            + Mac Mouse Fix kapatıldığında aktif kalacaktır

        ~ (14) capture-toast.button-name.numbered
        fileid:
            Localizable
        en:
            Button %@
        tr:
            - %@. Fare Düğmesi
            + Fare Düğmesi %@'in

        ~ (15) capture-toast.buttons.uncaptured.body|==|one
        fileid:
            Localizable
        en:
            %2$@ is no longer captured by Mac Mouse Fix
        tr:
            - %2$@ düğmesinin Mac Mouse Fix tarafından yakalanması sona erdi
            + %2$@ Mac Mouse Fix tarafından yakalanması sona erdi

        ~ (16) license-toast.already-active
        fileid:
            Localizable
        en:
            Your app is **already licensed** with this key
        tr:
            - Uygulamanız **zaten** bu lisans ile **aktif**
            + Bu lisans **zaten aktif**!

        ~ (17) license-toast.no-internet
        fileid:
            Localizable
        en:
            There is a **problem with the internet connection**

            Make sure your computer is online and no firewalls are blocking Mac Mouse Fix from connecting to the internet.

            If this doesn't solve the problem, contact me [here](%@).
        tr:
            - **İnternet bağlantısı yok**

            Bilgisayarınızın çevrimiçi olduğuna ve herhangi bir güvenlik duvarının Mac Mouse Fix'in internete bağlanmasına engel olmadığından emin olun.

            Eğer bu sorununuzu çözmez ise, bana [buradan](%@) ulaşın.
            + **İnternet bağlantısı yok**

            Bilgisayarınızın internete bağlı olduğundan ve güvenlik duvarının Mac Mouse Fix'i engellemediğinden emin olun.

            Sorun çözülmezse benimle [buradan](%@) iletişime geçebilirsiniz.

        ~ (18) license-toast.unknown-key
        fileid:
            Localizable
        en:
            '**%@**' is not a valid license key

            Make sure you enter your Mac Mouse Fix key exactly as you received it.
        tr:
            - *'%@'** geçerli bir lisans anahtarı değildir

            Mac Mouse Fix anahtarınızı aldığınız gibi yazdığınızdan emin olun.
            + *'%@'** geçerli bir lisans anahtarı değildir

            Lütfen başka bir anahtarı deneyin veya elinizdeki anahtarı olduğu gibi yazın.

        ~ (19) N7H-9j-DIr.title
        fileid:
            Main
        en:
            Move the mouse pointer inside the '+' field, then *Click* a mouse button to assign an action to it.
            You can also *Double Click*, *Click and Drag* and more.
        tr:
            - Bir düğmeye eylem ataması yapmak için fare imlecinizi '+' alanına getirin ve bir düğmeye tıklayın.
            Dilerseniz *Çift Tıklama*, *Tıklama ve Kaydırma* ve daha fazlasını yapabilirsiniz.
            + Bir düğmeye aksiyon ataması yapmak için fare imlecinizi '+' alanına getirin ve bir düğmeye tıklayın.
            Dilerseniz *Çift Tıklama*, *Tıklama ve Kaydırma* ve daha fazlasını yapabilirsiniz.

        ~ (20) questions.blender.body
        fileid:
            Readme
        en:
            In 3D apps like Blender, you normally Click and Drag the Middle Mouse Button to orbit around objects.<br>
            But if you assign actions to the Middle Mouse Button in Mac Mouse Fix, then this won't work anymore.

            To solve this, I know of 2 options:
            1. Assign clicking and dragging one of the buttons of your mouse to the 'Scroll & Navigate' feature. This feature simulates swiping with 2 fingers on an Apple Trackpad. This will, among other things, let you orbit in 3D apps!
            2. *Uncapture* the Middle Mouse Button by deleting all actions assigned to it in Mac Mouse Fix. See [this guide]({url}) for more info.
        tr:
            - Blender gibi 3D uygulamalarında normalde orta düğme ile Tıkla ve Sürükle eylemiyle yörüngede hareket edebilirsiniz.<br>
            Fakat, Mac Mouse Fix üzerinde orta tuşa bir eylem ayarlarsanız bu çalışmayacaktır.

            Bunu çözmek için 2 yol billiyorum:
            1. Tıkla ve Sürükle komutunu farenizin herhangi bir düğmesine atayın. Bu özellik İzleme Dörtgeninde 2 parmakla kaydırma özelliğini simüle eder. Bu 3D uygulamalarda yörüngede dönme özelliğini sağlar.
            2. Orta düğmenin *yakalanmasını* tüm eylemleri Mac Mouse Fix üzerinden silerek kaldırın. [Buradan]({url}) daha fazla bilgi sahibi olun.
            + Blender gibi 3D uygulamalarında normalde orta düğme ile Tıkla ve Sürükle aksiyonuyla yörüngede hareket edebilirsiniz.<br>
            Fakat, Mac Mouse Fix üzerinde orta tuşa bir aksiyon ayarlarsanız bu çalışmayacaktır.

            Bunu çözmek için 2 yol billiyorum:
            1. Tıkla ve Sürükle komutunu farenizin herhangi bir düğmesine atayın. Bu özellik İzleme Dörtgeninde 2 parmakla kaydırma özelliğini simüle eder. Bu 3D uygulamalarda yörüngede dönme özelliğini sağlar.
            2. Orta düğmenin *yakalanmasını* tüm aksiyonları Mac Mouse Fix üzerinden silerek kaldırın. [Buradan]({url}) daha fazla bilgi sahibi olun.

        ~ (21) trigger.substring.drag.1
        fileid:
            Localizable
        en:
            Click and *Drag* %@
        tr:
            - %@ düğmesine tıkla ve *Sürükle*
            + %@ düğmesine tıkla ve sürükle

        ~ (22) trigger.substring.drag.2
        fileid:
            Localizable
        en:
            Double Click and *Drag* %@
        tr:
            - %@ düğmesine çift tıkla ve *Sürükle*
            + %@ düğmesine çift tıkla ve sürükle

        ~ (23) trigger.substring.drag.3
        fileid:
            Localizable
        en:
            Triple Click and *Drag* %@
        tr:
            - %@ düğmesine üç kez tıkla ve *Sürükle*
            + %@ düğmesine üç kez tıkla ve sürükle

        ~ (24) trigger.substring.drag.flags
        fileid:
            Localizable
        en:
            and *Drag*
        tr:
            - ve *Sürükle*
            + ve *sürükle*

        ~ (25) trigger.substring.scroll.1
        fileid:
            Localizable
        en:
            Click and *Scroll* %@
        tr:
            - %@ düğmesine tıkla ve *Kaydır*
            + %@ düğmesine tıkla ve kaydır

        ~ (26) trigger.substring.scroll.2
        fileid:
            Localizable
        en:
            Double Click and *Scroll* %@
        tr:
            - %@ düğmesine çift tıkla ve *Kaydır*
            + %@ düğmesine çift tıkla ve kaydır

        ~ (27) trigger.substring.scroll.3
        fileid:
            Localizable
        en:
            Triple Click and *Scroll* %@
        tr:
            - %@ düğmesine üç kez tıkla ve *Kaydır*
            + %@ düğmesine üç kez tıkla ve kaydır

        ~ (28) trigger.substring.scroll.flags
        fileid:
            Localizable
        en:
            and *Scroll*
        tr:
            - ve *Kaydır*
            + ve kaydır
