# rupturesRcpp

Offline change-point detection for multivariate time series in R.

`rupturesRcpp` finds the times at which the behaviour of a series
changes: its mean, its variance, its autocorrelation, or its
relationship with covariates. It brings the cost functions and search
methods of the Python library
[ruptures](https://centre-borelli.github.io/ruptures-docs/) to R, with a
C++ core and an R6 interface.

Every detection combines a cost function, a segmentation method and a
penalty. The code below finds the change in mean and variance in two
simulated series.

``` r
library(rupturesRcpp)

set.seed(1)
tsMat = cbind(c(rnorm(100, 0), rnorm(100, 5, 5)),
              c(rnorm(100, 0), rnorm(100, 5, 5)))

binSegObj = binSeg$new(costFunc = costFunc$new("SIGMA"))
binSegObj$fit(tsMat)
binSegObj$predict(pen = 100)
#> [1] 100 200

binSegObj$plot(d = 1:2)
```

![Two simulated series, each split into two shaded segments at the
change-point t = 100 found by binary segmentation.](home-detection.png)

[Get
started](https://edelweiss611428.github.io/rupturesRcpp/articles/getting-started.md)
