var AlchemyAPI = require('./alchemyapi');
var alchemyapi = new AlchemyAPI();
var url = "https://api.stackexchange.com/2.2/advanced-search#order=desc&sort=activity&tagged=alchemyapi&filter=withbody&site=stackoverflow"

function httpGet(url){
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.open( "GET", url);
        xmlHttp.send( null );
	getParse = JSON.parse(xmlHTTP.responseText);
	for (i = 0; i < 30; i++) {
		
		alchemyapi.sentiment("text", getParse.items[i].body, {}, function(response) {
		console.log("Sentiment: " + response["docSentiment"]["type"]);
		});
	}
}

server.listen(8000);

console.log("Server running at http://127.0.0.1:8000/");
