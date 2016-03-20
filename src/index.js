'use strict';

require("basscss/css/basscss.css");
require("./app.css");

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var app = Elm.embed(Elm.Main, mountNode, {
        initialWindowDimensions: [
          document.body.clientWidth,
          window.innerHeight
        ]
      });
