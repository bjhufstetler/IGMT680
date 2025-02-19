          #####################
          ##    Chapter 3    ##
          #####################

# READ IN THE CHURN DATA SET
  churn <- read.csv(file = "churn.txt", stringsAsFactors=TRUE)
  
  # Show the first ten records
  churn[1:10,]
  
  # Summarize the Churn variable
  sum.churn <- summary(churn$Churn)
  sum.churn
  
  # Calculate proportion of churners
  prop.churn <- sum(churn$Churn == "True") / length(churn$Churn)
  prop.churn
  
# BAR CHART OF VARIABLE CHURN
  barplot(sum.churn, ylim = c(0, 3000),
          main = "Bar Graph of Churners and Non-Churners",
          col = "lightblue")
  box(which = "plot", lty = "solid", col="black")
  
# MAKE A TABLE FOR COUNTS OF CHURN AND INTERNATIONAL PLAN
  counts <- table(churn$Churn, churn$Int.l.Plan, dnn=c("Churn", "International Plan"))
  counts
  
#OVERLAYED BAR CHART
  barplot(counts, legend = rownames(counts), col = c("blue", "red"),
          ylim = c(0, 3300), ylab = "Count", xlab = "International Plan",
          main = "Comparison Bar Chart: Churn Proportions by International Plan")
  box(which = "plot", lty = "solid", col="black")
  
# CREATE A TABLE WITH SUMS FOR BOTH VARIABLES
  sumtable <- addmargins(counts, FUN = sum)
  sumtable
  
# CREATE A TABLE OF PROPORTIONS OVER ROWS
  row.margin <- round(prop.table(counts, margin = 1), 4)*100
  row.margin
  
# CREATE A TABLE OF PROPORTIONS OVER COLUMNS
  col.margin <- round(prop.table(counts, margin = 2), 4)*100
  col.margin
  
# CLUSTERED BAR CHART, WITH LEGEND
  barplot(counts, col = c("blue", "red"), ylim = c(0, 3300),
          ylab = "Count", xlab = "International Plan",
          main = "Churn Count by International Plan", beside = TRUE)
  legend("topright", c(rownames(counts)), col = c("blue", "red"),
         pch = 15, title = "Churn")
  box(which = "plot", lty = "solid", col="black")
  
# CLUSTERED BAR CHART OF CHURN AND INTERNATIONAL PLAN WITH LEGEND
  barplot(t(counts), col = c("blue", "green"), ylim = c(0, 3300),
          ylab = "Counts", xlab = "Churn",
          main = "International Plan Count by Churn", beside = TRUE)
  legend("topright", c(rownames(counts)), col = c("blue", "green"),
         pch = 15, title = "Int'l Plan")
  box(which = "plot", lty = "solid", col="black")
  
# HISTOGRAM OF NON-OVERLAYED CUSTOMER SERVICE CALLS
  hist(churn$CustServ.Calls, xlim = c(0,10),
       col = "lightblue", ylab = "Count", xlab = "Customer Service Calls",
       main = "Histogram of Customer Service Calls")
  
# DOWNLOAD AND INSTALL THE R PACKAGE GGPLOT2
  #install.packages("ggplot2")
  # Pick any CRAN mirror
  # (see example image)
  # Open the new package
  library(ggplot2)            
  
  # OVERLAYED BAR CHARTS
  ggplot() +
    geom_bar(data = churn,
             aes(x = factor(churn$CustServ.Calls),
                 fill = factor(churn$Churn)),
             position = "stack") +
    scale_x_discrete("Customer Service Calls") +
    scale_y_continuous("Percent") +
    guides(fill=guide_legend(title="Churn")) +
    scale_fill_manual(values=c("blue", "red"))
  
  ggplot() +
    geom_bar(data=churn,
             aes(x = factor(churn$CustServ.Calls),
                 fill = factor(churn$Churn)),
             position = "fill") +
    scale_x_discrete("Customer Service Calls") +
    scale_y_continuous("Percent") +
    guides(fill=guide_legend(title="Churn")) +
    scale_fill_manual(values=c("blue", "red"))
  
# TWO-SAMPLE T-TEST FOR INT'L CALLS
  # Partition data
  churn.false <- subset(churn, churn$Churn == "False.")
  churn.true <- subset(churn, churn$Churn == "True.")
  
  # Run the test
  t.test(churn.false$Intl.Calls, churn.true$Intl.Calls)
  
# SCATTERPLOT OF EVENING MINUTES AND DAY MINUTES, COLORED BY CHURN
  plot(churn$Eve.Mins, churn$Day.Mins,
       xlim = c(0, 400), ylim = c(0, 400),
       xlab = "Evening Minutes", ylab = "Day Minutes",
       main = "Scatterplot of Day and Evening Minutes by Churn",
       col = ifelse(churn$Churn== "True", "red", "blue"))
  legend("topright", c("True", "False"),
         col = c("red", "blue"), pch = 1, title = "Churn")
  
# SCATTERPLOT OF DAY MINUTES AND CUSTOMER SERVICE CALLS, COLORED BY CHURN
  plot(churn$Day.Mins, churn$CustServ.Calls, xlim = c(0, 400),
       xlab = "Day Minutes", ylab = "Customer Service Calls",
       main = "Scatterplot of Day Minutes and Customer Service Calls by Churn",
       col = ifelse(churn$Churn=="True", "red", "blue"),
       pch = ifelse(churn$Churn=="True", 16, 20))
  legend("topright", c("True", "False"),
         col = c("red", "blue"), pch = c(16, 20), title = "Churn")
  
# SCATTERPLOT MATRIX
  pairs(~churn$Day.Mins + churn$Day.Calls + churn$Day.Charge)
  
# REGRESSION OF DAY CHARGE VS DAY MINUTES
  fit <- lm(churn$Day.Charge ~ churn$Day.Mins)
  summary(fit)
  
# CORRELATION VALUES, WITH P-VALUES
  days <- cbind(churn$Day.Mins, churn$Day.Calls, churn$Day.Charge)
  MinsCallsTest <- cor.test(churn$Day.Mins, churn$Day.Calls)
  MinsChargeTest <- cor.test(churn$Day.Mins, churn$Day.Charge)
  CallsChargeTest <- cor.test(churn$Day.Calls, churn$Day.Charge)
  round(cor(days), 4)
  MinsCallsTest$p.value
  MinsChargeTest$p.value
  CallsChargeTest$p.value
  
# CORRELATION VALUES AND P-VALUES IN MATRIX FORM
  # Collect variables of interest
  corrdata <-
    cbind(churn$Account.Length, churn$VMail.Message, churn$Day.Mins, churn$Day.Calls, churn$CustServ.Calls)
  
  # Declare the matrix
  corrpvalues <- matrix(rep(0, 25), ncol = 5)
  
  # Fill the matrix with correlations
  for (i in 1:4) {
    for (j in (i+1):5) {
      corrpvalues[i,j] <-
        corrpvalues[j,i] <-
        round(cor.test(corrdata[,i],
                       corrdata[,j])$p.value,
              4)
    }
  }
  round(cor(corrdata), 4)
  corrpvalues
  
  
            #####################
            ##    Chapter 4    ##
            #####################
  
# READ IN THE HOUSES DATASET AND PREPARE THE DATA
  houses <- read.csv(file="houses.csv", stringsAsFactors = FALSE, header = FALSE)
  names(houses) <- c("MVAL", "MINC", "HAGE", "ROOMS", "BEDRMS", "POPN", "HHLDS", "LAT", "LONG")
  
  # Standardize the variables
  houses$MINC_Z <- (houses$MINC - mean(houses$MINC))/(sd(houses$MINC))
  houses$HAGE_Z <- (houses$HAGE - mean(houses$HAGE))/(sd(houses$HAGE))
  houses$ROOMS_Z <- (houses$ROOMS - mean(houses$ROOMS))/(sd(houses$ROOMS))
  houses$BEDRMS_Z <- (houses$BEDRMS - mean(houses$BEDRMS))/(sd(houses$BEDRMS))
  houses$POPN_Z <- (houses$POPN - mean(houses$POPN))/(sd(houses$POPN))
  houses$HHLDS_Z <- (houses$HHLDS - mean(houses$HHLDS))/(sd(houses$HHLDS))
  houses$LAT_Z <- (houses$LAT - mean(houses$LAT))/(sd(houses$LAT))
  houses$LONG_Z <- (houses$LONG - mean(houses$LONG))/(sd(houses$LONG))
  
  # Randomly select 90% for the Training dataset
  choose <- runif(dim(houses)[1],0, 1)
  test.house <- houses[which(choose < .1),]
  train.house <- houses[which(choose <= .1),]
  
# PRINCIPAL COMPONENT ANALYSIS
  # Requires library "psych"
  #install.packages("psych")
  library(psych)
  pca1 <- principal(train.house[,c(10:17)], nfactors=8, rotate="none", scores=TRUE)
  
# PCA RESULTS
  # Eigenvalues:
  pca1$values
  
  # Loadings matrix,
  # variance explained,
  pca1$loadings
  
# SCREE PLOT
  plot(pca1$values, type = "b", main = "Scree Plot for Houses Data")
  
# PLOT FACTOR SCORES
  pairs(~train.house$MINC + train.house$HAGE+pca1$scores[,3],
         labels = c("Median Income", "Housing Median Age", "Component 3 Scores"))
  
  pairs(~train.house$MINC + train.house$HAGE+pca1$scores[,4],
         labels = c("Median Income", "Housing Median Age", "Component 4 Scores"))
  
# CALCULATE COMMUNALITIES
  comm3 <- loadings(pca1)[2,1]^2 + loadings(pca1)[2,2]^2 + loadings(pca1)[2,3]^2
  comm4 <- loadings(pca1)[2,1]^2 + loadings(pca1)[2,2]^2+ loadings(pca1)[2,3]^2 + loadings(pca1)[2,4]^2
  comm3; comm4
  
# VALIDATION OF THE PRINCIPAL COMPONENTS
  pca2 <- principal(test.house[,c(10:17)], nfactors=4, rotate="none", scores=TRUE)
  pca2$loadings
  
# READ IN AND PREPARE DATA FOR FACTOR ANALYSIS
  adult <- read.csv(file="adult.txt", stringsAsFactors = FALSE)
  adult$"capnet"<- adult$capital.gain-adult$capital.loss
  adult.s <- adult[,c(1,3,5,13,16)]
  
  # Standardize the data:
  adult.s$AGE_Z <- (adult.s$age - mean(adult.s$age))/(sd(adult.s$age))
  adult.s$DEM_Z <- (adult.s$demogweight - mean(adult.s$demogweight))/(sd(adult.s$demogweight))
  adult.s$EDUC_Z <- (adult.s$education.num - mean(adult.s$education.num))/(sd(adult.s$education.num))
  adult.s$CAPNET_Z <- (adult.s$capnet - mean(adult.s$capnet))/(sd(adult.s$capnet))
  adult.s$HOURS_Z <- (adult.s$hours.per.week - mean(adult.s$hours.per.week))/(sd(adult.s$hours.per.week))
  
  # Randomly select a Training dataset
  choose <- runif(dim(adult.s)[1],0, 1)
  test.adult <- adult.s[which(choose < .1), c(6:10)]
  train.adult <- adult.s[which(choose >= .1), c(6:10)]
  
# BARTLETT'S TEST FOR SPHERICITY
  # Requires package psych
  library(psych)
  corrmat1 <- cor(train.adult, method = "pearson")
  cortest.bartlett(corrmat1, n = dim(train.adult)[1])
  
# FACTOR ANALYSIS WITH FIVE COMPONENTS
  # Requires psych, GPArotation
  #install.packages("GPArotation")
  library(GPArotation)
  fa1 <- fa(train.adult, nfactors=5, fm = "pa", rotate="none", SMC=FALSE)
  fa1$values # Eigenvalues
  fa1$loadings # Loadings, proportion of variance, and cumulative variance
  
# FACTOR ANALYSIS WITH TWO COMPONENTS
  fa2 <- fa(train.adult, nfactors=2, fm = "pa", max.iter = 200, rotate="none")
  fa2$values # Eigenvalues
  fa2$loadings # Loadings
  fa2$communality # Communality
  
# VARIMAX ROTATION
  fa2v <- fa(train.adult, nfactors = 2, fm = "pa", max.iter = 200, rotate="varimax")
  fa2v$loadings
  fa2v$communality
  
# USER-DEFINED COMPOSITES
  small.houses <- houses[,c(4:7)]
  a <- c(1/4, 1/4, 1/4, 1/4)
  W <- t(a)*small.houses
  
  
            #####################
            ##    Chapter 7    ##
            #####################
  
# READ IN THE DATA, PARTITION TRAINING AND TESTING DATA
  adult <- read.csv(file = "adult.txt", stringsAsFactors=TRUE)
  choose <- runif(length(adult$income), min = 0, max = 1)
  training <- adult[choose <= 0.75,]
  testing <- adult[choose > 0.75,]
  adult[1:5, c(1,2,3)]
  training[1:5, c(1,2,3)]
  testing[1:5, c(1,2,3)] 
  
# REMOVE THE TARGET VARIABLE, INCOME, FROM THE TESTING DATA
  names(testing)
  
  # Target variable is in Column 15
  testing <- testing[,-15]
  names(testing)
  # Target variable is no longer in the testing data
  
# REMOVE THE PARTITIONING VARIABLE, PART, FROM BOTH DATA SETS
  # Part is now the 15th variable
  testing <- testing[,-15]
  names(testing)
  names(training)
  
  # Part is the 16th variable in the training data set
  training <- training[,-16]
  names(training)
  
