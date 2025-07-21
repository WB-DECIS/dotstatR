
# ---------------------------------------------------------------------
# INTERNAL: pull the first child text that matches an XPath
# ---------------------------------------------------------------------
.first_text <- function(node, xpath, ns) {
  xml2::xml_find_first(node, xpath, ns) |>
    xml2::xml_text(trim = TRUE)
}

# ---------------------------------------------------------------------
# INTERNAL: generic iterator over SDMX structure items
#   - xml  : xml_document or character string
#   - xpath: item‑level XPath (e.g. ".//structure:Dataflow")
#   - fun  : a parser that converts ONE item node -> list/tibble row
# ---------------------------------------------------------------------
.parse_sdmx_items <- function(xml, xpath, fun) {

  if (is.character(xml)) xml <- xml2::read_xml(xml)

  ns  <- xml2::xml_ns(xml)
  nodes <- xml2::xml_find_all(xml, xpath, ns)

  purrr::map_dfr(nodes, fun, ns = ns)
}

#' @keywords internal
.parse_one_dataflow <- function(node, ns) {
  tibble::tibble(
    id        = xml2::xml_attr(node, "id"),
    agencyID  = xml2::xml_attr(node, "agencyID"),
    version   = xml2::xml_attr(node, "version"),
    is_final  = xml2::xml_attr(node, "isFinal") |> as.logical(),
    name_en   = .first_text(node, ".//common:Name[@xml:lang='en']", ns),
    annotations =
      xml2::xml_find_all(node,
                   ".//common:AnnotationType | .//common:AnnotationTitle",
                   ns) |>
      xml2::xml_text() |>
      stringr::str_c(collapse = "; ")
  )
}

#' @keywords internal
.parse_one_codelist <- function(node, ns) {
  tibble::tibble(
    id         = xml2::xml_attr(node, "id"),
    agencyID   = xml2::xml_attr(node, "agencyID"),
    version    = xml2::xml_attr(node, "version"),
    is_final   = xml2::xml_attr(node, "isFinal") |> as.logical(),
    is_external= xml2::xml_attr(node, "isExternalReference") |> as.logical(),
    url        = xml2::xml_attr(node, "structureURL"),
    name_en    = .first_text(node, ".//common:Name[@xml:lang='en']", ns),
    desc_en    = .first_text(node, ".//common:Description[@xml:lang='en']", ns)
  )
}

#' Parse all Dataflows from an SDMX Structure message
#'
#' @param xml `xml_document` **or** string containing the XML.
#' @return    A tibble (one row per `<structure:Dataflow>`).
#' @export
parse_dataflows <- function(xml) {
  .parse_sdmx_items(xml,
                    xpath = ".//structure:Dataflow",
                    fun   = .parse_one_dataflow)
}

#' Parse all Codelists from an SDMX Structure message
#'
#' @param xml `xml_document` **or** string containing the XML.
#' @return    A tibble (one row per `<structure:Codelist>`).
#' @export
parse_codelists <- function(xml) {
  .parse_sdmx_items(xml,
                    xpath = ".//structure:Codelist",
                    fun   = .parse_one_codelist)
}

#' @keywords internal
.parse_one_dsd <- function(node, ns) {
  tibble::tibble(
    id          = xml2::xml_attr(node, "id"),
    agencyID    = xml2::xml_attr(node, "agencyID"),
    version     = xml2::xml_attr(node, "version"),
    is_final    = xml2::xml_attr(node, "isFinal") |> as.logical(),
    is_external = xml2::xml_attr(node, "isExternalReference") |> as.logical(),
    url         = xml2::xml_attr(node, "structureURL"),
    name_en     = .first_text(node, ".//common:Name[@xml:lang='en']",        ns),
    desc_en     = .first_text(node, ".//common:Description[@xml:lang='en']", ns),
    annotations = xml2::xml_find_all(
      node,
      ".//common:AnnotationTitle | .//common:AnnotationType",
      ns
    ) |>
      xml2::xml_text() |>
      stringr::str_c(collapse = "; ")
  )
}

#' Parse all Data Structure Definitions (DSDs) from an SDMX Structure message
#'
#' @param xml An `xml_document` **or** a single XML string.
#'
#' @return A tibble with one row per `<structure:DataStructure>` element.
#' @export
parse_dsds <- function(xml) {
  .parse_sdmx_items(
    xml,
    xpath = ".//structure:DataStructure",
    fun   = .parse_one_dsd
  )
}
