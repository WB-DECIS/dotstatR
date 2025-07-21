#' Build the root URL for a .Stat Suite SDMX API
#'
#' Returns the root URL of the API service

#' @param data_space  One of the data spaces available in the .Stat instance
#' @param environment Either `"qa"` or `"prod"`
#'
#' @return A length‑one character vector containing the assembled URL.
#' @examples
#' build_root_url("design", "prod")
#' #> "https://designnsiserviceprod.ase.worldbank.org/rest/"
#' @export
build_root_url <- function(data_space = c("design",
                                          "collection",
                                          "processing",
                                          "staging",
                                          "disseminate",
                                          "disseminateext",
                                          "archive",
                                          "archiveext"),
                           environment = c("qa", "prod")) {

  # Match arg (allows lowercase, etc.)
  environment <- rlang::arg_match(environment, values = c("qa", "prod"))

  host <- env_host_map[[environment]]

  glue::glue("https://{data_space}{host}") |>
    as.character()
}
