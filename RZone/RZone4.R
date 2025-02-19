          #####################
          ##    Chapter 12   ##
          #####################

# READ IN AND PREPARE THE DATA
  adult <- read.csv(file = "adult.txt", stringsAsFactors=TRUE)
  
  # Collapse categories as in Chapter 11
  # We will work with a small sample of data
  adult <- adult[1:500,]
  
# DETERMINE HOW MANY INDICATOR VARIABLES ARE NEEDED
  unique(adult$income)             # One variable for income
  unique(adult$sex)                   # One variable for sex
  unique(adult$race)                  # Four variables for race
  unique(adult$workclass)         # Three variables for workclass
  unique(adult$marital.status)   # Four variables for marital.status
  
# CREATE INDICATOR VARIABLES
  adult$race_white <- adult$race_black <- adult$race_as.pac.is <-
  adult$race_am.in.esk <- adult$wc_gov <-  adult$wc_self <- adult$wc_priv <-
  adult$ms_marr <- adult$ms_div <- adult$ms_sep <- adult$ms_wid <-
  adult$income_g50K <- adult$sex2 <- c(rep(0, length(adult$income)))
  for (i in 1:length(adult$income)) {
    if(adult$income[i]==">50K.")
      adult$income_g50K[i]<-1
    if(adult$sex[i] == "Male")
      adult$sex2[i] <- 1
    if(adult$race[i] == "White") adult$race_white[i] <- 1
    if(adult$race[i] == "Amer-Indian-Eskimo") adult$race_am.in.esk[i] <- 1
    if(adult$race[i] == "Asian-Pac-Islander") adult$race_as.pac.is[i] <- 1
    if(adult$race[i] == "Black") adult$race_black[i] <- 1
    if(adult$workclass[i] == "Gov") adult$wc_gov[i] <- 1
    if(adult$workclass[i] == "Self") adult$wc_self[i] <- 1
    if(adult$workclass[i] == "Private" ) adult$wc_priv[i] <- 1
    if(adult$marital.status[i] == "Married") adult$ms_marr[i] <- 1
    if(adult$marital.status[i] == "Divorced" ) adult$ms_div[i] <- 1
    if(adult$marital.status[i] == "Separated" ) adult$ms_sep[i] <- 1
    if(adult$marital.status[i] == "Widowed" ) adult$ms_wid[i] <- 1
  }
  
# MINIMAX TRANSFORM THE CONTINUOUS VARIABLES
  adult$age_mm <- (adult$age - min(adult$age))/(max(adult$age)-min(adult$age))
  adult$edu.num_mm <- (adult$education.num - min(adult$education.num))/
    (max(adult$education.num)-min(adult$education.num))
  adult$capital.gain_mm <- (adult$capital.gain - min(adult$capital.gain))/
    (max(adult$capital.gain)- min(adult$capital.gain))
  adult$capital.loss_mm <- (adult$capital.loss - min(adult$capital.loss))/
    (max(adult$capital.loss)- min(adult$capital.loss))
  adult$hours.p.w_mm <- (adult$hours.per.week - min(adult$hours.per.week))/
    (max(adult$hours.per.week)-min(adult$hours.per.week))
  newdat <- as.data.frame(adult[,-c(1:15)]) # Get rid of the variables we no longer need
  
# RUN THE NEURAL NET
  #install.packages("nnet")
  library(nnet) # Requires package nnet
  net.dat <- nnet(income_g50K ~ ., data = newdat, size = 8)
  table(round(net.dat$fitted.values, 1))   # If fitted values are all the same, rerun nnet
  net.dat$wts # Weights
  hist(net.dat$wts)

          #####################
          ##    Chapter 15   ##
          #####################
  
# THE CONFUSION MATRIX
  # After using the C5.0 package, the confusion matrix is included in the output of summary()
  # See Chapter 11 for data preparation and code to implement the C5.0 package

# ADD COSTS TO THE MODEL
  #install.packages("C50")
  library("C50")
  
  #After data preparation from Chapter 11
  x <- adult[,c(2,6, 9, 10, 16, 17, 18, 19, 20)]
  y <- adult$income
  
  # Without weights:
  c50fit <- C5.0(x, y, control = C5.0Control(CF=.1))
  summary(c50fit)
  
  # With weights:
  costm <- matrix(c(1, 2, 1, 1), byrow = FALSE, 2, 2)
  c50cost <- C5.0(x, y, costs = costm, control = C5.0Control(CF=.1))
  summary(c50cost)
  