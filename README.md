# Italian Energy Consumption Prediction

*Model Identification and Data Analysis course project at University of Pavia  
Developed in collaboration with: @simoneghiazzi, @riccardocrescenti, @chiarabertocchi and @r1cky0*

## General Overview

*Goal: identification of an annual profile model for the long-term prediction of the Italian energy consumption time series*  

The provided dataset is composed of Italian energy consumption data for a two-year period.  
From initial observations of the available dataset, there is a periodic pattern, both annual and weekly. For this reason, Fourier Series will be used in the development of the model.  
The first step is to make the series stationary on average through the operation of detrending

![image](https://user-images.githubusercontent.com/48442855/139588394-1a6f148a-dadc-420f-b81f-24e8f05985b2.png)

## Model Development

For what concern the training and the validation of the model, the dataset is divided as follows:
- Training: energy consumption data of the first year
- Validation: second year energy consumption data

2 main models have been developed for the 2 different periodicities detected in the data:
1. Weekly periodicity model: Phi_settimanale consisting of 6 harmonics, of period 7

![image](https://user-images.githubusercontent.com/48442855/139588834-099da783-b963-44ff-a40f-8c3ff9725f6c.png)

2. Annual periodicity model: 12 annual models were developed, up to 24 harmonics

![image](https://user-images.githubusercontent.com/48442855/139588929-f00cda3d-f5b4-4eee-bc2a-4a2197877e65.png)

### Additive Model Validation
A new validation Phi was created for the weekly model, using the weekly days of validation data: 12 final models were created consisting of the sum of the weekly validation model and the annual models created in the training phase.  
Using the AIC and Crossvalidation tests, the model that best represents the data is chosen.

*AIC Test:*

![image](https://user-images.githubusercontent.com/48442855/139589174-7c523cdf-b677-4e07-ab25-f3d3648f828e.png)

*CrossValidation Test:*

![image](https://user-images.githubusercontent.com/48442855/139589182-b876af1a-2ae2-4bf8-85eb-3a7e8bf43db8.png)

From the tests we see that the best annual model is model 10, consisting of 20 regressors.  
For this model we calculated:
- MSE = 3.836955832
- RMSE = 1.958814904

*Validation Data 3D Plot:*

![image](https://user-images.githubusercontent.com/48442855/139589298-3624c9e5-ccfb-442a-af26-1aa4ea31a088.png)

*Final Model Surface:*

![image](https://user-images.githubusercontent.com/48442855/139589322-7cfd69bf-7f28-43ef-a32d-28a3a729a463.png)

## Holiday's Problem
An analysis of the error histogram shows a concentration of errors around zero. However, there is an "anomalous" zone between -6 and -10, which represents the errors found in correspondence with the holidays.

![image](https://user-images.githubusercontent.com/48442855/139589474-d304457c-565c-4d57-b278-edea555af881.png)

As can be seen from the graph, the periods of greatest fluctuation in the validation epsilon (which represents the magnitude of the error) are those in correspondence with holidays, where:
- Blue: Easter
- Yellow: mid-August
- Red: Christmas

![image](https://user-images.githubusercontent.com/48442855/139589571-2abb62f6-7953-46ee-98c3-a5bae6588b0b.png)

The final model was then retrained on the data without the holiday periods (Christmas and mid-August holidays, which have a fixed date) to improve the prediction of "normal" days. An average was made on the data values assumed during these holiday periods, which was then added to the final model as a "correction index".  
In this way the validation parameters improve:
- SSR = 1.186772448087091e+03
- MSE = 3.251431364622168
- RMSE = 1.803172583149535

## Final Function
The final function takes in input 2 scalars (day of the year, day of the week) and returns the prediction of energy consumption. It consists of:
- A method for solving null values
- Detrending technique: estimation of the trend of the 2 years
- Identification of the model on the 2 years supplied data
- Generation of the matrix containing all possible combinations day year - day week
- Trend extension: extension of the last value of the trend that is added to the data of forecast

The forecast data is then read from the matrix using the 2 input indices.
