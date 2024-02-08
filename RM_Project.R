library(faraway) 
library(olsrr)
library(caret)
library(car)

#use chredlin data set 
chredlin
summary(chredlin)

#basic multiple regression model
lmod <- lm(involact ~ race + fire + theft + age + income + side, data=chredlin)
summary(lmod)

y<- chredlin$involact
x1 <- chredlin$race
x2 <- chredlin$fire
x3 <- chredlin$theft
x4 <- chredlin$age 
x5 <- chredlin$income
x6 <- chredlin$side


#scatterplot matrix for all variables 
pairs(involact ~ race + fire + theft + age + income + side, data=chredlin)

#generate plots to assess normality and assumptions
qqnorm(residuals(lmod),ylab="Residuals",main="Normal Q-Q plot")
qqline(residuals(lmod))

#plot of partial regression plots
avPlots(lmod,print_plot=TRUE)

#residuals vs fitted values, leverage, etc
plot(lmod)

#find all possible regressions 
allpossible <- ols_step_all_possible(lmod)
allpossible

#find the best subsets model for each number of regressors
bestsubset <- ols_step_best_subset(lmod)
bestsubset

#perform forward, backward, and stepwise selection procedures
forward <- ols_step_forward_p(lmod)
backward <- ols_step_backward_p(lmod)
stepwise <- ols_step_both_p(lmod)

plot(forward)
plot(backward)
plot(stepwise)

forward
backward
stepwise

#model validation with models that seem satisfactory using 5 fold cross validation
#compare the model chosen from the forward/stepwise/backward and the model with second lowest mallow's Cp

modela <- lm(involact ~ race + fire + theft + age, data=chredlin)
modelb <- lm(involact ~ race + fire + theft + age + income, data = chredlin)

train.control <- trainControl(method="cv", number = 10 )
cva <- train(involact ~ race + fire + theft + age, data=chredlin, 
                  method="lm",trControl = train.control)
cvb <- train(involact ~ race + fire + theft + age + income, data=chredlin,
                  method="lm", trControl = train.control)

cva
cvb

#choose model a as the final 
