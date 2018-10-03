
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(DT)
library(data.table)
library(naniar)
library(visdat)
library(skimr)
library(readr)

source("R/helper.R")

data_dictionary <- read.csv("data/shhs-data-dictionary-0.13.1-variables.csv")
myDataFrame <- data.table(read_rds("data/common_data_small.rds"))

remove_categories <- c("any_cvd")
categoricalVars <- sort(names(get_category_variables(myDataFrame)))
cat_no_outcome <- setdiff(categoricalVars, remove_categories)

remove_numeric <- c("nsrrid")
numericVars <- sort(get_numeric_variables(myDataFrame))
numericVars <- setdiff(numericVars, remove_numeric)

theme_set(theme_classic(base_size = 15))


##Don't modify anything below here.

ui <- dashboardPage(
    header=dashboardHeader(
      title = "SHHS Data"
    ),
    sidebar=dashboardSidebar(
      sidebarMenu(
      menuItem("Overview", tabName = "overview", selected=TRUE),
      menuItem("Categorical", tabName = "categorical"),
      menuItem("Continuous", tabName = "continuous"))
    ),
    body=  dashboardBody(
      tabItems(
        tabItem("overview", 
                tabBox(width = 12,
                    tabPanel("Visual Summary of Data",
                      tags$head(tags$style("#TxtOut {white-space: nowrap;}")),
                      fluidRow(column(12, offset=0, plotOutput("visdat")))
                ),
          tabPanel("Tabular Summary of Data", 
                   tags$head(tags$style("#TxtOut {white-space: nowrap;}")),
                   fluidRow(column(12, offset=0, verbatimTextOutput("summaryTable")
                                   )
                              )),
          
          tabPanel("Data Dictionary", 
                   tags$head(tags$style("#TxtOut {white-space: nowrap;}")),
                   fluidRow(dataTableOutput("data_dictionary"))
                   )
          
            )
          ),
        tabItem("categorical", 
                tabBox(width=12,
                  tabPanel("Single Category", 
                           selectInput(inputId = "singleVar", 
                              "Select Categorical Variable",
                              choices = categoricalVars, 
                              selected = categoricalVars[1]), 
                   plotOutput("singleTab")
                ),
          
                tabPanel("Category/Outcome",
                   selectInput(inputId = "condTab", "Select Variable to Calculate Proportions",
                               choices=cat_no_outcome, selected=cat_no_outcome[1]),
                   plotOutput("proportionBarplot")
          
                   ),
          tabPanel("Crosstab Explorer",
                   selectInput(inputId = "crossTab1", "Select Crosstab Variable (x)", 
                               choices=categoricalVars, selected=categoricalVars[1]),
                   selectInput(inputId = "crossTab2", "Select Crosstab Variable (y)", 
                               choices=categoricalVars, selected=categoricalVars[1]),
                   verbatimTextOutput("crossTab")
          ),
          
          tabPanel("Missing Data Explorer", 
                   selectInput(inputId = "missingVar", "Select Variable to Examine",
                               choices=categoricalVars, selected = categoricalVars[1]),
                   plotOutput("missingTab")
          )
        )),
        tabItem("continuous", 
                tabBox(width=12,
                       tabPanel("Histogram Explorer",
                                fluidRow(column(width = 4,
                                                selectInput(inputId = "numericVarHist", 
                                                            "Select Numeric Variable", 
                                                  choices = numericVars, selected=numericVars[1])),
                     column(width=4, sliderInput("bins", "Number of bins:", min = 1, max = 50,value = 30))),
                   plotOutput("distPlot")
          ),
          tabPanel("Boxplot Explorer",
                   fluidRow(column(width = 4, selectInput(inputId = "numericVarBox", "Select Numeric Variable", 
                                                          choices = numericVars, selected=numericVars[1])),
                            column(width=4,selectInput(inputId = "catVarBox", "Select Category to Condition on", 
                                                       choices = categoricalVars, selected=categoricalVars[1]))),
                   plotOutput("boxPlot")
          ),
          tabPanel("Correlation Explorer", 
                   fluidRow(
                     column(width=4, selectInput("x_var", "Select Y Variable", 
                                                 choices=numericVars, selected = numericVars[1])),
                     column(width=4, selectInput("y_var", "Select Y Variable", 
                                                 choices=numericVars, selected = numericVars[2]))
                   ),
                   fluidRow(plotOutput("corr_plot"))
          ))
        ))
      )
    )

  
server <- function(input, output, session) {
  
  dataOut <- reactive({
    #req(input$cohort)
    myDataFrame #%>% filter_(cohortList[[input$cohort]])
    
  })
  
  output$singleTab <- renderPlot({
    
    dataOut()[,c(input$singleVar), with=FALSE] %>%
      mutate(gr = 1) %>%
      ggplot(aes_string(x=input$singleVar, fill=input$singleVar)) + 
      geom_bar(aes(y = ..count..), color="black") +
      geom_text(aes(group=gr, label = scales::percent(..prop..),
                    y= ..count.. ), stat= "count", vjust=-0.5)
  })
  
  output$visdat <- renderPlot({
    visdat::vis_dat(data.frame(dataOut())) + 
      theme(axis.text.x = element_text(size = 15, angle = 45))
  })
  
  output$summaryTable <- renderPrint({
    skimr::skim(dataOut())
  })
  
  output$missingTab <- renderPlot({
    
    var <- sym(input$missingVar)
    
    dataOut() %>%
      data.frame() %>%
      gg_miss_fct(fct = !!var) + 
      theme(axis.text = element_text(size = 15))
    
  })
  
  output$crossTab <- renderPrint({
    
    out <- dataOut()[,c(input$crossTab1, input$crossTab2), with=FALSE]
    tab <- table(out, useNA = "ifany")
    tab
  })
  
  proportionTable <- reactive({
    
    out <- dataOut()[,c(input$condTab, "any_cvd"), with=FALSE]
    out
  })
  
  output$proportionTab <- renderPrint({
    tab <- table(proportionTable(), useNA="ifany")
    return(tab[,"Yes"]/(tab[,"No"] + tab[,"Yes"]))
    
  })
  
  output$proportionBarplot <- renderPlot({
    
    print(input$condTab)
    
    percent_table <- proportionTable() %>% data.frame() %>% group_by(!!sym(input$condTab)) %>%
      count(any_cvd) %>% mutate(ratio=scales::percent(n/sum(n)))
    
    proportionTable() %>% 
      ggplot(aes_string(x=input$condTab, fill="any_cvd")) + 
      geom_bar(position="fill", color="black") + theme(text=element_text(size=20)) +
      geom_text(data = percent_table, mapping = aes(y=n, label=ratio), 
                position=position_fill(vjust=0.5))
    
    # group= !!sym(input$condTab)
  })
  
  output$distPlot <- renderPlot({
    
    outPlot <- ggplot(dataOut(), aes_string(x=input$numericVarHist)) + 
      geom_histogram(bins=input$bins) + theme(text=element_text(size=20))
    outPlot
  })
  
  output$boxPlot <- renderPlot({
    outPlot <- ggplot(dataOut(), aes_string(x=input$catVarBox, y=input$numericVarBox, fill=input$catVarBox)) + 
      geom_boxplot() + theme(text=element_text(size=20))
    outPlot
  })
  
  output$data_dictionary <- renderDataTable(
    datatable(data_dictionary, options=list(pageLength=20))
  )
  
  output$corr_plot <- renderPlot({
    
    mini_frame <- dataOut() %>% data.frame() %>% select(!!sym(input$x_var), !!sym(input$y_var)) %>%
      tidyr::drop_na()
    xcol <- mini_frame %>% pull(!!sym(input$x_var))
    ycol <- mini_frame %>% pull(!!sym(input$y_var))
    
    corval <- signif(cor(xcol, ycol), digits = 3)
    
    ggplot(dataOut(), aes_string(x=input$x_var, y=input$y_var)) +
      geom_miss_point() + stat_smooth(method=lm, se=FALSE) +
      ggtitle(paste(input$x_var, "vs.", input$y_var, "correlation =", corval)) 
  })
  
}

shinyApp(ui = ui, server = server)
