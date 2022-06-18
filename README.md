# reports
Report Systems for QBCore by @Cruso#5044
for use disable the report command in qb-adminmenu and add the reports:client:newreport call to qb-radialmenu
```Config.MenuItems = {
   ---add this---
   [3] = {
        id = '_ticket',
        title = 'Тикет',
        icon = 'bell',
      
        type = 'client',
        event = 'reports:client:newreport',
        shouldClose = true
    }
    
}```

