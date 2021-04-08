library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$prediction <- renderValueBox({
        
        Gender <- input$gender
        Company.Type <- input$company
        WFH.Setup.Available <- input$wfh
        Designation <- input$design
        Resource.Allocation <- input$resource
        Mental.Fatigue.Score <- input$mental
        
        burnout_test <- data.frame(Gender,Company.Type,WFH.Setup.Available,Designation,Resource.Allocation,Mental.Fatigue.Score)
        model_forest <- readRDS("model_forest.RDS")
        
        forest_class <- predict(model_forest, burnout_test, type = "raw")
        
        valueBox(value = forest_class,
                 subtitle = "Prediction",
                 color = "purple",
                 icon = icon("user-cog"))
        
    })
    
})
