# Coffee Test
A client-side 4-question true/false quiz single-page web app.

## Technologies used:
- Coffeescript
- Backbone.js
- Require.js
- mustache.js
- Stylus
- Grunt
- HTML5
- CSS3

## Requirements

- Single-page app
- A test with 4 true/false questions. 
- Only one question should be made visible to the user at a time.
- Results can be stored on the client; server-side code is not necessary.
- Examples of JSON for questions and answers below:

<pre>
    {
        "questions": [
            { "id": 1, "text": "Tim Berners-Lee invented the Internet."},
            { "id": 2, "text": "Dogs are better than cats."},
            { "id": 3, "text": "Winter is coming."},
            { "id": 4, "text": "Internet Explorer is the most advanced browser on Earth."}
        ]
    }
    {
        "answers": [
            { "id": 1, "selected": true},
            { "id": 2, "selected": false},
            { "id": 3, "selected": true},
            { "id": 4, "selected": false}
        ]
    }
</pre>