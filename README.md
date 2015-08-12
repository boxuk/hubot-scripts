# hubot-taphouse

Service | Status
--------|-----
Travis CI  | [![Build Status](https://travis-ci.org/boxuk/hubot-taphouse.svg?branch=master)](https://travis-ci.org/boxuk/hubot-taphouse)

Gets the latest beers and their stats from the taphouse beerboard.

## Installation

In hubot project repo, run:

`npm install hubot-taphouse --save`

Then add **hubot-taphouse** to your `external-scripts.json`:

```json
["hubot-taphouse"]
```

## Example

```
user1>> @hubot what beers are available?
Hubot> Hey there!
At the taphouse on tap we have:
(beer) Charlie Brown, Thornbridge, 6.2%, £2.45 ½, Specialty, (goldstar)(goldstar)(goldstar)
Cheers! (beer)
```
