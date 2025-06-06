const express = require('express');
     const app = express();
     const port = 3001;

     app.get('/', (req, res) => {
       res.send('Welkom by die Prod4 agterkant!');
     });

     app.listen(port, () => {
       console.log(`Bediener loop op http://localhost:${port}`);
     });