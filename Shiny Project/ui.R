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
    titlePanel("Abbot and Costello Survival Analysis"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with plot choice inputs
      sidebarPanel(
        # Select the date of the data set, also called the follow-up date
        dateInput("fdate", "Date of Data:", min = min_fdate),
        hr(),
        helpText("This is the date through which the run times are known."),
        
        radioButtons("plotType", label = h3("Type of Fit:"), 
                           choices = list("Combined" = 1,
                                          "By Asset" = 2),
                           selected = 2),
              
        hr()
        
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

