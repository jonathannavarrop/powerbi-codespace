# Configuration of the application in Azure AD
$clientId = "dcdb3bea-fdcd-49f5-8c08-0784a2e5254b"
$clientSecret = "KAZ8Q~zV-hf.akCvLPr5L.J2xwWmpFi5w4Qh4b5H"
$tenantId = "9abfb7ef-54d5-4e7d-925d-d9cb1e15fed0"
$scope = "https://analysis.windows.net/powerbi/api/.default"

# Construct the request body to obtain the token
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = $scope
}

# Make the request to Azure AD authentication API
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method Post -Body $body

# Obtain the access token from the response
$accessToken = $tokenResponse.access_token

# Display the access token (you can comment or delete this line after verification)
Write-Host "Access Token: $accessToken"

# URL of the Power BI API you want to query
$url = "https://api.powerbi.com/v1.0/myorg/groups/dc7c2df4-7b7b-4e2b-b91a-f9e9f0969eb8/datasets/d955b6ab-36b4-4db0-87b4-ec32c7e37fc6/refreshes"

# Use the stored access token
try {
    # Make the HTTP GET request with the access token in the headers
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{
        "Authorization" = "Bearer $accessToken"
        "Content-Type"  = "application/json"
    }

    # Convert the response to JSON format
    $jsonResponse = $response | ConvertTo-Json -Depth 100

    # Display the response as JSON
    Write-Host "Response of the GET request:"
    Write-Host $jsonResponse
}
catch {
    Write-Host "Error: $_"
}