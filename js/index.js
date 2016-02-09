var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
}));

var fs = require('fs');
var dbConfiguration = JSON.parse(fs.readFileSync("dbconfig.json"));

var mysql = require('mysql');
var db = mysql.createConnection(dbConfiguration);

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get("/rate/all/certs/:period", function(req, res) {
  var hourPeriod = req.params.period || 6;
  var query=`SELECT
    MIN(c.notBefore) AS date,
    COUNT(1) AS numIssued,
    COUNT(1) / (60*?) AS issuedPerMinute,
    i.commonName as issuer
FROM
    certificate AS c
JOIN issuer as i ON c.issuerID = i.issuerID
WHERE
    c.notBefore BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW()
GROUP BY i.commonName, DAY(c.notBefore), HOUR(c.notBefore) DIV ?
ORDER BY date DESC;`;

  db.query(query, [hourPeriod, hourPeriod], function(err, results){
    if (err) {
      console.log("Could not query: %s", err);
      res.status(400).end();
      return;
    }
    // Skip first result, it's unreliable
    results.shift();

    res.send(results);
  });
})

var server = app.listen(9000, function() {
  var host = server.address().address;
  var port = server.address().port;

  console.log('example app listening at http://%s:%s', host, port);
});
