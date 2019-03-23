###################################################################
#       Kimutatasok - Gombóc Artur Csokoladegyarto Zrt.           #
###################################################################

# A magyar karakterek miatt fontos beallitas: 
options(encoding = "UTF-8")
.Options$encoding

##### Csomagok behivasa #####
library("plyr")
library("dplyr")
library("tidyr")
library("ggplot2")
library("cowplot")


##### Munkakonyvtar beallitasa (ide mentsd az adatokat): #####
setwd("/home/eszter/Documents/R-Ladies 03.28.")
getwd()


##### Adatok beolvasasa: #####
  # Forras: https://sci2s.ugr.es/keel/timeseries.php - NNGC1_dataset_D1_V1_002 atdolgozva
gomboc_adat <- read.table("gomboc_artur_zrt.csv", 
                          sep = ",",
                          header = TRUE, 
                          strip.white = TRUE)

head(gomboc_adat)


##### Datumtipusok beallitasa, datumok formazasa: 
gyar_oszlop <- grepl('gyar', colnames(gomboc_adat))

gomboc_adat[gyar_oszlop] <- lapply(gomboc_adat[gyar_oszlop], function(x) {as.numeric(as.character(x))})

gomboc_adat_kesz <- gomboc_adat %>%
  mutate(datum = as.Date(datum, format = "%Y/%m/%d")) %>% # mert nem az R standard datumformatumaban van
  mutate(datum_rovid = as.Date(datum, format = "%Y-%m")) %>%
  select(c(datum_rovid, starts_with("gyar")))


##### Adatok attekintese: #####

# Adatsor szerkezete (valtozok, megfigyelt idoszakok szama)
str(gomboc_adat_kesz)

# Vannak-e hianyzo adataink?
sapply(gomboc_adat_kesz, function(x) {table(is.na(x))})

# Milyen idopontokrol vannak adataink? Minden idopontra rendelkezunk adatokkal?
min(gomboc_adat_kesz$datum_rovid)
max(gomboc_adat_kesz$datum_rovid)
length(unique(gomboc_adat_kesz$datum_rovid[!is.na(gomboc_adat_kesz$datum_rovid)]))


##### 1. Kerdes: termektípusok abrazolasa gyaregysegenkent + termektipusonkent #####
### Alkalmazott abratipus: stacked bar chart

# FONTOS: "Wide to long" formázás:  http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/

# Aggregálás gyaregysegenkent + termektipusonként, a teljes idoszakra

gyaregyseg_adat <- gomboc_adat_kesz %>%
  gather(., gyar_termek, mennyiseg, gyar1_et:gyar3_feher, factor_key=TRUE) %>% # "wide to long"
  group_by(gyar_termek) %>% 
  summarise(mennyiseg_teljes = sum(mennyiseg)) %>%
  ungroup() %>%
  mutate(gyar = substr(as.character(gyar_termek), 1, 5)) %>%
  mutate(termek = substr(as.character(gyar_termek), 7, nchar(as.character(gyar_termek)))) %>%
  select(gyar, termek, mennyiseg_teljes)

head(gyaregyseg_adat)

# Abrazolas:
  # szinek: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

gyaregyseg_termek_abra <- ggplot(gyaregyseg_adat, aes(x = gyar, y = mennyiseg_teljes, fill = termek, label = mennyiseg_teljes)) + 
  geom_bar(stat = "identity")  +
  geom_text(size = 5, position = position_stack(vjust = 0.5)) +
  ggtitle("Előállított termékek mennyisége és típusa \n gyáregységenként, 2014-2018") +
  theme(plot.title = element_text(size=16, hjust=0.5)) +
  xlab("Gyáregység") +
  ylab("Mennyiség (ezer db.)") +
  scale_fill_manual(values=c("chocolate4", "darkgoldenrod1", "peru"), 
                    name="Terméktípus",
                    breaks=c("et", "feher", "tej"),
                    labels=c("ét", "fehér", "tej"))
  
gyaregyseg_termek_abra


##### 2. Kerdes: eloallitott termektípusok abrazolasa idoben #####
### Alkalmazott abratipus: Grouped line chart

# Aggregalas havonta:

ido_adat <- gomboc_adat_kesz %>%
  gather(., gyar_termek, mennyiseg, gyar1_et:gyar3_feher, factor_key=TRUE) %>% # "wide to long"
  mutate(gyar = substr(as.character(gyar_termek), 1, 5)) %>%
  mutate(termek = substr(as.character(gyar_termek), 7, nchar(as.character(gyar_termek)))) %>%
  group_by(termek, datum_rovid) %>%
  summarize(mennyiseg_idopont = sum(mennyiseg)) %>%
  ungroup()
  
head(ido_adat)

# Abrazolas:

ido_termek_abra <- ggplot(ido_adat, aes(x = datum_rovid, y = mennyiseg_idopont, colour=termek, group = termek)) +
  geom_line() +
  ggtitle("Egyes terméktípusokból előállított mennyiség havonta, \n 2014-2018") +
  theme(plot.title = element_text(size=16, hjust=0.5)) +
  xlab("Idő") +
  ylab("Mennyiség (ezer db.)") +
  scale_color_manual(values=c("chocolate4", "darkgoldenrod1", "peru"),  # Pontosan megnézni, hogy melyik mit jelent!
                    name="Terméktípus",
                    breaks=c("et", "feher", "tej"),
                    labels=c("ét", "fehér", "tej")) +
  scale_x_date(breaks = ido_adat$datum_rovid[seq(1, length(ido_adat$datum_rovid), by = 6)]) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ido_termek_abra 


##### Abrak egyesitese es mentese a cowplot csomaggal #####

kozos_abra <- plot_grid(gyaregyseg_termek_abra, ido_termek_abra)

cim <- ggdraw() + draw_label("Kimutatások 2014-2018", fontface='bold', size = 18)
kozos_abra <- plot_grid(cim, kozos_abra, ncol=1, rel_heights=c(0.1, 1)) 

kozos_abra

save_plot("gomboc_abra.jpg", kozos_abra,
          base_height = 8, base_aspect_ratio = 1.7)

