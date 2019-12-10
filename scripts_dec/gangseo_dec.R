Sys.setenv(JAVA_HOME='/usr/local/software/spack/spack-0.11.2/opt/spack/linux-rhel7-x86_64/gcc-5.4.0/jdk-8u141-b15-p4aaoptkqukgdix6dh5ey236kllhluvr/jre') #Ubuntu cluster



## Load packages
library(nlrx)
library(tidyverse) 
library(rcartocolor)
library(ggthemes) 


# Office
netlogopath <- file.path("/usr/local/Cluster-Apps/netlogo/6.0.4")
outpath <- file.path("/home/hs621/github/chapter4")


## Step1: Create a nl obejct:
nl <- nl(nlversion = "6.0.4",
         nlpath = netlogopath,
         modelpath = file.path(outpath, "global_St111212_Gangseo.nlogo"),
         jvmmem = 1024)

## Step2: Add Experiment
nl@experiment <- experiment(expname = "nlrx_spatial",
                            outpath = outpath,
                            repetition = 1,      
                            tickmetrics = "true",
                            idsetup = "setup",   
                            idgo = "go",         
                            runtime = 8764,
                            evalticks=seq(1,8764),
                            metrics = c(
                              "number-dead",
                              "danger",
                              'Balsan1_risk',   
                              'Banghwa1_risk',  
                              'Banghwa2_risk',  
                              'Banghwa3_risk',  
                              'Deungchon1_risk', 
                              'Deungchon2_risk', 
                              'Deungchon3_risk', 
                              'Gayang1_risk',  
                              'Gayang2_risk',  
                              'Gayang3_risk',  
                              'Gonghang_risk', 
                              'Hwagok1_risk',  
                              'Hwagok2_risk',  
                              'Hwagok3_risk',  
                              'Hwagok4_risk',  
                              'Hwagok6_risk',  
                              'Hwagok8_risk',  
                              'Hwagokbon_risk', 
                              'Woojangsan_risk' ,
                              'Yeomchang_risk', 
                              "age15", "age1564", "age65", "eduhigh", "edulow"
                                        ),
                            variables = list('AC' = list(values=c(100,150,200))),
                            constants = list("PM10-parameters" = 100,
                                             "Scenario" = "\"DEC\"",
                                             "scenario-percent" = "\"dec-sce\"")
)


# Evaluate if variables and constants are valid:
eval_variables_constants(nl)

nl@simdesign <- simdesign_distinct(nl = nl, nseeds = 1)
#nl@simdesign <- simdesign_simple(nl = nl, nseeds = 1)

# Step4: Run simulations:
init <- Sys.time()
results <- run_nl_all(nl = nl)
Sys.time() - init


rm(nl)

write.csv(results, paste("gangseo_DEC_", results$`random-seed`[1], ".csv", sep = ""), row.names = F)

