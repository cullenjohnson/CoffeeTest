define (require) ->
    require 'backbone'

    Answer = require 'models/Answer'

    class AnswerSet extends Backbone.Collection
        model: Answer

        sync: (method, collection, options) =>
            sync: (method, collection, options) ->
            options = options || {}
            options.fileName = options.fileName || 'data/answers1.json'

            if method == 'read'
                $.ajax(
                    options.fileName,
                    {
                        cache: true,
                        complete: (jqXHR, textStatus) =>
                            if options.success? and jqXHR.responseJSON? and jqXHR.responseJSON.answers?
                                options.success(jqXHR.responseJSON.answers)
                            else if options.error?
                                options.error('The answers file on the server is invalid.')

                        error: (jqXHR, textStatus, errorThrown) =>
                            options.error('An error occurred while attempting to read the answers file.') if options.error?
                            console.error("AnswerSet.fetch(): #{textStatus}; #{errorThrown}")
                    }
                )