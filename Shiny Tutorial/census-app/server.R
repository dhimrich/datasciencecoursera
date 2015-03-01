# server.R census


library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")



shinyServer(
  function(input, output) {
    
    output$map <- renderPlot({
      data <- switch(input$var, 
                     "Percent White" = counties$white,
                     "Percent Black" = counties$black,
                     "Percent Hispanic" = counties$hispanic,
                     "Percent Asian" = counties$asian)
      
      color.choice <- switch(input$var,
                             "Percent White" = "darkgreen",
                             "Percent Black" = "brown",
                             "Percent Hispanic" = "darkred",
                             "Percent Asian" = "darkblue")
            
      leg.text <- input$var
      
      percent_map(var = data, color = color.choice, 
                  legend.title = leg.text, 
                  max = input$range[2], 
                  min = input$range[1])
      
    })
    
  }
)

