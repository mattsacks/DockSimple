## DockSimple

A MooTools class to control the docking of items at certain `window.scroll` thresholds.

## How to use

```javascript
var dockOptions = {
  dockElement:   '#menu',
  undockAt:      '.feature:last-child'
}

var docker = new DockSimple(dockOptions);
```

This creates a new object `docker` which will fire the `docked` and `undocked`
events appropriately.


