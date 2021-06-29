This file (dada2_to_phyloseq.md) is a workflow that utilizes dada2 for cleaning and producing approximate sequence variants from 16S rRNA gene amplicons. 
Portions in grey can be copied and pasted (after the '>') directly into the R console. 

The workflow assumes no prior knowledge of R. A few comments have been added that hopefully clarify what is happening.
The samples (and their directory) are associated with n=12 amplicon sequences collected in April 2021. This is a subset of the original (n=95) 
sequences collected, and is meant to run in quicker/faster fashion. However, the below commands can be run on any new data. 
Overall, this file is meant to familiarize one with the dada2 workflow.

So, lets assume you have opened up an R-terminal. Its good to see whhat your current working directory is. In a unix terminal you would type 'pwd' (print working
directory). In R, the quivalent is 'getwd()'. Type this in and see what happens.

```
getwd()
"/Users/stewartlab/"
```
Your current directoy is "/Users/stewartlab/".

We need to move into the directory with all the sequence data.
We can do this by setting a new directory path with the setwd command.
This is the same as the change directory, or cd command.

```
setwd("/Users/stewartlab/Desktop/Caddis_Toy/")
```


Now that we are in the right directory, we can load dada2 and begin quality filtering of the amplicons. The steps used in this workflow are essentially the same
as those from the original dada2 tutorial (v1.16). However, i have skipped over some of the steps regarding plotting error rates. 
First things first, lets load dada2 and tidyverse, a package that is required for other downstream steps.

```
library(dada2)
library(tidyverse)
```

Note, you may or may not see some information pop-up on the screen when loading dada2 or tidyverse (like the version), or 'Loading required package: Rcpp'/.
Don't worry about this. As long as you don't see a message that says; 'can't find package'. 

We need to tell dada2 where to find our data. Our current working directory has this. 

```
path<-"./"
```
Then, assign forward/reverse read files as 'fnFs' and 'fnRs' as below.

```
fnFs <- sort(list.files(path, pattern="_R1_001.fastq", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="_R2_001.fastq", full.names = TRUE))
```
Assign nsames/paths to reads that will be produced after filtering.
```
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
```
Assign names.
```
names(filtFs) <- sample.names
names(filtRs) <- sample.names
```

Filtering/trimming, with filterAndTrim, takes about 10 minutes.
```
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,160),
+               maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
+               compress=TRUE, multithread=TRUE)
```

Learning error rates takes a little longer on current machine, ~1 hour.
The error component of dada2 is, i believe, what makes it special, and somewhat unique
in comparison to other approximate sequence variant callers (like deblur, or vsearch).
It might be worth reading about this on the dada2 web-page.

```
errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)
dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)
```
The actual ASV production, where forward and reverse reads are merged.
```
mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)
```
Make an asv/sample table.
```
seqtab <- makeSequenceTable(mergers)
```
Remove chimeras. This took ~3 hours for all 96 samples on 16GB 2.2Ghz 2015 mac. 
```
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
taxa <- assignTaxonomy(seqtab.nochim, "/Users/stewartlab/Desktop/silva_nr99_v138.1_train_set.fa.gz")
```

Load some more packages needed for making a phyloseq object.

```
library(phyloseq); packageVersion("phyloseq")
library(Biostrings); packageVersion("Biostrings")
library(ggplot2); packageVersion("ggplot2")
```

Get samples from table.

```
samples.out <- rownames(seqtab.nochim) 
subject <- sapply(strsplit(samples.out, "D"), `[`, 1)

```
Load in the meta data from a csv file.
Meta data file with information on samples and their origins; fly, net, retreat, swab.

```
caddis_toy_meta<-read.csv("./caddis_toy_meta.csv", header=TRUE)
```
Creates another data frame needed for making the phyloseq object

```
samdf <- data.frame(Subject=subject, Type=caddis_toy_meta$TYPE, Color=caddis_toy_meta$COLOR)
```
Change row names.
```
rownames(samdf) <- samples.out
```
And finally, we can make the phyloseq object.
```
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), sample_data(samdf), tax_table(taxa))
```
These next commands/packages clean up the phyloseq object.
```
dna <- Biostrings::DNAStringSet(taxa_names(ps))
names(dna) <- taxa_names(ps)
ps <- merge_phyloseq(ps, dna)
taxa_names(ps) <- paste0("ASV", seq(ntaxa(ps)))
```
Might want to save

OK, thats it! You should, at this point, have a phyloseq object!!!


