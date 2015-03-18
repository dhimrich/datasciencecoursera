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
    life_data.df$End.Date[is.na(life_data.df$Stop.Date)] <- as.Date(input$fdate)
    
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
  
  ## Choose the fit that will be displayed according to the checkbox inputs
  
    ## Assign the combined fit to be displayed
  display.fit <- reactive({
    if (input$plotType == 1) {
      survfit(Surv(time=RDays(), event=Failed()) ~ 1, )
      } else {
      survfit(Surv(time=RDays(), event=Failed()) ~ Asset())
    }
  })
  
  display.title <- reactive({
    if (input$plotType == 1) {
      "Combined Survival"
    } else {
      "Survival by Asset"
    }
  })
  
  
  output$survplot <- renderPlot({
    plot(display.fit(), main=display.title(), col=1:input$plotType,
         xlab="Run Days", ylab="Proportion Surviving")
    if (input$plotType == 2) {
      legend("bottomleft", legend=unique(Asset()), 
             text.col=1:input$plotType)
    } else {
      title(sub="Dashed lines = 95% conf. limits")
    }
  })
  

  output$bsumm <- renderTable({
    if (input$plotType == 1) {
      as.table(t(summary(display.fit())$table))
    } else {
      as.table(summary(display.fit())$table)
    }
  })
  
  output$survtable <- renderTable({
    if (input$plotType == 1) {
      as.data.frame(summary(display.fit(), 
                          times=c(30,90,180,365))[c("time","n.risk",
                                                  "n.event", "surv")])
    } else {
      as.data.frame(summary(display.fit(), 
                            times=c(30,90,180,365))[c("strata", "time", 
                                                      "n.risk", "n.event", 
                                                      "surv")])
    }
    
  })
  
  output$dataset <- renderDataTable({
    cbind(life_data.df, RDays())
  }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
  
})