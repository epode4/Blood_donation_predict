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


(lamb <- BoxCox.lambda(train_b))
autoplot(train_b)
train_b1 <- train_b |> BoxCox(lambda = lamb)
train_b1 |> autoplot()
train_b2 <- train_b |> BoxCox(lambda = 0)
train_b2 |> autoplot()


four <- function(train_a,a=6,...){
  res <- vector("numeric",a)
  Time <- time(train_a)
  for (i in seq(res)){
    xreg <- cbind(Time,fourier(train_a,K=i))
    fit <- auto.arima(train_a,xreg=xreg,...)
    res[i] <- fit$aicc
  }
  b <- list(res,kmin <- which.min(res))
  return(b)
}

test <- function(train_a,fita,a){
  res_a <- residuals(fita)
  df_a <- length(fita$par)
  lag_a <- min(a,round(length(train_a)/5))
  ggtsdisplay(res_a,plot.type = "histogram")
  Box.test(res_a,fitdf=df_a,lag=lag_a,type="Ljung-Box")
}


#ets
fit1 <- ets(train_b)
summary(fit1)

test(train_b,fit1,24)


#arima
ggtsdisplay(train_b)
ndiffs(train_b)
nsdiffs(train_b)



train_b1 <- train_b |> diff()
train_b1 |> ggtsdisplay()
#비정상 자료로 진행 X


train_b2 <- train_b |> diff(lag=12)
train_b2 |> ggtsdisplay()
train_b2_1 <- train_b2 |> diff()
train_b2_1 |> ggtsdisplay()



fit2 <- auto.arima(train_b,d=1,D=1,stepwise = FALSE)
summary(fit2)
checkresiduals(fit2)


#regression
Time <- time(train_b)
Month <- seasonaldummy(train_b)

fit3 <- auto.arima(train_b,stepwise = FALSE,
                   xreg=cbind(Time,Month))
summary(fit3)


fit3_1 <- Arima(train_b,order=c(3,0,0),seasonal=c(2,0,0),
                include.mean = TRUE,xreg=cbind(Time,Month))
summary(fit3_1)


fit3_2 <- Arima(train_b,order=c(3,0,0),seasonal=c(2,0,0),
                include.mean = TRUE,xreg=cbind(Time,Month),
                fixed=c(NA,NA,NA,0,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA))
summary(fit3_2)

c(fit3_1$aicc,fit3_2$aicc)

checkresiduals(fit3_2)
pchisq(26.002,df=19-13,lower.tail = FALSE)

four(train_b)

#예측 진행 비교
#ets

fc1 <- forecast(fit1,h=length(test_b))
accuracy(fc1,test_b)

e1 <- autoplot(fc1)+
  autolayer(test_b,color="red",size=1)+
  labs(y=NULL,subtitle = "fc1")
e1_1 <- autoplot(fc1,include = 10)+
  autolayer(test_b,color="red",size=1)+
  labs(y=NULL,subtitle = "fc1")
e1/e1_1


#arima

fc2 <- forecast(fit2,h=length(test_b))
accuracy(fc2,test_b)

a1 <- autoplot(fc2)+
  autolayer(test_b,color="red",size=1)+
  labs(y=NULL,subtitle = "fc2")
a1_1 <- autoplot(fc2,include = 10)+
  autolayer(test_b,color="red",size=1)+
  labs(y=NULL,subtitle = "fc2")
a1/a1_1


#regression

fc3 <- forecast(fit3_2,
                xreg=cbind(Time=time(test_b),
                           Month=seasonaldummy(test_b)))
accuracy(fc3,test_b)

r1 <- autoplot(fc3)+
  autolayer(test_b,color="red",size=1)+
  labs(y=NULL,subtitle = "fc3")
r1_1 <- autoplot(fc3,include = 10)+
  autolayer(test_b,color="red",size=1)+
  labs(y=NULL,subtitle = "fc3")
r1/r1_1

