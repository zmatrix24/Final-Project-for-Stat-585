shinyUI(pageWithSidebar(
  headerPanel("Stocks"),

  sidebarPanel(
    wellPanel(
      p(strong("Stocks")),
      checkboxInput(inputId = "stock_ibm",  label = "IBM (IBM)",        value = TRUE),
      checkboxInput(inputId = "stock_intc",  label = "Intel (INTC)",    value = FALSE),
      checkboxInput(inputId = "stock_aapl", label = "Apple (AAPL)",     value = TRUE),
      checkboxInput(inputId = "stock_msft", label = "Microsoft (MSFT)", value = FALSE),
      checkboxInput(inputId = "stock_yhoo", label = "Yahoo (YHOO)",     value = FALSE),
      checkboxInput(inputId = "stock_amzn", label = "Amazon (AMZN)",    value = FALSE),      
      checkboxInput(inputId = "stock_goog", label = "Google (GOOG)",    value = FALSE),
      checkboxInput(inputId = "stock_fb", label = "Facebook (FB)",      value = FALSE),
      checkboxInput(inputId = "stock_twtr", label = "Twitter (TWTR)",     value = FALSE)          
            
      ),


   wellPanel(   
     helpText("Symbol separated by comma:"),
     textInput(inputId = "symbols", label = "", "IBM,"),    #default is IBM,
 #   textInput(inputId = "symbols", label = ""),
     br(),                                                  #separate one line
     actionButton(inputId = "updateData",label = "Compare" )
     
     ),
    
 
    
    
  

    
  wellPanel(
    p(strong("Date Range: yyyy-mm-dd")),
      dateRangeInput( inputId = 'dateRange',
                      label="",
     #                label = 'Date range input: yyyy-mm-dd',
                      start = Sys.Date() - 10, end = Sys.Date()  #if the start date is so close, it might mess up because of festivals and weekends
                    )
  ),
    
 wellPanel(
   selectInput(inputId = "chart_type",
               label = "Chart Type",
               choices = c("Candlestick" = "candlesticks",
                           "Matchstick" = "matchsticks",
                           "Bar" = "bars",
                           "Line" = "line")
   )),
 
  
    checkboxInput(inputId = "log_y", label = "log y axis", value = FALSE)
 
  ),

   

 
 
  mainPanel(
#    conditionalPanel(condition = "input.updateData",
#                     br(),
#                     tableOutput("view")),
#                     div(plotOutput(outputId = "plot_compare"))),
    
    
    conditionalPanel(condition = "input.updateData !=0  & input.symbols != ''  "  ,  #here we need '' instead of "", because it followed by a " and will cause problem  
                     br(),
#                    tableOutput("view")),   # we could output the data and see the messed up date, so we need to convert the date to character first
                     div(plotOutput(outputId = "plot_compare"))),
    
 

    
    conditionalPanel(condition = "input.stock_ibm",
                     br(),
                     div(plotOutput(outputId = "plot_ibm"))),
    conditionalPanel(condition = "input.stock_intc",
                     br(),
                     div(plotOutput(outputId = "plot_intc"))),
    conditionalPanel(condition = "input.stock_aapl",
                     br(),
                     div(plotOutput(outputId = "plot_aapl"))),

    conditionalPanel(condition = "input.stock_msft",
      br(),
      div(plotOutput(outputId = "plot_msft"))),

    conditionalPanel(condition = "input.stock_yhoo",
                     br(),
                     div(plotOutput(outputId = "plot_yhoo"))),
    conditionalPanel(condition = "input.stock_amzn",
                     br(),
                     div(plotOutput(outputId = "plot_amzn"))),
    
    conditionalPanel(condition = "input.stock_goog",
      br(),
      div(plotOutput(outputId = "plot_goog"))),

    conditionalPanel(condition = "input.stock_fb",
                     br(),
                     div(plotOutput(outputId = "plot_fb"))),
    
    conditionalPanel(condition = "input.stock_twtr",
      br(),
      plotOutput(outputId = "plot_twtr"))
  )
))



