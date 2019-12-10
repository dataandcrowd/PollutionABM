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
         modelpath = file.path(outpath, "global_St111121_Jung.nlogo"),
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
                              "Euljiro_risk",
                              "Gwanghee_risk",
                              "Hoehyun_risk",
                              "Hwanghak_risk",
                              "Jangchoong_risk",
                              "Jungrim_risk",
                              "Myungdong_risk",
                              "Pildong_risk",
                              "Shindang_risk",
                              "Dasan_risk",
                              "Yaksu_risk",
                              "Cheonggu_risk",
                              "Shindang5_risk",
                              "Donghwa_risk",
                              "Sogong_risk",
                              "age15", "age1564", "age65", "eduhigh", "edulow"
                                        ),
                            #metrics.turtles =  list("people" = c("who", "xcor", "ycor", "homename", "destinationName", "age", "edu","health")),
                            variables = list('AC' = list(values=c(100,150,200))),
                            constants = list("PM10-parameters" = 100,
                                             "Scenario" = "\"BAU\"",
                                             "scenario-percent" = "\"inc-sce\"")
)


# Evaluate if variables and constants are valid:
eval_variables_constants(nl)

nl@simdesign <- simdesign_distinct(nl = nl, nseeds = 1)
#nl@simdesign <- simdesign_simple(nl = nl, nseeds = 1)

# Step4: Run simulations:
init <- Sys.time()
results <- run_nl_all(nl = nl)
Sys.time() - init

#results$`random-seed` <- sample(1:1000, 1, replace = F)


# Attach results to nl object:
#setsim(nl, "simoutput") <- results

# Report spatial data:
#results_unnest <- unnest_simoutput(nl)

rm(nl)

write.csv(results, paste("jung_BAU_", results$`random-seed`[1], ".csv", sep = ""), row.names = F)
#save.image(paste("seoul_", results$`random-seed`[1], ".RData", sep = ""))
