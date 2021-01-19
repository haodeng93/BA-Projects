#rpm_data = read.csv("/Users/qinshuai/Desktop/RPM.csv")

setwd("~/Desktop/MSBA/FIN 642/Final Project")
rpm_data = read.csv("RPM.csv")

rpm_data
library(quantmod)
library(tseries)
library(forecast)
library(ggplot2)
library(seasonal)
attributes(rpm_data)
# converting to time series object
rpm.ts <-ts(rpm_data$RPM,start=c(2000,1),end=c(2020,2),frequency=12)
autoplot(rpm.ts)+ggtitle("Time series plot of RPM")+xlab("Year")+ylab("RPM")

#description of data(min,max...)
summary(rpm.ts)
boxplot(rpm.ts~cycle(rpm.ts))

# training set & testing set split
train.set = round(length(rpm.ts)*0.9)
rpm.ts.train = window(rpm.ts,index(rpm.ts)[1],index(rpm.ts)[train.set])
rpm.ts.test = window(rpm.ts,index(rpm.ts)[train.set+1],c(2020,2))
rpm.ts.train
rpm.ts.test

#snaive
rpm.snaive <- snaive(rpm.ts.train,h=24)
rpm.snaive1 <- snaive(rpm.ts)
accuracy(rpm.snaive,rpm.ts.test)
#accuracy(rpm.snaive1)
autoplot(rpm.ts)+autolayer(rpm.snaive,series='snaive',PI=FALSE)+xlab("Year")+ylab("RPM")
checkresiduals(rpm.snaive)
#Residuals are correlated as shown by both the LB test and the ACF and do not appear to be normal (they have a long left tail). There is considerable information remaining in the residuals which has not been captured with the seasonal naÃ¯ve method.

#Decompose the series using STL and obtain the seasonally adjusted data.
rpm.fit <- stl(rpm.ts, s.window=7, robust=TRUE)
autoplot(rpm.fit)+ggtitle("STL decomposition (Robust)")
adjusted <- seasadj(rpm.fit)
autoplot(adjusted)

# then, comparing different HW methods
fit1 <- hw(rpm.ts,seasonal="multiplicative")
fit2 <- hw(rpm.ts,seasonal = "multiplicative", damped = TRUE)

autoplot(rpm.ts) +
  autolayer(fit1, series="HW multiplicative forecasts",
            PI=FALSE) +
  autolayer(fit2, series="HW multiplicative forecasts w/ damping",
            PI=FALSE) +
  xlab("Year") +
  guides(colour=guide_legend(title="Forecast"))+ ggtitle(" Holt-Winters methods fitting")

# Holt-Winters multiplicative method
rpm.hwm_forecast <- hw(rpm.ts.train,seasonal="multiplicative",damped = TRUE,h=24)
rpm.hwm_forecast1 <- hw(rpm.ts.train,seasonal="multiplicative",h=24)
#hwmT <- hw(rpm.ts,seasonal="multiplicative",damped = TRUE)
#hwmF <- hw(rpm.ts,seasonal="multiplicative")
accuracy(rpm.hwm_forecast,rpm.ts.test)
accuracy(rpm.hwm_forecast1,rpm.ts.test)
checkresiduals(rpm.hwm_forecast1)
checkresiduals(rpm.hwm_forecast)
accuracy(hwmT)
accuracy(hwmF)

#Arima model
#adf.test(rpm.ts)
#lambda = BoxCox.lambda(rpm.ts)
#lambda
#autoplot(BoxCox(rpm.ts,lambda))
#adf.test(diff(log(rpm.ts)), alternative="stationary", k=0)

rpm.ts.diff = diff(diff(rpm.ts,12),1)
autoplot(rpm.ts.diff)+  ggtitle("Seasonal diff + first diff")+
  autolayer(diff(rpm.ts,12), series="Seasonal Difference only")+
  autolayer(diff(rpm.ts,1), series="First Difference only")+
  autolayer(rpm.ts.diff, series="Seasonal diff + first diff")
guides(colour=guide_legend(title="Differencing"))

# determine the number of differences
ndiffs(rpm.ts) # require difference
nsdiffs(rpm.ts) # require seasonal difference

ndiffs(rpm.ts.diff) # do not require seasonal difference

# plot 12diff + 1 diff:
ggtsdisplay(diff(rpm.ts,1))
ggtsdisplay(diff(diff(rpm.ts,1),12))
# d =1 and D =1 needed
# non-seasonal MA(1) significant lag at 12 at ACF, and at PACF
# seasonal MA1 

# would try ARIMA(1,1,1)X(0,1,1)_12 (model 1)
# as well as: ARIMA(0,1,1)X(1,1,1)_12 (model 2); ARIMA(1,1,1)X(1,1,1)_12 (model 3)

# building models on training set
model1 = Arima(rpm.ts.train, order=c(1,1,1),
               seasonal=c(0,1,1))
summary(model1)

model2 = Arima(rpm.ts.train, order=c(0,1,1),
               seasonal=c(1,1,1))
summary(model2)

model3 = Arima(rpm.ts.train, order=c(1,1,1),
               seasonal=c(0,1,2))
summary(model3)

c(model1$aicc, model2$aicc, model3$aicc)
checkresiduals(model2)

## model 2 forecast:
# check accuracy metrics
arima_forecast = forecast(model2,h=24)
summary(arima_forecast)
accuracy(arima_forecast,rpm.ts.test)

# forecast plot
autoplot(arima_forecast)+
  ggtitle("model2")+
  autolayer(rpm.ts.test, series="Actual Data")+
  autolayer(arima_forecast$mean, series="SARIMA forecast")+
  guides(colour=guide_legend(title="Forecast"))

### Final step:
# access different methods' accuracies:
autoplot(rpm.ts)+
  ggtitle("Three model Forecasts")+
  autolayer(rpm.ts.test, series="Actual Data")+
  autolayer(arima_forecast$mean, series="SARIMA forecast")+
  autolayer(rpm.snaive$mean, series="Snaive forecast")+
  autolayer(rpm.hwm_forecast$mean, series="HW multiplicative forecast")+
  guides(colour=guide_legend(title="Forecast"))

# comparing accuracies:
accuracy(rpm.snaive,rpm.ts.test)
accuracy(rpm.hwm_forecast1,rpm.ts.test)
accuracy(arima_forecast,rpm.ts.test)

#Arima model with boxcox transformation
rpm.ts1 <-ts(rpm_data$RPM,start=c(2000,1),end=c(2018,2),frequency=12)
autoplot(rpm.ts1)
lambda <- BoxCox.lambda(rpm.ts1)
rpm.ts1 %>% BoxCox(lambda) %>% autoplot()
rpm.ts1 %>% BoxCox(lambda) %>% nsdiffs()
rpm.ts1 %>% BoxCox(lambda)%>% diff(lag=12) %>% ggtsdisplay()

rpm.ts1 %>% Arima(lambda = lambda, order = c(0,1,1), seasonal = c(1,1,1)) -> boxcoxarima
summary(boxcoxarima)
checkresiduals(boxcoxarima)
boxcoxarima_forecast = forecast(boxcoxarima,24)
summary(boxcoxarima_forecast)
accuracy(boxcoxarima_forecast,rpm.ts.test)

rpm.ts1 %>% Arima(lambda = lambda, order = c(1,1,1), seasonal = c(0,1,1)) -> boxcoxarima1
summary(boxcoxarima1)
checkresiduals(boxcoxarima1)
boxcoxarima_forecast1 = forecast(boxcoxarima1,24)
summary(boxcoxarima_forecast1)
accuracy(boxcoxarima_forecast1,rpm.ts.test)

rpm.ts1 %>% Arima(lambda = lambda, order = c(1,1,1), seasonal = c(0,1,2)) -> boxcoxarima2
summary(boxcoxarima2)
checkresiduals(boxcoxarima2)
boxcoxarima_forecast2 = forecast(boxcoxarima2,24)
summary(boxcoxarima_forecast2)
accuracy(boxcoxarima_forecast2,rpm.ts.test)
