#Commands used for short example with 'toy' data-set from caddis fly study. Portions that are not commmented out (with #) can be copied/pasted directly on stewart lab
#osx R terminal. Notes, actual terminal view are the 'R-introduction.pptx' file.

#getwd, same as pwd in bash
getwd()
#setwd, same as change directory or cd in bash.
setwd("/Users/stewartlab/Desktop/")

#list.files, same as list, or ls in bash.
list.files()

#
setwd("./Caddis_Toy/")
list.files()

#load dada2
library(dada2)

#load tidyverse
library(tidyverse)

path<-"./"

#assign forward/reverse read files
fnFs <- sort(list.files(path, pattern="_R1_001.fastq", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="_R2_001.fastq", full.names = TRUE))

#assign sample names
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))

names(filtFs) <- sample.names
names(filtRs) <- sample.names

#filtering/trimming takes about 10 minutes.
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,160),
+               maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
+               compress=TRUE, multithread=TRUE)

#learning error rates takes a little longer on current machine, ~1 hour... 
errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)


dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)

#the actual ASV production.
mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)

#make an asv/sample table
seqtab <- makeSequenceTable(mergers)

#remove chimeras. This took ~3 hours for all 96 samples on 16GB 2.2Ghz 2015 mac. 
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)

taxa <- assignTaxonomy(seqtab.nochim, "/Users/stewartlab/Desktop/silva_nr99_v138.1_train_set.fa.gz")
