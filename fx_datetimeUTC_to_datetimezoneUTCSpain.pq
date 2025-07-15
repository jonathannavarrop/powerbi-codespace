// fx_AjustarHoraEspaña_DesdeDateTimeZone
(date as datetimezone) as datetime =>
let
    // Eliminar la zona horaria para trabajar con valores comparables
    localDate = DateTimeZone.RemoveZone(date),
    year = Date.Year(localDate),

    // Último domingo de marzo
    lastMarchSunday = Date.AddDays(#date(year, 3, 31), -Date.DayOfWeek(#date(year, 3, 31), Day.Sunday)),

    // Último domingo de octubre
    lastOctoberSunday = Date.AddDays(#date(year, 10, 31), -Date.DayOfWeek(#date(year, 10, 31), Day.Sunday)),

    // Límites del horario de verano
    startDST = #datetime(year, 3, Date.Day(lastMarchSunday), 2, 0, 0),
    endDST = #datetime(year, 10, Date.Day(lastOctoberSunday), 3, 0, 0),

    // ¿Está en horario de verano?
    offset = if localDate >= startDST and localDate < endDST then 2 else 1,

    // Ajustar la hora como suma de duración
    adjustedDate = localDate + #duration(0, offset, 0, 0)
in
    adjustedDate
