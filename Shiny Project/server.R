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
  # Set them all equal to the Stop Date less the Start Date
  
  RDays <- reactive({
    ## Make an end date that is by default the Stop Date
    life_data.df$End.Date <- life_data.df$Stop.Date
    
    ## For the missing Stop Dates, the End Date is the input follow-up date
    life_data.df$End.Date[is.na(life_data.df$End.Date)] <- as.Date(input$fdate)
    
    ## Now the run days for each system is End Date less Start Date
    life_data.df$RDays <- as.numeric(life_data.df$End.Date
                                               - life_data.df$Start.Date)
    life_data.df$RDays
  })
  
  ## Create a reactive version of the status variable  
  Failed <- reactive({
    life_data.df$Failed
  })
  
  ## Create a reactive version of the Asset variable  
  Asset <- reactive({
    life_data.df$Asset
  })
  
  ## Calculate the combined survival fit
  comb.fit <- reactive({
    survfit(Surv(time=RDays(), event=Failed()) ~ 1, )
  })
      
  ## Calculate the survival fit by Asset
  asset.fit <- reactive({
    survfit(Surv(time=RDays(), event=Failed()) ~ Asset())
  })
  
#   output$survplot <- renderPlot({
#     plot(comb.fit(), main="Abbott & Costello Combined Survival")
#   })
  
  output$survplot <- renderPlot({
    plot(asset.fit(), main="Survival by Asset", col=1:2)
    legend("bottomleft", legend=c("Abbott", "Costello"), text.col=1:2)
  })

  output$bsumm <- renderTable({
    data.frame(t(summary(comb.fit())$table))
  })
  
  output$survtable <- renderTable({
    as.data.frame(summary(comb.fit(), times=c(30,90,180,365))[c("time","n.risk",
                                                  "n.event", "surv")])
  })
  
  output$dataset <- renderDataTable({
    cbind(life_data.df, RDays())
  }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
  
})