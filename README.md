## DockSimple

A MooTools class to control the docking of items at a certain `window.scroll` threshold.

### How to use

```javascript
var dockOptions = {
  undockAt: '.feature:last-child'
}

var docker = new DockSimple('#menu', dockOptions);
```

This creates a new object `docker` which will dock the `#menu` element to the top of the screen and undock it once the user scrolls to the last `.feature` div element.

There are many different ways to use DockSimple for both singular and multiple
elements. Please explore the examples folder for some ideas and inspiration.

### Options

* `undockElement`: (_type: Element_) <br />
    The element in which DockSimple will undock it's `element` at
* `undockAt`: (_type: String, default: 'bottom'_) <br />
    Undocks at the 'top' or 'bottom' of it's `undockElement`
* `dockedClass`: (_type: String, default: 'docked'_) <br />
    The class applied to the `element` when docked
* `forcedClass`: (_type: String, default: 'force-dock'_) <br />
    No docking will occur on the `element` if it has this class applied to it.
* `dockCoordinate`: (_type: Number_) <br />
    If preferred, the `element` will dock when the `window.scroll` value
    meets this option.
* `dockOffset`: (_type: Number, default: 0_) <br />
    An amount to deduct from the `top` coordinate of the `element``
* `undockOffset`: (_type: Number, default: 0_) <br />
    An amount to deduct from the `undockAt` coordinate of the `undockElement`
* `replaceElement`: (_type: Boolean, default: false_) <br />
    A boolean to determine whether a dummy element with the same height as the
    given `element` should be replaced when applyed the `dockedClass`. This is
    really useful for preventing a 'jump' in the page when docking/undocking the
    `element`.
* `dummyHide`: (_type: Boolean, default: false_) <br />
    Determines whether or not to hide the replacement element when undocking the
    `element`. This will get switched to true automatically when using
    `replaceElement`.
* `multiReplace`: (_type: Boolean, default: false_) <br />
    Adds a dummy replacement element for each docked element when using
    `DockSimple.multiDock`.  Defaults to hiding the dummy when docking the next
    item to be docked. This isn't always necessary as `dummyHide` gets triggered
    appropriately for preventing the aforementioned 'jump' while scrolling.
* `active`: (_type: Boolean, default: true_) <br />
    A boolean of whether or not the newly initialized DockSimple object does
    anything. In order to activate later, call the `DockSimple.activate` method.
* `onDocked`: (_type: Function, returns: element [Element], elementY [Number]_) <br />
    Fires when docking the given `element`.
* `onUndocked`: (_type: Function, returns: element [Element], undockY [Number]_) <br />
    Fires when undocking the given `element`.

### Events

DockSimple fires two events, `docked` and `undocked`, both of which receive two
arguments. It's recommended to pass in whichever functions you want to fire on
those events as options `onDocked` and `onUndocked`. Please see above for which
arguments to expect in the given function.

### Instance Methods

The following can be invoked directly from the instantiated object returned from `new DockSimple()`:

* `attachUndocker`: (_args: undocker [String], returns: Element_) <br />
    Calculates the Y coordinate value in which to undock the `element`. Returns
    the element instance of the passed in selector.
* `toDock`: (_returns: Boolean_) <br />
    A function that calculates the docking or undocking of the `element`.
    Returns the `docked` state.
* `dockElement`: (_returns: this_) <br />
    Applies the `dockedClass` to the `element` and set the current `docked`
    state as `true`
* `undockElement`: (_args: dir [String], returns: this_) <br />
    Removes the `dockedClass` from the `element` and set the current
    `docked` state as false. `dir` should be a string `start` or `end` in
    coordination with the direction of scrolling down the page.
* `activate`: (_args: attach [Boolean], returns: this_) <br />
    Re-attaches the `scrollEvent` from the `window` if not already attached and
    sets the `active` state to true. Given a single argument `true`, will call
    `dockElement` for immediate docking.
* `deactivate`: (_args: detach [Boolean], returns: this_) <br />
    Detaches the `scrollEvent` from the `window` if already attached and sets
    the `active` state to false. Given a single argument `true`, will call
    `undockElement` for immediate undocking.

### Class Methods

Methods to be invoked directly on the `DockSimple` class without having to
create an instance of it:

* `multiDock`: (_args: selector [Element], options [Object]_) <br />
    Creates multiple instances of `DockSimple` for handling the docking
    of many elements on the page. Returns an array of the created instances of
    DockSimple.
    
    This **will** create as many `scroll` events as elements found, so be wary
    of doing heavy calculation in any `docked` or `undocked` event triggered.
    You may find it useful to use the provided `throttle` and `debounce` methods
    when using this.

    The passed in selector should not have an index provided in it's string.
    For example: use `.menu` and not `.menu[0]` as you would with maybe only one
    instance of DockSimple.

    Given the `replaceElement` option value of true but no `multiReplace`, this
    will not hide the dummy replacement until the first docked element is
    undocked from the top. That is - when scrolling down the page, the dummy
    will not be hidden to prevent a 'jump'. When scrolling up the page, the
    dummy will be hidden when the first found element in the passed in
    `selector` is undocked.

    If `multiReplace` is passed in as true, dummy elements will be hidden when
    their docked element is undocked.

### Provided

**String**

Added to the `String` type is `findElementIndex`, a easy way to pass a string
selector and index the found elements.

* `findElementIndex`: (_returns: Element, args: selector [String]_) <br />
    Given a selector string `.foo[2]`, this will find the second instance of an
    element with the `foo` class on the page. If nothing with the given index is
    found, returns `undefined`. If passed in a selector with no index provided,
    (example: `.foo.findElementIndex()`), returns the first instance of the
    element found.

    example: `var docker = new DockSimple('.menu[2]', {
      undockAt: '.menu[3]'
    });`

**Function**

Two added methods on the `Function` type, `throttle` and `debounce`, are
available for modifying amplitude of the `scrollEvent` if needed.

* `throttle`: (_returns: Function, args: interval [Number]_) <br />
    Provides a throttle method to limit the amount that a function is called
    repetitively. Useful for minifying the amount that the `scrollEvent` is
    called while scrolling the page.
* `debounce`: (_returns: Function, args: delay [Number]_) <br />
    Allows a function to prevent from being called until completed after a given
    delay. Great when a lot of math needs to happen on the current `scrollY` but
    not until after scrolling has finished.

