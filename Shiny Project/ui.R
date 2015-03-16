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
        helpText("The user selects the date through which the run times are known.
                 In medical statistics this is termed the 'follow-up' date, but it
                 can also be thought of as the date on which the data were gathered.
                 Varying dates will result in different plots and summary
                 data. The outputs are all based on the 'survfit' function in
                 the 'survival' package of the R programming language. These
                 are based on Kaplan-Meier estimates as described in the"),
        a(href="http://www.itl.nist.gov/div898/handbook/apr/section2/apr215.htm",
          "NIST Engineering Statistics Handbook"),
        helpText("and in many other sources. The outputs consist of a 
                 standard plot of the survival curves, with plot details 
                 depending on whether the user selected a combined analysis
                 or separate estimates for the two assets. The application
                 the presents a brief summary including the median time to
                 failure, and survival tables summarized at particular times."),
        helpText("The form of the survival tables also depends on whether the analysis
                 is combined, or by asset. At the bottom of the page, the
                 application displays the data set in tabular form.")
        
        ),
      
      # Create a spot for the survival plot
      mainPanel(
        plotOutput("survplot"),
        helpText("The vertical axis on this plot displays the proportion
                 surviving at each corresponding time value on the 
                 horizontal axis. These proportions can also be interpreted
                 as the estimated reliability of these systems at these 
                 times."),
        helpText("We are applying Kaplan-Meier estimates to this field
                 data because the data are 'right-censored.' That means
                 that some lives are continuing, and some lives ended 
                 without reaching the event of interest, in this case a
                 system failure. The Kaplan-Meier method estimates the
                 reliability that would be expected if all systems ran
                 until they failed."),
        hr(),
        
        h3("Survival Summary"),
        tableOutput("bsumm"),
        helpText("This table is a brief summary of the survival fit. The 
                 'records' value is the number of lives. The 'events' value
                 is the number of failures. The 'median' value is the time
                 beyond which half of systems are estimated to run before
                 failing. It is thus a 'typical' time to failure."),
        hr(),
        h3("Survival Table"),
        tableOutput("survtable"),
        helpText("The survival table displays reliability estimates in the
                 'surv' column at the times listed in the 'time' column.
                 The 'n.risk' values are the number of systems 'at risk'
                 until just before the listed time. The 'n.event' values
                 are the total number of failures between the listed times.
                 The values in this table at all failure times are displayed
                 in the plot at the top of the page. These tables summarize
                 the complete survival table at selected times."),
        hr(),
        
        dataTableOutput("dataset")
        
      )
    )
))

