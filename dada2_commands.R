#Commands used for short example with 'toy' data-set from caddis fly study. Portions that are not commmented out (with #) can be copied/pasted directly on stewart lab
#osx R terminal. Notes, actual terminal view are the 'R-introduction.pptx' file.

getwd, same as pwd in bash
```R
getwd()
#setwd, same as change directory or cd in bash.
setwd("/Users/stewartlab/Desktop/")
```

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

#load some more packages needed for making a phyloseq object
library(phyloseq); packageVersion("phyloseq")
library(Biostrings); packageVersion("Biostrings")
library(ggplot2); packageVersion("ggplot2")

#get samples from table
samples.out <- rownames(seqtab.nochim)

subject <- sapply(strsplit(samples.out, "D"), `[`, 1)

#meta data file with information on samples and their origins; fly, net, retreat, swab.
caddis_toy_meta<-read.csv("./caddis_toy_meta.csv", header=TRUE)

#creates another data frame needed for making the phyloseq object
samdf <- data.frame(Subject=subject, Type=caddis_toy_meta$TYPE, Color=caddis_toy_meta$COLOR)

#added 06242021
rownames(samdf) <- samples.out

#construcct the phyloseq object, a good master file for doing microbiome analyses.
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               sample_data(samdf), 
               tax_table(taxa))

#these next commands/packages clean up the phyloseq object
dna <- Biostrings::DNAStringSet(taxa_names(ps))

names(dna) <- taxa_names(ps)

ps <- merge_phyloseq(ps, dna)

taxa_names(ps) <- paste0("ASV", seq(ntaxa(ps)))

#OK, now we can do some exploratory analyses. First, sum all the taxa based on their genus designations.
ps_Genus<-tax_glom(ps, "Genus", NArm=TRUE)

#Get relative abundance of genera
ps_genus_rel= transform_sample_counts(ps_Genus, function(x) x / sum(x) )

#Lets look at the distribution of Desulfobacterota.
Desulfobacterota <- subset_taxa(ps_genus_rel, Phylum =="Desulfobacterota")

#Might be interesting to first look at just the dominant ones, those greater than 10%.                                      
Desulfobacterota_filter<-filter_taxa(Desulfobacterota, function(x) sum(x) >0.01, TRUE)

#can now plot the results. First tell R to make a pdf version.
pdf("./Desulfobacterota.pdf")
plot_bar(Desulfobacterota, fill="Genus")
dev.off()  

#perform NMDS
ps.prop <- transform_sample_counts(ps, function(otu) otu/sum(otu))
ord.nmds.bray <- ordinate(ps.prop, method="NMDS", distance="bray") 
pdf("./caddis_NMDS.pdf")
plot_ordination(ps.prop, ord.nmds.bray, color="Type", title="Bray NMDS")
dev.off()
