header <- dashboardHeader(title = "Burn Out Prediction")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem(text = "Bussiness Case", 
                 tabName = "case", 
                 icon = icon("dollar-sign")),
        menuItem(text = "Prediction", 
                 tabName = "predict", 
                 icon = icon("info-circle")),
        menuItem(text = "Wordcloud", 
                 tabName = "word", 
                 icon = icon("file-word"))
        
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "predict", 
                fluidRow(
                    tabBox(id="tabchart1", width = 12, height = "1800px", 
                           tabPanel("Value",
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
                                    box(title = "Plot",
                                        background = "black",
                                        width = 6,
                                        fileInput("file1", "Choose CSV File",
                                                  accept = c(
                                                      "text/csv",
                                                      "text/comma-separated-values,text/plain",
                                                      ".csv")
                                        ),
                                        tags$hr(),
                                        checkboxInput("header", "Header", TRUE),
                                        plotlyOutput(outputId = "plot_burnout")
                                    )
                                    ,
                                    box(title = "Plot based Gender",
                                        background = "maroon",
                                        width = 6,
                                        solidHeader = TRUE,
                                        selectInput(inputId = "jenis", 
                                                    label = "Gender",
                                                    choices = unique(burnout_a$Gender)),
                                        plotlyOutput(outputId = "plot_gender")
                                        ),
                                    box(title = "Plot based Company",
                                        background = "maroon",
                                        width = 6,
                                        solidHeader = TRUE,
                                        selectInput(inputId = "kumpeni", 
                                                    label = "Company Type",
                                                    choices = unique(burnout_a$Company.Type)),
                                        plotlyOutput(outputId = "plot_company")
                                    ),
                                    box(title = "Plot based WFH/No",
                                        background = "maroon",
                                        width = 6,
                                        solidHeader = TRUE,
                                        selectInput(inputId = "kerja", 
                                                    label = "WFH/No",
                                                    choices = unique(burnout_a$WFH.Setup.Available)),
                                        plotlyOutput(outputId = "plot_wfh")
                                    )
                                    )
        ))),
        tabItem(tabName = "word", 
                h1("Wordcloud", align = "center"),
                fluidRow(
                    box(title = "Wordcloud based on Status",
                        background = "maroon",
                        width = 12,
                        solidHeader = TRUE,
                        selectInput(inputId = "status", 
                                    label = "Status",
                                    choices = unique(reviews_pivot$status)),
                        sliderInput(inputId = "banyaknya", 
                                     label = "Pilih Top n", 
                                     value = 15,
                                     min = 10, 
                                     max = 50, 
                                     step = 1),
                        plotOutput(outputId = "word_status")
                        ),
                    box(title = "Wordcloud based on Job Title",
                        background = "green",
                        width = 12,
                        solidHeader = TRUE,
                        selectInput(inputId = "title", 
                                    label = "Job Title",
                                    choices = unique(reviews_pivot$job_title)),
                        sliderInput(inputId = "jumlah", 
                                     label = "Pilih Top n", 
                                     value = 15,
                                     min = 10, 
                                     max = 50, 
                                     step = 1),
                        plotOutput(outputId = "word_title")),
                    box(title = "Wordcloud based Place",
                        background = "purple",
                        width = 12,
                        solidHeader = TRUE,
                        selectInput(inputId = "place", 
                                    label = "Place",
                                    choices = unique(reviews_pivot$Place)),
                        sliderInput(inputId = "berapa", 
                                    label = "Pilih Top n", 
                                    value = 15,
                                    min = 10, 
                                    max = 50, 
                                    step = 1),
                        plotOutput(outputId = "word_place")
                    )
                        
                    )
                    
                )
        ))
        
        
    





dashboardPage(
    header = header,
    body = body,
    sidebar = sidebar, 
    skin = "blue"
)
