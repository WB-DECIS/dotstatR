# tests/testthat/test-build_root_url.R
local_edition(3)

test_that("build_root_url() assembles the expected URL for QA and PROD", {
  expect_equal(
    build_root_url("design", "qa"),
    sprintf("https://design%s", env_host_map[["qa"]])
  )

  expect_equal(
    build_root_url("disseminateext", "prod"),
    sprintf("https://disseminateext%s", env_host_map[["prod"]])
  )
})

test_that("invalid environment values trigger an error", {
  expect_error(build_root_url("design", "staging"))   # not qa/prod
})
#
# test_that("omitting environment argument triggers an error", {
#   expect_error(build_root_url("design"))               # ambiguous default
# })
