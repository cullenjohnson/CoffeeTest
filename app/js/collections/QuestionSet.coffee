define (require) ->
    require 'backbone'

    Question = require 'models/Question'

    class QuestionSet extends Backbone.Collection
        model: Question

        sync: (method, collection, options) ->
            options = options || {}
            options.fileName = options.fileName || 'data/questions1.json'

            if method == 'read'
                $.ajax(
                    options.fileName,
                    {
                        cache: true,
                        complete: (jqXHR, textStatus) =>
                            if options.success? and jqXHR.responseJSON? and jqXHR.responseJSON.questions?
                                options.success(jqXHR.responseJSON.questions)
                            else if options.error?
                                options.error('The questions file on the server is invalid.')

                        error: (jqXHR, textStatus, errorThrown) =>
                            debugger
                            options.error('An error occurred while attempting to read the questions file.') if options.error?
                            console.error("QuestionSet.fetch(): #{textStatus}; #{errorThrown}")
                    }
                )