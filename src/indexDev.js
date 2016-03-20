'use strict';

require("basscss/css/basscss.css");
require("./app.css");

var Elm = require('./MainDev.elm');
var mountNode = document.getElementById('main');

var app = Elm.embed(Elm.MainDev, mountNode, { 
        swap: false, 
        initialWindowDimensions: [
          document.body.clientWidth,
          window.innerHeight
        ]
      });
