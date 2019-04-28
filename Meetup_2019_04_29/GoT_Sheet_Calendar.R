

# ---- Szükséges csomagok beolvasása ----
library(data.table)
library(stringr)
library(lubridate)
library(googlecalendar)
library(googlesheets)
library(dplyr)
library(rvest)

# GoogleSheet csomag URL
# https://github.com/jennybc/googlesheets

# Google Calendar csomag URL
# https://github.com/benjcunningham/googlecalendar


# ---- Authentikáció a Google fiókhoz, file-hoz ----

# Authentikáció beállítása a Google Sheet-hez
# - Itt fel fog ugrani egy Google bejelentkező ablak, lépjünk be
# - Engedéllyezzük a csomagnak, hogy hozzáférjen a fájlhoz 

auth <- function(workbook_name) {
  # authentikáció - megjelenik a felugró ablak
  gs_ls()
  
  # workbook beolvasása cím alapján
  dt <-  gs_title(workbook_name)
  return(dt)
}

# - beolvassuk a workbook-ot egy objektumba
wb_GoT <- auth('GameOfThrones')


# ---- Sheet tartalmának letöltése  ----

# Adatletöltés a kiválasztott sheet-ről data.table formába
get_data_from_sheet <- function(wb, sheet_name) {
  dt_name <- na.omit(data.table(
      # GoogleSheet adatainak beolvasása
      # - Automatikus formátum felismerés
      #   - literal = True (alapbeállítás)
      # - Kézi formátum megadás
      #   - literal = False
      #   - col_types = cols(col_1 = col_character(), col_2 = col_integer())
      # - beolvasni kívánt oszlopok megadása
      #   - range = cell_cols(1:5)
    gs_read(
      ss = wb,              # a workbook object amit létrehoztunk
      ws = sheet_name,      # sheet neve, amit be szeretnénk olvasni
      col_names = T         # első sor az oszlopok neveit tartalmazza - e
    )
  ))
  return(dt_name)
}

# Epizódlista letöltése
dt_got_seasons <- get_data_from_sheet(wb_GoT, "Episodes")
View(dt_got_seasons)

# Házak listájának letöltése
dt_got_houses <- get_data_from_sheet(wb_GoT, "Houses")
View(dt_got_houses)


# ---- Adatmanipuláció ----

# Az epizódjainkat szeretnénk naptárba tenni, 
# hogy lássuk mikor voltak/lesznek vetítve. 
# Ehhez át kell alakítanunk a dátum formátumát,
# illetve szükségnk van egy time - összetevőre is

# Átnevezzük az oszlopokat, hogy könnyebb legyen dolgozni velük
colnames(dt_got_seasons)
colnames(dt_got_seasons) <- c("num_overall", "num_in_season", "season","title", "air_date")
colnames(dt_got_seasons)

# függvény a dátum átalakítására
#   - szétdaraboljuk a szöveget a " " mentén
#   - eltávolítjuk a vesszőt
split_date_func <- function(date_to_split, num){
    txt = strsplit(date_to_split, " ")[[1]][num]
    txt = gsub(",", "", txt)
    
    return(txt)
}

# A függvényünket használva létrehozzuk a szétdarabolt dátumunkat:
# - év
# - hónap hosszú formában
# - nap => hozzáadunk +1-et, hiszen nálunk már hétfőre esik a vetítés

dt_got_seasons[, c('air_year', 'air_month_long', 'air_day') := 
                 list(
                      mapply(split_date_func, dt_got_seasons$air_date, 3),
                      mapply(split_date_func, dt_got_seasons$air_date, 1),
                      mapply(split_date_func, dt_got_seasons$air_date, 2))
                      ]

View(dt_got_seasons)


# Konvertáljuk át a hónap megnevezésünket a hónap számává
dt_got_seasons[,air_month_num := match(dt_got_seasons$air_month_long, month.name)]
View(dt_got_seasons)

# +1 nap hozzáadása
dt_got_seasons[, air_date_cal := lubridate::ymd(paste(dt_got_seasons$air_year,
                             dt_got_seasons$air_month_num,
                             dt_got_seasons$air_day, sep = "-")) + 1]
View(dt_got_seasons)


# Adjunk hozzá időpontot
# - Mivel az USA-ban 21:00-kor kezdődik az új rész vetítése (Keleti parti idő szerint)
#   ezért mi hajnal 3:00 időpontot használunk 
#   (hiszen Magyarországon az eredeti vetítés hajnal 3-ra esik)

dt_got_seasons[, air_time_strt := "03:00:00"]
dt_got_seasons[, air_time_end := "04:00:00"]
View(dt_got_seasons)



# Google Calendar által használható dátum létrehozása
# a Calendar által használt formátum a következő:
# - "2011-04-17T03:00Z"

make_date_for_cal <- function(date_cal, tm){
  datetime_cal <- str_remove_all(paste(date_cal, "T", tm), " ")
  return(datetime_cal)
}

dt_got_seasons[, air_datetime_cal_strt := mapply(make_date_for_cal, 
                                            dt_got_seasons$air_date_cal,
                                            dt_got_seasons$air_time_strt)]
# Szükségünk van egy vége időpontra is
dt_got_seasons[, air_datetime_cal_end := mapply(make_date_for_cal, 
                                                dt_got_seasons$air_date_cal,
                                            dt_got_seasons$air_time_end)]

View(dt_got_seasons)

# Adat feldúsítás
# házak, helyszínek hozzáadása

setkey(dt_got_houses, "ID")
setkey(dt_got_seasons, "season")

dt_got_cal <- dt_got_houses[dt_got_seasons]
dt_got_cal <- dt_got_cal[,.(ID, House, Seat, Region, 
                            num_overall, num_in_season, title, 
                            air_datetime_cal_strt, air_datetime_cal_end)]
View(dt_got_cal)


# Táblázat visszaírása a egy új lapra a már létező táblázatunkhoz
gs_ws_new(wb_GoT, "GoT_for_calendar", input = dt_got_cal)


#### ---- Calendar műveletek ----

### setting up the Google authentication information 
key <- "104026675371-23co1kktt2pl3lsra9m2321h8p2r6gpt.apps.googleusercontent.com"
secret <- "VL9mibPs38q30QAtJzTEGpsN"

# Authentikáció beállítása a Google Calendar-hoz
# - Itt fel fog ugrani egy Google bejelentkező ablak, lépjünk be
# - Engedéllyezzük a csomagnak, hogy hozzáférjen a naptár alkalmazáshoz 
gc_auth(key = key, secret = secret, new_user = T, cache = F)


# Csináljunk egy új naptárat
# - itt megadhatunk információkat, mint 
#   - location: helyszín
#   - description: leírás a naptárról
#   - timeZone: időzóna megadása
#   - colirId: színkód az eseményekhez

cal_dummy <- gc_new("Dummy")

# nézzük meg mit hoztunk létre
cal_dummy


# így tudjuk módosítani a naptárunkat
cal_dummy <- gc_edit(
  cal_dummy,
  description = "Calendar for testing purposes",
  colorId = "20",
  timeZone =  "Europe/Budapest"
)


# nézzük meg, hogy sikerült-e a módosítás
# az str segítségével részletesebb információkat kapunk
str(cal_dummy)

# listázzuk ki, és tegyük data.table-be az elérhető naptárjainkat
dt_cal <- data.table(gc_ls())
View(dt_cal)


# Hozzunk létre egy dummy eseményt
gc_event_new(x = cal_dummy, 
             start = list(dateTime = "2019-04-29T18:00:00",
                          timeZone = "Europe/Budapest"),
             end = list(dateTime = "2019-04-29T21:00:00", 
                        timeZone = "Europe/Budapest"),
             summary = "Test esemény",
             location = "CEU",
             timeZone = "Europe/Budapest")
             
# Nézzük meg a naptárunkban, hogy létrehoztuk-e

# listázzuk ki az eseményeket a naptárunkban
dt_cal_dummy_events <- data.table(gc_event_ls(cal_dummy))
View(dt_cal_dummy_events)

# Módosítsuk az eseményt, hiszen elírtuk a címét
gc_event_edit(x = gc_event_query(cal_dummy, "Test esemény"), 
              summary = "Teszt Esemény")


# Törljük ki, hiszen csak teszt volt
# - ID alapján -> ki kell nézni a táblázatból
gc_event_delete(
  gc_event_id(cal_dummy, ""))
# - Esemény címe alapján
gc_event_delete(
  gc_event_query(cal_dummy, "Teszt esemény"))


# törölni is tudunk
gc_delete(cal_dummy)

# Ellenőrizzük, hogy tényleg töröltük-e
dt_cal <- data.table(gc_ls())
View(dt_cal)

#### ---- GoT Naptár ----

cal_got <- gc_new(summary = "Game of Thrones Calendar",
                  description = "Calendar for Episodes of Game of Thrones airing time",
                  location = "The 7 Kingdoms",
                  timeZone = 'Europe/Budapest', 
                  colorId = "20")

# Hozzáadjuk az eseményeket az új naptárunkhoz
for (i in 1:nrow(dt_got_cal)) {
  gc_event_new(x = cal_got,
               start = list(
                 dateTime = dt_got_cal$air_datetime_cal_strt[i],
                 timeZone = "Europe/Budapest"), 
               end = list(
                 dateTime = dt_got_cal$air_datetime_cal_end[i],
                 timeZone = "Europe/Budapest"),
               summary = dt_got_cal$title[i],
               description = dt_got_cal$House[i],
               location = paste0(dt_got_cal$Seat[i], " in ", dt_got_cal$Region[i]),
               timeZone = "Europe/Budapest",
               colorId = dt_got_cal$ID[i]
               
  )
}

dt_got_from_cal <- data.table(gc_event_ls(cal_got))
View(dt_got_from_cal)

# Táblázat visszaírása a egy új lapra a már létező táblázatunkhoz
gs_ws_new(wb_GoT, "GoT_cal_info", input = dt_got_from_cal)



#### ---- Frissítsük az eseményeket ----

# Menjünk be az új Google Sheet-be, és kézzel frissítsük az utolsó 4 epizódot
# hiszen ezek már nem 1, hanem 1.5 óra hosszúak

# frissítsük a workbook objektumunkat
wb_GoT <- auth('GameOfThrones')

# olvassuk be a frissíett sorokat
got_update <- gs_read(wb_GoT, 
                      "GoT_for_calendar",
                      range = cell_rows(71:74),
                      col_names = FALSE
                      )

colnames(got_update) <- colnames(dt_got_cal)
View(got_update)

to_update <- c(
  '33gua5lrf7bi54io1nuevqlpn4',
  '4keejmecu0nggbt40jv509n604',
  'tuv6boarm2cljsfir51t8gb5rg',
  'vtb4m2c3bu3scc7magcjggtf4g'
)

for (i in 1:length(to_update)){
  gc_event_edit(x = gc_event_id(cal_got,to_update[i]),
                end = list(
                  dateTime = str_remove_all(paste(strsplit(as.character(got_update$air_datetime_cal_end[i]), split = ' ')[[1]][1],
                                                  "T",
                                                  strsplit(as.character(got_update$air_datetime_cal_end[i]), split = ' ')[[1]][2]),
                                            " "),
                  timeZone = "Europe/Budapest")
                )
  
}
to_update[4]
as.character(got_update$air_datetime_cal_end[1])
strsplit(as.character(got_update$air_datetime_cal_end[1]), split = ' ')[[1]][1]


str_remove_all(paste(strsplit(as.character(got_update$air_datetime_cal_end[1]), split = ' ')[[1]][1],
      "T",
      strsplit(as.character(got_update$air_datetime_cal_end[1]), split = ' ')[[1]][2]),
      " ")
