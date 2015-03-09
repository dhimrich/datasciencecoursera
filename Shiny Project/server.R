## server.R for Data Products course project
library(survival)

## Load in the run times from the csv file
life_data.df <- read.csv("life_data.csv", 
                         colClasses=c("character", 
                                      "character", 
                                      "Date", 
                                      "Date", 
                                      "logical"))

shinyServer(function(input, output) {
  
  # Calculate the run days for the data set based on the follow-up date
  # Set them all equal to the follow-up date less the Start Date
  
  RDays <- reactive({
    life_data.df$fdate <- input$fdate
    life_data.df$Rdays <- as.numeric(life_data.df$fdate - 
                                       life_data.df$Start.Date)
    # Then for the records with Stop Dates, the days should be Stop - Start
    life_data.df$RDays[!is.na(life_data.df$Stop.Date)] <- 
      as.numeric(life_data.df$Stop.Date[!is.na(life_data.df$Stop.Date)] - 
      life_data.df$Start.Date[!is.na(life_data.df$Stop.Date)])
    life_data.df$RDays
  })
  
  ## Create a reactive version of the status variable  
  Failed <- reactive({
    life_data.df$Failed
  })
  
  ## Calculate the combined survival fit
  comb.fit <- reactive({
    survfit(Surv(time=RDays(), event=Failed()) ~ 1, )
  })
  
  
    
  output$survplot <- renderPlot({
    plot(comb.fit())
  })
  
})