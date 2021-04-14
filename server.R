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
        
        
        forest_class <- predict(model_forest, burnout_test, type = "raw")
        
        valueBox(value = forest_class,
                 subtitle = "Prediction",
                 color = "purple",
                 icon = icon("user-cog"))
        
    })
    
    output$plot_burnout <- renderPlotly({
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        data_test <- read.csv(inFile$datapath, header = input$header)
        
        data_test <- data_test %>%
            drop_na() %>%
            select(-c(Employee.ID,Date.of.Joining)) %>%
            mutate(Gender = as.factor(Gender),
                   Company.Type = as.factor(Company.Type),
                   WFH.Setup.Available = as.factor(WFH.Setup.Available),
                   Designation = as.factor(Designation))
        
        
        forest_class2 <- predict(model_forest, data_test, type = "raw")
        
        prediksi2 <- data.frame(forest_class2) %>% `colnames<-`("predict")
        
        test_predict <- cbind(data_test,prediksi2)
        
        freq_pred <- test_predict %>% group_by(predict) %>% summarise(total = n())
        
        plot_burnout <- ggplot(data = freq_pred,mapping = aes(x = predict, y = total, text = glue(
            "jumlah: {total}"))) +
            geom_col(aes(fill = predict))
        
        ggplotly(plot_burnout, tooltip = "text")
        
    })
    
    output$plot_gender <- renderPlotly({
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        data_test <- read.csv(inFile$datapath, header = input$header)
        
        data_test <- data_test %>%
            drop_na() %>%
            select(-c(Employee.ID,Date.of.Joining)) %>%
            mutate(Gender = as.factor(Gender),
                   Company.Type = as.factor(Company.Type),
                   WFH.Setup.Available = as.factor(WFH.Setup.Available),
                   Designation = as.factor(Designation))
        
        
        forest_class2 <- predict(model_forest, data_test, type = "raw")
        
        prediksi2 <- data.frame(forest_class2) %>% `colnames<-`("predict")
        
        test_predict <- cbind(data_test,prediksi2)
        
        freq_pred_gen <- test_predict %>% group_by(predict,Gender) %>% summarise(total = n())
        
        plot_gender <- ggplot(data = freq_pred_gen %>% filter(Gender == input$jenis),mapping = aes(x = predict, y = total, text = glue(
            "jumlah: {total}"))) +
            geom_col(aes(fill = predict))
        
        ggplotly(plot_gender, tooltip = "text")
        
        
        
    })
    
    output$plot_company <- renderPlotly({
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        data_test <- read.csv(inFile$datapath, header = input$header)
        
        data_test <- data_test %>%
            drop_na() %>%
            select(-c(Employee.ID,Date.of.Joining)) %>%
            mutate(Gender = as.factor(Gender),
                   Company.Type = as.factor(Company.Type),
                   WFH.Setup.Available = as.factor(WFH.Setup.Available),
                   Designation = as.factor(Designation))
        
        
        forest_class2 <- predict(model_forest, data_test, type = "raw")
        
        prediksi2 <- data.frame(forest_class2) %>% `colnames<-`("predict")
        
        test_predict <- cbind(data_test,prediksi2)
        
        freq_pred_company <- test_predict %>% group_by(predict,Company.Type) %>% summarise(total = n())
        
        plot_comp <- ggplot(data = freq_pred_company %>% filter(Company.Type == input$kumpeni),mapping = aes(x = predict, y = total, text = glue(
            "jumlah: {total}"))) +
            geom_col(aes(fill = predict))
        
        ggplotly(plot_comp, tooltip = "text")
        
    })
    
    output$plot_wfh <- renderPlotly({
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        data_test <- read.csv(inFile$datapath, header = input$header)
        
        data_test <- data_test %>%
            drop_na() %>%
            select(-c(Employee.ID,Date.of.Joining)) %>%
            mutate(Gender = as.factor(Gender),
                   Company.Type = as.factor(Company.Type),
                   WFH.Setup.Available = as.factor(WFH.Setup.Available),
                   Designation = as.factor(Designation))
        
        
        forest_class2 <- predict(model_forest, data_test, type = "raw")
        
        prediksi2 <- data.frame(forest_class2) %>% `colnames<-`("predict")
        
        test_predict <- cbind(data_test,prediksi2)
        
        freq_pred_wfh <- test_predict %>% group_by(predict,WFH.Setup.Available) %>% summarise(total = n())
        
        plot_wfh <- ggplot(data = freq_pred_wfh %>% filter(WFH.Setup.Available == input$kerja),mapping = aes(x = predict, y = total, text = glue(
            "jumlah: {total}"))) +
            geom_col(aes(fill = predict))
        
        ggplotly(plot_wfh, tooltip = "text")
        
    })
    
    output$word_status <- renderPlot({
        
        review_aa <- reviews_pivot %>% 
            filter(status == input$status) %>%
            unnest_tokens(word, coment)%>%
            mutate(word = textstem::lemmatize_words(word)) %>%
            anti_join(stop_words) %>% 
            count(word, sentiment, sort = T) %>% 
            group_by(sentiment) %>% 
            top_n(input$banyaknya)
        
        
        library(ggthemes)
        
        ggplot(review_aa, aes(label = word)) +
            ggwordcloud::geom_text_wordcloud(aes(size=n, color = sentiment)) +
            facet_wrap(~sentiment, scales = "free_y") +
            scale_size_area(max_size = 15) 
        
    })
    
    output$word_title <- renderPlot({
        
        review_bb <- reviews_pivot %>% 
            filter(job_title == input$title) %>%
            unnest_tokens(word, coment)%>%
            mutate(word = textstem::lemmatize_words(word)) %>%
            anti_join(stop_words) %>% 
            count(word, sentiment, sort = T) %>% 
            group_by(sentiment) %>% 
            top_n(input$jumlah)
        
        
        library(ggthemes)
        
        ggplot(review_bb, aes(label = word)) +
            ggwordcloud::geom_text_wordcloud(aes(size=n, color = sentiment)) +
            facet_wrap(~sentiment, scales = "free_y") +
            scale_size_area(max_size = 15) 
        
    })
    
    output$word_place <- renderPlot({
        
        review_cc <- reviews_pivot %>% 
            filter(Place == input$place) %>%
            unnest_tokens(word, coment)%>%
            mutate(word = textstem::lemmatize_words(word)) %>%
            anti_join(stop_words) %>% 
            count(word, sentiment, sort = T) %>% 
            group_by(sentiment) %>% 
            top_n(input$berapa)
        
        
        library(ggthemes)
        
        ggplot(review_cc, aes(label = word)) +
            ggwordcloud::geom_text_wordcloud(aes(size=n, color = sentiment)) +
            facet_wrap(~sentiment, scales = "free_y") +
            scale_size_area(max_size = 15) 
        
    })
    
})
