CharlesJSONImporter = ->

    @importString = (context, stringToImport) ->

        # Add here your string parsing logic
        # if your input is JSON, you can parse it with:
        inputSessions = JSON.parse(stringToImport)

        # Failure
        if not inputSessions
            # To report an error, just throw a JavaScript Error
            throw new Error("Invalid input format")

        # Create a request group
        # The syntax is: context.createRequestGroup(group_name)
        group = context.createRequestGroup('CharlesJSON Imported Group')

        for session, index in inputSessions
            
            if session.port
                fullUrl = session.scheme + "://" + session.host + ":" + session.port + session.path
            else
                fullUrl = session.scheme + "://" + session.host + session.path

            if session.query
                fullUrl += "?" + session.query

            # Create a request
            # The syntax is: context.createRequest(name, http_method, url)
            request = context.createRequest("Request #{index}", session.method, fullUrl)
            
            if session.request.sizes.body > 0
                request.body = session.request.body.text
            
            # set request headers
            for header in session.request.header.headers
                request.setHeader(header.name, header.value)
            
            # Add the request inside the group
            group.appendChild(request)

        return true

    return

# Set here the identifier of your importer
# the last component must match this file name (e.g. "CharlesJSONImporter.coffee")
CharlesJSONImporter.identifier = "com.luckymarmot.PawExtensions.CharlesJSONImporter"

# Give here a pretty display name to your importer
# this will be displayed in the user interface of Paw
CharlesJSONImporter.title = "Charles JSON Importer"

# supported file extensions
CharlesJSONImporter.fileExtensions = ["chlsj"]

# Don't forget to call `registerImporter` this is how Paw
# knows that you want to register your importer.
registerImporter(CharlesJSONImporter)
