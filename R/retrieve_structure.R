#' Retrieve any SDMX **structure artefact** from a .Stat Suite API
#'
#' @section Arguments:
#' * **`environment`** – either `"qa"` or `"prod"` (case‑insensitive).
#'   Passed straight to `build_root_url()`.
#' * **`data_space`**  – one of the sub‑domains your organisation uses
#'   (e.g. `"design"`, `"disseminate"`, `"staging"`). **Do not** include
#'   the protocol prefix.
#' * **`structure`**   – the SDMX path segment, such as
#'   `"datastructure/OECD/DSD_SNA_TABLE1/1.0"` or `"codelist/all/latest"`.
#' * **`...`**         – additional query parameters (name–value pairs) that
#'   will be added to the request, for example `references = "children"`.
#' * **`detail`**      – SDMX `detail` query parameter.  Defaults to
#'   `"allcompletestubs"`, the most complete form supported by .Stat Suite.
#'
#' @return An **`xml2::xml_document`** containing the SDMX‑XML payload.
#'         Combine with helpers like [`parse_dataflows()`],
#'         [`parse_codelists()`], or [`parse_dsds()`] to obtain tidy tables.
#'
#' @examples
#' \dontrun{
#'   # Pull a single DSD from QA design space
#'   xml <- retrieve_structure(
#'     environment = "qa",
#'     data_space  = "design",
#'     structure   = "datastructure/OECD/DSD_SNA_TABLE1/1.0"
#'   )
#'
#'   # Get *all* codelists, but only direct children, not references
#'   xml <- retrieve_structure(
#'     "qa", "design",
#'     "codelist/all/latest",
#'     references = "none"
#'   )
#' }
#' @export
retrieve_structure <- function(environment,
                               data_space,
                               structure,
                               ...,
                               detail= "allcompletestubs") {
  params <- list(
    ...,
    detail = detail
  )
  #names(params) <- paste0("_", names(params))

  root_url <- build_root_url(data_space = data_space,
                             environment = environment)

  httr2::request(root_url) |>
    httr2::req_url_path_append(structure) |>
    httr2::req_url_query(!!!params) |>
    httr2::req_user_agent("dotstatR package") |>
    httr2::req_perform() |>
    httr2::resp_body_xml()
}
