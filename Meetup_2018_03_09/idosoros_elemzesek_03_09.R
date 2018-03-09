##### Idosoros elemzések keszitese R-ben ######

#Csomagok betöltése:

time_series_packages <- c("tseries", "forecast", "forecastHybrid")

for (i in 1:length(time_series_packages)) {
  if(! (time_series_packages[i] %in% installed.packages())) {
    install.packages(time_series_packages[i])
  }
}

library("tseries")
library("forecast")
library("forecastHybrid")

#Adatok behivasa: 

data <- AirPassengers

##################
#   Alapadatok:  #
##################

AirPassengers

plot.ts(data, main = "Monthly totals of international airline passengers, 1949 to 1960")

is.ts(data)

summary(data)

###########################
#   Idosor-diagnosztika   #
###########################

#Frekvencia:
frequency(data)

#Augmented Dickey-Fuller Test
adf.test(data)

#Autokorrelacio, parcialis autokorrelacio
acf(data)
pacf(data)

diff(data)
diff(diff(data))
acf(diff(data))

#Dekompozicio
decomp <- stl(data, s.window = "periodic")
decomp
plot(decomp)


###################
#   Modellezes    #
###################


# Training- és test setek szétválasztása

train <- ts(data[1:134])
test <- ts(data[135:144])

set.seed(12345)

# 1. AUTO.ARIMA

arima_model <- auto.arima(train)
arima_model

arima_forecast <- forecast(arima_model, h = length(test))

plot(arima_forecast, main = "Results of auro.arima")


# 2. NNETAR

nnetar_model <- nnetar(train)
nnetar_model

nnetar_forecast <- forecast(nnetar_model, h = length(test))

plot(nnetar_forecast, main = "Results of NNETAR")


# 3. hybridModel

hybridModel_model <- hybridModel(train)
hybridModel_model

hybridModel_forecast <- forecast(hybridModel_model, h = length(test))


plot(hybridModel_forecast, main = "Results of hybridModel")

