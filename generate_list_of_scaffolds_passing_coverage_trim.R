#source then run by typing cov_trim("PATH"), where PATH is the path to the local Genome_QC folder
#importing data
cov_trim<- function(folder){
#define folder
library(readr)
covstats <- read_delim(paste(folder, "/covstats.txt", sep = ""),
                  "\t", escape_double = FALSE, col_types = cols(Avg_fold = col_number(),
                  Covered_percent = col_number(), Read_GC = col_number(),
                  Ref_GC = col_number(), Std_Dev = col_number()),
                  trim_ws = TRUE)

#Calculating minimum coverage threshold as 10% of coverage of (longest) scaffold_1
cov_thresh=as.numeric(0.1*covstats[1,2]) 
#adding flags for trimming by length and average coverage
covstats$trim= as.factor(ifelse(covstats$Length < 500 | covstats$Avg_fold < cov_thresh, "1", "0"))
#summarize number of cases by each flag condition
summary.factor(covstats$trim)
#create list of scaffold names to keep i.e. when trim = 0
names=as.data.frame.character(covstats$`#ID`[covstats[,12]=="0"])
#export scaffold names
write_delim(names,paste(folder, "/scaffold_names_keep.txt", sep = ""), "\t", col_names= FALSE)
}
#upload output file to MSI then run following command with appropriate genome files
#~/bbmap/filterbyname.sh in=~/Bcale_2567/Genome_QC/scaffolds_sort.fasta names=~/Bcale_2567/Genome_QC/scaffold_names_keep.txt out=~/Bcale_2567/Genome_QC/scaffolds_keep.fasta include
