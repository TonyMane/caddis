Bash, fastq-dump, and R commmands for preliminary insect study.
First portion describes how to download fastq files associated with an amplicon run (in this case 16S rRNA gene amplicon, but could be anything really) from NCBI.

Second portion describes combining this data (from NCBI) with your own data (in this case, caddis fly microbiomes from Cherry Creek collected in April).

Third portion describes running all this data through DADA2.

Fourth portion describes doing some preliminary alpha/beta diversity assesments.

We found four studies utilizing Earth Microbiome oligos that could be used for direct comparison with our study.
The four study Bioproject IDs are PRJEB40063, PRJNA547724, PRJNA578869, PRJNA589709. More information on
DOI numbers/publication names can be found in 'Fly-Microbiome-07062021.csv'. For each of the four BioProject IDs,
we can access all fastq files from the short read archive (SRA) by first getting a list of the experiments IDS (SRR numbers). Can be done multiple ways. 
'Easiest' way (for me) is to use the SRA Run Selector page, and get a flat list file. Visit https://www.ncbi.nlm.nih.gov/Traces/study/?o=acc_s%3Aa, 
enter in the a BioProject ID, select 'Accesion List Tab', will automically download a file called 'SRR_Acc_List.txt'. 
Use this to download the SRR files with fastq-dump as so:
```
for i in $(cat SRR_Acc_List.txt); do echo $i; /home/abertagnolli3/programs/sratoolkit.2.9.6-1-centos_linux64/bin/fastq-dump --gzip --split-3 $i; done;
```
This should begin downloading fastq files (one forward/reverse) for each sample. You can get the SRR numbers from each Bioproject and add them together as one
big list and download everything as once, or download the fastq files from each BioProject separately (which ever you choose).

Once we have all the public fastq files from the BioProjects, make a new directory, and add these files.

```
mkdir second_run
mv *gz second_run
```
Also include all the Fly samples from sampling trip one at Cherry Creek.
```
cp /Users/anthonyd.bertagnolli/Desktop/caddis/FLY_ONLY/*gz ./second_run
```
Note, need to change the extensions from our data from 'L001_R1_001' and 'L001_R2_001' to simply '1' and '2', respectively.
```
rename "s/L001_R1_001/1/" ./second_run/*
rename "s/L001_R2_001/2/" ./second_run/*
```
There should be 90 individual samples. But check this by counting the forward and reverse reads.
```
ls -l | grep -c "1.fastq.gz"
90

ls -l | grep -c "2.fastq.gz"
90
```
Ok, looks good. We can now run the data through dada2. The below lines, 9, should run quickly.
```
library(dada2); packageVersion("dada2")
path <- "second_run"
fnFs <- sort(list.files(path, pattern="_1.fastq.gz")
fnRs <- sort(list.files(path, pattern="_2.fastq.gz")
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names
names(filtRs) <- sample.names
```
This line, Trimming and Filtering, will take a bit longer (~20 minutes).
```
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,160),
              maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
              compress=TRUE, multithread=TRUE)
```
Learn the error rates. Both of the below takes about 30-45 minutes (on my MacBook Pro, 2.2 GHz Quad-Core Intel Core i7, 16 GB 1600 MHz DDR3).
```
errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)
```
Apply the core sample inference algorithims. This takes about 30 minutes both both forward (dadaF) and reverse (dadaR).
```
dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)
```
Now merge paired ends to make approximate sequence variants (ASVs).
```
mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)
```
Now we can make a sequence table.

```
seqtab <- makeSequenceTable(mergers)
```
Remove chimeras.
```
seqtab <- makeSequenceTable(mergers)
```
Assign taxonomy to the ASVs. NOTE, download the database (silva_nr_v132_train_set.fa.gz) from
https://zenodo.org/record/1172783/files/silva_nr_v132_train_set.fa.gz?download=1
This will take 30-45 minutes (again, on my MacBook Pro, 2.2 GHz Quad-Core Intel Core i7, 16 GB 1600 MHz DDR3).
```
taxa <- assignTaxonomy(seqtab.nochim, "silva_nr_v132_train_set.fa.gz", multithread=TRUE)
```
Download the meta-data file "insectcompare_07072021.csv" (in this repository).
Read it into R, we'll call it 'meta_data'. We'll need this to make a phyloseq object.
```
meta_data<-read.csv("insectcompare_07072021.csv")
```
Load some more packages.
```
library(phyloseq); packageVersion("phyloseq")
library(Biostrings); packageVersion("Biostrings")
library(ggplot2); packageVersion("ggplot2")
```
Now lets extract some information from the dada2 files and our meta-data, and make a phyloseq object.
```
samples.out <- rownames(seqtab.nochim)
subject <- sapply(strsplit(samples.out, "D"), `[`, 1)
subject <- substr(subject,2,999)
samdf <- data.frame(Subject=subject, Insect=meta_data$Insect, Color=meta_data$Color)
rownames(samdf) <- samples.out
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), sample_data(samdf), tax_table(taxa))
```
OK, now we have the phyloseq object, but we need to modify this file. The ASVs are listed as DNA strings. 
```    
dna <- Biostrings::DNAStringSet(taxa_names(ps))
names(dna) <- taxa_names(ps)
ps <- merge_phyloseq(ps, dna)
taxa_names(ps) <- paste0("ASV", seq(ntaxa(ps)))
```
