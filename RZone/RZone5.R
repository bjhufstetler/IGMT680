          #####################
          ##    Chapter 19   ##
          #####################

# INSTALL THE REQUIRED PACKAGE AND CREATE THE DATA
  library(cluster)
  data <- c(2, 5, 9, 15, 16, 18, 25, 33, 33, 45)
  
# SINGLE-LINKAGE CLUSTERING
  agn <- agnes(data, diss = FALSE, stand = FALSE, method = "single")
  
  # Make and plot the dendrogram
  dend_agn <- as.dendrogram(agn)
  plot(dend_agn,
       xlab = "Index of Data Points",
       ylab = "Steps",
       main = "Single-Linkage Clustering")
  
# COMPLETE-LINKAGE CLUSTERING
  agn_complete <- agnes(data, diss = FALSE, stand = FALSE, method = "complete")
  
  # Make and plot the dendrogram
  dend_agn_complete <- as.dendrogram(agn_complete)
  plot(dend_agn_complete,
       xlab = "Index of Data Points",
       ylab = "Steps",
       main = "Complete-Linkage  Clustering")
  
# K-MEANS CLUSTERING
  # Create the data matrix from Table 10.1
  m <- matrix(c(1,3,3,3,4,3,5,3, 1,2,4,2,1,1,2,1), byrow=TRUE, ncol = 2)
  km <- kmeans(m, centers = 2)
  km

          #####################
          ##    Chapter 20   ##
          #####################

# OPEN ‘KOHONEN’ PACKAGE. READ IN AND PREPARE THE DATA
  #install.packages("kohonen")
  library(kohonen)
  churn <- read.csv(file = "churn.txt", stringsAsFactors=TRUE)
  IntPlan <- VMPlan <- Churn <- c(rep(0, length(churn$Int.l.Plan))) # Flag variables
  for (i in 1:length(churn$Int.l.Plan)) {
    if (churn$Int.l.Plan[i]=="yes") IntPlan[i] = 1
    if (churn$VMail.Plan[i]=="yes") VMPlan[i] = 1
    if (churn$Churn[i] == "True.") Churn[i] = 1
  }
  AcctLen <- (churn$Account.Length - mean(churn$Account.Length)) / sd(churn$Account.Length)
  VMMess <- (churn$VMail.Message - mean(churn$VMail.Message)) / sd(churn$VMail.Message)
  DayMin <- (churn$Day.Mins - mean(churn$Day.Mins)) / sd(churn$Day.Mins)
  EveMin <- (churn$Eve.Mins - mean(churn$Eve.Mins)) / sd(churn$Eve.Mins)
  NiteMin <- (churn$Night.Mins - mean(churn$Night.Mins)) / sd(churn$Night.Mins)
  IntMin <- (churn$Intl.Mins - mean(churn$Intl.Mins)) / sd(churn$Intl.Mins)
  CSC <- (churn$CustServ.Calls - mean(churn$CustServ.Calls)) / sd(churn$CustServ.Calls)
  
# RUN THE ALGORITHM TO GET A 3X2 KOHONEN NETWORK
  # Make the variables into one matrix, and make sure the records are the rows
  dat <- t(rbind(IntPlan, VMPlan, AcctLen, VMMess, DayMin, EveMin, NiteMin, IntMin, CSC))
  som.6 <- som(dat, grid = somgrid(3, 2), rlen = 170, alpha = c(0.3, 0.00), radius = 2)
  
  # Plot the make-up of each cluster
  plot(som.6, type = c("codes"), palette.name = rainbow, main = "Cluster Content")
  
  # Plot the counts in each cluster
  plot(som.6, type = c("counts"), palette.name = rainbow, main = "Cluster Counts")
  
# PLOT MAKE-UP OF CLUSTERS
  som.6$unit.classif # Winning Clusters
  som.6$grid$pts # Plot locations
  coords <- matrix(0, ncol = 2, nrow = dim(dat)[1])
  for(i in 1:dim(dat)[1]){
    coords[i,] <-
      som.6$grid$pts[som.6$unit.classif[i],]
  }
  pchVMPlan <- ifelse(dat[,2]==0 , 1, 16)
  colVMPlan <- ifelse(dat[,2]==0 , 1, 2)
  plot(jitter(coords), main = "Kohonen Network colored by VM Plan",
       col = colVMPlan,
       pch = pchVMPlan)
  
# TABLE OF PERCENT CHURN BY CLUSTER
  c.table <- table(Churn, som.6$unit.classif)
  round(prop.table(c.table, 2)*100, 2)
  