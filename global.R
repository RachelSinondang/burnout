library(tidyverse)
library(caret)
library(randomForest)
library(e1071)
library(shiny)
library(shinydashboard)
library(plotly)
library(scales)
library(glue)
library(DT)
library(ggplot2)

burnout <- read.csv("train.csv")

burnout_a <- burnout %>%
  drop_na() %>%
  select(-c(Employee.ID,Date.of.Joining)) %>%
  mutate(Gender = as.factor(Gender),
         Company.Type = as.factor(Company.Type),
         WFH.Setup.Available = as.factor(WFH.Setup.Available),
         Designation = as.factor(Designation))

burnout_a$Burn.Rate <- if_else(condition = burnout_a$Burn.Rate > 0.5, true = "burnout",false = "not burnout")

burnout_a <- burnout_a %>%
  mutate(Burn.Rate = as.factor(Burn.Rate))

model_forest <- readRDS("model_forest.RDS")

review_clean <- read.csv("review_clean.csv")

reviews_pivot <- review_clean %>%
  pivot_longer(cols = c(positives,negatives),
               names_to = "sentiment",values_to = "coment") %>%
  mutate(sentiment = as.factor(sentiment))