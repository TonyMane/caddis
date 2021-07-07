Bash, fastq-dump, and R commmands for preliminary insect study.
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
Also include all the Fly samples from round one Cherry Creek.
```
cp /Users/anthonyd.bertagnolli/Desktop/caddis/FLY_ONLY/*gz ./second_run
```
Note, need to change the extensions from our data from 'L001_R1_001' and 'L001_R2_001' to simply '1' and '2', respectively.
```
rename "s/L001_R1_001/1/" ./second_run/*
rename "s/L001_R2_001/2/" ./second_run/*
```
There should be 90 individual samples. But check this:
```
ls -l | grep -c "1.fastq.gz"
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

