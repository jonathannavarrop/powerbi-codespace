// fx_AjustarHoraEspaña
(date as datetime) as datetime =>
let
    // Convertimos la fecha a un número de zona horaria según DST en España
    year = Date.Year(date),
 
    // Último domingo de marzo
    lastMarchSunday = Date.AddDays(#date(year, 3, 31), -Date.DayOfWeek(#date(year, 3, 31), Day.Sunday)),
 
    // Último domingo de octubre
    lastOctoberSunday = Date.AddDays(#date(year, 10, 31), -Date.DayOfWeek(#date(year, 10, 31), Day.Sunday)),
 
    // Límites del horario de verano
    startDST = #datetime(year, 3, Date.Day(lastMarchSunday), 2, 0, 0),
    endDST = #datetime(year, 10, Date.Day(lastOctoberSunday), 3, 0, 0),
 
    // ¿Está en horario de verano?
    offset = if date >= startDST and date < endDST then 2 else 1,
 
    // Ajustar la hora como suma de duración
    adjustedDate = date + #duration(0, offset, 0, 0)
in
    adjustedDate
