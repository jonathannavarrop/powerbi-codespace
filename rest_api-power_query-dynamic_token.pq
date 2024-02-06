() =>
let
    // Application configuration in Azure AD
    clientId = "dcdb3bea-fdcd-49f5-8c08-0784a2e5254b",
    clientSecret = "KAZ8Q~zV-hf.akCvLPr5L.J2xwWmpFi5w4Qh4b5H",
    tenantId = "9abfb7ef-54d5-4e7d-925d-d9cb1e15fed0",
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