## ui.R for Data Products course Project
library(shiny)

## We will use the survival library to make calculations and plots
library(survival)

## Load in the run times from the csv file
life_data.df <- read.csv("life_data.csv", 
                         colClasses=c("character", 
                                      "character", 
                                      "Date", 
                                      "Date", 
                                      "logical"))

## Make a variable that is the minimum allowed follow-up date
min_fdate <- max(life_data.df$Start.Date)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Survival Analysis Calculator"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with plot choice inputs
      sidebarPanel(
        # Select the date of the data set, also called the follow-up date
        dateInput("fdate", "Date of Data:", min = min_fdate),
        helpText("This is the date through which the run times are known.
                 Select dates in the future to see the survival plots change."),
        hr(),
        
        radioButtons("plotType", label = "Type of Fit:", 
                           choices = list("Combined" = 1,
                                          "By Asset" = 2),
                           selected = 2),
        helpText("Select a fit for all systems, or divided by Asset"),
        hr(),
        helpText("This application has loaded a data set consisting of 40 lives
                 of hardware systems, distributed across two different 'assets',
                 named 'Abbot' and 'Costello'. The life data are made-up, but
                 you can think of them as representing equipment in two 
                 different oil production facilities, or some similar project."),
        helpText("The times to failure of hardware systems is frequently of 
                 interest to their operators and suppliers. Contracts may include
                 reliability incentives. However, in some industries, the
                 most appropriate methods for estimating reliability for
                 field data are not well known. See, for example,"),
        a(href = "http://www.stat.tamu.edu/sheathermemorial/PDF/Pflueger_MasterProjectPaper.pdf",
                  "this paper"),
        helpText("for a brief description of some techniques that 
                 have been used in the petroleum industry in lieu of survival
                 analysis."),
        helpText("This application is an attempt to enable users to apply 
                 survival analysis techniques to their data without the need
                 to learn statistical software or code survival analysis into
                 a spreadsheet program. Future versions will enable users to
                 upload their own data sets. This demonstration operates on
                 a single data set."),
        helpText("User selects the date through which the run times are known,
                 in medical statistics is termed the 'follow-up' date, but
                 can also be thought of as the date the data were gathered.")
        
        ),
      
      # Create a spot for the survival plot
      mainPanel(
        plotOutput("survplot"),
        hr(),
        h3("Survival Summary"),
        tableOutput("bsumm"),
        h3("Survival Table"),
        tableOutput("survtable"),
        hr(),
        dataTableOutput("dataset")
        
      )
    )
))

