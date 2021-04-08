header <- dashboardHeader(title = "Burn Out Prediction")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem(text = "Bussiness Case", 
                 tabName = "case", 
                 icon = icon("dollar-sign")),
        menuItem(text = "Prediction", 
                 tabName = "predict", 
                 icon = icon("info-circle")),
        menuItem(text = "Plot", 
                 tabName = "plot", 
                 icon = icon("balance-scale"))
        
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "predict", 
                fluidRow(
                    tabBox(id="tabchart1", width = 12, height = "1000px", 
                           tabPanel("SuicideRate",
                                    box(title = "Input",
                                        background = "black",
                                        width = 6,
                                        selectInput(inputId = "gender", 
                                                    label = "Gender",
                                                    choices = unique(burnout_a$Gender)),
                                        selectInput(inputId = "company", 
                                                    label = "Company Type",
                                                    choices = unique(burnout_a$Company.Type)),
                                        selectInput(inputId = "wfh", 
                                                    label = "WFH/No",
                                                    choices = unique(burnout_a$WFH.Setup.Available)),
                                        selectInput(inputId = "design", 
                                                    label = "Designation",
                                                    choices = unique(burnout_a$Designation)),
                                        numericInput(inputId = "resource", 
                                                     label = "Resource Allocation", 
                                                     value = 5,
                                                     min = 1, 
                                                     max = 20, 
                                                     step = 1),
                                        numericInput(inputId = "mental", 
                                                     label = "Mental Fatigue Score", 
                                                     value = 3,
                                                     min = 0, 
                                                     max = 10, 
                                                     step = 0.1)
                                        
                                        
                                    ),
                                    
                                    valueBoxOutput("prediction")),
                           tabPanel("Plot",
                                    box(title = "Input",
                                        background = "black",
                                        width = 5,
                                        fileInput("file1", "Choose CSV File",
                                                  accept = c(
                                                      "text/csv",
                                                      "text/comma-separated-values,text/plain",
                                                      ".csv")
                                        ),
                                        tags$hr(),
                                        checkboxInput("header", "Header", TRUE)
                                    )
                                    ,
                                    box(title = "Plot",
                                        background = "maroon",
                                        width = 6,
                                        solidHeader = TRUE,
                                        plotlyOutput(outputId = "plot_burnout"))
                                    
                                    )
        )))))
        
        
    





dashboardPage(
    header = header,
    body = body,
    sidebar = sidebar, 
    skin = "blue"
)
