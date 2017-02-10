// Description:
//   Gets the latest beers and their stats from the taphouse beerboard.
//
// Dependencies:
//   "tiny-rebel-web-scraper": "latest"
//
// Commands:
//   hubot what|which beers are on|available - gets the latest beer info from the board
//   hubot get me drunk - gets the strongest available beer
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

    robot.respond(/(what|which) beers are (on|available) ?(\(sorted by (.+)?\))?/i, function (message) {
        tinyRebelWebScraper.getAllDrinks('cardiff')
            .then((drinks) => {
                const sortField = message.match[4];
                const shouldSort = Boolean(sortField);

                if (shouldSort) {
                    drinks = sortDrinks(drinks, sortField);
                }

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

    robot.respond(/get me drunk/i, function (message) {
        tinyRebelWebScraper.getAllDrinks('cardiff')
            .then((drinks) => {
                // Get the drink with the highest ABV level
                const drink = drinks.reduce((previous, current) => (previous.abv > current.abv) ? previous : current);

                const response = [
                    'Hey there!',
                    'The strongest drink on tap at Tiny Rebel (Cardiff) is:'
                ]
                    .concat(formatDrinks([drink]));

                message.send(response.join('\n'));
            })
            .catch((error) => {
                console.error(error);
                message.send(message.random(excuses));
            });
    });

    /**
     * Sort an array of drinks by the specified sort field.
     *
     * @param {Drink[]} drinks
     * @param {string} sortField
     *
     * @returns {Drink[]}
     */
    function sortDrinks (drinks, sortField) {
        return drinks.sort((a, b) => {
            if (a[sortField] < b[sortField]) {
                return -1;
            }

            if (a[sortField] > b[sortField]) {
                return 1;
            }

            return 0;
        });
    }

    /**
     * Takes an array of drinks (from the web scraper) and parses them into an array
     * of formatted strings, ready to be returned by the robot.
     *
     * @param {Drink[]} drinks
     *
     * @returns {String[]}
     */
    function formatDrinks (drinks) {
        const formattedDrinks = [];

        for (const drink of drinks) {
            let output = `(beer) ${drink.name} [${drink.brewery}] - ${drink.style} - ${drink.formattedAbv} -`;

            if (drink.quantity === 'half') {
                output = `${output} ½`;
            }

            output = `${output} ${drink.formattedPrice}`;

            formattedDrinks.push(output);
        }

        return formattedDrinks;
    }
};
