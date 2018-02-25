x <- c(1, 2, 3)
y <- c("Jancsi", "Juliska")
z <- c(TRUE, FALSE) 


x <- list("a", TRUE, 1)
y <- list(list("a", "b"),
          list(1, 2))
z <- list("a" = c(1, 2, 3))

x <- data.frame(a = c(1, 2, 3),
                b = c(TRUE, FALSE, FALSE))
                
for(i in c(1:3)) {
  print(x[[2]][i])
}
