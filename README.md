
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dotstatR

dotstatR is an API client to the dotstat Suite set of APIs. It is under
active development, and currently supports the following features: -
Retrieve the following SDMX structures - Dataflows - Data Structures
(DSDs) - Codelists - Retrieve observations from a Dataflow

## Installation

You can install the development version of dotstatR like so:

``` r
devtools::install_github("WB-DECIS/dotstatR")
```

## Examples

In Dotstat Suite, each data space gets its own API service, so it
important to know which data spaces are available in order to send
successful queries. The following data spaces are currently available: -
`design`  
- `collection`  
- `processing`  
- `staging`  
- `disseminate`  
- `disseminateext`  
- `archive`  
- `archiveext`

### Retrieve data structures

#### Retrieve all available codelists in a given space

``` r
library(dotstatR)
retrieve_structure(environment = "qa",
                   data_space = "design",
                   structure = "codelist") |>
  parse_codelists()
#> # A tibble: 55 × 8
#>    id                agencyID version is_final is_external url   name_en desc_en
#>    <chr>             <chr>    <chr>   <lgl>    <lgl>       <chr> <chr>   <chr>  
#>  1 CL_URBANISATION   IAEG-SD… 1.10    TRUE     TRUE        http… Degree…  <NA>  
#>  2 CL_LOCATION       OECD     1.0     TRUE     TRUE        http… Country  <NA>  
#>  3 CL_SNA_TABLE1__M… OECD     1.0     TRUE     TRUE        http… Measure  <NA>  
#>  4 CL_SNA_TABLE1__O… OECD     1.0     TRUE     TRUE        http… Observ…  <NA>  
#>  5 CL_SNA_TABLE1__T… OECD     1.0     TRUE     TRUE        http… Transa…  <NA>  
#>  6 CL_SNA_TABLE1__U… OECD     1.0     TRUE     TRUE        http… Unit o…  <NA>  
#>  7 CL_SNA_TABLE1__U… OECD     1.0     TRUE     TRUE        http… Multip…  <NA>  
#>  8 CL_AGE            SDMX     1.0     TRUE     TRUE        http… Age     "This …
#>  9 CL_CIVIL_STATUS   SDMX     1.0     TRUE     TRUE        http… Civil … "This …
#> 10 CL_CONF_STATUS    SDMX     1.1     FALSE    TRUE        http… Confid… "This …
#> # ℹ 45 more rows
```

#### Retrieve all available dataflows in a given space

``` r
retrieve_structure(environment = "qa",
                   data_space = "design",
                   structure = "dataflow") |>
  parse_dataflows()
#> # A tibble: 5 × 6
#>   id                  agencyID   version is_final name_en            annotations
#>   <chr>               <chr>      <chr>   <lgl>    <chr>              <chr>      
#> 1 SNA_TABLE1          OECD       1.0     TRUE     1. Gross domestic… NonProduct…
#> 2 DSD_POP@DF_POP_TEST WB         1.0     FALSE    Population test    NonProduct…
#> 3 DSD_POP@FAKE_DF     WB         1.0     FALSE    Population test    NonProduct…
#> 4 DF_WB_WGI           WB.DATA360 1.0     FALSE    WGI Dataflow       NonProduct…
#> 5 DF_IDS              WB.DEC     1.0     FALSE    International Deb… NonProduct…
```

#### Retrieve all available DSDs in a given space

``` r
retrieve_structure(environment = "qa",
                   data_space = "design",
                   structure = "datastructure") |>
  parse_dsds()
#> # A tibble: 8 × 9
#>   id     agencyID version is_final is_external url   name_en desc_en annotations
#>   <chr>  <chr>    <chr>   <lgl>    <lgl>       <chr> <chr>   <chr>   <chr>      
#> 1 DSD_S… OECD     1.0     TRUE     TRUE        http… 1. Gro… 1. Gro… "urn:sdmx:…
#> 2 DSD_G… WB       1.0     FALSE    TRUE        http… Get st… Simple… ""         
#> 3 DSD_P… WB       1.0     FALSE    TRUE        http… Popula… <NA>    ""         
#> 4 DS_DA… WB.DATA… 1.2     FALSE    TRUE        http… Data 3… <NA>    ""         
#> 5 DS_IDS WB.DEC   1.0     FALSE    TRUE        http… Intern… <NA>    ""         
#> 6 DS_WD… WB.DEC   1.0     FALSE    TRUE        http… World … <NA>    ""         
#> 7 DSD_C… WB.TEST  1.0     FALSE    TRUE        http… Corpor… <NA>    ""         
#> 8 DS_HC… WB.TEST  1.0     FALSE    TRUE        http… DSD fo… <NA>    ""
```

### Retrieve data

``` r
retrieve_data(environment = "qa",
                   data_space = "design",
                   agency_id = "WB",
                   dataflow_id = "DSD_POP@DF_POP_TEST",
                   dataflow_version = "1.0") |>
  head(10)
#> Rows: 405 Columns: 13
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (11): DATAFLOW, REF_AREA: Reference area, FREQ: Frequency of observation...
#> dbl  (2): TIME_PERIOD: Time period, OBS_VALUE
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 10 × 13
#>    DATAFLOW     REF_AREA: Reference …¹ FREQ: Frequency of o…² `MEASURE: Measure`
#>    <chr>        <chr>                  <chr>                  <chr>             
#>  1 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  2 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  3 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  4 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  5 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  6 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  7 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  8 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#>  9 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#> 10 WB:DSD_POP@… BEL: Belgium           A: Annual              POP: Population   
#> # ℹ abbreviated names: ¹​`REF_AREA: Reference area`,
#> #   ²​`FREQ: Frequency of observation`
#> # ℹ 9 more variables: `UNIT_MEASURE: Unit of measure` <chr>,
#> #   `DEG_URB: Degree of urbanisation` <chr>, `AGE: Age` <chr>,
#> #   `SEX: Sex` <chr>, `TIME_PERIOD: Time period` <dbl>, OBS_VALUE <dbl>,
#> #   `OBS_STATUS: Observation status` <chr>, `UNIT_MULT: Unit multiplier` <chr>,
#> #   `OLD_SERIES_CODE: Old series code` <chr>
```
