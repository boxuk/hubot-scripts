# Description:
#   Gets the latest beers and their stats from the taphouse beerboard.
#   Also injects beer ratings from untapped
#
# Dependencies:
#   "tiny-rebel-web-scraper": "latest"
#
# Commands:
#   hubot what|which beers are on|available - gets the latest beer info from the board
#
# Author:
#   studioromeo
#
# Contributors:
#   tomseldon
#

tinyRebelWebScraper = require('tiny-rebel-web-scraper');

module.exports = (robot) ->

    excuses = [
        'No beers here. Go to the City Arms instead.',
        'Sorry, dunno what\'s on, we\'re all drunk.',
        'ZZZzzz...wha..no, drank it all, try somewhere else...zzzZZZzzzZZZzzz...'
    ]

    robot.respond /(what|which) beers are (on|available)/i, (msg) ->
        tinyRebelWebScraper.getAllDrinks('cardiff')
            .then((drinks) ->
                response = [
                    'Hey there!',
                    'The following drinks are available at Tiny Rebel (Cardiff):'
                ];

                drinks.forEach((drink) ->
                    response.push(
                      '(beer) ' + drink.name + ' [' + drink.brewery + '] - ' + drink.formattedPrice
                    )
                )

                msg.send response.join('\n')
            )
            .catch((error) ->
                console.error(error);
                msg.send msg.random excuses
            );
