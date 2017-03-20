#------------------------Version Info------------------------------------------------
#Change Description: (1) Using only the significant variables except description with glm.
#-------------------------------------------------------------------------------------

# KAGGLE COMPETITION - GETTING STARTED


# We are adding in the argument stringsAsFactors=FALSE, since we have some text fields

eBayTrain = read.csv("eBayiPadTrain.csv", stringsAsFactors=FALSE)

eBayTest = read.csv("eBayiPadTest.csv", stringsAsFactors=FALSE)

# We will just create a simple logistic regression model, to predict Sold using Price:

SimpleMod = glm(sold ~ ., data=eBayTrain[,!colnames(eBayTrain) %in% c("description","cellular","carrier","color")], family=binomial)

summary(SimpleMod)
# And then make predictions on the test set:

PredTest = predict(SimpleMod, newdata=eBayTest, type="response")

# We can't compute the accuracy or AUC on the test set ourselves, since we don't have the dependent variable on the test set (you can compute it on the training set though!). 
# However, you can submit the file on Kaggle to see how well the model performs.You can make up to 5 submissions per day, so don't hesitate to just upload a solution to see how you did.

PredTrain = predict(SimpleMod, newdata=eBayTrain, type="response")

table(eBayTrain$sold, PredTrain > 0.5)
#Accuracy on training set
(845+646)/length(PredTrain)
# = 0.8011822

#AUC on the training set
library(ROCR)
predtrainROCR = prediction(PredTrain,eBayTrain$sold)
performance(predtrainROCR, "auc")@y.values
#AUC=0.8631984

# prepare a submission file for Kaggle (for more about this, see the "Evaluation" page on the competition site):

MySubmission = data.frame(UniqueID = eBayTest$UniqueID, Probability1 = PredTest)

write.csv(MySubmission, "Submit-exc-desc-glm-mod2-30-July.csv", row.names=FALSE)

