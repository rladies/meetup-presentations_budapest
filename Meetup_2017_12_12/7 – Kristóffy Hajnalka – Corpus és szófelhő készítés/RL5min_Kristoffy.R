###### 2017. 12. 12. RLadies Meetup 5min talk Kristóffy Hajnalka  ######
###### Szófelhõ készítése ####### 
#### Mire lesz szükségünk? ####
library(tm) # Text Mining Package szöveg tisztításhoz
#library(plyr) # gyakorisági táblából csak adatok kinyeréséhez 
library(RColorBrewer) # színskála, tetszõlegesen helyettesíthetõ
library(wordcloud) # magához a felhõhöz
#ShirleyCh1.txt
#aranycsinalo.txt
#ekezetek.txt

# install.packages("plyr")

# setwd("C:/Users/Hajni/Desktop/Ladies")
setwd("C:/Users/Berta/Google Drive/R-Ladies/2017.12_lightning_talks/Előadások/7 – Kristóffy Hajnalka – Corpus és szófelhő készítés")
#rm(list=ls(all=TRUE))

#### Olvassuk be a Shirley elsõ fejezetét. #### 
## A "." szeparátor mondatokra tagolja a szöveget, 
## hogy ne legyenek olyan hosszú soraink.
text <- scan(file = "ShirleyCh1.txt",encoding = "UTF-8",
             what = character(),sep = ".")
head(text)

#### Rakjuk bele egy corpusba, ami vektort szeretne bemeneti változónak
corpus <- Corpus(VectorSource(text)) 
#### Nézzük meg, sikeres volt-e az átalakítás
inspect(corpus[1:3])

## A tm_map(x, FUN, ...) szövegtranszformációs függvényeket alkalmaz 
## corpusra. 
#### Alakítsuk kisbetûssé az összes szót  
corpus <- tm_map(corpus, tolower) 
#### Távolítsuk el az írásjeleket
corpus <- tm_map(corpus, removePunctuation) 

## Stopwordnek hívjuk azokat a szavakat, amiket nem szeretnénk 
## belefoglalni az elemzésbe. Ezek a szavak sokszor fordulnak elõ, 
## de nem õket keressük, pl. kötõszavak, névelõk. A szokásos 
## stopwordökhöz hozzátehetünk számunkra nem érdekes, az adott
## szövegben túl gyakori, vagy más miatt nem kívánatos szavakat.
## A TM és SnowballC által stopwordlistával támogatott nyelvek kódjai:
## "danish", "dutch", "english", "finnish", "french", "german", 
## "hungarian", "italian", "norwegian", "portuguese", "russian", 
## "spanish", "swedish". 
#### Távolítsuk el a stopwordöket removeWords függvénnyel.
corpus <- tm_map(corpus, removeWords, c(stopwords("english"),"sir"))
inspect(corpus[1:3]) 

## A szótövek keresése még gyerekcipõben jár, angolra sem tökéletes,
#### De kipróbáljuk. :) 
corpus <- tm_map(corpus, stemDocument)
## Ilyen lett: 
inspect(corpus[1:3]) 
## A Document Term Matrix oszlopnevei a szavak, sorai a dokumentumok,
## a mátrix értékei pedig a szavak elõfordulási gyakorisága a 
## dokumentumokban.
#### Készítsünk gyakorisági mátrixot!
dtm = DocumentTermMatrix(corpus)
#### Alakítsuk át a colSums kedvéért, mert az legalább két dimenziós 
## tömböt szeretne majd, ráadásul a data.frame-en a View, és sok 
## numerikus elemzési módszer is mûködik.
allTexts = as.data.frame(as.matrix(dtm)) 
#View(allTexts) 
words=colnames(allTexts) 
freq=colSums(allTexts)

#### Mindebbõl most készítsünk szófelhõt! ####
## A wordcloud változói alapértékekkel: 
## wordcloud(words, : a felhasználandó szavak vektora
## freq,            : a szavakhoz tartozó gyakoriságok vagy súlyok
## scale=c(4,.5),   : betûnagyság a legnagyobbtól a legkisebbig
## min.freq=3,      : milyen gyakoriság fölött kerülnek be a szavak 
## max.words=Inf,   : összesen hány szó kerülhet bele 
##                  (Inf: az összes, ami a többi feltételnek is megfelel)
## random.order=TRUE, : kiíratási sorrend, FALSE = csökkenõ gyakorisággal
## random.color=FALSE,: színek hozzárendelése a palettáról véletlen-e
## rot.per=.1,      : a szavak hány százalékát írjuk hosszába
## colors="black",  : paletta a legritkábbtól a leggyakoribb szóig
## ordered.colors=FALSE,: TRUE= minden szónak elõre megvan a színe 
## use.r.layout=FALSE,: C++ (FALSE) vagy R (TRUE) ütközések feloldásához
## fixed.asp=TRUE,  : aspect ratio azaz kört vagy nem kört szeretnénk
## ...  vfont       : Hershey-féle rajzolt fontok
ee = brewer.pal(11,"Spectral")[c(8,9,10,11)] #display.brewer.all()
wordcloud(words,freq,scale=c(2,.3),colors=ee,min.freq=4,rot.per=0.9,
          random.order=FALSE,random.color=TRUE,vfont=c("serif","italic"))
dd = brewer.pal(11,"RdYlGn")[c(1,2,3,5)]
wordcloud(words,freq,scale=c(2.5,.3),colors=dd,rot.per=.5,
          vfont=c("gothic english","plain"))
hh = brewer.pal(11,"PRGn")[c(2,3,4,5)]
wordcloud(words,freq,scale=c(5,.5),colors=hh,rot.per=0,
          vfont=c("sans serif","bold italic"),random.order=FALSE,fixed.asp=FALSE)
## Annyi warning lesz, amennyi szó nem fért ki a vászonra.
#demo(Hershey)

###### Aranycsináló ######
## A stemming funkció kissé ügyetlen az angol esetében, a
## magyar szótöveket viszont inkább megcsinálom kézzel, ha azt kell. 
## A Document Term Matrix sajnos átrakná más kódolásba az ékezetes 
## betûket, ami nekünk nem jó. Ehelyett próbálkozzunk egy másik 
## gyakoriságszámolóval: 
textT <- scan(file = "aranycsinalo.txt",encoding="ANSI",
              what = character())
sw=c(stopwords("hu"),"lalus","balbinus","philecous")
fmatrixT <- termFreq(textT, control = list(removeNumbers=TRUE,
                                           removePunctuation=TRUE,stopwords=sw,language="hu"))
fmatrixT[1:14] # class(fmatrixT)# is a table. 
wordsT <- rownames(fmatrixT)
wordsT[1:6] 
freqT <- plyr::unrowname(fmatrixT)  # Csak a táblabeli gyakoriságokat veszi át
freqT[1:6]
wordcloud(wordsT,freqT,scale=c(2,.5),colors=ee,vfont=c("script","italic"))
## Megpróbáltam a fontokat variálni, de az elrontotta a karaktereket.
wordcloud(wordsT,freqT,scale=c(2,.05),colors=ee,min.freq=2,random.order=FALSE)

#### Ékezetes teszt ####
## Ami nekem mûködik: a magyar szöveget ANSI kódolásban 
## mentem el, és kiveszem belõle az idézõjeleket.
textB <- read.csv("ekezetek.txt",stringsAsFactors=FALSE)
wdsB <- textB$betu 
freqB <- textB$fr
wdsB
freqB
## és hagyom alapértelmezetten a fontot 
wordcloud(wdsB,freqB,scale=c(2,.5),colors=dd)
wordcloud(wdsB,freqB,scale=c(2,.05),colors=ee,random.color=TRUE)



#### Text sources: Charlotte Brontë: Shirley (University of Adelaide)
####               Erasmus: Az aranycsináló (MEK)
### EOF 