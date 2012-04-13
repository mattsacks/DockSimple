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
    undockElement: void 0,
    undockAt: 'bottom',
    dockedClass: 'docked',
    forcedClass: 'force-dock',
    dockCoordinate: void 0,
    dockOffset: 0,
    undockOffset: 0,
    replaceElement: false,
    active: true
  },
  initialize: function(element, options) {
    this.setOptions(options);
    this.element = $$(element)[0];
    this.undocker = this.options.undockElement != null ? $$(this.options.undockElement)[0] : void 0;
    this.elementY = this.options.dockCoordinate || this.element.getCoordinates().top - this.options.dockOffset;
    this.undockY = this.undocker != null ? this.undocker.getCoordinates()[this.options.undockAt] - this.options.undockOffset : void 0;
    this.active = this.options.active;
    if (this.options.replaceElement) {
      this.dummy = new Element('div', {
        id: 'DockSimple-dummy',
        styles: {
          height: this.element.getHeight(),
          display: 'none'
        }
      });
      this.element.grab(this.dummy, 'after');
    }
    this.scrollEvent = this.toDock.bind(this);
    if (!!this.active) window.addEvent('scroll', this.scrollEvent);
    return this;
  },
  toDock: function() {
    var scrollY;
    scrollY = window.getScrollTop();
    if (scrollY >= this.elementY && !this.docked) {
      if ((this.undockY != null) && scrollY <= this.undockY) {
        this.dockElement();
      } else if (!(this.undockY != null)) {
        this.dockElement();
      }
    } else if (this.docked) {
      if ((this.undockY != null) && scrollY >= this.undockY) {
        this.undockElement();
      } else if (scrollY <= this.elementY) {
        this.undockElement();
      }
    }
    return this.docked;
  },
  dockElement: function() {
    if (this.element.hasClass(this.options.forcedClass)) return;
    this.element.addClass(this.options.dockedClass);
    this.docked = true;
    if (this.options.replaceElement) this.dummy.setStyle('display', 'block');
    this.fireEvent('docked', this.element);
    return this;
  },
  undockElement: function() {
    if (this.element.hasClass(this.options.forcedClass)) return;
    this.element.removeClass(this.options.dockedClass);
    this.docked = false;
    if (this.options.replaceElement) this.dummy.setStyle('display', 'none');
    this.fireEvent('undocked', this.element);
    return this;
  },
  activate: function(attach) {
    if (!this.active) window.addEvent('scroll', this.scrollEvent);
    this.active = true;
    if (attach) return this.dockElement();
  },
  deactivate: function(detach) {
    if (this.active) window.removeEvent('scroll', this.scrollEvent);
    this.active = false;
    if (detach) return this.undockElement();
  }
});

if (!Function.throttle) {
  Function.implement({
    throttle: function(interval) {
      var timer,
        _this = this;
      timer = null;
      return function() {
        if (!timer) {
          timer = setTimeout(function() {
            return timer = null;
          }, interval);
          return _this.apply(_this);
        }
      };
    }
  });
}

if (!Function.debounce) {
  Function.implement({
    debounce: function(delay) {
      var timer,
        _this = this;
      timer = null;
      return function() {
        timer && clearTimeout(timer);
        return timer = setTimeout(function() {
          return _this.apply(_this);
        }, delay);
      };
    }
  });
}
