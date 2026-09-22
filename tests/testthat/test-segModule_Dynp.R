#Dynp module

# ========================================================
#         (R) Brute-force exact segmentation (L2)
# ========================================================

# Exhaustively enumerates every (minSize, jump)-admissible segmentation with exactly `nBkps`
# change-points and returns the true minimal L2 cost -- the ground truth `Dynp` is checked against.

R_L2segCost = function(tsMat, bkpts){
  starts = c(0, head(bkpts, -1))
  sum(mapply(function(a,b){
    seg = tsMat[(a+1):b,,drop=FALSE]
    sum(sweep(seg, 2, colMeans(seg), "-")^2)
  }, starts, bkpts))
}

R_bruteForceMin = function(tsMat, minSize, jump, nBkps){
  n = nrow(tsMat)
  grid = unique(c(seq(1, n-1, by = jump)))
  if(nBkps == 0) return(R_L2segCost(tsMat, n))
  if(nBkps > length(grid)) return(Inf)
  combos = combn(grid, nBkps, simplify = FALSE)
  best = Inf
  for(cb in combos){
    pts = c(0, sort(cb), n)
    if(any(diff(pts) < minSize)) next
    cost = R_L2segCost(tsMat, pts[-1])
    if(cost < best) best = cost
  }
  best
}

# ========================================================
#                   Simulated dataset
# ========================================================

set.seed(7)
n = 24
tsMat = as.matrix(c(rnorm(12,0,1), rnorm(12,6,1)))


test_that("Dynp$costPath() matches brute-force exact minima for every k (L2, minSize=2, jump=1)", {

  dynp = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  expect_message(dynp$fit(tsMat), "using the maximum feasible value")

  expect_equal(dynp$describe()$resolvedNBkpsMax, n %/% 2L - 1L)

  cp = dynp$costPath()
  expect_length(cp, dynp$describe()$resolvedNBkpsMax + 1L)

  for(k in 0:5){
    expect_equal(cp[k+1], R_bruteForceMin(tsMat, 2L, 1L, k), tolerance = 1e-8)
  }

})

test_that("Dynp$costPath() is non-increasing in k wherever both neighbours are feasible", {

  dynp = Dynp$new(minSize = 1L, jump = 1L, costFunc = costFunc$new("L2"))
  dynp$fit(tsMat)
  cp = dynp$costPath()

  finite = cp[is.finite(cp)]
  expect_true(all(diff(finite) <= 1e-8))

})

test_that("Dynp$predict(nBkps=k) reconstructs the exact costPath[k] cost via $eval()", {

  dynp = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  dynp$fit(tsMat)
  cp = dynp$costPath()

  for(k in 0:4){
    bkps = dynp$predict(nBkps = k)
    expect_equal(tail(bkps, 1), n)
    expect_length(bkps, k + 1L)
    starts = c(0, head(bkps, -1))
    reconCost = sum(mapply(function(a,b) dynp$eval(a,b), starts, bkps))
    expect_equal(reconCost, cp[k+1], tolerance = 1e-8)
  }

})

test_that("Dynp$predict(pen=) matches argmin_k costPath[k] + pen*k", {

  dynp = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  dynp$fit(tsMat)
  cp = dynp$costPath()

  for(pen in c(0, 0.5, 3.7, 50, 9999)){
    kStar = which.min(cp + pen * (0:(length(cp)-1))) - 1L
    expect_identical(dynp$predict(pen = pen), dynp$predict(nBkps = kStar))
  }

})

test_that("Dynp is never worse than binSeg under the same penalty (exact vs greedy)", {

  dynp = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  dynp$fit(tsMat)
  bs = binSeg$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  bs$fit(tsMat)

  segCost = function(obj, bkps){
    starts = c(0, head(bkps, -1))
    sum(mapply(function(a,b) obj$eval(a,b), starts, bkps))
  }

  for(pen in c(0.5, 2, 10, 50)){
    dpBkps = dynp$predict(pen = pen)
    bsBkps = bs$predict(pen = pen)
    dpCost = segCost(dynp, dpBkps) + pen * (length(dpBkps) - 1)
    bsCost = segCost(dynp, bsBkps) + pen * (length(bsBkps) - 1)
    expect_lte(dpCost, bsCost + 1e-8)
  }

})

test_that("Dynp works end-to-end with the 'Custom' (R-callback) cost and matches L2", {

  myL2 = function(segment, a, b){
    segment = as.matrix(segment)
    sum(sweep(segment, 2, colMeans(segment), "-")^2)
  }

  dynpCustom = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("Custom", evalFun = myL2))
  dynpL2 = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  dynpCustom$fit(tsMat)
  dynpL2$fit(tsMat)

  expect_equal(dynpCustom$costPath(), dynpL2$costPath(), tolerance = 1e-8)
  expect_identical(dynpCustom$predict(nBkps = 3), dynpL2$predict(nBkps = 3))

})

test_that("Dynp works end-to-end with the 'VAR' cost", {

  dynpVAR = Dynp$new(minSize = 3L, jump = 1L, costFunc = costFunc$new("VAR", pVAR = 1L))
  expect_no_error(dynpVAR$fit(tsMat))
  expect_no_error(dynpVAR$predict(nBkps = 1))
  expect_no_error(dynpVAR$costPath())

})

test_that("`nBkpsMax` active binding: NULL auto-resolves, explicit cap respected, over-cap warns", {

  dynp = Dynp$new(minSize = 2L, jump = 1L, nBkpsMax = 3L, costFunc = costFunc$new("L2"))
  expect_no_error(dynp$fit(tsMat))
  expect_equal(dynp$describe()$resolvedNBkpsMax, 3L)
  expect_length(dynp$costPath(), 4L)
  expect_error(dynp$predict(nBkps = 4), "between 0 and")

  dynp$nBkpsMax = 999L
  expect_warning(dynp$fit(tsMat), "exceeds the maximum feasible value")
  expect_equal(dynp$describe()$resolvedNBkpsMax, n %/% 2L - 1L)

  expect_error(Dynp$new(nBkpsMax = -1L))
  expect_error(Dynp$new(nBkpsMax = "a"))

})

test_that("`$predict()` requires exactly one of `nBkps`/`pen`, and validates both", {

  dynp = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  expect_error(dynp$predict(nBkps = 1), "must be run before")  # not fitted yet

  dynp$fit(tsMat)
  expect_error(dynp$predict(), "Exactly one of")
  expect_error(dynp$predict(nBkps = 1, pen = 1), "Exactly one of")
  expect_error(dynp$predict(nBkps = -1), "non-negative integer")
  expect_error(dynp$predict(nBkps = 1.5), "non-negative integer")
  expect_error(dynp$predict(pen = -1), "non-negative value")
  expect_no_error(dynp$predict(nBkps = 0))
  expect_no_error(dynp$predict(pen = 0))

})

test_that("`describe()` works for Dynp", {

  dynp = Dynp$new(minSize = 2L, jump = 1L, costFunc = costFunc$new("L2"))
  dynp$fit(tsMat)

  expect_no_error(dynp$describe(TRUE))
  expect_no_error(dynp$describe(FALSE))
  desc = dynp$describe()
  expect_true(all(c("minSize","jump","nBkpsMax","resolvedNBkpsMax","costFunc","fitted","n","p") %in% names(desc)))
  expect_true(desc$fitted)

})

test_that("Error handling for C++ module DynpCpp_L2 works as intended", {
  #constructor: const arma::mat& tsMat, int minSize_, int jump_, int nBkpsMax_

  set.seed(123)
  tsMat2 = as.matrix(rnorm(23))
  tsMat3 = as.matrix(rnorm(24))

  expect_error(new(rupturesRcpp:::DynpCpp_L2, tsMat2, 0, 1, 5)) #minSize_ = 0
  expect_error(new(rupturesRcpp:::DynpCpp_L2, tsMat2, 1, 0, 5)) #jump_ = 0
  expect_error(new(rupturesRcpp:::DynpCpp_L2, tsMat2, 10, 3, 1)) #segment too short
  expect_error(new(rupturesRcpp:::DynpCpp_L2, tsMat3, 10, 3, -1)) #nBkpsMax < 0
  expect_no_error(new(rupturesRcpp:::DynpCpp_L2, tsMat3, 10, 3, 1)) #len = minLen here

})
