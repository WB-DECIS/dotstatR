#' Retrieve observations from a .Stat Suite SDMX Dataflow
#'
#'
#' @param environment         Character(1). `"qa"` or `"prod"` (case‑insensitive),
#'                            passed to [build_root_url()].
#' @param data_space          Character(1). Data‑space prefix
#'                            (e.g. `"design"`, `"collection"`, `"processing"`,
#'                            `"staging"`, `"disseminate"`, `"archive"`).
#'                            **Do not** include `https://`.
#' @param agency_id           Character(1). SDMX agency ID owning the dataflow
#'                            (e.g. `"OECD"`).
#' @param dataflow_id         Character(1). Dataflow code without agency or version
#'                            (e.g. `"SNA_TABLE1"`).
#' @param dataflow_version    Character(1). Version of the dataflow (e.g. `"1.0"`).
#' @param ...                 Additional named SDMX query parameters, such as
#'                            `startPeriod`, `endPeriod`, or specific dimension filters.
#' @param dimensionAtObservation Character(1). SDMX `dimensionAtObservation` parameter;
#'                            defaults to `"AllDimensions"`.
#' @param format              Character(1). SDMX `format` parameter;
#'                            defaults to `"csvfilewithlabels"`.
#'
#' @return A tibble (`tbl_df`) of the observations returned by the API.
#'
#' @seealso [retrieve_structure()], [build_root_url()]
#'
#' @importFrom httr2 request req_url_path_append req_url_query req_user_agent req_perform
#' @importFrom readr read_csv
#'
#' @export
#'
#' @examples
#' \dontrun{
#' df <- retrieve_data(
#'   environment      = "qa",
#'   data_space       = "design",
#'   agency_id        = "OECD",
#'   dataflow_id      = "SNA_TABLE1",
#'   dataflow_version = "1.0",
#'   startPeriod      = "2020",
#'   endPeriod        = "2021"
#' )
#' }
retrieve_data <- function(environment,
                          data_space,
                          agency_id,
                          dataflow_id,
                          dataflow_version,
                          ...,
                          dimensionAtObservation= "AllDimensions",
                          format = "csvfilewithlabels") {
  params <- list(
    ...,
    dimensionAtObservation = dimensionAtObservation,
    format = format
  )
  #names(params) <- paste0("_", names(params))

  root_url <- build_root_url(data_space = data_space,
                             environment = environment)

  dataflow_id <- paste(agency_id, dataflow_id, dataflow_version, sep = ",")

  out <- httr2::request(root_url) |>
    httr2::req_url_path_append("data") |>
    httr2::req_url_path_append(dataflow_id) |>
    httr2::req_url_path_append("all") |>
    httr2::req_url_query(!!!params) |>
    httr2::req_user_agent("dotstatR package") |>
    httr2::req_perform()

  out <- readr::read_csv(out$body)

  return(out)
}
