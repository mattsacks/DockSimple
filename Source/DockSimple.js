/*
---

name: DockSimple
script: DockSimple.js
description: A MooTools class for docking elements at a certain scroll threshold.

requires:
  - Core/Class.Extras 
  - Core/Element.Event
  - Core/Element.Dimensions  

provides: [DockSimple]

authors:
  - Matt Sacks

...
*/
var DockSimple;

DockSimple = new Class({
  Implements: [Options, Events],
  options: {
    undockElement: '',
    undockAt: 'top',
    dockedClass: 'docked',
    forcedClass: 'force-dock',
    dockCoordinate: void 0
  },
  initialize: function(element, options) {
    this.element = element;
    return this.setOptions(options);
  }
});
