# AMAZON REDSHIFT
  	let
  	    Source = Value.NativeQuery(AmazonRedshift.Database(#"RedshiftHost", #"RedshiftDbName"), 
  	    "select distinct apollointernalclassification, loaddate
  	    from ubs_ods.breakouts_category bc
  	    left outer join risk_reporting_ods.mapping_asset_class mac
  	    on bc.apollointernalclassification = mac.classification 
  	    where mac.classification is null#(lf)
  	    order by 1,2", null,
        [EnableFolding=true])
  	in
      Source
	

# SQL SERVER
    let
        Source = Sql.Database(EntornoServidor, EntornoBBDD,
        [Query= "select distinct Fecha_Maxima_Closed=Max(Dataset)
                from [GDN].[MDL_FACT] (nolock)
                where File_type = 'CLOSED'",
                CreateNavigationProperties=false])
    in
        Source


# SHAREPOINT FOLDER
    let
        Source = SharePoint.Files("URL", [ApiVersion = 15]),
        #"Removed Other Columns" = Table.SelectColumns(Source,{"Content", "Name", "Folder Path"}),
        #"Filtered Rows - Carpeta" = Table.SelectRows(#"Removed Other Columns", each Text.Contains([Folder Path], "URLFolderPath")),
        #"Added Custom - File" = Table.AddColumn(#"Filtered Rows - Carpeta", "File", each Excel.Workbook([Content], true){[Item="Sheet1", Kind="Sheet"]}[Data]),
        #"Expanded File" = Table.ExpandTableColumn(#"Added Custom - File", "File", {"OrderID", "OrderDate", "CustomerName", "Product", "Quantity", "UnitPrice", "Total"}, {"OrderID", "OrderDate", "CustomerName", "Product", "Quantity", "UnitPrice", "Total"}),
        #"Removed Columns" = Table.RemoveColumns(#"Expanded File",{"Content", "Name", "Folder Path"}),
        #"Changed Type" = Table.TransformColumnTypes(#"Removed Columns",{{"OrderID", Int64.Type}, {"OrderDate", type date}, {"CustomerName", type text}, {"Product", type text}, {"Quantity", Int64.Type}, {"UnitPrice", Currency.Type}, {"Total", Currency.Type}})
    in
        #"Changed Type"
