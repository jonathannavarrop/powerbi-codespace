() =>
let
    // Obtener los valores de las celdas en Sheet1, Sheet2 y Sheet3
    clientId = "Sheet1{0}[Column1]",
    clientSecret = "Sheet2{0}[Column1]",
    tenantId = "Sheet3{0}[Column1]",
    resource = "https://analysis.windows.net/powerbi/api/.default",

    // Construir el cuerpo de la solicitud para obtener el token
    body = [
        grant_type = "client_credentials",
        client_id = clientId,
        client_secret = clientSecret,
        scope = resource
    ],

    // Hacer la solicitud a la API de autenticación de Azure AD
    tokenResponse = Json.Document(
        Web.Contents(
            "https://login.microsoftonline.com/" & tenantId & "/oauth2/v2.0/token",
            [
                Headers = [#"Content-Type"="application/x-www-form-urlencoded"],
                Content = Text.ToBinary(Uri.BuildQueryString(body))
            ]
        )
    ),

    // Obtener el token de la respuesta
    accessToken = "Bearer " & tokenResponse[access_token]
in
    accessToken