() =>
let
    // Application configuration in Azure AD
    clientId = "introduce_your_clientID",
    clientSecret = "introduce_your_clientsecret",
    tenantId = "introduce_your_tenantID",
    resource = "https://analysis.windows.net/powerbi/api/.default",
    
    // Build the request body to obtain the token
    body = [
        grant_type = "client_credentials",
        client_id = clientId,
        client_secret = clientSecret,
        scope = resource
    ],

    // Make the request to Azure AD authentication API
    tokenResponse = Json.Document(
        Web.Contents(
            "https://login.microsoftonline.com/" & tenantId & "/oauth2/v2.0/token",
            [
                Headers = [#"Content-Type"="application/x-www-form-urlencoded"],
                Content = Text.ToBinary(Uri.BuildQueryString(body))
            ]
        )
    ),

    // Get the token from the response
    accessToken = "Bearer " & tokenResponse[access_token]
in
    accessToken