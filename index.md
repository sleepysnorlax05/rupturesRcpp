# rupturesRcpp

`rupturesRcpp` detects change-points in multivariate time series. It
implements the cost functions and search methods of the Python library
[ruptures](https://centre-borelli.github.io/ruptures-docs/) in C++,
behind an R6 interface, and also accepts cost functions written in R. It
was created during Google Summer of Code 2025 for the R Project for
Statistical Computing.

``` r
install.packages("rupturesRcpp",
                 repos = c("https://edelweiss611428.r-universe.dev",
                           "https://cloud.r-project.org"))
```

This installs the development version that the guide documents; see
[Installation](https://edelweiss611428.github.io/rupturesRcpp/articles/installation.md)
for the CRAN release.

## Guide

### Getting started

1.  [Introduction](https://edelweiss611428.github.io/rupturesRcpp/articles/introduction.md):
    what change-point detection is, and the three choices behind every
    detection.
2.  [Overview](https://edelweiss611428.github.io/rupturesRcpp/articles/overview.md):
    one complete detection, from data to plot.
3.  [Installation](https://edelweiss611428.github.io/rupturesRcpp/articles/installation.md):
    the development version and the CRAN release.

### User guide

4.  [Cost
    functions](https://edelweiss611428.github.io/rupturesRcpp/articles/cost-functions.md):
    the built-in costs, their options, and costs written in R.
5.  [Segmentation
    methods](https://edelweiss611428.github.io/rupturesRcpp/articles/segmentation-methods.md):
    `binSeg`, `Window`, `PELT` and `Dynp`, their methods and active
    bindings.
6.  [Model
    selection](https://edelweiss611428.github.io/rupturesRcpp/articles/model-selection.md):
    choosing the number of change-points with the elbow method or
    `Dynp`.
7.  [Segment costs and
    parameters](https://edelweiss611428.github.io/rupturesRcpp/articles/segment-costs-and-parameters.md):
    `$segments()` and `costFactory`.

### Examples

8.  [Examples and case
    studies](https://edelweiss611428.github.io/rupturesRcpp/articles/examples.md):
    worked examples on simulated data. Case studies on real data are to
    be added.

Every class is documented in the [function
reference](https://edelweiss611428.github.io/rupturesRcpp/reference/index.md),
and in R,
e.g. [`?PELT`](https://edelweiss611428.github.io/rupturesRcpp/reference/PELT.md).

## Getting help

Report bugs or ask questions on the [issue
tracker](https://github.com/edelweiss611428/rupturesRcpp/issues).
