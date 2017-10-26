## alappelda: legyen a platform kulonbozo, mondjuk
## desktopon kb. 50%-os open rate,
## mobilon meg mondjuk csak 5%
## a controlban kb. 5% a konverzios rata, a testben kb. 

megkapta: 1000 a controlban, 1000 a tesztben
500 megnyitotta mindkettoben, mindkettoben 400 desktopon, 100 mobilon
Contr: 200 rakattintott az ajanlatra desktopon , 50 mobilon
Test: 100 rakattintott az ajandekra desktopon, 100 mobilon

A controlban tobb vasarlas volt, de kisebb ertekben.
A testben kevesebb vasarlas volt, de nagyob ertekben.

control <- data.frame(category = "Control",
                      opened = c(rep(x = 'Yes', times = 500),
                                 rep(x = 'No', times = 500)),
                      platform = c(rep(x = "Desktop", times = 400),
                                   rep(x = "Mobile", times = 100)),
                      clicked = c(sample(c("Yes", "No"), size = 400,
                                         replace = T, prob = c(0.25, 0.75)),
                                  sample(c("Yes", "No"), size = 100,
                                         replace = T, prob = c(0.66, 0.33))),
                      purcahse_value = rnorm(1000, mean = 40, sd = 40))
control$purcahse_value[control$purcahse_value < 20] <- 0
head(control)
sum(control$purcahse_value)


test <- data.frame(category = "Test",
                      opened = c(rep(x = 'Yes', times = 500),
                                 rep(x = 'No', times = 500)),
                      platform = c(rep(x = "Desktop", times = 400),
                                   rep(x = "Mobile", times = 100)),
                      clicked = c(sample(c("Yes", "No"), size = 400,
                                         replace = T, prob = c(0.25, 0.75)),
                                  sample(c("Yes", "No"), size = 100,
                                         replace = T, prob = c(0.33, 0.66))),
                      purcahse_value = rnorm(1000, mean = 40, sd = 40))
test$purcahse_value[test$purcahse_value < 30] <- 0
head(test)
sum(test$purcahse_value)

full <- rbind(control, test)
