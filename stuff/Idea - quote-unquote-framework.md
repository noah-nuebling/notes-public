
Simple vanilla js patterns 
with 50 lines of helper functions 
give you the same ergonomics as React 
with none of the downsides (almost 2000 dependencies!)

Started implementing this in repo:
    

In this Claude conversation you can see 
    TOC: 
        the core pattern
        plus ideas for pitches / promoting on GitHub
        Plus ideas for replacing tailwind
        Plus explanation of Zustand
        Plus conventions for publishing component libraries.
    [Nov 2025]

    https://claude.ai/share/46378e9c-1097-4875-b4f6-6ca55fc1eed2

Here's a copy-paste of the core pattern: (Slightly updated from the Claude conversatio [Nov 15 2025])


    //1. Templating (Simple → Interactive)

    ```javascript
    // Start simple - just returns HTML string
    function Card({ title, video }) {
    return `
        <div class="card">
        <h3>${title}</h3>
        <video src="${video}"></video>
        </div>
    `;
    }

    // Upgrade: Wrap in custom element + add behavior
    function Card({ title, video }) {
    let html = `
        <h3 class="title">${title}</h3>
        <video class="video" src="${video}"></video>
    `;
    
    html = wrapInCustomElement(html, {
        mounted() {
        const video = this.querySelector('.video');
        this.addEventListener('click', () => {
            video.play();
            gsap.to(this, { scale: 1.1 });
        });
        }
    });
    
    return html;
    }
    ```

    //2. Custom Element Helper

    ```javascript
    const instanceCallbacks = new Map();
    let instanceCounter = 0;

    function wrapInCustomElement(innerHtml, { mounted }) {
    const id = `inst-${instanceCounter++}`;
    instanceCallbacks.set(id, mounted);
    
    if (!xComponentIsInitialized) {
        class CustomElement extends HTMLElement {
            connectedCallback() {
                const id = this.dataset.instanceId;
                if (id && instanceCallbacks.has(id)) {
                    instanceCallbacks.get(id).call(this);
                    instanceCallbacks.delete(id);
                }
            }
        }
        customElements.define('x-component', CustomElement);
    }
    
    return `<x-component data-instance-id="${id}">${innerHtml}</x-component>`;
    }
    ```

    //3. Model-View Syncing

    ```javascript
    function observe(obj, prop, callback, triggerImmediately = true) {
    let value = obj[prop];
    
    Object.defineProperty(obj, prop, {
        get: () => value,
        set: (newVal) => {
        value = newVal;
        callback(newVal);
        }
    });
    if (triggerImmediately) callback(value);
    }

    function observeMultiple(objsAndProps, callback, triggerImmediately = true) {
    objsAndProps.forEach(x => observe(x[0], x[1], callback, false));
    if (triggerImmediately) callback();
    }

    // Usage
    const model = { firstName: '', lastName: '', fullName: '' };

    // Bind view <- model
    observeMultiple([[model, 'firstName'], [model, 'lastName']], () => {
        model.fullName = `${model.firstName} ${model.lastName}`;
        mfqs('.fullname-display').textContent = model.fullName;
    });

    // Bind model <- view
    mfqs('.firstname-input').addEventListener('input',  e => model.firstName = e.target.value);
    ```

    // 4. Styling Options

    Option A: Inline CSS (Ergonomic and close to tailwindCSS)

    ```javascript
    function Card({ title, color = 'blue' }) {
    return `
        <div class="card" style="background: ${color}; padding: 20px;">
        <h3>${title}</h3>
        </div>
    `;
    }
    ```

    Option B: @scope (Same code-locality as inline CSS but allows comments and styling of dynamically created child elements)

    ```javascript
    let html = `
        <style> @scope {
            h3  { background: gray; padding: 20px; }
            img { border: 5px solid black; }
        } </style>
        <h3>${title}</h3>
        <img src="photo.jpg">
    `
    ```

    Option C: Imperative styling. (Bit more verbose, but acceptable in reusable components I think. Allows comments. Allows complex conditional logic.)

    ```javascript
    wrapInCustomElement(html, {
    mounted() {
        this.style.backgroundColor = 'gray';
        this.style.padding = '20px';
        this.style.transition = 'transform 0.3s';
    }
    });
    ```

    //5. Query Helper

    ```javascript
    const mfqs = sel => document.querySelector(sel);
    const mfqsa = sel => document.querySelectorAll(sel);

    // Usage - Reference elements directly and manipulate them imperatively after creating the view-hierarchy declaratively. Similar to outlets in AppKit.
    mfqs('#username').addEventListener('input', e => model.username = e.target.value);
    mfqs('.fullname').textContent = model.fullName;
    ```

    Example

    ```javascript
    // index.js
    document.body.innerHTML = `
    <div class="page">
        <input class="firstname" placeholder="First Name" />
        <input class="lastname" placeholder="Last Name" />
        <div class="fullname"></div>
        ${Card({ title: 'Hello', video: 'vid.mp4' })}
    </div>
    `;

    // Model
    const model = { firstName: '', lastName: '', fullName: '' };

    // Bindings
    mfqs('.firstname').addEventListener('input', e => model.firstName = e.target.value);
    mfqs('.lastname').addEventListener('input', e => model.lastName = e.target.value);

    observeMultiple([[model, 'firstName'], [model, 'lastName']], () => {
        model.fullName = `${model.firstName} ${model.lastName}`;
        mfqs('.fullname').textContent = model.fullName;
    });
    ```

    Total "framework" code: ~30 lines
    * `wrapInCustomElement()` (~15 lines)
    * `observe()` + `observeMultiple()` (~15 lines)
    * `mfqs()` helper (~1 line)
    Everything else is native browser APIs!

    ---

    Thoughts and limitations:

    - `wrapInCustomElement()` could be easily extended to provide an `unmounted()` callback if needed (disconnectedCallback()) to clean up ram from a video or something like that.
    - Where should state live? I'd have state live outside the components inside a centralized 'model' (perhaps one per page or whatever makes sense) which is then synced with the view states via observation. You could also store state on components by capturing variables (or storing props on `this`) inside `wrapInCustomElement() { mounted() {.... }}` Might be useful for component-internal/transient stuff like hover or animation states.
    - This pattern doesn't have a solution for dynamic lists (when the number of child elements depends on the model). In Cocoa you'd use a special component – NSTableView/NSOutlineView. We could probably create simple mflist(item => return htmlElement(item)) that works like NSTableView. Initially it could just rerender the whole list every time, later we could optimize if needed (lazy loading, recycling of HTMLElements - but we’ll probably never need this). Or instead of mflist, we could also write simple inline code that regenerates the whole list‘s innerHTML whenever the model updates.
    - `observe()` doesn't support 'deep reactivity', that means you can't watch array insertions / removals. Could switch from Object.defineProperty to Proxy to get deep observation, or create a custom mflist component for dynamic lists when needed (see above). 
        - ... But honestly just observing children explicitly is probably better than 'deep observations'.
    - Conditional rendering can be done by simply observing the model and setting `display: none`.


Had another idea about Tailwind that's not in the Claude Chat [Nov 15 2025]
    - Tailwind actually isn't that bad. It doesn't add a "source-transforming" build-step. 
        It just runs a background process that:
        continually scans your source files for css-utility-class usage and then 
        updates a CSS file to define those utility classes.
        -> You still write vanilla HTML/CSS/js that can run in the browser immediately.
        -> You could easily use just Tailwind with the "Framework". It only has like 4 dependencies.