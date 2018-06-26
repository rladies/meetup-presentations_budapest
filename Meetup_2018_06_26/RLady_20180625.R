# dataMaid package by Claus Ekstrom and Anne Helby Petersen (UCPH Biostatistics)
library(dataMaid)
# allCheckFunctions()
# allSummaryFunctions()
# allVisualFunctions()
# setSummaries()
# setChecks()
# setVisuals()
# vignette("extending_dataMaid")
# check ()
# summarize ()
# visualize ()

#################################################################
#PRESIDATA
################################################################
load(url("http://biostatistics.dk/eRum2018/data/presiData.rda"))

# keressünk hibákat!
head(presiData)
str(presiData)
summary(presiData)

# 1. feladat
# készítsünk egy sztenderd riportot
makeDataReport(presiData,  vol = 2) # replace=TRUE,


###################################################
# TOYDATA
###################################################
# Interaktívan használjuk a dataMaid-et

# egyesével futtathatók a check és summary jellegű parancsok
check(toyData$events)

# vagy beállíthatjuk, hogy pontosan milyen check-et akarunk
check(toyData$events, checks = setChecks(numeric="identifyMissing"))

# ha csak néhány statisztikát akarunk elhagyni az alapbeállításból (akár például a characterekre az identifyLoners)
summarize(toyData$events,
            summaries = setSummaries(
            numeric = defaultNumericSummaries(remove = c("variableType", "countMissing"))))


# térjünk vissza a presiData-hoz, és nézzük meg, hogy hogy tudnánk a riportunkat jobbá tenni!

# 1.formátum: mi szolgálja jobban a céljaimat? doc, pdf, html

# 2.változó formátum: van olyan változónk, amit nem tud kezelni a dataMaid, ezért megmondhatjuk, hogy azt miként kezelje. 
#Itt a komplex számokat sima számként a Name pedig character

# 3. Adhatunk neki címet

makeDataReport(presiData, replace=TRUE, 
               output = "html", 
               treatXasY = list(complex="numeric", Name="character"),
               reportTitle = "Amerikai elnökök - adatriport")

#szabjuk testre, bármely függvényt lehet szerepeltetni (most a summary függvények közül válogattam)

# típusonként
makeDataReport(presiData,replace=TRUE, 
               summaries = setSummaries(numeric=c("variableType", "minMax", "uniqueValues"), 
                                        character = c("countMissing"))) 
#minden változó típusra
makeDataReport(presiData,replace=TRUE, 
               summaries = setSummaries(all = c("variableType", "centralValue"))) 

# mivel sok characterre a factor ellenőrzést is futtatja, mindenhol megkapjuk, hogy egy kategóriában nincs elég megfigyelés ->hagyjuk el
makeDataReport(presiData,replace=TRUE, 
               treatXasY = list(complex="numeric", Name="character"),
               checks = setChecks(character = defaultCharacterChecks(remove="identifyLoners")),
               reportTitle = "Amerikai elnökök - adatriport")
               


# gyorsan javítható hibák
###############################################################
#1. lépés: másoljuk a táblát
data_tofix<-presiData


# 2. lépés: indexálás (ismétlés)
tD<-head(presiData, 3)
# például a 2. sort többféleképp is megkaphatom
> tD[2, ] #indexing
> tD[c(FALSE, TRUE, FALSE), ] #manual logical vector 
> tD[tD$id == 2, ] #informative logical vector
> tD %>% filter(id==2)  # Using tidyverse


# 3. lépés: hibás adatok javítása

# sorszám legyen szám és ne faktor
class(data_tofix$orderOfPresidency) <-"numeric"

# space-ek eltüntetése
data_tofix$lastName[data_tofix$lastName == " Truman"] <- "Truman"

# kisbetű javítás
data_tofix$stateOfBirth[data_tofix$stateOfBirth == "New york"] <- "New York"

# kódoljuk faktorrá aminek csak két értéke lehet
data_tofix$assassinationAttempt <- factor(data_tofix$assassinationAttempt)

# szám legyen a beiktatáskori kor
data_tofix$ageAtInauguration <- as.numeric(data_tofix$ageAtInauguration)

# igénytól függ, hogy a Name vagy a character kellemesebb
class(data_tofix$firstName) <- "character"
class(data_tofix$lastName) <- "character"

# A.A. eltüntetése
# data_tofix<-data_tofix[data_tofix$lastName!="Arathornson", ]
# lehetne úgy is szűrni, mint egy outliert
birthdayOutlierVal <- identifyOutliers(data_tofix$birthday)$problemValues
data_tofix <- data_tofix[data_tofix$birthday != birthdayOutlierVal, ]


# Trump nevének javítása
data_tofix$firstName<-ifelse(data_tofix$lastName=="Trump", "Donald", data_tofix$firstName)

# Obama hivatali ideje
# először megnézzük, hogy kivel van baj
data_tofix[is.na(data_tofix$presidencyYears) | data_tofix$presidencyYears %in% identifyOutliers(data_tofix$presidencyYears)$problemValues,
c("firstName", "lastName", "presidencyYears")]

data_tofix$presidencyYears<-ifelse(data_tofix$lastName=="Obama", 8, data_tofix$presidencyYears)

# 4. lépés: mentsük el egy tiszta fájlba
cleaned_presi<-data_tofix
save(cleaned_presi, file = "presiData_cleaned.rdata")
# NÉZZÜK MEG, HOGY MIT ALKOTTUNK
str(cleaned_presi)                   

makeDataReport(cleaned_presi,replace=TRUE, 
               treatXasY = list(complex="numeric", Name="character"),
               checks = setChecks(character = defaultCharacterChecks(remove="identifyLoners")),
               reportTitle = "Amerikai elnökök - javított adatriport")
               


# Codebook

#praktikus label-ekkel és más attributumokkal ellátni az adatainkat, hogy később is azonosíthatók legyenek
attr(cleaned_presi$presidencyYears, "label") <-   "Full years as president"
attr(cleaned_presi$birthday, "shortDescription") <-  "Dates are stored in YYYY-MM-DD format"
attr(cleaned_presi$assassinationAttempt, "label")<-"Was an assasination attempt against him?"

makeCodebook(cleaned_presi, replace=T)



 