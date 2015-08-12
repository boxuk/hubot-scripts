# Description:
#   Gets the latest beers and their stats from the taphouse beerboard.
#   Also injects beer ratings from untapped
#
# Dependencies:
#   "cheerio": "latest"
#   "q": "latest"
#
# Commands:
#   hubot what|which beers are on|available - gets the latest beer info from the board
#
# Author:
#   studioromeo

cheerio = require('cheerio');
q = require('q');

module.exports = (robot) ->

    excuses = [
      'No beers here. Go to the City Arms instead.',
      'Sorry, dunno what\'s on, we\'re all drunk.',
      'ZZZzzz...wha..no, drank it all, try somewhere else...zzzZZZzzzZZZzzz...'
    ]

    beers = []

    getRating = (msg, query, info) ->
        deferred = q.defer();
        msg.http('https://untappd.com/search?q=' + query).get() (err, res, body) ->
            if (err)
                deferred.reject()
            else
                $ = cheerio.load(body);
                rating = $('.results-container .beer-item:first-child .num');

                rating = rating.text()
                rating = rating.substring(1, rating.length-1)

                message = '';
                $i = 1
                while $i <= Math.round(rating)
                    message += '(goldstar)'
                    $i++

                info.push message unless !message

                beers.push '(beer) ' + info.join(', ');
                deferred.resolve();

        return deferred.promise


    robot.respond /(what|which) beers are (on|available)/i, (msg) ->
        beers = []

        msg.http('http://www.urbantaphouse.co.uk/beer-board').get() (err, res, body) ->
            return res.send res.random excuses if err

            promises = []
            $ = cheerio.load(body);
            boardRows = $(".beer-board > table tr");

            boardRows.each (i, el) ->
                info = [];
                $(this).children().each (i, el) ->
                    info.push $(this).text().trim();

                query = $(this).children(':nth-child(1)').text() + '+%2B+' + $(this).children(':nth-child(2)').text();
                promises.push getRating(msg, query, info)

            q.all(promises).then(() ->
                msg.send "Hey there!\nAt the taphouse on tap we have:\n" + beers.join("\n") + "\nCheers! (beer)";
            ).catch(() ->
                msg.send msg.random excuses
            )
