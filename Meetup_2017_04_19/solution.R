#########################################################################################
## TELEPITES
## 
## Az alabbi csomagot kell telepiteni es betolteni: ggplot2
## Telepites: Packages -> Install -> ggplot2
#########################################################################################

## 1.1 Csomag betoltese
library(ggplot2)

#########################################################################################
## BEOLVASAS
##
## Honnan lett adatunk? http://www.oecd.org/pisa/data/2015database/
## Adattranszformacios szkript: transform.R
## Oszlopnevek magyarazata: http://www.oecd.org/pisa/data/2015database/Codebook_CMB.xlsx
#########################################################################################

## 2.1 Adat beolvasasa
adat <- read.csv("pisa_hun_small.csv")

#########################################################################################
## FELDERITES
#########################################################################################

## 3.1 Milyen valtozoink vannak egyaltalan?
colnames(adat)

## 3.2 Ezek milyen tipusuak?
summary(adat)

#########################################################################################
## VIZUALIZACIOS ALAPOK GGPLOT2-VEL
## 
## Megprobalunk oda eljutni, hogy nagyjabol ertsuk, mirol van szo itt:
## https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
#########################################################################################

#########################################################################################
## SCATTERPLOTOK
#########################################################################################

## 4.1 Hogyan neznek ki a matematikai es szovegertes pontszamok?
## Mi kell hozza?
## Adat + x tengely + y tengely

ggplot(adat) +
  geom_point(aes(x = PontMat, y = PontSzovegertes))


## 4.2 Hogyan teljesitenek a lanyok es a fiuk? Szinezzuk be a pontokat!
ggplot(adat) +
  geom_point(aes(x = PontMat, y = PontSzovegertes, col = Nem))

## 4.3 Szamit a szamitogepek szama otthon? Szinezzuk be a pontokat!
ggplot(adat) +
  geom_point(aes(x = PontMat, y = PontSzovegertes, col = SzamitogepekOtthon))

## 4.4 Egymasra masznak a pontok: probaljunk halvanyitani!
ggplot(adat) +
  geom_point(aes(x = PontMat, y = PontSzovegertes, col = SzamitogepekOtthon), alpha = 0.25)

## 4.5 Meg mindig nem latszik rendesen: szedjuk szet kulonbozo kis abrakra!
ggplot(adat) +
  geom_point(aes(x = PontMat, y = PontSzovegertes, col = Nem), alpha = 0.25) +
  facet_wrap(~Nem)

## 4.6 Csinaljuk meg ugyanezt a szamitogepek szama szerint!
ggplot(adat) +
  geom_point(aes(x = PontMat, y = PontSzovegertes, col = SzamitogepekOtthon)) +
  facet_wrap(~SzamitogepekOtthon)

## 4.7 Onallo feladat: deritsuk ki, mit mond az iskola tipusa!
## Szinezzuk be a pontokat az IskolaTipusa valtozo szerint 
## es/vagy szedjuk szet a valtozo szerint pici abrakra!
ggplot(adat) +
  geom_point(aes(x = PontMat, y = PontSzovegertes, col = IskolaTipusa)) +
  facet_wrap(~IskolaTipusa)

#########################################################################################
## Elmeleti kitekintes:
## 1. a ggplot2 retegezett strukturat hasznal, szetvalasztja az adatot a megjelenitestol
## 2. a facet jellegu vizualizaciokat a szakma "small multiples"-nek hivja, eleg elterjedt
## 3. Okolszabaly: minden, ami aes()-en belul van, az adatfuggo, minden, ami
## azon kivul, az altalanosan alkalmazott.
#########################################################################################

#########################################################################################
## Gyakorlati kitekintes:
## 1. sokat masolgatunk: Ctrl + C a masolasra es Ctrl + V a beillesztesre nagyon hasznos
## 2. nyugodtan bizzuk ra magunkat a fejlesztokornyezetre: Tab (es elvileg a Ctrl + Space)
## kombinacio szepen kiegesziti, amit mondani akarunk es segit a parameterezesben is
## 3. Elobb-utobb biztosan dokumentaciot kell olvasnunk, szerencsere eleg jo:
## http://docs.ggplot2.org/current/
#########################################################################################

#########################################################################################
## HISTOGRAMOK ES SURUSEGABRAK
#########################################################################################

## 5.1 Hogyan neznek ki a termeszettudomanyos pontszamok?
ggplot(adat) +
  geom_histogram(aes(x = PontTermTud))

## 5.2 Esetleg ennel jobb felbonassal? Allitsuk az oszlopszelesseget 5-re!
ggplot(adat) +
  geom_histogram(aes(x = PontTermTud), binwidth = 5)

## 5.3 Simitsuk ki a gorbet! Keszitsunk egy surusegabrat!
ggplot(adat) +
  geom_density(aes(x = PontTermTud))


## 5.4 Hasonlitsuk megint ossze a fiukat es a lanyokat!
## Itt a gorbe alatti teruletet akarjuk szinezni, nem pedig a gorbet magat,
## igy itt fillt hasznaljunk, ne clort!
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = Nem))

## 5.5. Hat ezek jol egymasra masznak. :( 
## Hivjuk segitsegul az alpha opciot!
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = Nem), alpha = 0.5)

## 5.6 Onallo feladat: Hasonlitsuk ossze a termeszettudomanyos pontszamokat
## iskolatipus szerint
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = IskolaTipusa), alpha = 0.5)

#########################################################################################
## HALADO ESZTETIKAI RESZLETEK
## 
## Hogyan nezhetnenek ki ezek az abrak kevesbe rosszul?
#########################################################################################

#########################################################################################
## SCALES
#########################################################################################

## 6.1 Az nem szimpatikus, hogy a fiuk pirosak, a lanyok pedig kekek,
## csereljuk meg a szineket a scale_fill_manual fuggvennyel!
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = Nem), alpha = 0.5) +
  scale_fill_manual(values = c("darkblue", "darkred"))

## 6.2 Mi van, ha nem akarunk pepecselni a szinekkel, csak szeretnenk
## valami beepitettet?
## Nezzuk meg peldaul a colorbrewert:
## http://colorbrewer2.org/#type=qualitative&scheme=Dark2&n=3
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = IskolaTipusa), alpha = 0.5) +
  scale_fill_brewer(palette = "Dark2")

## 6.3 Modositsuk az x tengely feliratat!
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = IskolaTipusa), alpha = 0.5) +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "A magyar iskolasok termeszettudomanyos pontszamai")

#########################################################################################
## THEMES
#########################################################################################

## 7.1 Modositsunk valami altalanosat!
## Noveljuk meg az x tengely betumeretet es szinet!
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = IskolaTipusa), alpha = 0.5) +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "A magyar iskolasok termeszettudomanyos pontszamai") +
  theme(axis.text.x = element_text(size = 19, color = "darkred"))

## 7.2 Tegyuk at mashova a legendet!
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = IskolaTipusa), alpha = 0.5) +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "A magyar iskolasok termeszettudomanyos pontszamai") +
  theme(axis.text.x = element_text(size = 19, color = "darkred"),
        legend.position = "bottom")

## 7.3 Szabaduljunk meg ettol a csunya szurke hattertol mondjuk egy black and white
## temaval! 
## Vigyazz: a theme_* fuggvenyek felulirjak a modositasokat, ugyhogy az osszes
## theme() hivas elott kell alkalmaznunk
ggplot(adat) +
  geom_density(aes(x = PontTermTud, fill = IskolaTipusa), alpha = 0.5) +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "A magyar iskolasok termeszettudomanyos pontszamai") +
  theme_classic() +
  theme(axis.text.x = element_text(size = 19, color = "darkred"),
        legend.position = "bottom")
  
#########################################################################################
## Megjegyzesek
## 1. Rengeteg geometriai beallitas van es ezek kombinalhatoak is
## 2. Most csak az egyertelmuen numerikus es egyertelmuen diszkret ertekekkel foglalkoztunk
## de a fenti geomoknak persze megvan a megfelelo kiterjesztese is.
## 3. Hala es koszonet a smarterpoland blognak, akiktol az adatbeolvasast lestem el:
## https://www.r-bloggers.com/pisa-2015-how-to-readprocessplot-the-data-with-r/
#########################################################################################
