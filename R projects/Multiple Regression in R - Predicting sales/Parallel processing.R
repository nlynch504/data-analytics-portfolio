
library(doParallel)
detectCores()

#8 cores detected 

# Create cluster with desired number of cores
cl <- makeCluster(5)

# Register cluster
registerDoParallel(cl)

# Find out how many cores are being used
getDoParWorkers()

#stop parallel processing
stopCluster(cl)