------------
# DAX QUERY
------------
DEFINE
    VAR __DS0Core =
        FILTER (
            SUMMARIZECOLUMNS (
                'Dim_BU'[BU],
                'Dim_Heading'[Heading],
                'Dim_Heading'[Order],
                'Master_Data_AOCD1'[Capital generation],
                'Dim_Date'[Year],
                'Dim_Date'[Quarter],
                'Dim_Date'[YearQQ],
                'Dim_Date'[Month],
                'Dim_Date'[YearMth],
                "Total_Act", 'Measures Table'[Total Act],
                "Total_Plan", 'Measures Table'[Total Plan]
            ),
            ( 'Dim_Date'[Year] = @YearParameter
                && 'Dim_Date'[Quarter] = @QuarterParameter )
        )
    VAR __DS0BodyLimited =
        TOPN (
            500000,
            __DS0Core,
            'Dim_BU'[BU], 1,
            'Dim_Heading'[Order], 1,
            'Dim_Heading'[Heading], 1,
            'Master_Data_AOCD1'[Capital generation], 1,
            'Dim_Date'[Year], 1,
            'Dim_Date'[Quarter], 1,
            'Dim_Date'[YearQQ], 1,
            'Dim_Date'[Month], 1,
            'Dim_Date'[YearMth], 1
        )

EVALUATE
__DS0BodyLimited
ORDER BY
    'Dim_BU'[BU],
    'Dim_Heading'[Order],
    'Dim_Heading'[Heading],
    'Master_Data_AOCD1'[Capital generation],
    'Dim_Date'[Year],
    'Dim_Date'[Quarter],
    'Dim_Date'[YearQQ],
    'Dim_Date'[Month],
    'Dim_Date'[YearMth]

----------------
# Macro - Module
----------------
Sub Macro1()
    ' Select the range of the table
    Range("CapitalDashboardTable").Select

    ' Get the values of the parameters from the Excel sheet
    Dim DaxQuery As String
    Dim YearParam As String
    Dim QuarterParam As String

    ' Retrieve the DAX query text and parameter values
    DaxQuery = Range("DaxQuery").Text
    YearParam = Range("YearParameter").Text
    QuarterParam = """" & Range("QuarterParameter").Text & """"

    ' Replace both parameters in the DAX query
    DaxQuery = Replace(DaxQuery, "@YearParameter", YearParam)
    DaxQuery = Replace(DaxQuery, "@QuarterParameter", QuarterParam)

    ' Update the QueryTable command text and refresh the query
    With Selection.ListObject.QueryTable
        .CommandText = DaxQuery
        .Refresh BackgroundQuery:=False
    End With
End Sub

----------------
# Macro - Sheet1
----------------
Private Sub Worksheet_Change(ByVal Target As Range)
    ' Declare the ranges for the two parameter cells
    Dim QuarterCell As Range
    Dim YearCell As Range

    ' Set the ranges for the quarter and year parameters
    Set QuarterCell = Range("QuarterParameter") ' Cell for the quarter parameter
    Set YearCell = Range("YearParameter") ' Cell for the year parameter

    ' Check if the changed cell is either the quarter or year parameter cell
    If Not Application.Intersect(QuarterCell, Target) Is Nothing Or _
       Not Application.Intersect(YearCell, Target) Is Nothing Then

        ' Call the macro to update the query with both parameters
        Call Macro1

    End If
End Sub
  
