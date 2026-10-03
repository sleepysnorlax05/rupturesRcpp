# Installation

`rupturesRcpp` has a development version and a CRAN release. This guide
documents the development version.

## Development version

r-universe builds the development version from the `main` branch on
GitHub, with binaries for Windows, macOS and Linux, so no compiler is
needed:

``` r
install.packages("rupturesRcpp",
                 repos = c("https://edelweiss611428.r-universe.dev",
                           "https://cloud.r-project.org"))
```

To build it from source instead, you need a C++ toolchain: Rtools on
Windows, or the Xcode command line tools on macOS.

``` r
# install.packages("remotes")
remotes::install_github("edelweiss611428/rupturesRcpp")
```

## CRAN release

``` r
install.packages("rupturesRcpp")
```

The CRAN release (1.0.3) has `binSeg`, `Window` and `PELT` with the
`"L1"`, `"L2"`, `"SIGMA"`, `"VAR"` and `"LinearL2"` costs. The rest of
this guide also uses features that are only in the development version,
so some of its code fails on 1.0.3:

- `Dynp` and `costFactory`;
- the `"LinearSIGMA"`, `"LinearL1"` and `"Custom"` costs;
- `$predict(nBkps = ...)`, `$getHistory()`, `$plotElbow()` and
  `$segments()`.

## Checking the installation

``` r
packageVersion("rupturesRcpp")
#> [1] '2.0.0'
```

The packages `rupturesRcpp` depends on (Rcpp, R6, ggplot2 and patchwork)
are installed with it.
