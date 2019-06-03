/*!
 * coServ TODO example web app.
 * authors: Ben Lue
 * Copyright(c) 2019 Gocharm Inc.
 */
const  config = require('./config.json'),
       coServ = require('coserv')
       

// now initiate & start the server...
coServ.init( config );
coServ.restart();