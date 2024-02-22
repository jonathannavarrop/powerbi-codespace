let
    // Step 1: Define the list of tables
    Tables = {
        Table1 = Table1,
        Table2 = Table2,
        Table3 = Table3
    },

    // Step 2: Create a table with tables and their column names and types
    ColumnNames = Table.FromRecords(
        List.Transform(
            Record.FieldValues(Tables),
            each {
                [TableName = Text.From(Value.Metadata(_)[Name]), 
                 Columns = Table.Schema(_)[Name], 
                 Types = Table.Schema(_)[Kind]}
            )
        ),

    // Step 3: Expand the list of column names and types for each table
    ExpandColumnNames = Table.ExpandRecordColumn(ColumnNames, "Columns", {"Name"}),
    ExpandTypes = Table.ExpandRecordColumn(ColumnNames, "Types", {"Kind"}),

    // Step 4: Change data type of column names and types to text
    ChangeToText = Table.TransformColumnTypes(ExpandColumnNames,{{"Name", type text}}),
    ChangeToTextTypes = Table.TransformColumnTypes(ExpandTypes,{{"Kind", type text}}),

    // Step 5: Combine tables and Rename columns
    CombineTables = Table.Combine({ChangeToText, ChangeToTextTypes}),
    RenameColumns = Table.RenameColumns(CombineTables,{{"Name", "Column Name"}, {"Kind", "Column Type"}})
in
    RenameColumns
