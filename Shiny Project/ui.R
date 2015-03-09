## ui.R for Data Products course Project
library(shiny)

## We will use the survival library to make calculations and plots
library(survival)

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
        dateInput("fdate", "Date of Data:"),
        hr(),
        helpText("This is the date through which the run times are known."),
        
        checkboxGroupInput("plotGroup", label = h3("Plot curves:"), 
                           choices = list("Abbott" = "Abbott", 
                                          "Costello" = "Costello", 
                                          "Combined" = "Combined"),
                           selected = c("Abbott", "Costello")),
              
        hr()
        
        ),
      
      # Create a spot for the barplot
      mainPanel(
        h3(textOutput("Survival Plot")),
        plotOutput("survplot"),
        hr()
        
      )
    )
))

