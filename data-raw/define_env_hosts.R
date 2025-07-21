# data-raw/define_env_hosts.R
env_host_map <- c(
  qa   = "nsiserviceqa.ocappsaseqa2.appserviceenvironment.net/rest/",
  prod = "nsiserviceprod.ase.worldbank.org/rest/"
)

usethis::use_data(env_host_map, internal = TRUE, overwrite = TRUE)
