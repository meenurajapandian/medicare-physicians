library(shiny)
library(ggplot2)
library(plotly)
library(maps)

ui <- fluidPage(  
   titlePanel("Plotly"),
   plotlyOutput("plot2"),
   verbatimTextOutput("click")
)

server <- function(input, output) {
   
   output$plot2 <- renderPlotly({
      us_states$keys <- row.names(us_states)
      p <- ggplot(data = us_states, aes(x = long, y = lat, group = group, key=keys)) + 
         geom_polygon(fill = "white", color = "black")
      ggplotly(p, layerData = 1)
   })
   
   output$click <- renderPrint({
      d <- event_data("plotly_click")
      if (is.null(d)) "Click events appear here (double-click to clear)" else d
   })
}

shinyApp(ui, server)