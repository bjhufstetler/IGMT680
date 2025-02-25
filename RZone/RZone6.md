---
title: "R Zone 6: Chapter 21 and 22"
date: "19 August 2019"
author: " Brandon Hufstetler, Garrett Alarcon, Jinan Andrews, Anson Cheng, Nick Forrest, and Nestor Herandez"
output: 
  # tufte_handout:
    # highlight: tango
  # html_document:
  #   theme: journal
  tufte::tufte_html:
    keep_md: true
    # highlight: tango
---



# Chapter 21

### OPEN REQUIRED PACKAGE, READ IN THE DATA
#### Note that birch is no longer supported on CRAN and must be installed through an archived version. The approval and interest were removed from the classification training data because the interest is perfectly correlated with the requested amount.

```r
  #install.packages("birch")
  setwd("~/IMGT680")
  library(birch)
```

```
## Loading required package: ellipse
```

```
## 
## Attaching package: 'ellipse'
```

```
## The following object is masked from 'package:graphics':
## 
##     pairs
```

```r
  loan.test <- read.csv(file="Loans_Test.csv", header = TRUE)
  loan.train <- read.csv(file="Loans_Training.csv", header = TRUE)
  
  # Use 5,000 records for a small example
  train <- as.matrix(loan.train[1:5000,-c(1,5)])
```

### BIRCH CLUSTERING

```r
  b1 <- birch(x = train, radius=1000) # Create the Birch tree
  
  # Cluster the sub-clusters using kmeans
  kb1 <- kmeans.birch(birchObject = b1, centers = 2, nstart = 1)
```

### PLOT THE RESULTS
#### Since only one value of k is selected (2), we cannot make a comparison to different models and BIRCH is unable to suggest a k. The clusters shown below 

```r
  par(mfrow=c(2,2))
  plot(b1[,c(2,3)], col = kb1$clust$sub)
  plot(jitter(train[,c(1,3)], .1), col = kb1$clust$sub, pch = 16)
  plot(jitter(train[,c(1,2)], .1), col = kb1$clust$sub, pch = 16)
  plot(train[,c(2,3)], col = kb1$clust$sub, pch = 16)
```

<img src="RZone6_files/figure-html/unnamed-chunk-3-1.png"  />

# Chapter 22

### READ IN AND PREPARE THE DATA

```r
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
```

### SILHOUETTE VALUES

```r
  # Requires package 'cluster'
  #install.packages("cluster")
  library(cluster)
 
  # k-means (k=3)
  km1 <- kmeans(i.data[,6:9], 3)
  dist1 <- dist(i.data[,6:9], method = "euclidean")
  sil1 <- silhouette(km1$cluster, dist1)
  plot(sil1, col = c("black", "red", "green"),
       main = "Silhouette Plot: 3-Cluster K-Means Clustering of Iris Data")
```

<img src="RZone6_files/figure-html/unnamed-chunk-5-1.png"  />

```r
  # k-means (k=2)
  km2 <- kmeans(i.data[,6:9], 2)
  dist2 <- dist(i.data[,6:9], method = "euclidean")
  sil2 <- silhouette(km2$cluster, dist2)
  plot(sil2, col = c("black", "red"),
       main = "Silhouette Plot: 2-Cluster K-Means Clustering of Iris Data")
```

<img src="RZone6_files/figure-html/unnamed-chunk-5-2.png"  />

### PLOT SILHOUETTE VALUES

```r
  silval1 <- ifelse(sil1[,3] <= 0.33, 0, 1)
  plot(i.data$PL, i.data$PW, col = silval1+1,
       pch = 16,
       main = "Silhouette Values, K = 3",
       xlab = "Petal Length (min-max)",
       ylab = "Petal Width (min-max)")
  legend("topleft", col=c(1,2), pch = 16, legend=c("<= 0.33", "> 0.33"))
```

<img src="RZone6_files/figure-html/unnamed-chunk-6-1.png"  />

```r
  silval2 <- ifelse(sil2[,3] <= 0.33, 0, 1)
  plot(i.data$PL, i.data$PW, col = silval2+1,
        pch = 16,
        main = "Silhouette Values, K = 2",
        xlab = "Petal Length (min-max)",
        ylab = "Petal Width (min-max)")
  legend("topleft", col=c(1,2), pch = 16,
          legend=c("<= 0.33", "> 0.33"))
```

<img src="RZone6_files/figure-html/unnamed-chunk-6-2.png"  />

### PSEUDO-F

```r
  # Requires package 'clusterSim'
  #install.packages("clusterSim")
  library("clusterSim")
```

```
## Warning: package 'clusterSim' was built under R version 3.5.2
```

```
## Loading required package: MASS
```

```r
  n <- dim(i.data)[1]
  psF1 <- index.G1(i.data[,6:9], cl = km1$cluster)
  pf(psF1, 2, n-2)
```

```
## [1] 1
```

```r
  psF2 <- index.G1(i.data[,6:9], cl = km2$cluster)
  pf(psF2, 1, n-1)
```

```
## [1] 1
```

### CLUSTER VALIDATION—PREPARE THE DATA

```r
  setwd("~/IMGT680")
  loan.test <- read.csv(file="Loans_Test.csv", header = TRUE)
  loan.train <- read.csv(file="Loans_Training.csv", header = TRUE)
  test <- loan.test[,-1]
  train <- loan.train[,-1]
  kmtest <- kmeans(test, centers = 3)
  kmtrain <- kmeans(train, centers = 3)
```

### CLUSTER VALIDATION—VARIABLE SUMMARIES BY CLUSTER

```r
  clust.sum <- matrix(0.0, ncol = 3, nrow = 4)
  colnames(clust.sum) <- c("Cluster 1", "Cluster 2", "Cluster 3")
  rownames(clust.sum) <- c("Test Data Mean", "Train Data Mean", "Test Data Std Dev", "Test Data Std Dev")
  clust.sum[1,] <- tapply(test$Debt.to.Income.Ratio, kmtest$cluster, mean)
  clust.sum[2,] <- tapply(train$Debt.to.Income.Ratio, kmtrain$cluster, mean)
  clust.sum[3,] <- tapply(test$Debt.to.Income.Ratio, kmtest$cluster, sd)
  clust.sum[4,] <- tapply(train$Debt.to.Income.Ratio, kmtrain$cluster, sd)
```
  
