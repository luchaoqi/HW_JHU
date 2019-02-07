
# Rscript --slave fdr.R -i pvalues.tsv -o pvalues.corrected.tsv
# Practical 3, Exercise 1
# Group members:
# Saki Fujita (sfujita2)
# Chuheng Chen (cchen217)
# Vorada Sakulsaengprapha (vsakuls1)

#read in the data frame with raw p-values
args = commandArgs(TRUE) 
inputName = args[2]
outputName = args[4]
x <- read.table(file=args[2])
x_no_name = x[-1,]#get rid of the first line in the table
p_data = as.numeric(as.character(x[2:1001,2]))




#apply BH correction to each row 
p_rank = rank(p_data)
alpha =  0.05
m = length(p_data)
q = p_data*m/p_rank
#store the resulting data frame as a tab-delimited file in pvalues.corrected.tsv.
colum3 = c('qvalue',q)
x[,3]<-colum3
#print the number of discoveries at fdr <= 0.05 to output.
which(q<=alpha)
write.table(x,file=outputName)
