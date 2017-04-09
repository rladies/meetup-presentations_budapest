############################################################################################################################
###### How to get the data?
###### Data file here: http://www.oecd.org/pisa/data/2015database/ (I downloaded the SPSS file)
###### Field names and their descriptions are here: http://www.oecd.org/pisa/data/2015database/Codebook_CMB.xlsx
############################################################################################################################


library("foreign")
library("intsvy")
library("plyr")
library("dplyr")
library("ggplot2")
library("tidyr")


stud2015 <- read.spss("C:/Users/Agnes/Downloads/PUF_SPSS_COMBINED_CMB_STU_QQQ/Cy6_ms_cmb_stu_qqq.sav", use.value.labels = TRUE, to.data.frame = TRUE)

## what do we keep from the fields?
## CTR -- orszagnev
## STRATUM == iskola tipusa
## ST003D02T -- milyen honapban szuletett?
## ST004D01T -- 1: Female, 2: Male
## ST011Q01TA -- van-e sajat asztalod, amin tanulhatsz?
## ST011Q04TA -- van-e szamitogeped otthon?
## ST011Q06TA -- internet
## ST012Q06NA -- hany szamitogep van otthon? Computers (desktop computer, portable laptop, or notebook) None, one, two, three or more
## ST123Q04NA -- My parents encourage me to be confident.
## ST034Q05TA -- Other students seem to like me.
## ST059Q02TA -- Orak szama matek
## ST059Q03TA -- Orak szama science
## ST071Q01NA -- This school year, approximately how many hours per week do you spend learning in addition? <School Science>
## ST071Q02NA -- This school year, approximately how many hours per week do you spend learning in addition? Mathematics
## ST071Q03NA -- This school year, approximately how many hours per week do you spend learning in addition? <Test language>
## IC006Q01TA -- During a typical weekday, for how long do you use the Internet outside of school?
## EC001Q01NA -- Approx how many hrs\week attend add. instruct in the follow. domains? <School science> or <broad science>
## EC001Q02NA -- Approx how many hrs\week attend add. instruct in the follow. domains? Mathematics
## EC001Q03NA -- Approx how many hrs\week attend add. instruct in the follow. domains? <Test language>
## PV1MATH -- Plausible Value 1 in Mathematics
## PV1READ -- Plausible Value 1 in Reading
## PV1SCIE -- Plausible Value 1 in Science

pisa_hun_small <- stud2015 %>%
  filter(CNTRYID == "Hungary") %>%
  select(Orszag = CNT, IskolaTipusa = STRATUM, Nem = ST004D01T,
         SzamitogepekOtthon = ST012Q06NA, OraszamIskolaMat = ST059Q02TA,
         OraszamIskolaTermTud = ST059Q03TA, OraszamOtthonMat = ST071Q02NA,
         OraszamOtthonTermTud = ST071Q01NA, OraszamOtthonNyelv = ST071Q03NA,
         KulonOrakMat = EC001Q01NA, KulonOrakTermTud = EC001Q02NA, KulonOrakNyelv = EC001Q03NA,
         PontMat = PV1MATH, PontSzovegertes = PV1READ, PontTermTud = PV1SCIE) %>%
  mutate(IskolaTipusa = as.character(IskolaTipusa)) %>%
  mutate(IskolaTipusa = gsub(" ", replacement = "", IskolaTipusa)) %>%
  mutate(IskolaTipusa = as.factor(IskolaTipusa)) %>%
  mutate(IskolaTipusa = revalue(IskolaTipusa, c("HUN0001" = "AltIskola",
                                                "HUN0002" = "Gimn4Osztalyos",
                                                "HUN0003" = "Gimn6Osztalyos",
                                                "HUN0004" = "Gimn8Osztalyos",
                                                "HUN0005" = "Szakkozep",
                                                "HUN0006" = "Szakmunkaskepzo"))) %>%
  mutate(Nem = revalue(Nem, c("Female" = "No", "Male" = "Ferfi"))) %>%
  mutate(SzamitogepekOtthon = revalue(SzamitogepekOtthon, c("None" = "0", "One" = "1",
                                             "Two" = "2", "Three or more" = ">=3")))
write.csv(pisa_hun_small, file = "pisa_hun_small.csv", row.names = F)


