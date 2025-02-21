# v2g_shiny

## Overview
`v2g_shiny` is a Shiny web application that allows users to input a list of variant rsids and retrieve gene V2G (Variant to Gene) outputs. The application displays the results in a filterable, searchable, and resizable reactable table, and provides an option to download the results as a CSV file.

## Features
- Input a list of variant rsids.
- Retrieve gene V2G outputs using the `otargen` package.
- Display results in a reactable table with filtering, searching, and resizing capabilities.
- Download the results as a CSV file.
- Filter the table by rsid and gene using drop-down boxes.

## Installation
To run the application locally, follow these steps:

1. Ensure you have R and RStudio installed on your machine.
2. Install the required R packages:
    ```r
    install.packages(c("shiny", "reactable", "dplyr", "purrr", "otargen", "crosstalk"))
    ```
3. Clone this repository to your local machine:
    ```sh
    git clone https://github.com/yourusername/v2g_shiny.git
    ```
4. Open the `app.R` file in RStudio.
5. Click the 'Run App' button in RStudio to start the application.

## Usage
1. Enter a list of variant rsids (one per line) in the provided text area.
2. Click the 'Retrieve V2G' button to fetch the gene V2G outputs.
3. The results will be displayed in a reactable table.
4. Use the drop-down boxes to filter the table by rsid and gene.
5. Click the 'Download as CSV' button to download the results.

## Example
Here is an example of the expected output:

```
gene.symbol         variant overallScore         gene.id
1       HERC2 15_28120472_A_G  0.192756539 ENSG00000128731
2        OCA2 15_28120472_A_G  0.106237425 ENSG00000104044
3     GOLGA8F 15_28120472_A_G  0.033199195 ENSG00000153684
4  GOLGA6L24P 15_28120472_A_G  0.033199195 ENSG00000237850
5     GOLGA8G 15_28120472_A_G  0.013279678 ENSG00000183629
6  GOLGA6L25P 15_28120472_A_G  0.006639839 ENSG00000227717
```
