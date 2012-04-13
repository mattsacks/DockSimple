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

### Options

* `undockElement`: (_type: Element_) <br />
    The element in which DockSimple will undock it's `element` at
* `undockAt`: (_type: String, default: 'top'_) <br />
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
    given `element` should be replaced when applyed the `dockedClass`
* `active`: (_type: Boolean, default: true_) <br />
    A boolean of whether or not the newly initialized DockSimple object does
    anything. In order to activate later, call the `DockSimple.activate` method.


### Methods

The following can be invoked directly from the instantiated object returned from `new DockSimple()`:

* `toDock`: (_returns: Boolean_) <br />
    A function that calculates the docking or undocking of the `element`.
    Returns the `docked` state.
* `dockElement`: (_returns: this_) <br />
    Applies the `dockedClass` to the `element` and set the current `docked`
    state as `true`
* `undockElement`: (_returns: this_) <br />
    Removes the `dockedClass` from the `element` and set the current
    `docked` state as false
* `activate`: (_args: attach [Boolean], returns: this_) <br />
    Re-attaches the `scrollEvent` from the `window` if not already attached and
    sets the `active` state to true. Given a single argument `true`, will call
    `dockElement` for immediate docking.
* `deactivate`: (_args: detach [Boolean], returns: this_) <br />
    Detaches the `scrollEvent` from the `window` if already attached and sets
    the `active` state to false. Given a single argument `true`, will call
    `undockElement` for immediate undocking.

### Provided

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

