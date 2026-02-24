#####################################################
Combine rows into a single line separated by (;) 
#####################################################

1) Group all the rows and columns you wish to keep into a single line, then add it as a sum
    = Table.Group(#"Merged Columns", {"First Name", "Last Name"}, 
        {{"Equipment", each List.Sum([Equipment.1]), type text}})	
        
2) Change the code created (List.Sum) to (Text.Combine) by adding (;) as a separator:
    = Table.Group(#"Merged Columns", {"First Name", "Last Name"}, 
        {{"Equipment", each Text.Combine([Equipment.1], "; "), type text}})
