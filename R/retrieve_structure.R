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
