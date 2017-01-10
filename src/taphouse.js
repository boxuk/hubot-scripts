// Description:
//   Gets the latest beers and their stats from the taphouse beerboard.
//
// Dependencies:
//   "tiny-rebel-web-scraper": "latest"
//
// Commands:
//   hubot what|which beers are on|available - gets the latest beer info from the board
//
// Authors:
//   studioromeo
//   tomseldon
//

'use strict';

const tinyRebelWebScraper = require('tiny-rebel-web-scraper');

module.exports = function (robot) {
    const excuses = [
        'No beers here. Go to the City Arms instead.',
        'Sorry, dunno what\'s on, we\'re all drunk.',
        'ZZZzzz...wha..no, drank it all, try somewhere else...zzzZZZzzzZZZzzz...'
    ];

    robot.respond(/(what|which) beers are (on|available)/i, function (message) {
        tinyRebelWebScraper.getAllDrinks('cardiff')
            .then((drinks) => {
                const response = [
                    'Hey there!',
                    'The following drinks are available at Tiny Rebel (Cardiff):'
                ]
                    .concat(formatDrinks(drinks));

                message.send(response.join('\n'));
            })
            .catch((error) => {
                console.error(error);
                message.send(message.random(excuses));
            });
    });

    /**
     * Takes an array of drinks (from the web scraper) and parses them into an array
     * of formatted string, ready to be returned by the robot.
     *
     * @param {Drink[]} drinks
     *
     * @returns {String[]}
     */
    function formatDrinks (drinks) {
        const formattedDrinks = [];

        for (const drink of drinks) {
            let output = `(beer) ${drink.name} [${drink.brewery}] - `;

            if (drink.quantity === 'half') {
                output = `${output} ½`;
            }

            output = `${output} ${drink.formattedPrice}`;

            formattedDrinks.push(output);
        }

        return formattedDrinks;
    }
};
