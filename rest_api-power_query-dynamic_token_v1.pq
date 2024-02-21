() =>
let
    url = "https://login.microsoftonline.com/{tenant_ID}/oauth2/v2.0/token",
    tokenResponse = Json.Document(
        Web.Contents(
            url,
            [
                Headers = [#"Accept"="application/json",
                #"Content-Type"="application/x-www-form-urlencoded;charset=UTF-8"],
                Content = Text.ToBinary("grant_type=client_credentials&client_id={your_clientID}&client_secret={secret}&resource={your_resource_url}")
            ]
        )),
        acces_token = tokenResponse[access_token]
        in
        acces_token