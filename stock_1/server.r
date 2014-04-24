if (!require(quantmod)) {
  stop("This app requires the quantmod package. To install it, run 'install.packages(\"quantmod\")'.\n")
}

library(ggplot2)
library(reshape)

# Download data for a stock if needed, and return the data
require_symbol <- function(symbol, envir = parent.frame()) {
  if (is.null(envir[[symbol]])) {
    envir[[symbol]] <- getSymbols(symbol, from = 1970-01-01, auto.assign = F)
  }
  
  envir[[symbol]]
}






shinyServer(function(input, output) {

  # Create an environment for storing data
  symbol_env <- new.env()
  

  
  # Make a chart for a symbol, with the settings from the inputs
  make_chart <- function(symbol) {
    symbol_data <- require_symbol(symbol, symbol_env)

#   cat(input$dateRange)   # through this we find the start date should be early enough
    
    chartSeries(symbol_data,
                name      = symbol,
                type      = input$chart_type,
                subset    = paste(input$dateRange, collapse ="::"),
#               subset    = paste(input$dates[1], "::", input$dates[2]),
#               subset    = 'last 4 year',             # different ways of constructing subset
#               subset    = paste("last", input$time_num, input$time_unit),
                log.scale = input$log_y,
                theme     = "white")
  }
  

  
  



dataInput <- reactive({  

  if (input$updateData == 0  ) return(NULL)

  
#  cat(input$updateData,"\n")                     # use this to figure out the logic problem about "input.updateData & input.symbols != '' "
#  cat(input$symbols,"\n")
#  cat( (input$updateData  & input$symbols != ''  ) ,"\n")

  isolate({

    data <- NULL
    for (symbol in unlist(strsplit( input$symbols, ","))){
    sym <- tryCatch(
             {getSymbols(symbol, 
                         from = input$dateRange[1],
                         to = input$dateRange[2], 
                         src="yahoo",
                         auto.assign = FALSE)},
             error = function(e) { stop(paste('The symbol might be wrong:',symbol)) }
            )
    sym <- sym[,4]
    names(sym)[1] <- toupper(symbol)
    data <- cbind(data,sym)
    
    }
  data <- data.frame( index(data), coredata(data), stringsAsFactors=F ) 
  })
  data <- melt(data, id=("index.data."))
  data
})



output$plot_compare <- renderPlot({
  
 
  
  if(input$updateData == 0  ) return(NULL)
  
  p1 <- qplot(data= dataInput(), x = index.data. , y =value, geom="line", col = variable)+
    labs(x="time", y="price",col="", 
         title =paste(("Stock Close Price:           "), "           [",paste(input$dateRange, collapse = "/"),"]"))+
  theme( 
        #plot.margin = unit(c(1.5, 1, 1, 1), "cm"), 
        plot.title = element_text(size = 18, face = "bold", colour = "black", vjust = +1))
       

  print(p1)  

})









#   output$view <- renderTable({
#     if(input$updateData == 0 | input$symbols == "") return(NULL)
#        head(dataInput(), n = 10)
#   })  
  
  
  
###   output$plot_compare  <- renderPlot({ make_comparison(dataInput() )  })



  output$plot_ibm  <- renderPlot({ make_chart("IBM")  })
  output$plot_intc <- renderPlot({ make_chart("INTC") })
  output$plot_aapl <- renderPlot({ make_chart("AAPL") })
  output$plot_msft <- renderPlot({ make_chart("MSFT") })
  output$plot_yhoo <- renderPlot({ make_chart("YHOO") })
  output$plot_amzn <- renderPlot({ make_chart("AMZN") })
  output$plot_goog <- renderPlot({ make_chart("GOOG") })
  output$plot_fb   <- renderPlot({ make_chart("FB")   })
  output$plot_twtr <- renderPlot({ make_chart("TWTR") })
})
