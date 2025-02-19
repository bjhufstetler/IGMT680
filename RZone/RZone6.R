          #####################
          ##    Chapter 21   ##
          #####################

# OPEN REQUIRED PACKAGE, READ IN THE DATA
  #install.packages("birch")
  library(birch)
  loan.test <- read.csv(file="Loans_Test.csv", header = TRUE)
  loan.train <- read.csv(file="Loans_Training.csv", header = TRUE)
  
  # Use 5,000 records for a small example
  train <- as.matrix(loan.train[1:1000,-c(1,5)])
  
# BIRCH CLUSTERING
  b1 <- birch(x = train, radius=1000) # Create the Birch tree
  
  # Cluster the sub-clusters using kmeans
  kb1 <- kmeans.birch(birchObject = b1, centers = 2, nstart = 1)
  
# PLOT THE RESULTS
  par(mfrow=c(2,2))
  plot(b1[,c(2,3)], col = kb1$clust$sub)
  plot(jitter(train[,c(1,3)], .1), col = kb1$clust$sub, pch = 16)
  plot(jitter(train[,c(1,2)], .1), col = kb1$clust$sub, pch = 16)
  plot(train[,c(2,3)], col = kb1$clust$sub, pch = 16)

          #####################
          ##    Chapter 22   ##
          #####################

# READ IN AND PREPARE THE DATA
  i.data <- iris # Iris is a built-in dataset
  # Min-max normalization
  i.data$SL <- (i.data$Sepal.Length - min(i.data$Sepal.Length))/
    (max(i.data$Sepal.Length) - min(i.data$Sepal.Length))
  i.data$SW <- (i.data$Sepal.Width - min(i.data$Sepal.Width))/
    (max(i.data$Sepal.Width) - min(i.data$Sepal.Width))
  i.data$PL <- (i.data$Petal.Length - min(i.data$Petal.Length))/
    (max(i.data$Petal.Length) - min(i.data$Petal.Length))
  i.data$PW <- (i.data$Petal.Width - min(i.data$Petal.Width))/
    (max(i.data$Petal.Width) - min(i.data$Petal.Width))
  
# SILHOUETTE VALUES
  # Requires package 'cluster'
  #install.packages("cluster")
  library(cluster)
  
  # k-means (k=3)
  km1 <- kmeans(i.data[,6:9], 3)
  dist1 <- dist(i.data[,6:9], method = "euclidean")
  sil1 <- silhouette(km1$cluster, dist1)
  plot(sil1, col = c("black", "red", "green"),
       main = "Silhouette Plot: 3-Cluster K-Means Clustering of Iris Data")
  
  # k-means (k=2)
  km2 <- kmeans(i.data[,6:9], 2)
  dist2 <- dist(i.data[,6:9], method = "euclidean")
  sil2 <- silhouette(km2$cluster, dist2)
  plot(sil2, col = c("black", "red"),
       main = "Silhouette Plot: 2-Cluster K-Means Clustering of Iris Data")
  
# PLOT SILHOUETTE VALUES
  silval1 <- ifelse(sil1[,3] <= 0.33, 0, 1)
  plot(i.data$PL, i.data$PW, col = silval1+1,
       pch = 16,
       main = "Silhouette Values, K = 3",
       xlab = "Petal Length (min-max)",
       ylab = "Petal Width (min-max)")
  legend("topleft", col=c(1,2), pch = 16, legend=c("<= 0.33", "> 0.33"))
  silval2 <- ifelse(sil2[,3] <= 0.33, 0, 1)
  plot(i.data$PL, i.data$PW, col = silval2+1,
        pch = 16,
        main = "Silhouette Values, K = 2",
        xlab = "Petal Length (min-max)",
        ylab = "Petal Width (min-max)")
  legend("topleft", col=c(1,2), pch = 16,
          legend=c("<= 0.33", "> 0.33"))
       
# PSEUDO-F
  # Requires package 'clusterSim'
  #install.packages("clusterSim")
  library("clusterSim")
  n <- dim(i.data)[1]
  psF1 <- index.G1(i.data[,6:9], cl = km1$cluster)
  pf(psF1, 2, n-2)
  psF2 <- index.G1(i.data[,6:9], cl = km2$cluster)
  pf(psF2, 1, n-1)
  
# CLUSTER VALIDATION—PREPARE THE DATA
  loan.test <- read.csv(file="Loans_Test.csv", header = TRUE)
  loan.train <- read.csv(file="Loans_Training.csv", header = TRUE)
  test <- loan.test[,-1]
  train <- loan.train[,-1]
  kmtest <- kmeans(test, centers = 3)
  kmtrain <- kmeans(train, centers = 3)
  
# CLUSTER VALIDATION—VARIABLE SUMMARIES BY CLUSTER
  clust.sum <- matrix(0.0, ncol = 3, nrow = 4)
  colnames(clust.sum) <- c("Cluster 1", "Cluster 2", "Cluster 3")
  rownames(clust.sum) <- c("Test Data Mean", "Train Data Mean", "Test Data Std Dev", "Test Data Std Dev")
  clust.sum[1,] <- tapply(test$Debt.to.Income.Ratio, kmtest$cluster, mean)
  clust.sum[2,] <- tapply(train$Debt.to.Income.Ratio, kmtrain$cluster, mean)
  clust.sum[3,] <- tapply(test$Debt.to.Income.Ratio, kmtest$cluster, sd)
  clust.sum[4,] <- tapply(train$Debt.to.Income.Ratio, kmtrain$cluster, sd)
  