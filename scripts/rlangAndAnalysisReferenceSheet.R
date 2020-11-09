return(0)

#GUI and platform utility
rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
gc() #free up memrory and report the memory usage.


#sink - printing console output to file
#sink("filename.txt")
#sink(NULL)

#save r-data (untested)
#save(c("myimage","myotherimage"), file="run1Data.RData")
#load(file="run1Data.RData")

#user packages
old.packages() #lists old packages
update.packages(ask=FALSE) #updates installed packages without prompting

#file handling
pgc.mdd.full<-read.table('data/PGC_UKB_depression_genome-wide.txt', header=T)
write.table(pgc.mdd.full,file = 'data/PGC_UKB_depression_genome-wide_OR.txt', sep = '\t', quote = FALSE, row.names = FALSE)

#data inspection
#class
class(iris)
#dimemsions
dim(iris)
#structure
str(iris)
#which - conditionall query - returns entries
which(iris$Sepal.Length>7)
which(is.na(iris$Sepal.Length))

summary(iris)

library(tableone)
CreateTableOne(data = bfi)

#data transformation
#new/empty data frame
newempty<-data.frame(matrix("somevalue",ncol = 3,nrow = 3))

#names
names(delphi_round3)[names(delphi_round3)=="r2_done"]<-"tempselect"
colnames(mytable)<-make.names(colnames(mytable)) #supposedly sets colnames to the actual colnames?
colnames(data_new)<-sub("_numeric$","",colnames(data_new)) #replace as per regex
#order
irisOrder<-iris[order(iris$Sepal.Length),]
#subset
irisSub<-iris[,c(1,3,4)]
irisSub<-iris[which(iris$Species=='setosa' | iris$Species=='versicolor'),]
#make factor with updated levels
irisSub$Species <- factor(irisSub$Species)
#standardization
iris$Petal.Length.std<-scale(iris$Petal.Length)
#aggregate
aggregate(Petal.Length ~ Species, FUN = mean, data = iris)

#dplyr cross join
test<-data.frame(col=c(1:5))
test2<-data.frame(col2=c(1:5))
cross<-test %>%
  inner_join(test2, by = character())

#plots
hist(iris$Petal.Length, breaks=100)
barplot(iris$Petal.Length) #needs more configuration to be pretty and more suitable for few bars
plot(iris$Petal.Length, iris$Petal.Width)

#significance tests
cor.test(iris$Petal.Length, iris$Petal.Width)
#2-sample, split the variable by another variable (categorical, factor)
t.test(Petal.Length ~ Species, data = irisSub)
#aov, anova
summary(aov(Petal.Length ~ Species, data = irisSub))

#linear model
summary(lm(Petal.Length ~ Petal.Width, data = iris))

summary(lm(Petal.Length ~ Species, data = irisSub))

summary(lm(scale(Petal.Length) ~ scale(Petal.Width), data = iris))

##multiple
summary(lm(Petal.Length ~ Petal.Width + Sepal.Length, data = iris))

##multiple (with covariance?; interaction)
summary(lm(Petal.Length ~ Petal.Width + Sepal.Length + Petal.Width:Sepal.Length, data = iris))

##interaction, same as above but shorter
summary(lm(Petal.Length ~ Petal.Width * Sepal.Length, data = iris))

#effect size
library(lsr)
cohensD(Sepal.Length ~ Species, data = iris2)

#power calculations
library(pwr)
pwr.t.test(n=100,d=.14,sig.level = .05,type = "one.sample")
pwr.t.test(n=123,d=.36,sig.level = .05,type = "two.sample")
pwr.t.test(n=20,d=.91,sig.level = .05,type = "paired")

pwr.r.test(r = .2, power = .8, sig.level = .05)

library(psych)
#factor analysis
cor.plot(iris[,1:4])
scree(iris[,1:4], pc=F)
fa(iris[1:4], nfactors=2)

##test reliability,consistency
alpha(iris[,c(1,3,4)])


#random sample
pop<-rnorm(1000,mean = 100,sd=15)
sample1<-sample(pop,size=10)
sample2<-sample(pop,size=10)
data<-as.data.frame(cbind(sample1,sample2))


library(reshape)
#aggregate data
data_long<-melt(data)
names(data_long)<-c("sample","testscore")
t.test(testscore~sample,data = data_long)

#Working on a computation cluster, command line
##Remote access with ssh
#ssh k19049801@login.rosalind.kcl.ac.uk
#ssh -i ~/Downloads/keypair0.pem ubuntu@10.200.105.5
#Personal - for scripts, logs, and programs: /users/k19049801
#Scratch - for data files and other larger files: /scratch/users/k19049801

#interactive node
#srun -p shared --pty /bin/bash
#exit

#cancel slurm job
#scancel [jobid]

#example of sbatch submitting a job on Rosalind
#sbatch --time 00:10:00 --partition shared --job-name=JZ_LDSC --wrap="ls -al" --output "ls.out" --error "ls.err"

#background execution
#add & at the end of a shell command
#sh my_script.sh &
#list jobs, with info
#jobs -l
#bring to foreground
#fg
#kill %1

#use tmux for multiple sessions in one window
#tmux
#‘crtl-b’ then ‘c’: create new session
#‘crtl-b’ then ‘n’: switch session
#‘crtl-b’ then ‘d’: detach from tmux
#To scroll while in tmux: ‘crtl-b’ then ‘[‘. Then move around with arrows or page up and down buttons.

#symlinks (soft links)
#ln -s /scratch/users/k19049801/project/ project

#datastructures and functions
#nested loops - watch where you place the brackets!
testDataframe=data.frame("A"=c(1,0,1), "B"=c(1,1,1), "C"=c(0,1,0))

maxPairs <-function(mat)
{
  numberOfPairs=0
  nRow=nrow(mat)
  
  for (irow in 1:nRow) {
    if(irow>1) {
      for (icol in 1:(irow-1)) {
        #do check
        if (mat[[irow,icol]]==1) {
          #this is a one - count this?
          numberOfPairs<-numberOfPairs+1
        }
        else {
          #do something else
        }
      }
    }
  }
  
  return (numberOfPairs)
}

maxPairs(testDataframe)

#a class
#setClass() would produce an S3 class instead
student<-setRefClass("student",
                     fields = list(name = "character", age = "numeric"),
                     methods = list
                     (
                       hello=function()
                       {
                         print(paste(paste("Hello World, I'm ",age)," years old."))
                       },
                       processStudent=function()
                       {
                         age<<-91
                       }
                     )
                     )

studentBob<-student(name='Bob', age=19)
studentBob$hello()
studentBob$processStudent()
studentBob$hello()
studentBob$age
studentBob$age<-6
studentBob$hello()


#links and material
library(swirl)
install_course("Statistical Inference") 
swirl()

#packages
#run from containing dir
#package.skeleton(name = "mynewpackage")
#myRpackage <- as.package("MOLD")
#load_all(myRpackage)
#document(mrRpackage)

#By running document, roxygen will automatically update the documentation. NOTE: One should carefully examine the Collate field in DESCRIPTION. If a certain file should be loaded before another, the Collate order should follow it as well.
#From command line
#R CMD build packageName
#R CMD check --as-cran packageNameFileName.tar.gz
#R CMD install packageNameFileName.tar.gz

#Cpp functions
library(Rcpp)
#run in package directory or otherwise specify the package directory
compileAttributes(verbose=TRUE) #produces RcppExports.R in R - for R
library(tools)
#run in package directory or otherwise specify the package directory
package_native_routine_registration_skeleton(".") #produces text to be put in src/init.c or append to the c-file of the package. - for Cpp


#https://bookdown.org/ndphillips/YaRrr/
#https://lindeloev.github.io/tests-as-linear/
#http://www.mit.edu/~6.s085/notes/lecture3.pdf