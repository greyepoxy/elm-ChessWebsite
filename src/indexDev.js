'use strict';

require("basscss/css/basscss.css");

var Elm = require('./MainDev.elm');
var mountNode = document.getElementById('main');

var app = Elm.embed(Elm.MainDev, mountNode, { swap: false });
