library(shiny)

# ui.R

shinyUI(fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(
      h1("Installation"),
      p("Shiny is available on CRAN, so you can install it in the usual
        way from your R console:"),
      code("install.packages(\"shiny\")"),
      img(src="BigOrb.png", height = 72, width = 72),
      p("shiny is a product of"),
      a("www.rstudio.com")
      ),
    mainPanel(
      h1("Introducing Shiny"),
      p("Shiny is a new package from RStudio that makes it incredibly easy
        to build interactive web applications with R."),
      p("For an introduction and live examples, vist the"),
      a("Shiny homepage", "shiny.rstudio.com"),
      h2("Features"),
      p("*Build useful web with only a few lines of code - no JavaScript
        required"),
      p("*Shiny applications are automatically \"live\" in the same way that
        _spreadsheets_ are live. Outputs change instantly as users modify
        inputs, without requiring a reload of the browser.")
     
    )
  )
))
