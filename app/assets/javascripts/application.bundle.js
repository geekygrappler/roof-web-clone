/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	
	var _interopRequire = function (obj) { return obj && obj.__esModule ? obj["default"] : obj; };
	
	var riot = _interopRequire(__webpack_require__(1));
	
	var api = _interopRequire(__webpack_require__(3));
	
	__webpack_require__(5);
	
	__webpack_require__(6);
	
	__webpack_require__(7);
	
	riot.route.base("/app/");
	var mount = function () {
	  riot.mount("r-app", { api: api });
	  riot.route.start(true);
	};
	api.sessions.one("check.fail", mount);
	api.sessions.one("check.success", mount);
	api.sessions.check();

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_RESULT__;/* Riot v2.3.17, @license MIT */
	
	;(function(window, undefined) {
	  'use strict';
	var riot = { version: 'v2.3.17', settings: {} },
	  // be aware, internal usage
	  // ATTENTION: prefix the global dynamic variables with `__`
	
	  // counter to give a unique id to all the Tag instances
	  __uid = 0,
	  // tags instances cache
	  __virtualDom = [],
	  // tags implementation cache
	  __tagImpl = {},
	
	  /**
	   * Const
	   */
	  GLOBAL_MIXIN = '__global_mixin',
	
	  // riot specific prefixes
	  RIOT_PREFIX = 'riot-',
	  RIOT_TAG = RIOT_PREFIX + 'tag',
	  RIOT_TAG_IS = 'data-is',
	
	  // for typeof == '' comparisons
	  T_STRING = 'string',
	  T_OBJECT = 'object',
	  T_UNDEF  = 'undefined',
	  T_BOOL   = 'boolean',
	  T_FUNCTION = 'function',
	  // special native tags that cannot be treated like the others
	  SPECIAL_TAGS_REGEX = /^(?:t(?:body|head|foot|[rhd])|caption|col(?:group)?|opt(?:ion|group))$/,
	  RESERVED_WORDS_BLACKLIST = ['_item', '_id', '_parent', 'update', 'root', 'mount', 'unmount', 'mixin', 'isMounted', 'isLoop', 'tags', 'parent', 'opts', 'trigger', 'on', 'off', 'one'],
	
	  // version# for IE 8-11, 0 for others
	  IE_VERSION = (window && window.document || {}).documentMode | 0
	/* istanbul ignore next */
	riot.observable = function(el) {
	
	  /**
	   * Extend the original object or create a new empty one
	   * @type { Object }
	   */
	
	  el = el || {}
	
	  /**
	   * Private variables and methods
	   */
	  var callbacks = {},
	    slice = Array.prototype.slice,
	    onEachEvent = function(e, fn) { e.replace(/\S+/g, fn) }
	
	  // extend the object adding the observable methods
	  Object.defineProperties(el, {
	    /**
	     * Listen to the given space separated list of `events` and execute the `callback` each time an event is triggered.
	     * @param  { String } events - events ids
	     * @param  { Function } fn - callback function
	     * @returns { Object } el
	     */
	    on: {
	      value: function(events, fn) {
	        if (typeof fn != 'function')  return el
	
	        onEachEvent(events, function(name, pos) {
	          (callbacks[name] = callbacks[name] || []).push(fn)
	          fn.typed = pos > 0
	        })
	
	        return el
	      },
	      enumerable: false,
	      writable: false,
	      configurable: false
	    },
	
	    /**
	     * Removes the given space separated list of `events` listeners
	     * @param   { String } events - events ids
	     * @param   { Function } fn - callback function
	     * @returns { Object } el
	     */
	    off: {
	      value: function(events, fn) {
	        if (events == '*' && !fn) callbacks = {}
	        else {
	          onEachEvent(events, function(name) {
	            if (fn) {
	              var arr = callbacks[name]
	              for (var i = 0, cb; cb = arr && arr[i]; ++i) {
	                if (cb == fn) arr.splice(i--, 1)
	              }
	            } else delete callbacks[name]
	          })
	        }
	        return el
	      },
	      enumerable: false,
	      writable: false,
	      configurable: false
	    },
	
	    /**
	     * Listen to the given space separated list of `events` and execute the `callback` at most once
	     * @param   { String } events - events ids
	     * @param   { Function } fn - callback function
	     * @returns { Object } el
	     */
	    one: {
	      value: function(events, fn) {
	        function on() {
	          el.off(events, on)
	          fn.apply(el, arguments)
	        }
	        return el.on(events, on)
	      },
	      enumerable: false,
	      writable: false,
	      configurable: false
	    },
	
	    /**
	     * Execute all callback functions that listen to the given space separated list of `events`
	     * @param   { String } events - events ids
	     * @returns { Object } el
	     */
	    trigger: {
	      value: function(events) {
	
	        // getting the arguments
	        var arglen = arguments.length - 1,
	          args = new Array(arglen),
	          fns
	
	        for (var i = 0; i < arglen; i++) {
	          args[i] = arguments[i + 1] // skip first argument
	        }
	
	        onEachEvent(events, function(name) {
	
	          fns = slice.call(callbacks[name] || [], 0)
	
	          for (var i = 0, fn; fn = fns[i]; ++i) {
	            if (fn.busy) return
	            fn.busy = 1
	            fn.apply(el, fn.typed ? [name].concat(args) : args)
	            if (fns[i] !== fn) { i-- }
	            fn.busy = 0
	          }
	
	          if (callbacks['*'] && name != '*')
	            el.trigger.apply(el, ['*', name].concat(args))
	
	        })
	
	        return el
	      },
	      enumerable: false,
	      writable: false,
	      configurable: false
	    }
	  })
	
	  return el
	
	}
	/* istanbul ignore next */
	;(function(riot) {
	
	/**
	 * Simple client-side router
	 * @module riot-route
	 */
	
	
	var RE_ORIGIN = /^.+?\/+[^\/]+/,
	  EVENT_LISTENER = 'EventListener',
	  REMOVE_EVENT_LISTENER = 'remove' + EVENT_LISTENER,
	  ADD_EVENT_LISTENER = 'add' + EVENT_LISTENER,
	  HAS_ATTRIBUTE = 'hasAttribute',
	  REPLACE = 'replace',
	  POPSTATE = 'popstate',
	  HASHCHANGE = 'hashchange',
	  TRIGGER = 'trigger',
	  MAX_EMIT_STACK_LEVEL = 3,
	  win = typeof window != 'undefined' && window,
	  doc = typeof document != 'undefined' && document,
	  hist = win && history,
	  loc = win && (hist.location || win.location), // see html5-history-api
	  prot = Router.prototype, // to minify more
	  clickEvent = doc && doc.ontouchstart ? 'touchstart' : 'click',
	  started = false,
	  central = riot.observable(),
	  routeFound = false,
	  debouncedEmit,
	  base, current, parser, secondParser, emitStack = [], emitStackLevel = 0
	
	/**
	 * Default parser. You can replace it via router.parser method.
	 * @param {string} path - current path (normalized)
	 * @returns {array} array
	 */
	function DEFAULT_PARSER(path) {
	  return path.split(/[/?#]/)
	}
	
	/**
	 * Default parser (second). You can replace it via router.parser method.
	 * @param {string} path - current path (normalized)
	 * @param {string} filter - filter string (normalized)
	 * @returns {array} array
	 */
	function DEFAULT_SECOND_PARSER(path, filter) {
	  var re = new RegExp('^' + filter[REPLACE](/\*/g, '([^/?#]+?)')[REPLACE](/\.\./, '.*') + '$'),
	    args = path.match(re)
	
	  if (args) return args.slice(1)
	}
	
	/**
	 * Simple/cheap debounce implementation
	 * @param   {function} fn - callback
	 * @param   {number} delay - delay in seconds
	 * @returns {function} debounced function
	 */
	function debounce(fn, delay) {
	  var t
	  return function () {
	    clearTimeout(t)
	    t = setTimeout(fn, delay)
	  }
	}
	
	/**
	 * Set the window listeners to trigger the routes
	 * @param {boolean} autoExec - see route.start
	 */
	function start(autoExec) {
	  debouncedEmit = debounce(emit, 1)
	  win[ADD_EVENT_LISTENER](POPSTATE, debouncedEmit)
	  win[ADD_EVENT_LISTENER](HASHCHANGE, debouncedEmit)
	  doc[ADD_EVENT_LISTENER](clickEvent, click)
	  if (autoExec) emit(true)
	}
	
	/**
	 * Router class
	 */
	function Router() {
	  this.$ = []
	  riot.observable(this) // make it observable
	  central.on('stop', this.s.bind(this))
	  central.on('emit', this.e.bind(this))
	}
	
	function normalize(path) {
	  return path[REPLACE](/^\/|\/$/, '')
	}
	
	function isString(str) {
	  return typeof str == 'string'
	}
	
	/**
	 * Get the part after domain name
	 * @param {string} href - fullpath
	 * @returns {string} path from root
	 */
	function getPathFromRoot(href) {
	  return (href || loc.href || '')[REPLACE](RE_ORIGIN, '')
	}
	
	/**
	 * Get the part after base
	 * @param {string} href - fullpath
	 * @returns {string} path from base
	 */
	function getPathFromBase(href) {
	  return base[0] == '#'
	    ? (href || loc.href || '').split(base)[1] || ''
	    : getPathFromRoot(href)[REPLACE](base, '')
	}
	
	function emit(force) {
	  // the stack is needed for redirections
	  var isRoot = emitStackLevel == 0
	  if (MAX_EMIT_STACK_LEVEL <= emitStackLevel) return
	
	  emitStackLevel++
	  emitStack.push(function() {
	    var path = getPathFromBase()
	    if (force || path != current) {
	      central[TRIGGER]('emit', path)
	      current = path
	    }
	  })
	  if (isRoot) {
	    while (emitStack.length) {
	      emitStack[0]()
	      emitStack.shift()
	    }
	    emitStackLevel = 0
	  }
	}
	
	function click(e) {
	  if (
	    e.which != 1 // not left click
	    || e.metaKey || e.ctrlKey || e.shiftKey // or meta keys
	    || e.defaultPrevented // or default prevented
	  ) return
	
	  var el = e.target
	  while (el && el.nodeName != 'A') el = el.parentNode
	  if (
	    !el || el.nodeName != 'A' // not A tag
	    || el[HAS_ATTRIBUTE]('download') // has download attr
	    || !el[HAS_ATTRIBUTE]('href') // has no href attr
	    || el.target && el.target != '_self' // another window or frame
	    || el.href.indexOf(loc.href.match(RE_ORIGIN)[0]) == -1 // cross origin
	  ) return
	
	  if (el.href != loc.href) {
	    if (
	      el.href.split('#')[0] == loc.href.split('#')[0] // internal jump
	      || base != '#' && getPathFromRoot(el.href).indexOf(base) !== 0 // outside of base
	      || !go(getPathFromBase(el.href), el.title || doc.title) // route not found
	    ) return
	  }
	
	  e.preventDefault()
	}
	
	/**
	 * Go to the path
	 * @param {string} path - destination path
	 * @param {string} title - page title
	 * @param {boolean} shouldReplace - use replaceState or pushState
	 * @returns {boolean} - route not found flag
	 */
	function go(path, title, shouldReplace) {
	  if (hist) { // if a browser
	    path = base + normalize(path)
	    title = title || doc.title
	    // browsers ignores the second parameter `title`
	    shouldReplace
	      ? hist.replaceState(null, title, path)
	      : hist.pushState(null, title, path)
	    // so we need to set it manually
	    doc.title = title
	    routeFound = false
	    emit()
	    return routeFound
	  }
	
	  // Server-side usage: directly execute handlers for the path
	  return central[TRIGGER]('emit', getPathFromBase(path))
	}
	
	/**
	 * Go to path or set action
	 * a single string:                go there
	 * two strings:                    go there with setting a title
	 * two strings and boolean:        replace history with setting a title
	 * a single function:              set an action on the default route
	 * a string/RegExp and a function: set an action on the route
	 * @param {(string|function)} first - path / action / filter
	 * @param {(string|RegExp|function)} second - title / action
	 * @param {boolean} third - replace flag
	 */
	prot.m = function(first, second, third) {
	  if (isString(first) && (!second || isString(second))) go(first, second, third || false)
	  else if (second) this.r(first, second)
	  else this.r('@', first)
	}
	
	/**
	 * Stop routing
	 */
	prot.s = function() {
	  this.off('*')
	  this.$ = []
	}
	
	/**
	 * Emit
	 * @param {string} path - path
	 */
	prot.e = function(path) {
	  this.$.concat('@').some(function(filter) {
	    var args = (filter == '@' ? parser : secondParser)(normalize(path), normalize(filter))
	    if (typeof args != 'undefined') {
	      this[TRIGGER].apply(null, [filter].concat(args))
	      return routeFound = true // exit from loop
	    }
	  }, this)
	}
	
	/**
	 * Register route
	 * @param {string} filter - filter for matching to url
	 * @param {function} action - action to register
	 */
	prot.r = function(filter, action) {
	  if (filter != '@') {
	    filter = '/' + normalize(filter)
	    this.$.push(filter)
	  }
	  this.on(filter, action)
	}
	
	var mainRouter = new Router()
	var route = mainRouter.m.bind(mainRouter)
	
	/**
	 * Create a sub router
	 * @returns {function} the method of a new Router object
	 */
	route.create = function() {
	  var newSubRouter = new Router()
	  // stop only this sub-router
	  newSubRouter.m.stop = newSubRouter.s.bind(newSubRouter)
	  // return sub-router's main method
	  return newSubRouter.m.bind(newSubRouter)
	}
	
	/**
	 * Set the base of url
	 * @param {(str|RegExp)} arg - a new base or '#' or '#!'
	 */
	route.base = function(arg) {
	  base = arg || '#'
	  current = getPathFromBase() // recalculate current path
	}
	
	/** Exec routing right now **/
	route.exec = function() {
	  emit(true)
	}
	
	/**
	 * Replace the default router to yours
	 * @param {function} fn - your parser function
	 * @param {function} fn2 - your secondParser function
	 */
	route.parser = function(fn, fn2) {
	  if (!fn && !fn2) {
	    // reset parser for testing...
	    parser = DEFAULT_PARSER
	    secondParser = DEFAULT_SECOND_PARSER
	  }
	  if (fn) parser = fn
	  if (fn2) secondParser = fn2
	}
	
	/**
	 * Helper function to get url query as an object
	 * @returns {object} parsed query
	 */
	route.query = function() {
	  var q = {}
	  var href = loc.href || current
	  href[REPLACE](/[?&](.+?)=([^&]*)/g, function(_, k, v) { q[k] = v })
	  return q
	}
	
	/** Stop routing **/
	route.stop = function () {
	  if (started) {
	    if (win) {
	      win[REMOVE_EVENT_LISTENER](POPSTATE, debouncedEmit)
	      win[REMOVE_EVENT_LISTENER](HASHCHANGE, debouncedEmit)
	      doc[REMOVE_EVENT_LISTENER](clickEvent, click)
	    }
	    central[TRIGGER]('stop')
	    started = false
	  }
	}
	
	/**
	 * Start routing
	 * @param {boolean} autoExec - automatically exec after starting if true
	 */
	route.start = function (autoExec) {
	  if (!started) {
	    if (win) {
	      if (document.readyState == 'complete') start(autoExec)
	      // the timeout is needed to solve
	      // a weird safari bug https://github.com/riot/route/issues/33
	      else win[ADD_EVENT_LISTENER]('load', function() {
	        setTimeout(function() { start(autoExec) }, 1)
	      })
	    }
	    started = true
	  }
	}
	
	/** Prepare the router **/
	route.base()
	route.parser()
	
	riot.route = route
	})(riot)
	/* istanbul ignore next */
	
	/**
	 * The riot template engine
	 * @version v2.3.21
	 */
	
	/**
	 * riot.util.brackets
	 *
	 * - `brackets    ` - Returns a string or regex based on its parameter
	 * - `brackets.set` - Change the current riot brackets
	 *
	 * @module
	 */
	
	var brackets = (function (UNDEF) {
	
	  var
	    REGLOB = 'g',
	
	    R_MLCOMMS = /\/\*[^*]*\*+(?:[^*\/][^*]*\*+)*\//g,
	
	    R_STRINGS = /"[^"\\]*(?:\\[\S\s][^"\\]*)*"|'[^'\\]*(?:\\[\S\s][^'\\]*)*'/g,
	
	    S_QBLOCKS = R_STRINGS.source + '|' +
	      /(?:\breturn\s+|(?:[$\w\)\]]|\+\+|--)\s*(\/)(?![*\/]))/.source + '|' +
	      /\/(?=[^*\/])[^[\/\\]*(?:(?:\[(?:\\.|[^\]\\]*)*\]|\\.)[^[\/\\]*)*?(\/)[gim]*/.source,
	
	    FINDBRACES = {
	      '(': RegExp('([()])|'   + S_QBLOCKS, REGLOB),
	      '[': RegExp('([[\\]])|' + S_QBLOCKS, REGLOB),
	      '{': RegExp('([{}])|'   + S_QBLOCKS, REGLOB)
	    },
	
	    DEFAULT = '{ }'
	
	  var _pairs = [
	    '{', '}',
	    '{', '}',
	    /{[^}]*}/,
	    /\\([{}])/g,
	    /\\({)|{/g,
	    RegExp('\\\\(})|([[({])|(})|' + S_QBLOCKS, REGLOB),
	    DEFAULT,
	    /^\s*{\^?\s*([$\w]+)(?:\s*,\s*(\S+))?\s+in\s+(\S.*)\s*}/,
	    /(^|[^\\]){=[\S\s]*?}/
	  ]
	
	  var
	    cachedBrackets = UNDEF,
	    _regex,
	    _cache = [],
	    _settings
	
	  function _loopback (re) { return re }
	
	  function _rewrite (re, bp) {
	    if (!bp) bp = _cache
	    return new RegExp(
	      re.source.replace(/{/g, bp[2]).replace(/}/g, bp[3]), re.global ? REGLOB : ''
	    )
	  }
	
	  function _create (pair) {
	    if (pair === DEFAULT) return _pairs
	
	    var arr = pair.split(' ')
	
	    if (arr.length !== 2 || /[\x00-\x1F<>a-zA-Z0-9'",;\\]/.test(pair)) {
	      throw new Error('Unsupported brackets "' + pair + '"')
	    }
	    arr = arr.concat(pair.replace(/(?=[[\]()*+?.^$|])/g, '\\').split(' '))
	
	    arr[4] = _rewrite(arr[1].length > 1 ? /{[\S\s]*?}/ : _pairs[4], arr)
	    arr[5] = _rewrite(pair.length > 3 ? /\\({|})/g : _pairs[5], arr)
	    arr[6] = _rewrite(_pairs[6], arr)
	    arr[7] = RegExp('\\\\(' + arr[3] + ')|([[({])|(' + arr[3] + ')|' + S_QBLOCKS, REGLOB)
	    arr[8] = pair
	    return arr
	  }
	
	  function _brackets (reOrIdx) {
	    return reOrIdx instanceof RegExp ? _regex(reOrIdx) : _cache[reOrIdx]
	  }
	
	  _brackets.split = function split (str, tmpl, _bp) {
	    // istanbul ignore next: _bp is for the compiler
	    if (!_bp) _bp = _cache
	
	    var
	      parts = [],
	      match,
	      isexpr,
	      start,
	      pos,
	      re = _bp[6]
	
	    isexpr = start = re.lastIndex = 0
	
	    while (match = re.exec(str)) {
	
	      pos = match.index
	
	      if (isexpr) {
	
	        if (match[2]) {
	          re.lastIndex = skipBraces(str, match[2], re.lastIndex)
	          continue
	        }
	        if (!match[3])
	          continue
	      }
	
	      if (!match[1]) {
	        unescapeStr(str.slice(start, pos))
	        start = re.lastIndex
	        re = _bp[6 + (isexpr ^= 1)]
	        re.lastIndex = start
	      }
	    }
	
	    if (str && start < str.length) {
	      unescapeStr(str.slice(start))
	    }
	
	    return parts
	
	    function unescapeStr (s) {
	      if (tmpl || isexpr)
	        parts.push(s && s.replace(_bp[5], '$1'))
	      else
	        parts.push(s)
	    }
	
	    function skipBraces (s, ch, ix) {
	      var
	        match,
	        recch = FINDBRACES[ch]
	
	      recch.lastIndex = ix
	      ix = 1
	      while (match = recch.exec(s)) {
	        if (match[1] &&
	          !(match[1] === ch ? ++ix : --ix)) break
	      }
	      return ix ? s.length : recch.lastIndex
	    }
	  }
	
	  _brackets.hasExpr = function hasExpr (str) {
	    return _cache[4].test(str)
	  }
	
	  _brackets.loopKeys = function loopKeys (expr) {
	    var m = expr.match(_cache[9])
	    return m
	      ? { key: m[1], pos: m[2], val: _cache[0] + m[3].trim() + _cache[1] }
	      : { val: expr.trim() }
	  }
	
	  _brackets.hasRaw = function (src) {
	    return _cache[10].test(src)
	  }
	
	  _brackets.array = function array (pair) {
	    return pair ? _create(pair) : _cache
	  }
	
	  function _reset (pair) {
	    if ((pair || (pair = DEFAULT)) !== _cache[8]) {
	      _cache = _create(pair)
	      _regex = pair === DEFAULT ? _loopback : _rewrite
	      _cache[9] = _regex(_pairs[9])
	      _cache[10] = _regex(_pairs[10])
	    }
	    cachedBrackets = pair
	  }
	
	  function _setSettings (o) {
	    var b
	    o = o || {}
	    b = o.brackets
	    Object.defineProperty(o, 'brackets', {
	      set: _reset,
	      get: function () { return cachedBrackets },
	      enumerable: true
	    })
	    _settings = o
	    _reset(b)
	  }
	
	  Object.defineProperty(_brackets, 'settings', {
	    set: _setSettings,
	    get: function () { return _settings }
	  })
	
	  /* istanbul ignore next: in the browser riot is always in the scope */
	  _brackets.settings = typeof riot !== 'undefined' && riot.settings || {}
	  _brackets.set = _reset
	
	  _brackets.R_STRINGS = R_STRINGS
	  _brackets.R_MLCOMMS = R_MLCOMMS
	  _brackets.S_QBLOCKS = S_QBLOCKS
	
	  return _brackets
	
	})()
	
	/**
	 * @module tmpl
	 *
	 * tmpl          - Root function, returns the template value, render with data
	 * tmpl.hasExpr  - Test the existence of a expression inside a string
	 * tmpl.loopKeys - Get the keys for an 'each' loop (used by `_each`)
	 */
	
	var tmpl = (function () {
	
	  var _cache = {}
	
	  function _tmpl (str, data) {
	    if (!str) return str
	
	    return (_cache[str] || (_cache[str] = _create(str))).call(data, _logErr)
	  }
	
	  _tmpl.haveRaw = brackets.hasRaw
	
	  _tmpl.hasExpr = brackets.hasExpr
	
	  _tmpl.loopKeys = brackets.loopKeys
	
	  _tmpl.errorHandler = null
	
	  function _logErr (err, ctx) {
	
	    if (_tmpl.errorHandler) {
	
	      err.riotData = {
	        tagName: ctx && ctx.root && ctx.root.tagName,
	        _riot_id: ctx && ctx._riot_id  //eslint-disable-line camelcase
	      }
	      _tmpl.errorHandler(err)
	    }
	  }
	
	  function _create (str) {
	
	    var expr = _getTmpl(str)
	    if (expr.slice(0, 11) !== 'try{return ') expr = 'return ' + expr
	
	    return new Function('E', expr + ';')
	  }
	
	  var
	    RE_QBLOCK = RegExp(brackets.S_QBLOCKS, 'g'),
	    RE_QBMARK = /\x01(\d+)~/g
	
	  function _getTmpl (str) {
	    var
	      qstr = [],
	      expr,
	      parts = brackets.split(str.replace(/\u2057/g, '"'), 1)
	
	    if (parts.length > 2 || parts[0]) {
	      var i, j, list = []
	
	      for (i = j = 0; i < parts.length; ++i) {
	
	        expr = parts[i]
	
	        if (expr && (expr = i & 1 ?
	
	              _parseExpr(expr, 1, qstr) :
	
	              '"' + expr
	                .replace(/\\/g, '\\\\')
	                .replace(/\r\n?|\n/g, '\\n')
	                .replace(/"/g, '\\"') +
	              '"'
	
	          )) list[j++] = expr
	
	      }
	
	      expr = j < 2 ? list[0] :
	             '[' + list.join(',') + '].join("")'
	
	    } else {
	
	      expr = _parseExpr(parts[1], 0, qstr)
	    }
	
	    if (qstr[0])
	      expr = expr.replace(RE_QBMARK, function (_, pos) {
	        return qstr[pos]
	          .replace(/\r/g, '\\r')
	          .replace(/\n/g, '\\n')
	      })
	
	    return expr
	  }
	
	  var
	    RE_BREND = {
	      '(': /[()]/g,
	      '[': /[[\]]/g,
	      '{': /[{}]/g
	    },
	    CS_IDENT = /^(?:(-?[_A-Za-z\xA0-\xFF][-\w\xA0-\xFF]*)|\x01(\d+)~):/
	
	  function _parseExpr (expr, asText, qstr) {
	
	    if (expr[0] === '=') expr = expr.slice(1)
	
	    expr = expr
	          .replace(RE_QBLOCK, function (s, div) {
	            return s.length > 2 && !div ? '\x01' + (qstr.push(s) - 1) + '~' : s
	          })
	          .replace(/\s+/g, ' ').trim()
	          .replace(/\ ?([[\({},?\.:])\ ?/g, '$1')
	
	    if (expr) {
	      var
	        list = [],
	        cnt = 0,
	        match
	
	      while (expr &&
	            (match = expr.match(CS_IDENT)) &&
	            !match.index
	        ) {
	        var
	          key,
	          jsb,
	          re = /,|([[{(])|$/g
	
	        expr = RegExp.rightContext
	        key  = match[2] ? qstr[match[2]].slice(1, -1).trim().replace(/\s+/g, ' ') : match[1]
	
	        while (jsb = (match = re.exec(expr))[1]) skipBraces(jsb, re)
	
	        jsb  = expr.slice(0, match.index)
	        expr = RegExp.rightContext
	
	        list[cnt++] = _wrapExpr(jsb, 1, key)
	      }
	
	      expr = !cnt ? _wrapExpr(expr, asText) :
	          cnt > 1 ? '[' + list.join(',') + '].join(" ").trim()' : list[0]
	    }
	    return expr
	
	    function skipBraces (ch, re) {
	      var
	        mm,
	        lv = 1,
	        ir = RE_BREND[ch]
	
	      ir.lastIndex = re.lastIndex
	      while (mm = ir.exec(expr)) {
	        if (mm[0] === ch) ++lv
	        else if (!--lv) break
	      }
	      re.lastIndex = lv ? expr.length : ir.lastIndex
	    }
	  }
	
	  // istanbul ignore next: not both
	  var
	    JS_CONTEXT = '"in this?this:' + (typeof window !== 'object' ? 'global' : 'window') + ').',
	    JS_VARNAME = /[,{][$\w]+:|(^ *|[^$\w\.])(?!(?:typeof|true|false|null|undefined|in|instanceof|is(?:Finite|NaN)|void|NaN|new|Date|RegExp|Math)(?![$\w]))([$_A-Za-z][$\w]*)/g,
	    JS_NOPROPS = /^(?=(\.[$\w]+))\1(?:[^.[(]|$)/
	
	  function _wrapExpr (expr, asText, key) {
	    var tb
	
	    expr = expr.replace(JS_VARNAME, function (match, p, mvar, pos, s) {
	      if (mvar) {
	        pos = tb ? 0 : pos + match.length
	
	        if (mvar !== 'this' && mvar !== 'global' && mvar !== 'window') {
	          match = p + '("' + mvar + JS_CONTEXT + mvar
	          if (pos) tb = (s = s[pos]) === '.' || s === '(' || s === '['
	        } else if (pos) {
	          tb = !JS_NOPROPS.test(s.slice(pos))
	        }
	      }
	      return match
	    })
	
	    if (tb) {
	      expr = 'try{return ' + expr + '}catch(e){E(e,this)}'
	    }
	
	    if (key) {
	
	      expr = (tb ?
	          'function(){' + expr + '}.call(this)' : '(' + expr + ')'
	        ) + '?"' + key + '":""'
	
	    } else if (asText) {
	
	      expr = 'function(v){' + (tb ?
	          expr.replace('return ', 'v=') : 'v=(' + expr + ')'
	        ) + ';return v||v===0?v:""}.call(this)'
	    }
	
	    return expr
	  }
	
	  // istanbul ignore next: compatibility fix for beta versions
	  _tmpl.parse = function (s) { return s }
	
	  _tmpl.version = brackets.version = 'v2.3.21'
	
	  return _tmpl
	
	})()
	
	/*
	  lib/browser/tag/mkdom.js
	
	  Includes hacks needed for the Internet Explorer version 9 and below
	  See: http://kangax.github.io/compat-table/es5/#ie8
	       http://codeplanet.io/dropping-ie8/
	*/
	var mkdom = (function _mkdom() {
	  var
	    reHasYield  = /<yield\b/i,
	    reYieldAll  = /<yield\s*(?:\/>|>([\S\s]*?)<\/yield\s*>)/ig,
	    reYieldSrc  = /<yield\s+to=['"]([^'">]*)['"]\s*>([\S\s]*?)<\/yield\s*>/ig,
	    reYieldDest = /<yield\s+from=['"]?([-\w]+)['"]?\s*(?:\/>|>([\S\s]*?)<\/yield\s*>)/ig
	  var
	    rootEls = { tr: 'tbody', th: 'tr', td: 'tr', col: 'colgroup' },
	    tblTags = IE_VERSION && IE_VERSION < 10
	      ? SPECIAL_TAGS_REGEX : /^(?:t(?:body|head|foot|[rhd])|caption|col(?:group)?)$/
	
	  /**
	   * Creates a DOM element to wrap the given content. Normally an `DIV`, but can be
	   * also a `TABLE`, `SELECT`, `TBODY`, `TR`, or `COLGROUP` element.
	   *
	   * @param   {string} templ  - The template coming from the custom tag definition
	   * @param   {string} [html] - HTML content that comes from the DOM element where you
	   *           will mount the tag, mostly the original tag in the page
	   * @returns {HTMLElement} DOM element with _templ_ merged through `YIELD` with the _html_.
	   */
	  function _mkdom(templ, html) {
	    var
	      match   = templ && templ.match(/^\s*<([-\w]+)/),
	      tagName = match && match[1].toLowerCase(),
	      el = mkEl('div')
	
	    // replace all the yield tags with the tag inner html
	    templ = replaceYield(templ, html)
	
	    /* istanbul ignore next */
	    if (tblTags.test(tagName))
	      el = specialTags(el, templ, tagName)
	    else
	      el.innerHTML = templ
	
	    el.stub = true
	
	    return el
	  }
	
	  /*
	    Creates the root element for table or select child elements:
	    tr/th/td/thead/tfoot/tbody/caption/col/colgroup/option/optgroup
	  */
	  function specialTags(el, templ, tagName) {
	    var
	      select = tagName[0] === 'o',
	      parent = select ? 'select>' : 'table>'
	
	    // trim() is important here, this ensures we don't have artifacts,
	    // so we can check if we have only one element inside the parent
	    el.innerHTML = '<' + parent + templ.trim() + '</' + parent
	    parent = el.firstChild
	
	    // returns the immediate parent if tr/th/td/col is the only element, if not
	    // returns the whole tree, as this can include additional elements
	    if (select) {
	      parent.selectedIndex = -1  // for IE9, compatible w/current riot behavior
	    } else {
	      // avoids insertion of cointainer inside container (ex: tbody inside tbody)
	      var tname = rootEls[tagName]
	      if (tname && parent.childElementCount === 1) parent = $(tname, parent)
	    }
	    return parent
	  }
	
	  /*
	    Replace the yield tag from any tag template with the innerHTML of the
	    original tag in the page
	  */
	  function replaceYield(templ, html) {
	    // do nothing if no yield
	    if (!reHasYield.test(templ)) return templ
	
	    // be careful with #1343 - string on the source having `$1`
	    var src = {}
	
	    html = html && html.replace(reYieldSrc, function (_, ref, text) {
	      src[ref] = src[ref] || text   // preserve first definition
	      return ''
	    }).trim()
	
	    return templ
	      .replace(reYieldDest, function (_, ref, def) {  // yield with from - to attrs
	        return src[ref] || def || ''
	      })
	      .replace(reYieldAll, function (_, def) {        // yield without any "from"
	        return html || def || ''
	      })
	  }
	
	  return _mkdom
	
	})()
	
	/**
	 * Convert the item looped into an object used to extend the child tag properties
	 * @param   { Object } expr - object containing the keys used to extend the children tags
	 * @param   { * } key - value to assign to the new object returned
	 * @param   { * } val - value containing the position of the item in the array
	 * @returns { Object } - new object containing the values of the original item
	 *
	 * The variables 'key' and 'val' are arbitrary.
	 * They depend on the collection type looped (Array, Object)
	 * and on the expression used on the each tag
	 *
	 */
	function mkitem(expr, key, val) {
	  var item = {}
	  item[expr.key] = key
	  if (expr.pos) item[expr.pos] = val
	  return item
	}
	
	/**
	 * Unmount the redundant tags
	 * @param   { Array } items - array containing the current items to loop
	 * @param   { Array } tags - array containing all the children tags
	 */
	function unmountRedundant(items, tags) {
	
	  var i = tags.length,
	    j = items.length,
	    t
	
	  while (i > j) {
	    t = tags[--i]
	    tags.splice(i, 1)
	    t.unmount()
	  }
	}
	
	/**
	 * Move the nested custom tags in non custom loop tags
	 * @param   { Object } child - non custom loop tag
	 * @param   { Number } i - current position of the loop tag
	 */
	function moveNestedTags(child, i) {
	  Object.keys(child.tags).forEach(function(tagName) {
	    var tag = child.tags[tagName]
	    if (isArray(tag))
	      each(tag, function (t) {
	        moveChildTag(t, tagName, i)
	      })
	    else
	      moveChildTag(tag, tagName, i)
	  })
	}
	
	/**
	 * Adds the elements for a virtual tag
	 * @param { Tag } tag - the tag whose root's children will be inserted or appended
	 * @param { Node } src - the node that will do the inserting or appending
	 * @param { Tag } target - only if inserting, insert before this tag's first child
	 */
	function addVirtual(tag, src, target) {
	  var el = tag._root, sib
	  tag._virts = []
	  while (el) {
	    sib = el.nextSibling
	    if (target)
	      src.insertBefore(el, target._root)
	    else
	      src.appendChild(el)
	
	    tag._virts.push(el) // hold for unmounting
	    el = sib
	  }
	}
	
	/**
	 * Move virtual tag and all child nodes
	 * @param { Tag } tag - first child reference used to start move
	 * @param { Node } src  - the node that will do the inserting
	 * @param { Tag } target - insert before this tag's first child
	 * @param { Number } len - how many child nodes to move
	 */
	function moveVirtual(tag, src, target, len) {
	  var el = tag._root, sib, i = 0
	  for (; i < len; i++) {
	    sib = el.nextSibling
	    src.insertBefore(el, target._root)
	    el = sib
	  }
	}
	
	
	/**
	 * Manage tags having the 'each'
	 * @param   { Object } dom - DOM node we need to loop
	 * @param   { Tag } parent - parent tag instance where the dom node is contained
	 * @param   { String } expr - string contained in the 'each' attribute
	 */
	function _each(dom, parent, expr) {
	
	  // remove the each property from the original tag
	  remAttr(dom, 'each')
	
	  var mustReorder = typeof getAttr(dom, 'no-reorder') !== T_STRING || remAttr(dom, 'no-reorder'),
	    tagName = getTagName(dom),
	    impl = __tagImpl[tagName] || { tmpl: dom.outerHTML },
	    useRoot = SPECIAL_TAGS_REGEX.test(tagName),
	    root = dom.parentNode,
	    ref = document.createTextNode(''),
	    child = getTag(dom),
	    isOption = tagName.toLowerCase() === 'option', // the option tags must be treated differently
	    tags = [],
	    oldItems = [],
	    hasKeys,
	    isVirtual = dom.tagName == 'VIRTUAL'
	
	  // parse the each expression
	  expr = tmpl.loopKeys(expr)
	
	  // insert a marked where the loop tags will be injected
	  root.insertBefore(ref, dom)
	
	  // clean template code
	  parent.one('before-mount', function () {
	
	    // remove the original DOM node
	    dom.parentNode.removeChild(dom)
	    if (root.stub) root = parent.root
	
	  }).on('update', function () {
	    // get the new items collection
	    var items = tmpl(expr.val, parent),
	      // create a fragment to hold the new DOM nodes to inject in the parent tag
	      frag = document.createDocumentFragment()
	
	    // object loop. any changes cause full redraw
	    if (!isArray(items)) {
	      hasKeys = items || false
	      items = hasKeys ?
	        Object.keys(items).map(function (key) {
	          return mkitem(expr, key, items[key])
	        }) : []
	    }
	
	    // loop all the new items
	    var i = 0,
	      itemsLength = items.length
	
	    for (; i < itemsLength; i++) {
	      // reorder only if the items are objects
	      var
	        item = items[i],
	        _mustReorder = mustReorder && item instanceof Object && !hasKeys,
	        oldPos = oldItems.indexOf(item),
	        pos = ~oldPos && _mustReorder ? oldPos : i,
	        // does a tag exist in this position?
	        tag = tags[pos]
	
	      item = !hasKeys && expr.key ? mkitem(expr, item, i) : item
	
	      // new tag
	      if (
	        !_mustReorder && !tag // with no-reorder we just update the old tags
	        ||
	        _mustReorder && !~oldPos || !tag // by default we always try to reorder the DOM elements
	      ) {
	
	        tag = new Tag(impl, {
	          parent: parent,
	          isLoop: true,
	          hasImpl: !!__tagImpl[tagName],
	          root: useRoot ? root : dom.cloneNode(),
	          item: item
	        }, dom.innerHTML)
	
	        tag.mount()
	
	        if (isVirtual) tag._root = tag.root.firstChild // save reference for further moves or inserts
	        // this tag must be appended
	        if (i == tags.length || !tags[i]) { // fix 1581
	          if (isVirtual)
	            addVirtual(tag, frag)
	          else frag.appendChild(tag.root)
	        }
	        // this tag must be insert
	        else {
	          if (isVirtual)
	            addVirtual(tag, root, tags[i])
	          else root.insertBefore(tag.root, tags[i].root) // #1374 some browsers reset selected here
	          oldItems.splice(i, 0, item)
	        }
	
	        tags.splice(i, 0, tag)
	        pos = i // handled here so no move
	      } else tag.update(item, true)
	
	      // reorder the tag if it's not located in its previous position
	      if (
	        pos !== i && _mustReorder &&
	        tags[i] // fix 1581 unable to reproduce it in a test!
	      ) {
	        // update the DOM
	        if (isVirtual)
	          moveVirtual(tag, root, tags[i], dom.childNodes.length)
	        else root.insertBefore(tag.root, tags[i].root)
	        // update the position attribute if it exists
	        if (expr.pos)
	          tag[expr.pos] = i
	        // move the old tag instance
	        tags.splice(i, 0, tags.splice(pos, 1)[0])
	        // move the old item
	        oldItems.splice(i, 0, oldItems.splice(pos, 1)[0])
	        // if the loop tags are not custom
	        // we need to move all their custom tags into the right position
	        if (!child && tag.tags) moveNestedTags(tag, i)
	      }
	
	      // cache the original item to use it in the events bound to this node
	      // and its children
	      tag._item = item
	      // cache the real parent tag internally
	      defineProperty(tag, '_parent', parent)
	    }
	
	    // remove the redundant tags
	    unmountRedundant(items, tags)
	
	    // insert the new nodes
	    if (isOption) {
	      root.appendChild(frag)
	
	      // #1374 <select> <option selected={true}> </select>
	      if (root.length) {
	        var si, op = root.options
	
	        root.selectedIndex = si = -1
	        for (i = 0; i < op.length; i++) {
	          if (op[i].selected = op[i].__selected) {
	            if (si < 0) root.selectedIndex = si = i
	          }
	        }
	      }
	    }
	    else root.insertBefore(frag, ref)
	
	    // set the 'tags' property of the parent tag
	    // if child is 'undefined' it means that we don't need to set this property
	    // for example:
	    // we don't need store the `myTag.tags['div']` property if we are looping a div tag
	    // but we need to track the `myTag.tags['child']` property looping a custom child node named `child`
	    if (child) parent.tags[tagName] = tags
	
	    // clone the items array
	    oldItems = items.slice()
	
	  })
	
	}
	/**
	 * Object that will be used to inject and manage the css of every tag instance
	 */
	var styleManager = (function(_riot) {
	
	  if (!window) return { // skip injection on the server
	    add: function () {},
	    inject: function () {}
	  }
	
	  var styleNode = (function () {
	    // create a new style element with the correct type
	    var newNode = mkEl('style')
	    setAttr(newNode, 'type', 'text/css')
	
	    // replace any user node or insert the new one into the head
	    var userNode = $('style[type=riot]')
	    if (userNode) {
	      if (userNode.id) newNode.id = userNode.id
	      userNode.parentNode.replaceChild(newNode, userNode)
	    }
	    else document.getElementsByTagName('head')[0].appendChild(newNode)
	
	    return newNode
	  })()
	
	  // Create cache and shortcut to the correct property
	  var cssTextProp = styleNode.styleSheet,
	    stylesToInject = ''
	
	  // Expose the style node in a non-modificable property
	  Object.defineProperty(_riot, 'styleNode', {
	    value: styleNode,
	    writable: true
	  })
	
	  /**
	   * Public api
	   */
	  return {
	    /**
	     * Save a tag style to be later injected into DOM
	     * @param   { String } css [description]
	     */
	    add: function(css) {
	      stylesToInject += css
	    },
	    /**
	     * Inject all previously saved tag styles into DOM
	     * innerHTML seems slow: http://jsperf.com/riot-insert-style
	     */
	    inject: function() {
	      if (stylesToInject) {
	        if (cssTextProp) cssTextProp.cssText += stylesToInject
	        else styleNode.innerHTML += stylesToInject
	        stylesToInject = ''
	      }
	    }
	  }
	
	})(riot)
	
	
	function parseNamedElements(root, tag, childTags, forceParsingNamed) {
	
	  walk(root, function(dom) {
	    if (dom.nodeType == 1) {
	      dom.isLoop = dom.isLoop ||
	                  (dom.parentNode && dom.parentNode.isLoop || getAttr(dom, 'each'))
	                    ? 1 : 0
	
	      // custom child tag
	      if (childTags) {
	        var child = getTag(dom)
	
	        if (child && !dom.isLoop)
	          childTags.push(initChildTag(child, {root: dom, parent: tag}, dom.innerHTML, tag))
	      }
	
	      if (!dom.isLoop || forceParsingNamed)
	        setNamed(dom, tag, [])
	    }
	
	  })
	
	}
	
	function parseExpressions(root, tag, expressions) {
	
	  function addExpr(dom, val, extra) {
	    if (tmpl.hasExpr(val)) {
	      expressions.push(extend({ dom: dom, expr: val }, extra))
	    }
	  }
	
	  walk(root, function(dom) {
	    var type = dom.nodeType,
	      attr
	
	    // text node
	    if (type == 3 && dom.parentNode.tagName != 'STYLE') addExpr(dom, dom.nodeValue)
	    if (type != 1) return
	
	    /* element */
	
	    // loop
	    attr = getAttr(dom, 'each')
	
	    if (attr) { _each(dom, tag, attr); return false }
	
	    // attribute expressions
	    each(dom.attributes, function(attr) {
	      var name = attr.name,
	        bool = name.split('__')[1]
	
	      addExpr(dom, attr.value, { attr: bool || name, bool: bool })
	      if (bool) { remAttr(dom, name); return false }
	
	    })
	
	    // skip custom tags
	    if (getTag(dom)) return false
	
	  })
	
	}
	function Tag(impl, conf, innerHTML) {
	
	  var self = riot.observable(this),
	    opts = inherit(conf.opts) || {},
	    parent = conf.parent,
	    isLoop = conf.isLoop,
	    hasImpl = conf.hasImpl,
	    item = cleanUpData(conf.item),
	    expressions = [],
	    childTags = [],
	    root = conf.root,
	    tagName = root.tagName.toLowerCase(),
	    attr = {},
	    implAttr = {},
	    propsInSyncWithParent = [],
	    dom
	
	  // only call unmount if we have a valid __tagImpl (has name property)
	  if (impl.name && root._tag) root._tag.unmount(true)
	
	  // not yet mounted
	  this.isMounted = false
	  root.isLoop = isLoop
	
	  // keep a reference to the tag just created
	  // so we will be able to mount this tag multiple times
	  root._tag = this
	
	  // create a unique id to this tag
	  // it could be handy to use it also to improve the virtual dom rendering speed
	  defineProperty(this, '_riot_id', ++__uid) // base 1 allows test !t._riot_id
	
	  extend(this, { parent: parent, root: root, opts: opts, tags: {} }, item)
	
	  // grab attributes
	  each(root.attributes, function(el) {
	    var val = el.value
	    // remember attributes with expressions only
	    if (tmpl.hasExpr(val)) attr[el.name] = val
	  })
	
	  dom = mkdom(impl.tmpl, innerHTML)
	
	  // options
	  function updateOpts() {
	    var ctx = hasImpl && isLoop ? self : parent || self
	
	    // update opts from current DOM attributes
	    each(root.attributes, function(el) {
	      var val = el.value
	      opts[toCamel(el.name)] = tmpl.hasExpr(val) ? tmpl(val, ctx) : val
	    })
	    // recover those with expressions
	    each(Object.keys(attr), function(name) {
	      opts[toCamel(name)] = tmpl(attr[name], ctx)
	    })
	  }
	
	  function normalizeData(data) {
	    for (var key in item) {
	      if (typeof self[key] !== T_UNDEF && isWritable(self, key))
	        self[key] = data[key]
	    }
	  }
	
	  function inheritFromParent () {
	    if (!self.parent || !isLoop) return
	    each(Object.keys(self.parent), function(k) {
	      // some properties must be always in sync with the parent tag
	      var mustSync = !contains(RESERVED_WORDS_BLACKLIST, k) && contains(propsInSyncWithParent, k)
	      if (typeof self[k] === T_UNDEF || mustSync) {
	        // track the property to keep in sync
	        // so we can keep it updated
	        if (!mustSync) propsInSyncWithParent.push(k)
	        self[k] = self.parent[k]
	      }
	    })
	  }
	
	  /**
	   * Update the tag expressions and options
	   * @param   { * }  data - data we want to use to extend the tag properties
	   * @param   { Boolean } isInherited - is this update coming from a parent tag?
	   * @returns { self }
	   */
	  defineProperty(this, 'update', function(data, isInherited) {
	
	    // make sure the data passed will not override
	    // the component core methods
	    data = cleanUpData(data)
	    // inherit properties from the parent
	    inheritFromParent()
	    // normalize the tag properties in case an item object was initially passed
	    if (data && isObject(item)) {
	      normalizeData(data)
	      item = data
	    }
	    extend(self, data)
	    updateOpts()
	    self.trigger('update', data)
	    update(expressions, self)
	
	    // the updated event will be triggered
	    // once the DOM will be ready and all the re-flows are completed
	    // this is useful if you want to get the "real" root properties
	    // 4 ex: root.offsetWidth ...
	    if (isInherited && self.parent)
	      // closes #1599
	      self.parent.one('updated', function() { self.trigger('updated') })
	    else rAF(function() { self.trigger('updated') })
	
	    return this
	  })
	
	  defineProperty(this, 'mixin', function() {
	    each(arguments, function(mix) {
	      var instance
	
	      mix = typeof mix === T_STRING ? riot.mixin(mix) : mix
	
	      // check if the mixin is a function
	      if (isFunction(mix)) {
	        // create the new mixin instance
	        instance = new mix()
	        // save the prototype to loop it afterwards
	        mix = mix.prototype
	      } else instance = mix
	
	      // loop the keys in the function prototype or the all object keys
	      each(Object.getOwnPropertyNames(mix), function(key) {
	        // bind methods to self
	        if (key != 'init')
	          self[key] = isFunction(instance[key]) ?
	                        instance[key].bind(self) :
	                        instance[key]
	      })
	
	      // init method will be called automatically
	      if (instance.init) instance.init.bind(self)()
	    })
	    return this
	  })
	
	  defineProperty(this, 'mount', function() {
	
	    updateOpts()
	
	    // add global mixin
	    var globalMixin = riot.mixin(GLOBAL_MIXIN)
	    if (globalMixin) self.mixin(globalMixin)
	
	    // initialiation
	    if (impl.fn) impl.fn.call(self, opts)
	
	    // parse layout after init. fn may calculate args for nested custom tags
	    parseExpressions(dom, self, expressions)
	
	    // mount the child tags
	    toggle(true)
	
	    // update the root adding custom attributes coming from the compiler
	    // it fixes also #1087
	    if (impl.attrs)
	      walkAttributes(impl.attrs, function (k, v) { setAttr(root, k, v) })
	    if (impl.attrs || hasImpl)
	      parseExpressions(self.root, self, expressions)
	
	    if (!self.parent || isLoop) self.update(item)
	
	    // internal use only, fixes #403
	    self.trigger('before-mount')
	
	    if (isLoop && !hasImpl) {
	      // update the root attribute for the looped elements
	      root = dom.firstChild
	    } else {
	      while (dom.firstChild) root.appendChild(dom.firstChild)
	      if (root.stub) root = parent.root
	    }
	
	    defineProperty(self, 'root', root)
	
	    // parse the named dom nodes in the looped child
	    // adding them to the parent as well
	    if (isLoop)
	      parseNamedElements(self.root, self.parent, null, true)
	
	    // if it's not a child tag we can trigger its mount event
	    if (!self.parent || self.parent.isMounted) {
	      self.isMounted = true
	      self.trigger('mount')
	    }
	    // otherwise we need to wait that the parent event gets triggered
	    else self.parent.one('mount', function() {
	      // avoid to trigger the `mount` event for the tags
	      // not visible included in an if statement
	      if (!isInStub(self.root)) {
	        self.parent.isMounted = self.isMounted = true
	        self.trigger('mount')
	      }
	    })
	  })
	
	
	  defineProperty(this, 'unmount', function(keepRootTag) {
	    var el = root,
	      p = el.parentNode,
	      ptag,
	      tagIndex = __virtualDom.indexOf(self)
	
	    self.trigger('before-unmount')
	
	    // remove this tag instance from the global virtualDom variable
	    if (~tagIndex)
	      __virtualDom.splice(tagIndex, 1)
	
	    if (this._virts) {
	      each(this._virts, function(v) {
	        if (v.parentNode) v.parentNode.removeChild(v)
	      })
	    }
	
	    if (p) {
	
	      if (parent) {
	        ptag = getImmediateCustomParentTag(parent)
	        // remove this tag from the parent tags object
	        // if there are multiple nested tags with same name..
	        // remove this element form the array
	        if (isArray(ptag.tags[tagName]))
	          each(ptag.tags[tagName], function(tag, i) {
	            if (tag._riot_id == self._riot_id)
	              ptag.tags[tagName].splice(i, 1)
	          })
	        else
	          // otherwise just delete the tag instance
	          ptag.tags[tagName] = undefined
	      }
	
	      else
	        while (el.firstChild) el.removeChild(el.firstChild)
	
	      if (!keepRootTag)
	        p.removeChild(el)
	      else
	        // the riot-tag attribute isn't needed anymore, remove it
	        remAttr(p, 'riot-tag')
	    }
	
	
	    self.trigger('unmount')
	    toggle()
	    self.off('*')
	    self.isMounted = false
	    delete root._tag
	
	  })
	
	  // proxy function to bind updates
	  // dispatched from a parent tag
	  function onChildUpdate(data) { self.update(data, true) }
	
	  function toggle(isMount) {
	
	    // mount/unmount children
	    each(childTags, function(child) { child[isMount ? 'mount' : 'unmount']() })
	
	    // listen/unlisten parent (events flow one way from parent to children)
	    if (!parent) return
	    var evt = isMount ? 'on' : 'off'
	
	    // the loop tags will be always in sync with the parent automatically
	    if (isLoop)
	      parent[evt]('unmount', self.unmount)
	    else {
	      parent[evt]('update', onChildUpdate)[evt]('unmount', self.unmount)
	    }
	  }
	
	
	  // named elements available for fn
	  parseNamedElements(dom, this, childTags)
	
	}
	/**
	 * Attach an event to a DOM node
	 * @param { String } name - event name
	 * @param { Function } handler - event callback
	 * @param { Object } dom - dom node
	 * @param { Tag } tag - tag instance
	 */
	function setEventHandler(name, handler, dom, tag) {
	
	  dom[name] = function(e) {
	
	    var ptag = tag._parent,
	      item = tag._item,
	      el
	
	    if (!item)
	      while (ptag && !item) {
	        item = ptag._item
	        ptag = ptag._parent
	      }
	
	    // cross browser event fix
	    e = e || window.event
	
	    // override the event properties
	    if (isWritable(e, 'currentTarget')) e.currentTarget = dom
	    if (isWritable(e, 'target')) e.target = e.srcElement
	    if (isWritable(e, 'which')) e.which = e.charCode || e.keyCode
	
	    e.item = item
	
	    // prevent default behaviour (by default)
	    if (handler.call(tag, e) !== true && !/radio|check/.test(dom.type)) {
	      if (e.preventDefault) e.preventDefault()
	      e.returnValue = false
	    }
	
	    if (!e.preventUpdate) {
	      el = item ? getImmediateCustomParentTag(ptag) : tag
	      el.update()
	    }
	
	  }
	
	}
	
	
	/**
	 * Insert a DOM node replacing another one (used by if- attribute)
	 * @param   { Object } root - parent node
	 * @param   { Object } node - node replaced
	 * @param   { Object } before - node added
	 */
	function insertTo(root, node, before) {
	  if (!root) return
	  root.insertBefore(before, node)
	  root.removeChild(node)
	}
	
	/**
	 * Update the expressions in a Tag instance
	 * @param   { Array } expressions - expression that must be re evaluated
	 * @param   { Tag } tag - tag instance
	 */
	function update(expressions, tag) {
	
	  each(expressions, function(expr, i) {
	
	    var dom = expr.dom,
	      attrName = expr.attr,
	      value = tmpl(expr.expr, tag),
	      parent = expr.dom.parentNode
	
	    if (expr.bool) {
	      value = !!value
	      if (attrName === 'selected') dom.__selected = value   // #1374
	    }
	    else if (value == null)
	      value = ''
	
	    // #1638: regression of #1612, update the dom only if the value of the
	    // expression was changed
	    if (expr.value === value) {
	      return
	    }
	    expr.value = value
	
	    // textarea and text nodes has no attribute name
	    if (!attrName) {
	      // about #815 w/o replace: the browser converts the value to a string,
	      // the comparison by "==" does too, but not in the server
	      value += ''
	      // test for parent avoids error with invalid assignment to nodeValue
	      if (parent) {
	        if (parent.tagName === 'TEXTAREA') {
	          parent.value = value                    // #1113
	          if (!IE_VERSION) dom.nodeValue = value  // #1625 IE throws here, nodeValue
	        }                                         // will be available on 'updated'
	        else dom.nodeValue = value
	      }
	      return
	    }
	
	    // ~~#1612: look for changes in dom.value when updating the value~~
	    if (attrName === 'value') {
	      dom.value = value
	      return
	    }
	
	    // remove original attribute
	    remAttr(dom, attrName)
	
	    // event handler
	    if (isFunction(value)) {
	      setEventHandler(attrName, value, dom, tag)
	
	    // if- conditional
	    } else if (attrName == 'if') {
	      var stub = expr.stub,
	        add = function() { insertTo(stub.parentNode, stub, dom) },
	        remove = function() { insertTo(dom.parentNode, dom, stub) }
	
	      // add to DOM
	      if (value) {
	        if (stub) {
	          add()
	          dom.inStub = false
	          // avoid to trigger the mount event if the tags is not visible yet
	          // maybe we can optimize this avoiding to mount the tag at all
	          if (!isInStub(dom)) {
	            walk(dom, function(el) {
	              if (el._tag && !el._tag.isMounted)
	                el._tag.isMounted = !!el._tag.trigger('mount')
	            })
	          }
	        }
	      // remove from DOM
	      } else {
	        stub = expr.stub = stub || document.createTextNode('')
	        // if the parentNode is defined we can easily replace the tag
	        if (dom.parentNode)
	          remove()
	        // otherwise we need to wait the updated event
	        else (tag.parent || tag).one('updated', remove)
	
	        dom.inStub = true
	      }
	    // show / hide
	    } else if (attrName === 'show') {
	      dom.style.display = value ? '' : 'none'
	
	    } else if (attrName === 'hide') {
	      dom.style.display = value ? 'none' : ''
	
	    } else if (expr.bool) {
	      dom[attrName] = value
	      if (value) setAttr(dom, attrName, attrName)
	
	    } else if (value === 0 || value && typeof value !== T_OBJECT) {
	      // <img src="{ expr }">
	      if (startsWith(attrName, RIOT_PREFIX) && attrName != RIOT_TAG) {
	        attrName = attrName.slice(RIOT_PREFIX.length)
	      }
	      setAttr(dom, attrName, value)
	    }
	
	  })
	
	}
	/**
	 * Specialized function for looping an array-like collection with `each={}`
	 * @param   { Array } els - collection of items
	 * @param   {Function} fn - callback function
	 * @returns { Array } the array looped
	 */
	function each(els, fn) {
	  var len = els ? els.length : 0
	
	  for (var i = 0, el; i < len; i++) {
	    el = els[i]
	    // return false -> current item was removed by fn during the loop
	    if (el != null && fn(el, i) === false) i--
	  }
	  return els
	}
	
	/**
	 * Detect if the argument passed is a function
	 * @param   { * } v - whatever you want to pass to this function
	 * @returns { Boolean } -
	 */
	function isFunction(v) {
	  return typeof v === T_FUNCTION || false   // avoid IE problems
	}
	
	/**
	 * Detect if the argument passed is an object, exclude null.
	 * NOTE: Use isObject(x) && !isArray(x) to excludes arrays.
	 * @param   { * } v - whatever you want to pass to this function
	 * @returns { Boolean } -
	 */
	function isObject(v) {
	  return v && typeof v === T_OBJECT         // typeof null is 'object'
	}
	
	/**
	 * Remove any DOM attribute from a node
	 * @param   { Object } dom - DOM node we want to update
	 * @param   { String } name - name of the property we want to remove
	 */
	function remAttr(dom, name) {
	  dom.removeAttribute(name)
	}
	
	/**
	 * Convert a string containing dashes to camel case
	 * @param   { String } string - input string
	 * @returns { String } my-string -> myString
	 */
	function toCamel(string) {
	  return string.replace(/-(\w)/g, function(_, c) {
	    return c.toUpperCase()
	  })
	}
	
	/**
	 * Get the value of any DOM attribute on a node
	 * @param   { Object } dom - DOM node we want to parse
	 * @param   { String } name - name of the attribute we want to get
	 * @returns { String | undefined } name of the node attribute whether it exists
	 */
	function getAttr(dom, name) {
	  return dom.getAttribute(name)
	}
	
	/**
	 * Set any DOM attribute
	 * @param { Object } dom - DOM node we want to update
	 * @param { String } name - name of the property we want to set
	 * @param { String } val - value of the property we want to set
	 */
	function setAttr(dom, name, val) {
	  dom.setAttribute(name, val)
	}
	
	/**
	 * Detect the tag implementation by a DOM node
	 * @param   { Object } dom - DOM node we need to parse to get its tag implementation
	 * @returns { Object } it returns an object containing the implementation of a custom tag (template and boot function)
	 */
	function getTag(dom) {
	  return dom.tagName && __tagImpl[getAttr(dom, RIOT_TAG_IS) ||
	    getAttr(dom, RIOT_TAG) || dom.tagName.toLowerCase()]
	}
	/**
	 * Add a child tag to its parent into the `tags` object
	 * @param   { Object } tag - child tag instance
	 * @param   { String } tagName - key where the new tag will be stored
	 * @param   { Object } parent - tag instance where the new child tag will be included
	 */
	function addChildTag(tag, tagName, parent) {
	  var cachedTag = parent.tags[tagName]
	
	  // if there are multiple children tags having the same name
	  if (cachedTag) {
	    // if the parent tags property is not yet an array
	    // create it adding the first cached tag
	    if (!isArray(cachedTag))
	      // don't add the same tag twice
	      if (cachedTag !== tag)
	        parent.tags[tagName] = [cachedTag]
	    // add the new nested tag to the array
	    if (!contains(parent.tags[tagName], tag))
	      parent.tags[tagName].push(tag)
	  } else {
	    parent.tags[tagName] = tag
	  }
	}
	
	/**
	 * Move the position of a custom tag in its parent tag
	 * @param   { Object } tag - child tag instance
	 * @param   { String } tagName - key where the tag was stored
	 * @param   { Number } newPos - index where the new tag will be stored
	 */
	function moveChildTag(tag, tagName, newPos) {
	  var parent = tag.parent,
	    tags
	  // no parent no move
	  if (!parent) return
	
	  tags = parent.tags[tagName]
	
	  if (isArray(tags))
	    tags.splice(newPos, 0, tags.splice(tags.indexOf(tag), 1)[0])
	  else addChildTag(tag, tagName, parent)
	}
	
	/**
	 * Create a new child tag including it correctly into its parent
	 * @param   { Object } child - child tag implementation
	 * @param   { Object } opts - tag options containing the DOM node where the tag will be mounted
	 * @param   { String } innerHTML - inner html of the child node
	 * @param   { Object } parent - instance of the parent tag including the child custom tag
	 * @returns { Object } instance of the new child tag just created
	 */
	function initChildTag(child, opts, innerHTML, parent) {
	  var tag = new Tag(child, opts, innerHTML),
	    tagName = getTagName(opts.root),
	    ptag = getImmediateCustomParentTag(parent)
	  // fix for the parent attribute in the looped elements
	  tag.parent = ptag
	  // store the real parent tag
	  // in some cases this could be different from the custom parent tag
	  // for example in nested loops
	  tag._parent = parent
	
	  // add this tag to the custom parent tag
	  addChildTag(tag, tagName, ptag)
	  // and also to the real parent tag
	  if (ptag !== parent)
	    addChildTag(tag, tagName, parent)
	  // empty the child node once we got its template
	  // to avoid that its children get compiled multiple times
	  opts.root.innerHTML = ''
	
	  return tag
	}
	
	/**
	 * Loop backward all the parents tree to detect the first custom parent tag
	 * @param   { Object } tag - a Tag instance
	 * @returns { Object } the instance of the first custom parent tag found
	 */
	function getImmediateCustomParentTag(tag) {
	  var ptag = tag
	  while (!getTag(ptag.root)) {
	    if (!ptag.parent) break
	    ptag = ptag.parent
	  }
	  return ptag
	}
	
	/**
	 * Helper function to set an immutable property
	 * @param   { Object } el - object where the new property will be set
	 * @param   { String } key - object key where the new property will be stored
	 * @param   { * } value - value of the new property
	* @param   { Object } options - set the propery overriding the default options
	 * @returns { Object } - the initial object
	 */
	function defineProperty(el, key, value, options) {
	  Object.defineProperty(el, key, extend({
	    value: value,
	    enumerable: false,
	    writable: false,
	    configurable: false
	  }, options))
	  return el
	}
	
	/**
	 * Get the tag name of any DOM node
	 * @param   { Object } dom - DOM node we want to parse
	 * @returns { String } name to identify this dom node in riot
	 */
	function getTagName(dom) {
	  var child = getTag(dom),
	    namedTag = getAttr(dom, 'name'),
	    tagName = namedTag && !tmpl.hasExpr(namedTag) ?
	                namedTag :
	              child ? child.name : dom.tagName.toLowerCase()
	
	  return tagName
	}
	
	/**
	 * Extend any object with other properties
	 * @param   { Object } src - source object
	 * @returns { Object } the resulting extended object
	 *
	 * var obj = { foo: 'baz' }
	 * extend(obj, {bar: 'bar', foo: 'bar'})
	 * console.log(obj) => {bar: 'bar', foo: 'bar'}
	 *
	 */
	function extend(src) {
	  var obj, args = arguments
	  for (var i = 1; i < args.length; ++i) {
	    if (obj = args[i]) {
	      for (var key in obj) {
	        // check if this property of the source object could be overridden
	        if (isWritable(src, key))
	          src[key] = obj[key]
	      }
	    }
	  }
	  return src
	}
	
	/**
	 * Check whether an array contains an item
	 * @param   { Array } arr - target array
	 * @param   { * } item - item to test
	 * @returns { Boolean } Does 'arr' contain 'item'?
	 */
	function contains(arr, item) {
	  return ~arr.indexOf(item)
	}
	
	/**
	 * Check whether an object is a kind of array
	 * @param   { * } a - anything
	 * @returns {Boolean} is 'a' an array?
	 */
	function isArray(a) { return Array.isArray(a) || a instanceof Array }
	
	/**
	 * Detect whether a property of an object could be overridden
	 * @param   { Object }  obj - source object
	 * @param   { String }  key - object property
	 * @returns { Boolean } is this property writable?
	 */
	function isWritable(obj, key) {
	  var props = Object.getOwnPropertyDescriptor(obj, key)
	  return typeof obj[key] === T_UNDEF || props && props.writable
	}
	
	
	/**
	 * With this function we avoid that the internal Tag methods get overridden
	 * @param   { Object } data - options we want to use to extend the tag instance
	 * @returns { Object } clean object without containing the riot internal reserved words
	 */
	function cleanUpData(data) {
	  if (!(data instanceof Tag) && !(data && typeof data.trigger == T_FUNCTION))
	    return data
	
	  var o = {}
	  for (var key in data) {
	    if (!contains(RESERVED_WORDS_BLACKLIST, key))
	      o[key] = data[key]
	  }
	  return o
	}
	
	/**
	 * Walk down recursively all the children tags starting dom node
	 * @param   { Object }   dom - starting node where we will start the recursion
	 * @param   { Function } fn - callback to transform the child node just found
	 */
	function walk(dom, fn) {
	  if (dom) {
	    // stop the recursion
	    if (fn(dom) === false) return
	    else {
	      dom = dom.firstChild
	
	      while (dom) {
	        walk(dom, fn)
	        dom = dom.nextSibling
	      }
	    }
	  }
	}
	
	/**
	 * Minimize risk: only zero or one _space_ between attr & value
	 * @param   { String }   html - html string we want to parse
	 * @param   { Function } fn - callback function to apply on any attribute found
	 */
	function walkAttributes(html, fn) {
	  var m,
	    re = /([-\w]+) ?= ?(?:"([^"]*)|'([^']*)|({[^}]*}))/g
	
	  while (m = re.exec(html)) {
	    fn(m[1].toLowerCase(), m[2] || m[3] || m[4])
	  }
	}
	
	/**
	 * Check whether a DOM node is in stub mode, useful for the riot 'if' directive
	 * @param   { Object }  dom - DOM node we want to parse
	 * @returns { Boolean } -
	 */
	function isInStub(dom) {
	  while (dom) {
	    if (dom.inStub) return true
	    dom = dom.parentNode
	  }
	  return false
	}
	
	/**
	 * Create a generic DOM node
	 * @param   { String } name - name of the DOM node we want to create
	 * @returns { Object } DOM node just created
	 */
	function mkEl(name) {
	  return document.createElement(name)
	}
	
	/**
	 * Shorter and fast way to select multiple nodes in the DOM
	 * @param   { String } selector - DOM selector
	 * @param   { Object } ctx - DOM node where the targets of our search will is located
	 * @returns { Object } dom nodes found
	 */
	function $$(selector, ctx) {
	  return (ctx || document).querySelectorAll(selector)
	}
	
	/**
	 * Shorter and fast way to select a single node in the DOM
	 * @param   { String } selector - unique dom selector
	 * @param   { Object } ctx - DOM node where the target of our search will is located
	 * @returns { Object } dom node found
	 */
	function $(selector, ctx) {
	  return (ctx || document).querySelector(selector)
	}
	
	/**
	 * Simple object prototypal inheritance
	 * @param   { Object } parent - parent object
	 * @returns { Object } child instance
	 */
	function inherit(parent) {
	  function Child() {}
	  Child.prototype = parent
	  return new Child()
	}
	
	/**
	 * Get the name property needed to identify a DOM node in riot
	 * @param   { Object } dom - DOM node we need to parse
	 * @returns { String | undefined } give us back a string to identify this dom node
	 */
	function getNamedKey(dom) {
	  return getAttr(dom, 'id') || getAttr(dom, 'name')
	}
	
	/**
	 * Set the named properties of a tag element
	 * @param { Object } dom - DOM node we need to parse
	 * @param { Object } parent - tag instance where the named dom element will be eventually added
	 * @param { Array } keys - list of all the tag instance properties
	 */
	function setNamed(dom, parent, keys) {
	  // get the key value we want to add to the tag instance
	  var key = getNamedKey(dom),
	    isArr,
	    // add the node detected to a tag instance using the named property
	    add = function(value) {
	      // avoid to override the tag properties already set
	      if (contains(keys, key)) return
	      // check whether this value is an array
	      isArr = isArray(value)
	      // if the key was never set
	      if (!value)
	        // set it once on the tag instance
	        parent[key] = dom
	      // if it was an array and not yet set
	      else if (!isArr || isArr && !contains(value, dom)) {
	        // add the dom node into the array
	        if (isArr)
	          value.push(dom)
	        else
	          parent[key] = [value, dom]
	      }
	    }
	
	  // skip the elements with no named properties
	  if (!key) return
	
	  // check whether this key has been already evaluated
	  if (tmpl.hasExpr(key))
	    // wait the first updated event only once
	    parent.one('mount', function() {
	      key = getNamedKey(dom)
	      add(parent[key])
	    })
	  else
	    add(parent[key])
	
	}
	
	/**
	 * Faster String startsWith alternative
	 * @param   { String } src - source string
	 * @param   { String } str - test string
	 * @returns { Boolean } -
	 */
	function startsWith(src, str) {
	  return src.slice(0, str.length) === str
	}
	
	/**
	 * requestAnimationFrame function
	 * Adapted from https://gist.github.com/paulirish/1579671, license MIT
	 */
	var rAF = (function (w) {
	  var raf = w.requestAnimationFrame    ||
	            w.mozRequestAnimationFrame || w.webkitRequestAnimationFrame
	
	  if (!raf || /iP(ad|hone|od).*OS 6/.test(w.navigator.userAgent)) {  // buggy iOS6
	    var lastTime = 0
	
	    raf = function (cb) {
	      var nowtime = Date.now(), timeout = Math.max(16 - (nowtime - lastTime), 0)
	      setTimeout(function () { cb(lastTime = nowtime + timeout) }, timeout)
	    }
	  }
	  return raf
	
	})(window || {})
	
	/**
	 * Mount a tag creating new Tag instance
	 * @param   { Object } root - dom node where the tag will be mounted
	 * @param   { String } tagName - name of the riot tag we want to mount
	 * @param   { Object } opts - options to pass to the Tag instance
	 * @returns { Tag } a new Tag instance
	 */
	function mountTo(root, tagName, opts) {
	  var tag = __tagImpl[tagName],
	    // cache the inner HTML to fix #855
	    innerHTML = root._innerHTML = root._innerHTML || root.innerHTML
	
	  // clear the inner html
	  root.innerHTML = ''
	
	  if (tag && root) tag = new Tag(tag, { root: root, opts: opts }, innerHTML)
	
	  if (tag && tag.mount) {
	    tag.mount()
	    // add this tag to the virtualDom variable
	    if (!contains(__virtualDom, tag)) __virtualDom.push(tag)
	  }
	
	  return tag
	}
	/**
	 * Riot public api
	 */
	
	// share methods for other riot parts, e.g. compiler
	riot.util = { brackets: brackets, tmpl: tmpl }
	
	/**
	 * Create a mixin that could be globally shared across all the tags
	 */
	riot.mixin = (function() {
	  var mixins = {}
	
	  /**
	   * Create/Return a mixin by its name
	   * @param   { String } name - mixin name (global mixin if missing)
	   * @param   { Object } mixin - mixin logic
	   * @returns { Object } the mixin logic
	   */
	  return function(name, mixin) {
	    if (isObject(name)) {
	      mixin = name
	      mixins[GLOBAL_MIXIN] = extend(mixins[GLOBAL_MIXIN] || {}, mixin)
	      return
	    }
	
	    if (!mixin) return mixins[name]
	    mixins[name] = mixin
	  }
	
	})()
	
	/**
	 * Create a new riot tag implementation
	 * @param   { String }   name - name/id of the new riot tag
	 * @param   { String }   html - tag template
	 * @param   { String }   css - custom tag css
	 * @param   { String }   attrs - root tag attributes
	 * @param   { Function } fn - user function
	 * @returns { String } name/id of the tag just created
	 */
	riot.tag = function(name, html, css, attrs, fn) {
	  if (isFunction(attrs)) {
	    fn = attrs
	    if (/^[\w\-]+\s?=/.test(css)) {
	      attrs = css
	      css = ''
	    } else attrs = ''
	  }
	  if (css) {
	    if (isFunction(css)) fn = css
	    else styleManager.add(css)
	  }
	  name = name.toLowerCase()
	  __tagImpl[name] = { name: name, tmpl: html, attrs: attrs, fn: fn }
	  return name
	}
	
	/**
	 * Create a new riot tag implementation (for use by the compiler)
	 * @param   { String }   name - name/id of the new riot tag
	 * @param   { String }   html - tag template
	 * @param   { String }   css - custom tag css
	 * @param   { String }   attrs - root tag attributes
	 * @param   { Function } fn - user function
	 * @returns { String } name/id of the tag just created
	 */
	riot.tag2 = function(name, html, css, attrs, fn) {
	  if (css) styleManager.add(css)
	  //if (bpair) riot.settings.brackets = bpair
	  __tagImpl[name] = { name: name, tmpl: html, attrs: attrs, fn: fn }
	  return name
	}
	
	/**
	 * Mount a tag using a specific tag implementation
	 * @param   { String } selector - tag DOM selector
	 * @param   { String } tagName - tag implementation name
	 * @param   { Object } opts - tag logic
	 * @returns { Array } new tags instances
	 */
	riot.mount = function(selector, tagName, opts) {
	
	  var els,
	    allTags,
	    tags = []
	
	  // helper functions
	
	  function addRiotTags(arr) {
	    var list = ''
	    each(arr, function (e) {
	      if (!/[^-\w]/.test(e)) {
	        e = e.trim().toLowerCase()
	        list += ',[' + RIOT_TAG_IS + '="' + e + '"],[' + RIOT_TAG + '="' + e + '"]'
	      }
	    })
	    return list
	  }
	
	  function selectAllTags() {
	    var keys = Object.keys(__tagImpl)
	    return keys + addRiotTags(keys)
	  }
	
	  function pushTags(root) {
	    if (root.tagName) {
	      var riotTag = getAttr(root, RIOT_TAG_IS) || getAttr(root, RIOT_TAG)
	
	      // have tagName? force riot-tag to be the same
	      if (tagName && riotTag !== tagName) {
	        riotTag = tagName
	        setAttr(root, RIOT_TAG_IS, tagName)
	      }
	      var tag = mountTo(root, riotTag || root.tagName.toLowerCase(), opts)
	
	      if (tag) tags.push(tag)
	    } else if (root.length) {
	      each(root, pushTags)   // assume nodeList
	    }
	  }
	
	  // ----- mount code -----
	
	  // inject styles into DOM
	  styleManager.inject()
	
	  if (isObject(tagName)) {
	    opts = tagName
	    tagName = 0
	  }
	
	  // crawl the DOM to find the tag
	  if (typeof selector === T_STRING) {
	    if (selector === '*')
	      // select all the tags registered
	      // and also the tags found with the riot-tag attribute set
	      selector = allTags = selectAllTags()
	    else
	      // or just the ones named like the selector
	      selector += addRiotTags(selector.split(/, */))
	
	    // make sure to pass always a selector
	    // to the querySelectorAll function
	    els = selector ? $$(selector) : []
	  }
	  else
	    // probably you have passed already a tag or a NodeList
	    els = selector
	
	  // select all the registered and mount them inside their root elements
	  if (tagName === '*') {
	    // get all custom tags
	    tagName = allTags || selectAllTags()
	    // if the root els it's just a single tag
	    if (els.tagName)
	      els = $$(tagName, els)
	    else {
	      // select all the children for all the different root elements
	      var nodeList = []
	      each(els, function (_el) {
	        nodeList.push($$(tagName, _el))
	      })
	      els = nodeList
	    }
	    // get rid of the tagName
	    tagName = 0
	  }
	
	  pushTags(els)
	
	  return tags
	}
	
	/**
	 * Update all the tags instances created
	 * @returns { Array } all the tags instances
	 */
	riot.update = function() {
	  return each(__virtualDom, function(tag) {
	    tag.update()
	  })
	}
	
	/**
	 * Export the Tag constructor
	 */
	riot.Tag = Tag
	  // support CommonJS, AMD & browser
	  /* istanbul ignore next */
	  if (typeof exports === T_OBJECT)
	    module.exports = riot
	  else if ("function" === T_FUNCTION && typeof __webpack_require__(2) !== T_UNDEF)
	    !(__WEBPACK_AMD_DEFINE_RESULT__ = function() { return riot }.call(exports, __webpack_require__, exports, module), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__))
	  else
	    window.riot = riot
	
	})(typeof window != 'undefined' ? window : void 0);


/***/ },
/* 2 */
/***/ function(module, exports) {

	/* WEBPACK VAR INJECTION */(function(__webpack_amd_options__) {module.exports = __webpack_amd_options__;
	
	/* WEBPACK VAR INJECTION */}.call(exports, {}))

/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	
	var _interopRequire = function (obj) { return obj && obj.__esModule ? obj["default"] : obj; };
	
	var _defineProperty = function (obj, key, value) { return Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); };
	
	var riot = _interopRequire(__webpack_require__(1));
	
	var request = _interopRequire(__webpack_require__(4));
	
	var apis = {
	  unauthenticatedRoot: "/",
	  authenticatedRoot: "/projects",
	  sessions: riot.observable(),
	  registrations: riot.observable(),
	  passwords: riot.observable()
	};
	var resources = ["projects"];
	resources.forEach(function (api) {
	  apis[api] = riot.observable();
	
	  apis[api].index = function (data) {
	    return request({
	      url: "/api/" + api,
	      data: _defineProperty({}, api.singular(), data)
	    }).fail(function (xhr) {
	      apis[api].trigger("index.fail", xhr);
	      return xhr;
	    }).then(function (data) {
	      apis[api].trigger("index.success", data);
	      return data;
	    });
	  };
	
	  apis[api].show = function (id) {
	    return request({ url: "/api/" + api + "/" + id }).fail(function (xhr) {
	      apis[api].trigger("show.fail", xhr);
	      return xhr;
	    }).then(function (data) {
	      apis[api].trigger("show.success", data);
	      return data;
	    });
	  };
	
	  apis[api].create = function (data) {
	    return request({
	      url: "/api/" + api,
	      type: "post",
	      data: _defineProperty({}, api.singular(), data)
	    }).fail(function (xhr) {
	      apis[api].trigger("create.fail", xhr);
	      return xhr;
	    }).then(function (data) {
	      apis[api].trigger("create.success", data);
	      return data;
	    });
	  };
	
	  apis[api].update = function (id, data) {
	    return request({
	      url: "/api/" + api + "/" + id,
	      type: "put",
	      data: _defineProperty({}, api.singular(), data)
	    }).fail(function (xhr) {
	      apis[api].trigger("update.fail", xhr);
	      return xhr;
	    }).then(function () {
	      apis[api].trigger("update.success", id);
	      return id;
	    });
	  };
	
	  apis[api]["delete"] = function (id) {
	    return request({ url: "/api/" + api + "/" + id, type: "delete" }).fail(function (xhr) {
	      apis[api].trigger("delete.fail", xhr);
	      return xhr;
	    }).then(function () {
	      apis[api].trigger("delete.success", id);
	      return id;
	    });
	  };
	});
	
	apis.sessions.check = function () {
	  return request({
	    type: "get",
	    url: "/api/accounts/sign_in"
	  }).fail(function (xhr) {
	    apis.sessions.trigger("check.fail", xhr);
	  }).then(function (data) {
	    $.csrfToken = null;
	    apis.currentAccount = data;
	    //riot.route(apis.authenticatedRoot)
	    apis.sessions.trigger("check.success", data);
	  });
	};
	apis.sessions.signin = function (creds) {
	  return request({
	    type: "post",
	    url: "/api/accounts/sign_in",
	    data: { account: creds }
	  }).fail(function (xhr) {
	    return apis.sessions.trigger("signin.fail", xhr);
	  }).then(function (data) {
	    $.csrfToken = null;
	    apis.currentAccount = data;
	    //riot.route(apis.authenticatedRoot)
	    apis.sessions.trigger("signin.success", data);
	  });
	};
	apis.sessions.signout = function (creds) {
	  return request({
	    type: "delete",
	    url: "/api/accounts/sign_out",
	    data: { account: creds }
	  }).fail(function (xhr) {
	    return apis.sessions.trigger("signout.fail", xhr);
	  }).then(function () {
	    $.csrfToken = null;
	    apis.currentAccount = null;
	    delete apis.currentAccount;
	    apis.sessions.trigger("signout.success");
	    window.location.href = apis.unauthenticatedRoot;
	  });
	};
	apis.registrations.signup = function (data) {
	  return request({
	    type: "post",
	    url: "/api/accounts",
	    data: { account: data }
	  }).fail(function (xhr) {
	    return apis.registrations.trigger("signup.fail", xhr);
	  }).then(function (data) {
	    $.csrfToken = null;
	    apis.currentAccount = data;
	    //riot.route(apis.authenticatedRoot)
	    apis.registrations.trigger("signup.success", data);
	  });
	};
	
	module.exports = apis;

/***/ },
/* 4 */
/***/ function(module, exports) {

	"use strict";
	
	module.exports = function (_ref) {
	  var url = _ref.url;
	  var _ref$type = _ref.type;
	  var type = _ref$type === undefined ? "get" : _ref$type;
	  var _ref$data = _ref.data;
	  var data = _ref$data === undefined ? null : _ref$data;
	
	  if (!$.csrfToken) {
	    return $.getJSON("/api/accounts/csrf_token.json").then(function (d, x, r) {
	      var token = r.getResponseHeader("X-CSRF-Token");
	      if (token) {
	        $.csrfToken = token;
	        $("meta[name=csrf-token]").attr("content", token);
	
	        return $.ajax({
	          url: url,
	          type: type,
	          data: data ? type == "get" ? data : JSON.stringify(data) : null,
	          contentType: type == "get" ? null : "application/json",
	          dataType: "json",
	          beforeSend: function beforeSend(xhr) {
	            xhr.setRequestHeader("X-Csrf-Token", $.csrfToken);
	          }
	        });
	      }
	    });
	  } else {
	    return $.ajax({
	      url: url,
	      type: type,
	      data: data ? type == "get" ? data : JSON.stringify(data) : null,
	      contentType: type == "get" ? null : "application/json",
	      dataType: "json",
	      beforeSend: function beforeSend(xhr) {
	        // xhr.setRequestHeader("X-Csrf-Token", $('[name=csrf-token]').attr('content'));
	        xhr.setRequestHeader("X-Csrf-Token", $.csrfToken);
	      }
	    });
	  }
	};

/***/ },
/* 5 */
/***/ function(module, exports) {

	
	/*!
	 * Inflector
	 * Copyright(c) 2011 Vadim Demedes <sbioko@gmail.com>
	 * MIT Licensed
	 */
	
	/**
	 * Library version.
	 */
	
	exports.version = '0.0.1';
	
	String.prototype.trim = function() { // not inflector, just helper for its libraries
		return this.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}
	
	String.prototype.plural = function() {
		var s = this.trim().toLowerCase();
		end = s.substr(-1);
		if(end == 'y') {
			var vowels = ['a', 'e', 'i', 'o', 'u'];
			s = s.substr(-2, 1) in vowels ? s + 's' : s.substr(0, s.length-1) + 'ies';
		} else if(end == 'h') {
	    	s += s.substr(-2) == 'ch' || s.substr(-2) == 'sh' ? 'es' : 's';
		} else if(end == 's') {
			s += 'es';
		} else {
			s += 's';
		}
		return s;
	}
	
	String.prototype.singular = function() {
		var s = this.trim().toLowerCase();
		var end = s.substr(-3);
		if(end == 'ies') {
			s = s.substr(0, s.length-3) + 'y';
		} else if(end == 'ses') {
			s = s.substr(0, s.length-2);
		} else {
			end = s.substr(-1);
			if(end == 's') {
				s = s.substr(0, s.length-1);
			}
		}
		return s;
	}
	
	String.prototype.camelize = function() {
		var s = 'x_' + this.trim().toLowerCase();
		s = s.replace(/[\s_]/g, ' ');
		s = s.replace(/^(.)|\s(.)/g, function($1) {
			return $1.toUpperCase();
		});
		return s.replace(/ /g, '').substr(1);
	}
	
	String.prototype.underscore = function() {
		return this.trim().toLowerCase().replace(/[\s]+/g, '_');
	}
	
	String.prototype.humanize = function() {
		var s = this.trim().toLowerCase().replace(/[_]+/g, ' ');
		s = s.replace(/^(.)|\s(.)/g, function($1) {
			return $1.toUpperCase();
		});
		return s;
	}
	


/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	var _interopRequire = function (obj) { return obj && obj.__esModule ? obj["default"] : obj; };
	
	var request = _interopRequire(__webpack_require__(4));
	
	var dot = _interopRequire(__webpack_require__(20));
	
	riot.mixin({
	  ERRORS: {
	    0: "Hmm, something not right, you may try again later or contact with us.",
	    401: "Hmm, are you sure given email and password are correct?",
	    403: "Hmm, are you sure you are allowed to do that?",
	    404: "Whops 404! Whatever you are looking for is not found!",
	    500: "Ops!, something went wrong at our end, try again later.",
	    ASSET_ASSIGNMENT: "We got your brief, but unfortunately your files lost on the way to us",
	    BLANK: "cannot be blank"
	  },
	  initialize: function initialize() {
	    if (this.parent && this.parent.opts.api) this.opts.api = this.parent.opts.api;
	  },
	  request: request,
	  dot: new dot(".", true), // allow overrides!
	  serializeForm: function serializeForm(form) {
	    return $(form).serializeJSON({ parseAll: true });
	  },
	  errorHandler: function errorHandler(xhr) {
	    this.update({ busy: false });
	    switch (xhr.status) {
	      case 422:
	        this.update({ errors: xhr.responseJSON.errors });
	        break;
	      case 401:
	        this.showAuthModal();
	        break;
	      case 403:
	        alert(this.ERRORS[403]);
	        break;
	      case 404:
	        alert(this.ERRORS[404]);
	        break;
	      case 500:
	        alert(this.ERRORS[500]);
	        break;
	      default:
	        alert(this.ERRORS[0]);
	        break;
	    }
	    return xhr;
	  }
	});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	__webpack_require__(8);
	
	__webpack_require__(12);
	
	__webpack_require__(13);
	
	__webpack_require__(17);
	
	__webpack_require__(16);
	
	__webpack_require__(18);
	
	riot.tag2("r-app", "<yield from=\"header\"></yield> <div name=\"content\"></div>", "", "", function (opts) {
	  var _this = this;
	
	  this.opts.api.sessions.on("signin.success", this.update);
	  this.opts.api.sessions.on("signout.success", this.update);
	  this.opts.api.registrations.on("signup.success", this.update);
	  riot.route("signout", function () {
	    _this.opts.api.sessions.signout();
	  });
	  riot.route("signin", function () {
	    if (opts.api.currentAccount) return riot.route(_this.authenticatedRoot);
	    riot.mount("r-modal", {
	      content: "r-auth",
	      persisted: true, api: opts.api,
	      contentOpts: { tab: "r-signin", api: opts.api }
	    });
	  });
	  riot.route("signup", function () {
	    if (opts.api.currentAccount) return riot.route(_this.authenticatedRoot);
	    riot.mount("r-modal", {
	      content: "r-auth",
	      persisted: true,
	      api: opts.api,
	      contentOpts: { tab: "r-signup", api: opts.api }
	    });
	  });
	  riot.route("projects", function () {
	    riot.mount(_this.content, "r-projects-index", { api: opts.api });
	  });
	  riot.route("projects/new", function () {
	    riot.mount(_this.content, "r-projects-brief", { api: opts.api });
	  });
	});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	riot.tag2("r-header", "<header class=\"container\"> <div> <nav class=\"relative clearfix black h5\"> <div class=\"left\"> <a href=\"/\" class=\"btn py2\" black><img src=\"/images/logos/black.svg\" class=\"logo--small\"></a> </div> <div class=\"right py1 sm-show mr1\" if=\"{opts.api.currentAccount}\"> <a href=\"/app/projects\" class=\"btn py2\">Projects</a> <a href=\"/app/settings\" class=\"btn py2\">Settings</a> <a href=\"/app/signout\" class=\"btn py2\">Sign out</a> </div> <div class=\"right py1 sm-show mr1\" if=\"{!opts.api.currentAccount}\"> <a href=\"/pages/about\" class=\"btn py2\">About us</a> <a href=\"/#how-it-works\" class=\"btn py2\">How it works</a> <a href=\"/app/signin\" class=\"btn py2\">Sign in</a> </div> <div class=\"right sm-hide py1 mr1\"> <div class=\"inline-block\" data-disclosure> <div data-details class=\"fixed top-0 right-0 bottom-0 left-0\"></div> <a class=\"btn py2 m0\"> <span class=\"md-hide\"> <i class=\"fa fa-bars\"></i> </span> </a> <div data-details class=\"absolute left-0 right-0 nowrap bg-white black mt1\"> <ul class=\"h5 list-reset py1 mb0\" if=\"{opts.api.currentAccount}\"> <li><a href=\"/app/projects\" class=\"btn block\">Projects</a></li> <li><a href=\"/app/settings\" class=\"btn block\">Settings</a></li> <li><a href=\"/app/signout\" class=\"btn block\">Sign out</a></li> </ul> <ul class=\"h5 list-reset py1 mb0\" if=\"{!opts.api.currentAccount}\"> <li><a href=\"/pages/about\" class=\"btn block\">About us</a></li> <li><a href=\"/#how-it-works\" class=\"btn block\">How it works</a></li> <li><a href=\"/app/signin\" class=\"btn block\">Sign in</a></li> </ul> </div> </div> </div> </nav> </div> </header>", "", "", function (opts) {});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 9 */,
/* 10 */,
/* 11 */,
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	riot.tag2("r-tabs", "<div name=\"tab\"></div>", "", "", function (opts) {
	  var _this = this;
	
	  this.navigate = function (e) {
	    if (e) {
	      e.preventDefault();
	      _this.opts.tab = e.target.name;
	      history.pushState(null, e.target.title, e.target.href);
	    }
	    riot.mount(_this.tab, _this.opts.tab, {
	      navigate: _this.navigate,
	      api: opts.api
	    });
	  };
	  this.navigate();
	});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	__webpack_require__(14);
	
	__webpack_require__(15);
	
	riot.tag2("r-auth", "<r-tabs tab=\"{opts.tab}\" api=\"{opts.api}\"></r-tabs>", "", "", function (opts) {});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 14 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	riot.tag2("r-signup", "<h2 class=\"center mt0 mb2\">Sign up</h2> <form name=\"form\" classes=\"sm-col-12 left-align\" action=\"/api/accounts\" onsubmit=\"{submit}\"> <div class=\"clearfix mxn2\"> <div class=\"col col-6 px2\"> <label for=\"user[profile][first_name]\">First Name *</label> <input class=\"block col-12 mb2 field\" autofocus=\"true\" type=\"text\" name=\"user[profile][first_name]\"> <span if=\"{errors['user.profile.first_name']}\" class=\"inline-error\">{errors['user.profile.first_name']}</span> </div> <div class=\"col col-6 px2\"> <label for=\"user[profile][last_name]\">Last Name *</label> <input class=\"block col-12 mb2 field\" type=\"text\" name=\"user[profile][last_name]\"> <span if=\"{errors['user.profile.last_name']}\" class=\"inline-error\">{errors['user.profile.last_name']}</span> </div> </div> <label for=\"user[profile][phone_number]\">Phone Number *</label> <input class=\"block col-12 mb2 field\" type=\"tel\" name=\"user[profile][phone_number]\"> <span if=\"{errors['user.profile.phone_number']}\" class=\"inline-error\">{errors['user.profile.phone_number']}</span> <h6 class=\"mb2 p1 green border-left border-right border-bottom\" style=\"margin-top:-1rem\">Your privacy is important. <br>We only share your number with selected contractors working on your project. </h6> <label for=\"email\">Email *</label> <input class=\"block col-12 mb2 field\" type=\"text\" name=\"email\"> <span if=\"{errors['email']}\" class=\"inline-error\">{errors['email']}</span> <label for=\"password\">Password *</label> <em class=\"h5\">(8 characters minimum)</em> <input class=\"block col-12 mb2 field\" autocomplete=\"off\" type=\"password\" name=\"password\"> <span if=\"{errors['password']}\" class=\"inline-error\">{errors['password']}</span> <button type=\"submit\" class=\"block col-12 mb2 btn btn-big btn-primary\">Sign up</button> <small class=\"h6 block center\">By signing up, you agree to the <a href=\"/pages/terms-conditions\">Terms of Service</a></small> </form> <div class=\"center\"><a name=\"r-signin\" href=\"/app/signin\" title=\"Sign in\" onclick=\"{opts.navigate}\">Sign in</a></div>", "", "", function (opts) {
	  var _this = this;
	
	  this.submit = function (e) {
	
	    e.preventDefault();
	
	    var data = _this.serializeForm(_this.form);
	
	    if (_.isEmpty(data)) {
	      $(_this.form).animateCss("shake");
	      return;
	    }
	
	    _this.update({ busy: true });
	
	    _this.opts.api.registrations.signup(data).fail(_this.errorHandler).then(function (account) {
	      _this.update({ busy: false });
	      riot.route(opts.api.authenticatedRoot);
	    });
	  };
	});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 15 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	riot.tag2("r-signin", "<h2 class=\"center mt0 mb2\">Sign in</h2> <form name=\"form\" classes=\"sm-col-12 left-align\" action=\"/api/accounts/sign_in\" onsubmit=\"{submit}\"> <div if=\"{errors}\" id=\"error_explanation\"> {errors} </div> <label for=\"email\">Email</label> <input class=\"block col-12 mb2 field\" autofocus=\"true\" type=\"text\" name=\"email\"> <label for=\"email\">Password</label> <input class=\"block col-12 mb2 field\" autocomplete=\"off\" type=\"password\" name=\"password\"> <div> <label class=\"inline-block mb2\"> <input type=\"checkbox\" label=\"Remember me\" name=\"remember_me\"> Remember me </label> </div> <button name=\"submit\" type=\"submit\" class=\"block col-12 mb2 btn btn-big btn-primary {busy: busy}\" __disabled=\"{busy}\">Sign in</button> <div class=\"center\"> <a name=\"r-reset-password\" href=\"/app/reset-password\" title=\"Reset Password\" onclick=\"{opts.navigate}\" class=\"block\">Forgot your password?</a> </div> </form> <div class=\"center\"><a name=\"r-signup\" href=\"/app/signup\" title=\"Sign up\" onclick=\"{opts.navigate}\">Sign up</a></div>", "", "", function (opts) {
	  var _this = this;
	
	  this.submit = function (e) {
	
	    e.preventDefault();
	
	    var creds = _this.serializeForm(_this.form);
	
	    if (_.isEmpty(creds)) {
	      $(_this.form).animateCss("shake");
	      return;
	    }
	
	    _this.update({ busy: true });
	    _this.opts.api.sessions.signin(creds).fail(_this.errorHandler).then(function (account) {
	      _this.update({ busy: false });
	      riot.route(opts.api.authenticatedRoot);
	    });
	  };
	  this.showAuthModal = function () {
	    _this.update({ errors: _this.ERRORS[401] });
	  };
	});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 16 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	riot.tag2("r-projects-index", "<yield to=\"header\"> <r-header api=\"{opts.api}\"></r-header> </yield> <h1>Projects</h1>", "", "", function (opts) {});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 17 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	riot.tag2("r-modal", "<div name=\"body\" class=\"black modal-body out\"> <div class=\"fixed left-0 top-0 right-0 bottom-0 z4 overflow-auto bg-darken-4\"> <div class=\"relative sm-col-6 sm-px3 px1 py3 mt4 mb4 mx-auto bg-white modal-container\"> <a if=\"{!opts.persisted}\" class=\"absolute btn btn-small right-0 top-0 mr1 mt1\" onclick=\"{close}\"> <i class=\"fa fa-times\"></i> </a> <div name=\"content\"></div> </div> </div> </div>", "", "", function (opts) {
	  var _this = this;
	
	  riot.mount(this.content, this.opts.content, this.opts.contentOpts);
	
	  // auth modal? let's auto close it when it's done
	  if (this.opts.content == "r-auth") {
	    this.opts.api.sessions.on("signin.success", function () {
	      return _this.close();
	    });
	    this.opts.api.registrations.on("signup.success", function () {
	      return _this.close();
	    });
	  }
	
	  this.close = function (e) {
	    if (e) e.preventUpdate = true;
	    $(_this.body).on("transitionend", _this.unmount.bind(true)).addClass("out");
	  };
	
	  this.on("mount", function () {
	    document.body.classList.add("overflow-hidden");
	    setTimeout(function () {
	      $(_this.body).removeClass("out");
	    }, 100);
	  });
	
	  this.on("unmount", function () {
	    $("body").removeClass("overflow-hidden");
	  });
	});
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 18 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(riot) {"use strict";
	
	var _defineProperty = function (obj, key, value) { return Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); };
	
	var options = __webpack_require__(19);
	
	riot.tag2("r-files-input-with-preview", "<div class=\"relative\"> <r-file-input name=\"{opts.name}\" record=\"{opts.record}\" data-accept=\"{opts.data_accept}\" accept=\"{opts.accept}\"></r-file-input> <div class=\"border center dropzone\"> <i class=\"fa fa-plus fa-2x mt3\"></i> <p>Drag and drop your documents here or click to select</p> <div class=\"clearfix upload-previews\"> <div each=\"{asset, index in opts.record[opts.name]}\" class=\"sm-col sm-col-4 p1 rounded center thumb animated bounceIn\"> <div class=\"border p1 truncate overflow-hidden\"> <a class=\"cursor-zoom\" href=\"{asset.file.url}\" target=\"_blank\"> <img riot-src=\"{asset.content_type.indexOf('image') > -1 ? asset.file.thumb.url : asset.file.cover.url}\" class=\"fixed-height\"> </a> <br><a class=\"btn btn-small\" onclick=\"{destroy}\"><i class=\"fa fa-times\"></i></a> </div> </div> </div> </div> </div>", "", "", function (opts) {
	  var _this = this;
	
	  this.destroy = function (e) {
	    var index = e.item.index;
	    var assets = opts.record[opts.name];
	    var id = assets[index].id;
	
	    _this.request({
	      type: "delete",
	      url: "/api/assets/" + id
	    }).fail(function () {
	      $(e.target).parents(".thumb").animateCss("shake");
	    }).then(function () {
	      $(e.target).parents(".thumb").one($.animationEnd, function (e) {
	        assets.splice(index, 1);
	        $(e.target).remove();
	      }).animateCss("bounceOut");
	    });
	  };
	  this.on("update", this.parent.update);
	});
	
	riot.tag2("r-file-input", "<input type=\"file\" name=\"{opts.name}\" multiple class=\"absolute col-12 left-0 top-0 bottom-0 center transparent\" style=\"height:100%\" data-accept=\"{opts.data_accept}\" accept=\"{opts.accept}\" ondragover=\"{fileDragHover}\" ondragleave=\"{fileDragHover}\" ondrop=\"{fileSelectHandler}\">", "", "", function (opts) {
	  var _this = this;
	
	  this.index = 0;
	
	  this.fileDragHover = function (e) {
	    e.stopPropagation();
	    e.preventDefault();
	    $(".dropzone", _this.parent.root).toggleClass("hover", e.type === "dragover");
	  };
	  this.fileSelectHandler = function (e) {
	    // cancel event and hover styling
	    _this.fileDragHover(e);
	
	    // // fetch FileList object
	    var files = e.dataTransfer && e.dataTransfer.files.length > 0 ? e.dataTransfer.files : e.currentTarget.files;
	    _this.uploader.fileupload("add", {
	      files: files
	    });
	  };
	  this.on("mount", function () {
	
	    _this.uploader = $("input[type=file]", _this.root).fileupload({
	      paramName: "asset[file]",
	      url: "/api/assets",
	      dropZone: $(".dropzone", _this.parent.root),
	      add: function (e, data) {
	        // not a new project? then assign assets directly to it
	        if (opts.record.id) data.formData = { "asset[project_id]": opts.record.id };
	        data.submit().success(function (result, textStatus, jqXHR) {
	          var files = opts.record[opts.name] || [];
	          files.push(result);
	          opts.record[opts.name] = files;
	
	          _this.parent.update();
	        }).error(function (jqXHR, textStatus, errorThrown) {
	          console.error("upload err", textStatus);
	        });
	      }
	    });
	  });
	});
	
	riot.tag2("r-projects-brief", "<yield if=\"{!opts.api.currentAccount}\" to=\"header\"> <header class=\"container\"> <nav class=\"relative clearfix {step > 0 ? 'black' : 'white'} h5\"> <div class=\"left\"> <a href=\"/\" class=\"btn py2\"><img riot-src=\"/images/logos/{step > 0 ? 'black' : 'white'}.svg\" class=\"logo--small\"></a> </div> </nav> </header> </yield> <yield if=\"{opts.api.currentAccount}\" to=\"header\"> <r-header api=\"{opts.api}\"></r-header> </yield> <section if=\"{!opts.api.currentAccount}\" class=\"absolute col-12 center px2 py2 white {out: step != 0}\" data-step=\"0\"> <div class=\"container\"> <h1 class=\"h1 h1-responsive sm-mt4 mb1\">Thanks for getting started!</h1> <p class=\"h3 sm-col-6 mx-auto mb2\">The next few questions will create your brief :)</p> <div><button class=\"btn btn-big btn-primary mb3\" onclick=\"{start}\">Ok, Got it</button></div> <p>Or <button class=\"h5 btn btn-narrow btn-outline white ml1 mr1\" onclick=\"{showArrangeCallbackModal}\">Arrange a callback</button> to speak with a human</p> </div> </section> <form name=\"form\" action=\"/api/projects\" onsubmit=\"{submit}\"> <section class=\"absolute col-12 center px2 py2 {out: step != 1}\" data-step=\"1\"> <div class=\"container\"> <h1 class=\"h1-responsive mt0 mb4\">Mission</h1> <div class=\"clearfix mxn2 border\"> <div each=\"{options.kind}\" class=\"center col col-6 md-col-4\"> <a class=\"block p2 bg-lighten-4 black icon-radio--button {active: (name === project.kind)}\" onclick=\"{setProjectKind}\"> <img class=\"fixed-height\" riot-src=\"{icon}\" alt=\"{name}\"> <h4 class=\"m0 caps center truncate icon-radio--name\">{name}</h4> <input type=\"radio\" name=\"kind\" value=\"{value}\" class=\"hide\" __checked=\"{value === project.kind}\"> </a> </div> </div> </div> </section> <section class=\"absolute col-12 center px2 py2 {out: step != 2}\" data-step=\"2\"> <div class=\"container\"> <h1 class=\"h1-responsive mt0 mb4\">Helpful details</h1> <p class=\"h2\">Description *</p> <textarea id=\"brief.description\" name=\"brief[description]\" class=\"fixed-height block col-12 mb2 field\" placeholder=\"Please write outline of your project\" required=\"true\" autofocus=\"true\" oninput=\"{setValue}\">{project.brief.description}</textarea> <span if=\"{errors['brief.description']}\" class=\"inline-error\">{errors['brief.description']}</span> <div class=\"clearfix mxn2 mb2 left-align\"> <div class=\"sm-col sm-col-6 px2\"> <label for=\"brief[budget]\">Budget</label> <select id=\"brief.budget\" name=\"brief[budget]\" class=\"block col-12 mb2 field\" onchange=\"{setValue}\"> <option each=\"{value, i in options.budget}\" value=\"{value}\" __selected=\"{value === project.brief.budget}\">{value}</option> </select> </div> <div class=\"sm-col sm-col-6 px2\"> <label for=\"brief[preferred_start]\">Start</label> <select id=\"brief.preferred_start\" name=\"brief[preferred_start]\" class=\"block col-12 mb2 field\" onchange=\"{setValue}\"> <option each=\"{value, i in options.preferredStart}\" value=\"{value}\" __selected=\"{value === project.brief.preferred_start}\">{value}</option> </select> </div> </div> <div class=\"right-align\"> <a class=\"btn btn-big mb4\" onclick=\"{prevStep}\">Back</a> <a class=\"btn btn-big btn-primary mb4\" onclick=\"{nextStep}\">Continue</a> </div> </div> </section> <section class=\"absolute col-12 center px2 py2 {out: step != 3}\" data-step=\"3\"> <div class=\"container\"> <h1 class=\"h1-responsive mt0 mb4\">Documents and Photos</h1> <div class=\"clearfix mxn2\"> <div class=\"sm-col sm-col-12 px2 mb2\"> <p class=\"h2\">Upload plans, documents, site photos or any other files about your project</p> <r-files-input-with-preview name=\"assets\" record=\"{project}\"></r-files-input-with-preview> </div> </div> <div class=\"right-align\"> <a class=\"btn btn-big mb1\" onclick=\"{prevStep}\">Back</a> <a class=\"btn btn-big btn-primary mb1\" onclick=\"{nextStep}\">Continue</a> </div> <div class=\"right-align mb4\"> <a onclick=\"{parent.nextStep}\">Skip for now</a> </div> </div> </section> <section class=\"absolute col-12 center px2 py2 {out: step != 4}\" data-step=\"4\"> <div class=\"container\"> <h1 class=\"h1-responsive mt0 mb4\">Address</h1> <p class=\"h2\">Location of project</p> <div class=\"clearfix left-align\"> <label for=\"address[street_address]\">Street Address</label> <input id=\"address.street_address\" class=\"block col-12 mb2 field\" type=\"text\" name=\"address[street_address]\" value=\"{project.address.street_address}\" oninput=\"{setValue}\"> <div class=\"clearfix mxn2\"> <div class=\"col col-6 px2\"> <label for=\"address[city]\">City</label> <input id=\"address.city\" class=\"block col-12 mb2 field\" type=\"text\" name=\"address[city]\" value=\"{project.address.city}\" oninput=\"{setValue}\"> </div> <div class=\"col col-6 px2\"> <label for=\"address[postcode]\">Postcode</label> <input id=\"address.postcode\" class=\"block col-12 mb2 field\" type=\"text\" name=\"address[postcode]\" value=\"{project.address.postcode}\" oninput=\"{setValue}\"> </div> </div> </div> <div class=\"right-align\"> <a class=\"btn btn-big mb1\" onclick=\"{prevStep}\">Back</a> <a class=\"btn btn-big btn-primary mb1\" onclick=\"{nextStep}\">Continue</a> </div> </div> </section> <section class=\"absolute col-12 center px2 py2 {out: step != 5}\" data-step=\"5\"> <div class=\"container\"> <h1 class=\"h1-responsive mt0 mb4\">Project Summary</h1> <div class=\"clearfix p3 border mb3\"> <p class=\"h3 mt0\"> You are planning a <strong><span class=\"inline-block px1 mb1 border-bottom border-yellow summary--project-type\">{project.kind}</span></strong> <span show=\"{!_.isEmpty(_.compact(_.values(project.address)))}\" class=\"summary--address-container\">at <strong><span class=\"inline-block px1 mb1 border-bottom border-yellow summary--address\"><span each=\"{name, add in project.address}\">{add}, </span></span></strong></span>. The basic overview of the brief is: <strong><span class=\"inline-block px1 mb1 border-bottom border-yellow summary--description\">{project.brief.description}</span></strong>. <br> <span show=\"{project.brief.budget}\" class=\"summary--budget-container\">You have a budget of <strong><span class=\"inline-block px1 mb1 border-bottom border-yellow summary--budget\">{project.brief.budget}</span></strong></span> <span show=\"{project.brief.preferred_start}\" class=\"summary--start-date-container\">and would like to start <strong><span class=\"inline-block px1 mb1 border-bottom border-yellow summary--start-date\">{project.brief.preferred_start}</span></strong>.</span> </p> </div> <div class=\"right-align\"> <a class=\"btn btn-big mb4\" onclick=\"{prevStep}\">Back</a> <button class=\"btn btn-big btn-primary mb4\" type=\"submit\">Correct! Make it happen</button> </div> </div> </section> </form>", "", "", function (opts) {
	  var _this = this;
	
	  this.step = opts.api.currentAccount ? 1 : 0;
	  this.project = { brief: {}, address: {} };
	  this.options = options;
	  // listen signup/signin events if not logged in as we need to resubmit form
	  // after user authorized herself
	  if (!opts.api.currentAccount) {
	    opts.api.sessions.one("signin.success", function () {
	      return _this.submit();
	    });
	    opts.api.registrations.one("signup.success", function () {
	      return _this.submit();
	    });
	  }
	
	  if (this.step === 0) {
	    $("body").one("transitionend", function () {
	      return $("body").removeClass("no-transition");
	    }).addClass("no-transition bg-gray");
	  }
	
	  this.start = function () {
	    $("body").toggleClass("no-transition bg-gray");
	    setTimeout(function () {
	      return $(".logo--small").attr("src", $(".logo--small").attr("data-src-black"));
	    }, 300);
	    _this.update({ step: 1 });
	  };
	
	  this.setProjectKind = function (e) {
	    _this.project.kind = e.item.value;
	    _this.update({ step: 2 });
	  };
	
	  this.setValue = function (e) {
	    _this.dot.str(e.target.id, e.target.value, _this.project);
	  };
	
	  this.nextStep = function (e) {
	    e.preventDefault();
	    if (_this.validateStep()) _this.update({ step: _this.step + 1 });
	  };
	
	  this.prevStep = function (e) {
	    e.preventDefault();
	    _this.update({ step: _this.step - 1 });
	  };
	
	  this.validateStep = function () {
	    var hasError = undefined,
	        $requireds = $("[data-step=" + _this.step + "] [required]");
	    if ($requireds.length > 0) {
	      hasError = _.isEmpty(_.compact(_.map($requireds, function (el) {
	        var empty = _.isEmpty(el.value);
	        if (empty) {
	          _this.update({ errors: _defineProperty({}, el.id, [_this.ERRORS.BLANK]) });
	        }
	        return empty ? null : true;
	      })));
	      return !hasError;
	    } else {
	      return true;
	    }
	  };
	
	  this.submit = function (e) {
	    var project = undefined,
	        assetsToAssign = undefined;
	    if (e) e.preventDefault();
	
	    if (_this.step === 5) {
	      project = _this.serializeForm(_this.form);
	
	      if (_.isEmpty(project)) {
	        $(_this.form).animateCss("shake");
	        return;
	      }
	
	      _this.update({ busy: true });
	
	      // stash uploaded assets to be assigned to project
	      assetsToAssign = _.pluck(_this.project.assets, "id");
	
	      _this.opts.api.projects.create(project).fail(_this.errorHandler).then(function (project) {
	        _this.update({ busy: false });
	
	        // no assets? go to project page immediately
	        if (_.isEmpty(assetsToAssign)) {
	          riot.route("/projects/" + project.id);
	        } else {
	          _this.request({ url: "/api/projects/" + project.id + "/assets", type: "post", data: { ids: assetsToAssign } }).fail(function () {
	            window.alert(_this.ERRORS.ASSET_ASSIGNMENT);
	            riot.route("/projects/" + project.id);
	          }).then(function () {
	            console.log("assets uplaoded");
	            riot.route("/projects/" + project.id);
	          });
	        }
	      });
	    } else {
	      _this.update({ step: _this.step + 1 });
	    }
	  };
	
	  this.showAuthModal = function () {
	    riot.mount("r-modal", {
	      content: "r-auth",
	      persisted: false,
	      api: opts.api,
	      contentOpts: { tab: "r-signup", api: opts.api }
	    });
	  };
	
	  this.showArrangeCallbackModal = function () {
	    riot.mount("r-modal", {
	      content: "r-arrange-callback",
	      persisted: false,
	      api: opts.api,
	      contentOpts: { api: opts.api }
	    });
	  };
	});
	// got some uploads, let's assign them to project
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ },
/* 19 */
/***/ function(module, exports) {

	module.exports = {
		"kind": [
			{
				"name": "renovation",
				"value": "renovation",
				"icon": "/images/project_types/renovation.png"
			},
			{
				"name": "redecoration",
				"value": "redecoration",
				"icon": "/images/project_types/redecoration.png"
			},
			{
				"name": "kitchen",
				"value": "kitchen",
				"icon": "/images/project_types/kitchen.png"
			},
			{
				"name": "bathroom",
				"value": "bathroom",
				"icon": "/images/project_types/bathroom.png"
			},
			{
				"name": "extension",
				"value": "extension",
				"icon": "/images/project_types/extension.png"
			},
			{
				"name": "other",
				"value": "other",
				"icon": "/images/project_types/other.png"
			}
		],
		"budget": [
			null,
			"Don't know",
			"less than £10k",
			"£10-20k",
			"£20-30k",
			"£30-40k",
			"£40-50k",
			"£50-60k",
			"£60-70k",
			"£70-80k",
			"£80-90k",
			"£90-100k",
			"+100k",
			"+200k",
			"+300k"
		],
		"preferredStart": [
			null,
			"ASAP",
			"Weeks",
			"Months",
			"Just planning"
		],
		"ownership": [
			null,
			"Owner/occupier",
			"Owner",
			"Not owned"
		]
	};

/***/ },
/* 20 */
/***/ function(module, exports) {

	'use strict'
	
	function _process (v, mod) {
	  var i
	  var r
	
	  if (typeof mod === 'function') {
	    r = mod(v)
	    if (r !== undefined) {
	      v = r
	    }
	  } else if (Array.isArray(mod)) {
	    for (i = 0; i < mod.length; i++) {
	      r = mod[i](v)
	      if (r !== undefined) {
	        v = r
	      }
	    }
	  }
	
	  return v
	}
	
	function parseKey (key, val) {
	  // detect negative index notation
	  if (key[0] === '-' && Array.isArray(val) && /^-\d+$/.test(key)) {
	    return val.length + parseInt(key, 10)
	  }
	  return key
	}
	
	function isIndex (k) {
	  return /^\d+/.test(k)
	}
	
	function parsePath (path, sep) {
	  if (path.indexOf('[') >= 0) {
	    path = path.replace(/\[/g, '.').replace(/]/g, '')
	  }
	  return path.split(sep)
	}
	
	function DotObject (seperator, override, useArray) {
	  if (!(this instanceof DotObject)) {
	    return new DotObject(seperator, override, useArray)
	  }
	
	  if (typeof seperator === 'undefined') seperator = '.'
	  if (typeof override === 'undefined') override = false
	  if (typeof useArray === 'undefined') useArray = true
	  this.seperator = seperator
	  this.override = override
	  this.useArray = useArray
	
	  // contains touched arrays
	  this.cleanup = []
	}
	
	var dotDefault = new DotObject('.', false, true)
	function wrap (method) {
	  return function () {
	    return dotDefault[method].apply(dotDefault, arguments)
	  }
	}
	
	DotObject.prototype._fill = function (a, obj, v, mod) {
	  var k = a.shift()
	
	  if (a.length > 0) {
	    obj[k] = obj[k] ||
	      (this.useArray && isIndex(a[0]) ? [] : {})
	
	    if (obj[k] !== Object(obj[k])) {
	      if (this.override) {
	        obj[k] = {}
	      } else {
	        throw new Error(
	          'Trying to redefine `' + k + '` which is a ' + typeof obj[k]
	        )
	      }
	    }
	
	    this._fill(a, obj[k], v, mod)
	  } else {
	    if (!this.override &&
	      obj[k] === Object(obj[k]) && Object.keys(obj[k]).length) {
	      throw new Error("Trying to redefine non-empty obj['" + k + "']")
	    }
	
	    obj[k] = _process(v, mod)
	  }
	}
	
	/**
	 *
	 * Converts an object with dotted-key/value pairs to it's expanded version
	 *
	 * Optionally transformed by a set of modifiers.
	 *
	 * Usage:
	 *
	 *   var row = {
	 *     'nr': 200,
	 *     'doc.name': '  My Document  '
	 *   }
	 *
	 *   var mods = {
	 *     'doc.name': [_s.trim, _s.underscored]
	 *   }
	 *
	 *   dot.object(row, mods)
	 *
	 * @param {Object} obj
	 * @param {Object} mods
	 */
	DotObject.prototype.object = function (obj, mods) {
	  var self = this
	
	  Object.keys(obj).forEach(function (k) {
	    var mod = mods === undefined ? null : mods[k]
	    // normalize array notation.
	    var ok = parsePath(k, self.seperator).join(self.seperator)
	
	    if (ok.indexOf(self.seperator) !== -1) {
	      self._fill(ok.split(self.seperator), obj, obj[k], mod)
	      delete obj[k]
	    } else if (self.override) {
	      obj[k] = _process(obj[k], mod)
	    }
	  })
	
	  return obj
	}
	
	/**
	 * @param {String} path dotted path
	 * @param {String} v value to be set
	 * @param {Object} obj object to be modified
	 * @param {Function|Array} mod optional modifier
	 */
	DotObject.prototype.str = function (path, v, obj, mod) {
	  if (path.indexOf(this.seperator) !== -1) {
	    this._fill(path.split(this.seperator), obj, v, mod)
	  } else if (this.override) {
	    obj[path] = _process(v, mod)
	  }
	
	  return obj
	}
	
	/**
	 *
	 * Pick a value from an object using dot notation.
	 *
	 * Optionally remove the value
	 *
	 * @param {String} path
	 * @param {Object} obj
	 * @param {Boolean} remove
	 */
	DotObject.prototype.pick = function (path, obj, remove) {
	  var i
	  var keys
	  var val
	  var key
	  var cp
	
	  keys = parsePath(path, this.seperator)
	  for (i = 0; i < keys.length; i++) {
	    key = parseKey(keys[i], obj)
	    if (obj && typeof obj === 'object' && key in obj) {
	      if (i === (keys.length - 1)) {
	        if (remove) {
	          val = obj[key]
	          delete obj[key]
	          if (Array.isArray(obj)) {
	            cp = keys.slice(0, -1).join('.')
	            if (this.cleanup.indexOf(cp) === -1) {
	              this.cleanup.push(cp)
	            }
	          }
	          return val
	        } else {
	          return obj[key]
	        }
	      } else {
	        obj = obj[key]
	      }
	    } else {
	      return undefined
	    }
	  }
	  if (remove && Array.isArray(obj)) {
	    obj = obj.filter(function (n) { return n !== undefined })
	  }
	  return obj
	}
	
	/**
	 *
	 * Remove value from an object using dot notation.
	 *
	 * @param {String} path
	 * @param {Object} obj
	 * @return {Mixed} The removed value
	 */
	DotObject.prototype.remove = function (path, obj) {
	  var i
	
	  this.cleanup = []
	  if (Array.isArray(path)) {
	    for (i = 0; i < path.length; i++) {
	      this.pick(path[i], obj, true)
	    }
	    this._cleanup(obj)
	    return obj
	  } else {
	    return this.pick(path, obj, true)
	  }
	}
	
	DotObject.prototype._cleanup = function (obj) {
	  var ret
	  var i
	  var keys
	  var root
	  if (this.cleanup.length) {
	    for (i = 0; i < this.cleanup.length; i++) {
	      keys = this.cleanup[i].split('.')
	      root = keys.splice(0, -1).join('.')
	      ret = root ? this.pick(root, obj) : obj
	      ret = ret[keys[0]].filter(function (v) { return v !== undefined })
	      this.set(this.cleanup[i], ret, obj)
	    }
	    this.cleanup = []
	  }
	}
	
	// alias method
	DotObject.prototype.del = DotObject.prototype.remove
	
	/**
	 *
	 * Move a property from one place to the other.
	 *
	 * If the source path does not exist (undefined)
	 * the target property will not be set.
	 *
	 * @param {String} source
	 * @param {String} target
	 * @param {Object} obj
	 * @param {Function|Array} mods
	 * @param {Boolean} merge
	 */
	DotObject.prototype.move = function (source, target, obj, mods, merge) {
	  if (typeof mods === 'function' || Array.isArray(mods)) {
	    this.set(target, _process(this.pick(source, obj, true), mods), obj, merge)
	  } else {
	    merge = mods
	    this.set(target, this.pick(source, obj, true), obj, merge)
	  }
	
	  return obj
	}
	
	/**
	 *
	 * Transfer a property from one object to another object.
	 *
	 * If the source path does not exist (undefined)
	 * the property on the other object will not be set.
	 *
	 * @param {String} source
	 * @param {String} target
	 * @param {Object} obj1
	 * @param {Object} obj2
	 * @param {Function|Array} mods
	 * @param {Boolean} merge
	 */
	DotObject.prototype.transfer = function (source, target, obj1, obj2, mods, merge) {
	  if (typeof mods === 'function' || Array.isArray(mods)) {
	    this.set(target,
	      _process(
	        this.pick(source, obj1, true),
	        mods
	      ), obj2, merge)
	  } else {
	    merge = mods
	    this.set(target, this.pick(source, obj1, true), obj2, merge)
	  }
	
	  return obj2
	}
	
	/**
	 *
	 * Copy a property from one object to another object.
	 *
	 * If the source path does not exist (undefined)
	 * the property on the other object will not be set.
	 *
	 * @param {String} source
	 * @param {String} target
	 * @param {Object} obj1
	 * @param {Object} obj2
	 * @param {Function|Array} mods
	 * @param {Boolean} merge
	 */
	DotObject.prototype.copy = function (source, target, obj1, obj2, mods, merge) {
	  if (typeof mods === 'function' || Array.isArray(mods)) {
	    this.set(target,
	      _process(
	        // clone what is picked
	        JSON.parse(
	          JSON.stringify(
	            this.pick(source, obj1, false)
	          )
	        ),
	        mods
	      ), obj2, merge)
	  } else {
	    merge = mods
	    this.set(target, this.pick(source, obj1, false), obj2, merge)
	  }
	
	  return obj2
	}
	
	function isObject (val) {
	  return Object.prototype.toString.call(val) === '[object Object]'
	}
	
	/**
	 *
	 * Set a property on an object using dot notation.
	 *
	 * @param {String} path
	 * @param {Mixed} val
	 * @param {Object} obj
	 * @param {Boolean} merge
	 */
	DotObject.prototype.set = function (path, val, obj, merge) {
	  var i
	  var k
	  var keys
	  var key
	
	  // Do not operate if the value is undefined.
	  if (typeof val === 'undefined') {
	    return obj
	  }
	  keys = parsePath(path, this.seperator)
	
	  for (i = 0; i < keys.length; i++) {
	    key = keys[i]
	    if (i === (keys.length - 1)) {
	      if (merge && isObject(val) && isObject(obj[key])) {
	        for (k in val) {
	          if (val.hasOwnProperty(k)) {
	            obj[key][k] = val[k]
	          }
	        }
	      } else if (merge && Array.isArray(obj[key]) && Array.isArray(val)) {
	        for (var j = 0; j < val.length; j++) {
	          obj[keys[i]].push(val[j])
	        }
	      } else {
	        obj[key] = val
	      }
	    } else if (
	      // force the value to be an object
	      !obj.hasOwnProperty(key) ||
	      (!isObject(obj[key]) && !Array.isArray(obj[key]))
	    ) {
	      // initialize as array if next key is numeric
	      if (/^\d+$/.test(keys[i + 1])) {
	        obj[key] = []
	      } else {
	        obj[key] = {}
	      }
	    }
	    obj = obj[key]
	  }
	  return obj
	}
	
	/**
	 *
	 * Transform an object
	 *
	 * Usage:
	 *
	 *   var obj = {
	 *     "id": 1,
	  *    "some": {
	  *      "thing": "else"
	  *    }
	 *   }
	 *
	 *   var transform = {
	 *     "id": "nr",
	  *    "some.thing": "name"
	 *   }
	 *
	 *   var tgt = dot.transform(transform, obj)
	 *
	 * @param {Object} recipe Transform recipe
	 * @param {Object} obj Object to be transformed
	 * @param {Array} mods modifiers for the target
	 */
	DotObject.prototype.transform = function (recipe, obj, tgt) {
	  obj = obj || {}
	  tgt = tgt || {}
	  Object.keys(recipe).forEach(function (key) {
	    this.set(recipe[key], this.pick(key, obj), tgt)
	  }.bind(this))
	  return tgt
	}
	
	/**
	 *
	 * Convert object to dotted-key/value pair
	 *
	 * Usage:
	 *
	 *   var tgt = dot.dot(obj)
	 *
	 *   or
	 *
	 *   var tgt = {}
	 *   dot.dot(obj, tgt)
	 *
	 * @param {Object} obj source object
	 * @param {Object} tgt target object
	 * @param {Array} path path array (internal)
	 */
	DotObject.prototype.dot = function (obj, tgt, path) {
	  tgt = tgt || {}
	  path = path || []
	  Object.keys(obj).forEach(function (key) {
	    if (Object(obj[key]) === obj[key]) {
	      return this.dot(obj[key], tgt, path.concat(key))
	    } else {
	      tgt[path.concat(key).join(this.seperator)] = obj[key]
	    }
	  }.bind(this))
	  return tgt
	}
	
	DotObject.pick = wrap('pick')
	DotObject.move = wrap('move')
	DotObject.transfer = wrap('transfer')
	DotObject.transform = wrap('transform')
	DotObject.copy = wrap('copy')
	DotObject.object = wrap('object')
	DotObject.str = wrap('str')
	DotObject.set = wrap('set')
	DotObject.del = DotObject.remove = wrap('remove')
	DotObject.dot = wrap('dot')
	
	;['override', 'overwrite'].forEach(function (prop) {
	  Object.defineProperty(DotObject, prop, {
	    get: function () {
	      return dotDefault.override
	    },
	    set: function (val) {
	      dotDefault.override = !!val
	    }
	  })
	})
	
	Object.defineProperty(DotObject, 'useArray', {
	  get: function () {
	    return dotDefault.useArray
	  },
	  set: function (val) {
	    dotDefault.useArray = val
	  }
	})
	
	DotObject._process = _process
	
	module.exports = DotObject;


/***/ }
/******/ ]);
//# sourceMappingURL=application.bundle.js.map