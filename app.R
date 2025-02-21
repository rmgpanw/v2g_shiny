library(shiny)
library(reactable)
library(dplyr)
library(purrr)
library(otargen)
library(crosstalk)

# Define UI for application
ui <- fluidPage(
  titlePanel("Variant to Gene (V2G) Mapping"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput(
        "rsids",
        "Enter variant rsids (one per line):",
        value = "",
        rows = 10,
        resize = "vertical",
        placeholder = "rs12913832"
      ),
      actionButton("retrieve", "Retrieve V2G"),
      downloadButton("downloadData", "Download as CSV"),
      uiOutput("filterUI")
    ),
    mainPanel(reactableOutput("v2gTable"), textOutput("errorMessage"))
  )
)

# Define server logic
server <- function(input, output) {
  possibly_genesForVariant <- purrr::possibly(otargen::genesForVariant, otherwise = list(tssd = list(gene.symbol = "Unknown")))

  v2g_data <- eventReactive(input$retrieve, {
    rsids <- strsplit(input$rsids, "\n")[[1]]
    rsids <- trimws(rsids)
    rsids <- rsids[rsids != ""]

    data <- rsids |>
      purrr::set_names() |>
      purrr::map(possibly_genesForVariant) |>
      purrr::map(\(x) x$v2g) |>
      dplyr::bind_rows(.id = "variant_input")

    if (nrow(data) == 0) {
      return(NULL)
    } else {
      return(data)
    }
  })

  shared_data <- reactive({
    data <- v2g_data()
    if (!is.null(data)) {
      SharedData$new(data)
    } else {
      NULL
    }
  })

  output$v2gTable <- renderReactable({
    data <- shared_data()
    if (is.null(data)) {
      output$errorMessage <- renderText("No results found for the provided rsids.")
      return(NULL)
    } else {
      output$errorMessage <- renderText("")
      reactable(
        data,
        columns = list(
          gene.symbol = colDef(name = "Gene Symbol"),
          variant = colDef(name = "Variant"),
          overallScore = colDef(name = "Overall Score"),
          gene.id = colDef(name = "Gene ID")
        ),
        searchable = TRUE,
        resizable = TRUE,
        filterable = TRUE,
        showPageSizeOptions = TRUE,
        paginationType = "jump",
        defaultPageSize = 10,
        pageSizeOptions = c(10, 25, 50, 100, 200)
      )
    }
  })

  output$filterUI <- renderUI({
    data <- shared_data()
    if (!is.null(data)) {
      tagList(
        filter_select(
          "filterRsidInput",
          "Filter by rsid (input)",
          data,
          ~ variant_input
        ),
        filter_select("filterRsid", "Filter by rsid", data, ~ variant),
        filter_select("filterGene", "Filter by gene", data, ~ gene.symbol)
      )
    }
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste("v2g_data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(v2g_data(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
