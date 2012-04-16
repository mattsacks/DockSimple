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
    undockSide: 'top',
    dockedClass: 'docked',
    forcedClass: 'force-dock',
    dockCoordinate: void 0,
    dockOffset: 0,
    undockOffset: 0,
    replaceElement: false,
    dummyHide: false,
    multiReplace: false,
    active: true
  },
  initialize: function(element, options) {
    this.setOptions(options);
    this.element = element.findElementIndex();
    this.elementHeight = this.element.getHeight();
    this.undocker = this.options.undockElement != null ? this.attachUndocker(this.options.undockElement) : void 0;
    this.elementY = this.options.dockCoordinate || this.element.getCoordinates().top - this.options.dockOffset;
    this.active = this.options.active;
    if (this.options.replaceElement) {
      this.dummy = new Element('div', {
        id: 'DockSimple-dummy',
        styles: {
          height: this.elementHeight,
          display: 'none'
        }
      });
      this.element.grab(this.dummy, 'after');
    }
    this.scrollEvent = this.toDock.bind(this);
    if (!!this.active) window.addEvent('scroll', this.scrollEvent);
    return this;
  },
  attachUndocker: function(undocker) {
    if (undocker == null) return;
    this.undocker = undocker.findElementIndex();
    this.undockY = this.options.undockSide === 'bottom' && (this.undocker != null) ? this.undocker.getCoordinates()[this.options.undockAt] - (this.elementHeight + this.options.undockOffset) : this.undocker != null ? this.undocker.getCoordinates()[this.options.undockAt] - this.options.undockOffset : void 0;
    return this.undocker;
  },
  toDock: function() {
    var scrollY;
    scrollY = window.scrollY;
    if (scrollY >= this.elementY && !this.docked) {
      if ((this.undockY != null) && scrollY <= this.undockY) {
        this.dockElement();
      } else if (this.undockY == null) {
        this.dockElement();
      }
    } else if (this.docked) {
      if ((this.undockY != null) && scrollY >= this.undockY) {
        this.undockElement('end');
      } else if (scrollY <= this.elementY) {
        this.undockElement('start');
      }
    }
    return this.docked;
  },
  dockElement: function() {
    if (this.element.hasClass(this.options.forcedClass)) return;
    this.element.addClass(this.options.dockedClass);
    this.docked = true;
    if (this.options.replaceElement) this.dummy.setStyle('display', 'block');
    this.fireEvent('docked', [this.element, this.elementY]);
    return this;
  },
  undockElement: function(dir) {
    if (this.element.hasClass(this.options.forcedClass)) return;
    this.element.removeClass(this.options.dockedClass);
    this.docked = false;
    if (this.options.replaceElement) {
      if (this.options.dummyHide) {
        this.dummy.setStyle('display', 'none');
      } else if (!((this.options.dummyHide != null) && dir === 'end')) {
        this.dummy.setStyle('display', 'none');
      }
    }
    if (dir === 'start') {
      this.fireEvent('undocked', [this.element, this.elementY, dir]);
    } else if (dir === 'end') {
      this.fireEvent('undocked', [this.element, this.undockY, dir]);
    } else {
      this.fireEvent('undocked', this.element);
    }
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

DockSimple.extend({
  multiDock: function(selector, options) {
    var dockers, elements, i, undockSelector, x, _len;
    elements = $$(selector);
    if (elements.length > 0) {
      dockers = [];
      for (i = 0, _len = elements.length; i < _len; i++) {
        x = elements[i];
        if (i === 1 && !options.multiReplace && options.replaceElement) {
          options.replaceElement = false;
        } else if (options.multiReplace) {
          if (options.dummyHide == null) options.dummyHide = true;
          options.replaceElement = true;
        }
        undockSelector = selector + '[' + (i + 1) + ']';
        Object.merge(options, {
          undockElement: undockSelector
        });
        dockers.push(new DockSimple(selector + '[' + i + ']', options));
      }
    } else {
      dockers = new DockSimple(selector, options);
    }
    return dockers;
  }
});

String.implement({
  findElementIndex: function() {
    var index;
    index = this.match(/\[(\d+)\]$/);
    if (index && index[1]) {
      return $$('' + this.match(/(.*)\[\d+\]$/)[1])[index[1]];
    } else {
      return $$('' + this)[0];
    }
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
