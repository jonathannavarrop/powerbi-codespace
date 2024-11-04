# Define the DAX query
"DEFINE
    VAR __DS0Core =
        FILTER (
            SUMMARIZECOLUMNS (
                'Fecha'[Año],
                'Producto'[Categoria],
                ""Ventas____"", 'Ventas'[Ventas (€)]
            ),
            'Fecha'[Año] = @SelectedDate
        )
    VAR __DS0BodyLimited =
        TOPN ( 500000, __DS0Core, 'Fecha'[Año], 1, 'Producto'[Categoria], 1 )

EVALUATE
__DS0BodyLimited
ORDER BY
    'Fecha'[Año],
    'Producto'[Categoria]"


# Create a Macro in Module
  Sub Macro1()
'
' Macro1 Macro
'

'
    Range("SalesDetails").Select
    With Selection.ListObject.QueryTable
        .CommandText = Replace(Range("DaxQuery").Text, "@SelectedDate", Range("SelectedDate").Text)
        .Refresh BackgroundQuery:=False
    End With
End Sub


# Create a Macro in the Sheet that will handle the cell change
Private Sub Worksheet_Change(ByVal Target As Range)
    Dim KeyCells As Range

' The variable KeyCells contains the cells that will
    ' cause an alert when they are changed.
    Set KeyCells = Range("SelectedDate")

If Not Application.Intersect(KeyCells, Range(Target.Address)) _
           Is Nothing Then

            Call Macro1

End If
End Sub
