let
  Source = Json.Document(
    Web.Contents(
      "https://api.powerbi.com/v1.0/myorg/groups/{group_id}/datasets/{dataset_id}/refreshes",
      [
        Headers = [
          Authorization =
            let // Get dynamic token
              Query = 
                let
                  clientId = "{client_id}",
                  clientSecret = "{client_secret}",
                  tenantId = "{tenant_id}",
                  resource = "https://analysis.windows.net/powerbi/api/.default",
                  body = [
                    grant_type    = "client_credentials",
                    client_id     = clientId,
                    client_secret = clientSecret,
                    scope         = resource
                  ],
                  tokenResponse = Json.Document(
                    Web.Contents(
                      "https://login.microsoftonline.com/" & tenantId & "/oauth2/v2.0/token",
                      [
                        Headers = [#"Content-Type" = "application/x-www-form-urlencoded"],
                        Content = Text.ToBinary(Uri.BuildQueryString(body))
                      ]
                    )
                  ),
                  accessToken = "Bearer " & tokenResponse[access_token]
                in
                  accessToken
            in
              Query // Get dynamic token
        ]
      ]
    )
  ),
  #"Converted to Table" = Table.FromRecords({Source}),
  #"Expanded value" = Table.ExpandListColumn(#"Converted to Table", "value"),
  #"Expanded value1" = Table.ExpandRecordColumn(
    #"Expanded value",
    "value",
    {
      "requestId",
      "id",
      "refreshType",
      "startTime",
      "endTime",
      "serviceExceptionJson",
      "status",
      "refreshAttempts"
    },
    {
      "value.requestId",
      "value.id",
      "value.refreshType",
      "value.startTime",
      "value.endTime",
      "value.serviceExceptionJson",
      "value.status",
      "value.refreshAttempts"
    }
  ),
  #"Expanded value.refreshAttempts" = Table.ExpandListColumn(
    #"Expanded value1",
    "value.refreshAttempts"
  ),
  #"Expanded value.refreshAttempts1" = Table.ExpandRecordColumn(
    #"Expanded value.refreshAttempts",
    "value.refreshAttempts",
    {"attemptId", "startTime", "endTime", "type", "serviceExceptionJson"},
    {
      "value.refreshAttempts.attemptId",
      "value.refreshAttempts.startTime",
      "value.refreshAttempts.endTime",
      "value.refreshAttempts.type",
      "value.refreshAttempts.serviceExceptionJson"
    }
  ),
  #"Changed Type" = Table.TransformColumnTypes(
    #"Expanded value.refreshAttempts1",
    {
      {"@odata.context", type text},
      {"value.requestId", type text},
      {"value.id", Int64.Type},
      {"value.refreshType", type text},
      {"value.startTime", type datetime},
      {"value.endTime", type datetime},
      {"value.serviceExceptionJson", type text},
      {"value.status", type text},
      {"value.refreshAttempts.attemptId", Int64.Type},
      {"value.refreshAttempts.startTime", type datetime},
      {"value.refreshAttempts.endTime", type datetime},
      {"value.refreshAttempts.type", type text},
      {"value.refreshAttempts.serviceExceptionJson", type text}
    }
  )
in
  #"Changed Type"