'use strict';

require("basscss/css/basscss.css");
require("./app.css");

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var app = Elm.Main.embed(mountNode);
