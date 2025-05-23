let
    // Replace this line with your original UTC time
    DateUTC = DateTime.From(DateTimeZone.UtcNow()),
    
    // Convert to datetime (in case it came as date)
    DateUTC_DT = DateTime.From(DateUTC),
    Year = Date.Year(DateUTC_DT),
    
    // Last Sunday of March
    LastSundayMarch = Date.AddDays(#date(Year, 3, 31), - Date.DayOfWeek(#date(Year, 3, 31), Day.Sunday)),
    
    // Last Sunday of October
    LastSundayOctober = Date.AddDays(#date(Year, 10, 31), - Date.DayOfWeek(#date(Year, 10, 31), Day.Sunday)),
    
    // Compare as datetime
    SummerStart = #datetime(Year, 3, Date.Day(LastSundayMarch), 1, 0, 0),
    SummerEnd = #datetime(Year, 10, Date.Day(LastSundayOctober), 1, 0, 0),
    InSummerTime = DateUTC_DT >= SummerStart and DateUTC_DT < SummerEnd,
    
    // Convert to datetimezone before changing zone
    DateUTC_Zone = DateTimeZone.From(DateUTC_DT),
    // Apply offset according to whether it is summer time or not
    MadridTime = if InSummerTime
        then DateTimeZone.SwitchZone(DateUTC_Zone, 2)
        else DateTimeZone.SwitchZone(DateUTC_Zone, 1)
in
    MadridTime
