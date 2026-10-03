# 2 Overview

``` r
library(rupturesRcpp)
```

This chapter runs one complete detection. Each step links to the chapter
that covers it in depth.

## Data

Both series below change in mean and variance at $`t = 100`$. `tsMat`
has one row per time point and one column per series.

``` r
set.seed(1)
tsMat = cbind(c(rnorm(100, 0), rnorm(100, 5, 5)),
              c(rnorm(100, 0), rnorm(100, 5, 5)))
```

## Detection

The variance changes as well as the mean, so the `"SIGMA"` cost, which
models both, suits this data ([Cost
functions](https://edelweiss611428.github.io/rupturesRcpp/articles/cost-functions.md)).
Binary segmentation is a fast search method ([Segmentation
methods](https://edelweiss611428.github.io/rupturesRcpp/articles/segmentation-methods.md)).

``` r
binSegObj = binSeg$new(costFunc = costFunc$new("SIGMA"))
binSegObj$fit(tsMat)
binSegObj$predict(pen = 100)
#> [1] 100 200
```

`$predict()` returns the end of each segment, so the last value is
always the number of observations. Here it finds the one change-point at
$`t = 100`$. The penalty `pen` sets how many change-points are kept
([Model
selection](https://edelweiss611428.github.io/rupturesRcpp/articles/model-selection.md)).

## Plot

``` r
binSegObj$plot(d = 1:2)
```

![Two simulated series split into two shaded segments at the detected
change-point, t =
100.](overview_files/figure-html/unnamed-chunk-4-1.png)

[Previous1
Introduction](https://edelweiss611428.github.io/rupturesRcpp/articles/introduction.md)
[Next3
Installation](https://edelweiss611428.github.io/rupturesRcpp/articles/installation.md)
