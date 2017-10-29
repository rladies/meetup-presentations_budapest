
control <- data.frame(category = "Control",
                      opened = c(rep(x = 'Yes', times = 500),
                                 rep(x = 'No', times = 500)),
                      platform = c(rep(x = "Desktop", times = 400),
                                   rep(x = "Mobile", times = 100),
                                   rep(x = NA, times = 500)),
                      clicked = c(sample(c("Yes", "No"), size = 400,
                                         replace = T, prob = c(0.25, 0.75)),
                                  sample(c("Yes", "No"), size = 100,
                                         replace = T, prob = c(0.66, 0.33)),
                                  rep(x = NA, times = 500)),
                      purchase_value = rnorm(1000, mean = 40, sd = 40))
control$purchase_value[control$purchase_value < 20] <- 0
head(control)
sum(control$purchase_value)


test <- data.frame(category = "Test",
                      opened = c(rep(x = 'Yes', times = 500),
                                 rep(x = 'No', times = 500)),
                      platform = c(rep(x = "Desktop", times = 400),
                                   rep(x = "Mobile", times = 100),
                                   rep(x = NA, times = 500)),
                      clicked = c(sample(c("Yes", "No"), size = 400,
                                         replace = T, prob = c(0.25, 0.75)),
                                  sample(c("Yes", "No"), size = 100,
                                         replace = T, prob = c(0.33, 0.66)),
                                  rep(x = NA, times = 500)),
                      purchase_value = rnorm(1000, mean = 40, sd = 40))
test$purchase_value[test$purchase_value < 30] <- 0
head(test)
sum(test$purchase_value)

full <- rbind(control, test)

full$id <- paste0("User ", sample(1:2000, 2000, replace = F))
full <- full[, c(6, 1:5)]

write.csv(full, file = "data/hotels_email.csv", row.names = F)
