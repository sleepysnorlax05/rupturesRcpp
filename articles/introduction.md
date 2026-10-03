# Introduction

`rupturesRcpp` detects change-points in multivariate time series. A
change-point is a time at which the behaviour of a series changes: its
mean, its variance, its autocorrelation, or its relationship with other
variables. Detection here is offline. The whole series is available at
once, and the goal is the set of change-points that best explains it,
not an alarm raised as new observations arrive.

## The segmentation problem

Take a series $`y_1, \dots, y_n`$ with $`K`$ change-points
$`t_1 < \dots < t_K`$, and set $`t_0 = 0`$ and $`t_{K+1} = n`$. The
change-points split the series into the $`K + 1`$ segments
$`(t_k, t_{k+1}]`$. A cost function $`c(\cdot)`$ scores each segment by
how badly a single model fits it, and the best segmentation for a
penalty $`\lambda \ge 0`$ minimises

``` math
\sum_{k=0}^{K} c\left(y_{(t_k+1):t_{k+1}}\right) + \lambda K.
```

The penalty stops every observation from becoming its own segment: an
extra change-point is only worth adding if it lowers the total cost by
more than $`\lambda`$. When the number of change-points is known in
advance, the penalty is dropped and $`K`$ is fixed instead.

## Three components

Every detection in `rupturesRcpp` combines three choices, and each has
its own chapter:

- a cost function (`costFunc`), which sets the kind of change to look
  for ([Cost
  functions](https://edelweiss611428.github.io/rupturesRcpp/articles/cost-functions.md));
- a segmentation method (`binSeg`, `Window`, `PELT` or `Dynp`), which
  searches for the change-points ([Segmentation
  methods](https://edelweiss611428.github.io/rupturesRcpp/articles/segmentation-methods.md));
- a penalty `pen`, or a number of change-points `nBkps`, which sets how
  many change-points are returned ([Model
  selection](https://edelweiss611428.github.io/rupturesRcpp/articles/model-selection.md)).

The
[Overview](https://edelweiss611428.github.io/rupturesRcpp/articles/overview.md)
puts the three together on simulated data.

## Relation to ruptures

The cost functions and search methods follow the Python library
[ruptures](https://centre-borelli.github.io/ruptures-docs/), whose
methods are reviewed by [Truong, Oudre and Vayatis
(2020)](https://doi.org/10.1016/j.sigpro.2019.107299). `rupturesRcpp`
implements them in C++ with Rcpp and RcppArmadillo, wraps them in R6
classes, and also accepts cost functions written in R (the `"Custom"`
cost). The package was created during Google Summer of Code 2025 for the
R Project for Statistical Computing.

## How to read this guide

The sidebar lists every chapter in reading order. The getting-started
chapters (this one, Installation and Overview) get you running. The user
guide chapters can then be read in any order, and Examples collects
longer worked examples.
