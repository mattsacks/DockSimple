## DockSimple

A MooTools class to control the docking of items at a certain `window.scroll` threshold.

### How to use

```javascript
var dockOptions = {
  undockAt:      '.feature:last-child'
}

var docker = new DockSimple('#menu', dockOptions);
```

This creates a new object `docker` which will dock the `#menu` element to the top of the screen and undock it once the user scrolls to the last `.feature` div element.

### Options

* `dockElement`: (_**required**_) (_type: Element_) <br />
    The element of which DockSimple is docking
* `undockElement`: (_type: Element_) <br />
    The element in which DockSimple will undock it's `dockElement` at
* `undockAt`: (_type: String, default: 'top'_) <br />
    Undocks at the 'top' or 'bottom' of it's `undockElement`
* `dockedClass`: (_type: String, default: 'docked'_) <br />
    The class applied to the `dockElement` when docked
* `forcedClass`: (_type: String, default: 'force-dock'_) <br />
    No docking will occur on the `dockElement` if it has this class applied to it.
* `dockCoordinate`: (_type: Number_) <br />
    If preferred, the `dockElement` will dock when the `window.scroll` value
    meets this option.


### Methods

The following can be invoked directly from the instantiated object returned from `new DockSimple()`:

* `docked`: (_type: Boolean_) <br />
    Whether the `dockedElement` is docked or not.
