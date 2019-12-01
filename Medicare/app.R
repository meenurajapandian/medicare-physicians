library(shiny)
library(ggplot2)
library(plotly)
library(maps)

ui <- fluidPage(  
   titlePanel("Plotly"),
   sidebarLayout(
      sidebarPanel(),
      mainPanel(
         plotlyOutput("plot2"))))

server <- function(input, output) {
   
   output$plot2 <- renderPlotly({
      p <- ggplot(data = us_states,
                  mapping = aes(x = long, y = lat,
                                group = group)) + geom_polygon(fill = "white", color = "black")
      ggplotly(p)
   })
}

shinyApp(ui, server)