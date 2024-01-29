library(fpp2)
library(patchwork)
library(readxl)
library(tidyverse)

blood <- read_xlsx("C:/Users/Seain/Desktop/공부하긔/4-1/시계열분석/report/헌혈현황(월별).xlsx")


blood_ts <- ts(as.numeric(blood$합계),start=c(2005,1),end=c(2021,12),freq=12)
blood_ts |> autoplot()
blood_ts |> decompose() |> autoplot()

train_b <- window(blood_ts,end=c(2019,12))
test_b <- window(blood_ts,start=c(2020,1))

