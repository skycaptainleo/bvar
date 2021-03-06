library(mvtnorm)

to_source <- c(0:99)
sapply(list.files("R"), function(x) {
  if(any(stringr::str_detect(x, as.character(to_source))))
    source(paste0("R/", x))
})


# Simulated data ----------------------------------------------------------

data <- matrix(rnorm(20000), ncol = 2)
lags <- 2
n_draw <- 10000
n_burn <- 0
n_thin <- 1
fcast <- bv_fcast()
verbose <- TRUE
priors <- bv_priors()
mh <- bv_mh()

run1 <- bvar(data, lags, n_draw, n_burn, 1L,
             priors, mh, fcast, bv_irf(), verbose = TRUE)
run2 <- bvar(data, lags, n_draw, n_burn, n_thin,
             fcast = NULL, irf = NULL, verbose = TRUE)
run3 <- bvar(data, lags, 1000, n_burn, n_thin,
             fcast = NULL, irf = NULL, verbose = TRUE)

predict(run1)
predict(run2)
predict(run1, bv_fcast(8L), n_thin = 4L)
run2$fcast <- predict(run2, horizon = 14L)

bv_plot_fcast(run1, vars = c(1, 2))
bv_plot_fcast(run2, vars = c("a"), variables = c("a", "b"))
bv_plot_fcast(run2, vars = c(1))

plot(run1$fcast)
plot(run2$fcast)

run1$fcast$variables <- run2$fcast$variables <- c("a", "b")

plot(predict(run1), vars = c("b"))
plot(predict(run2, conf_bands = 0.5), vars = 2)
plot(predict(run2, conf_bands = c(0.5)))
plot(predict(run2, conf_bands = c(0.49)))
plot(predict(run2, n_thin = 10))

summary(run1$fcast)
summary(predict(run1), vars = 1)
summary(predict(run1, conf_bands = 0.2), vars = 1)
summary(predict(run1, conf_bands = c(0.25)))

predict(run1, newdata = data[2000:nrow(data), ] * rnorm(1, mean = 10))

run1$irf <- irf(run1, horizon = 10L)
run2$irf <- irf(run2)

bv_plot_irf(run1)
bv_plot_irf(run2)

plot(irf(run1, conf_bands = 0.5))

plot(run1$irf)
plot(irf(run2))
plot(irf(run2, conf_bands = 0.5))

summary(irf(run2, conf_bands = 0.01))
summary(run2$irf)

coef(run1)
vcov(run1)
fevd(run1)

coef(run1, 0.1)
vcov(run1, 0.2)
fevd(run1, conf_bands = c(0.1, 0.2))
