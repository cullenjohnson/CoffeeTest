define (require) ->
    require 'backbone'

    Answer = require 'models/Answer'

    class AnswerSet extends Backbone.Collection
        model: Answer

        # sync: (method, collection, options) =>
        #     options = options || {};
        #     options.fileName = options.fileName || 'data/questions1.json';

        #     if (method == 'read')
        #         $.ajax(
        #             cache: false,
        #             success: (data) =>
        #
        #             error: () =>
        #
        #         )