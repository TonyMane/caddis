A collection of analyses that is by no means comprehensive for analyzing amplicon data with phyloseq.
First load all required packages (tidyverse, phyloseq), read in meta-data (caddis_meta.tsv) and phyloseq object (caddis-stripped-0626201.RDS has this saved). 
```
library(phyloseq)
library(tidyverse)
caddis_meta<-read.csv("caddis_meta.csv")
load("caddis-stripped-06262021.RDS")
```
The .RDS file should have an object called ps. Check to make sure this there with the objects function.

```
objects()
```
It should print a list of files to your console.
We can do A LOT with phyloseq objects. I'll just go through a few quick exploratory analyses.

produce relative abundance matrix

```
ps_Phylum_rel<-transform_sample_counts(ps_Phylum, function(OTU) OTU/sum(OTU)*100)
```

collapse matrix by Genus abundance                                       
```
ps_Genus<-tax_glom(ps, "Genus", NArm=TRUE)
```

For generic plotting of taxa abundances, use transform sample function.

```
ps_genus_rel= transform_sample_counts(ps_Genus, function(x) x / sum(x) )
```
Now, lets look at one phyloum. Desulfobacterota.

```
Desulfobacterota <- subset_taxa(ps_genus_rel, Phylum =="Desulfobacterota")
``` 
Rather than look at all samples (n=95), we could look at a subset (n=20), four from each retreat type.

NAMES<-c("CC1-FLY1", "CC1-FLY2", "CC1-FLY3", "CC1-FLY4", "CC1-FLY5", "CC1-NET1", "CC1-NET2", "CC1-NET3", "CC1-NET4", "CC1-NET5", "CC1-RETR1", "CC1-RETR2", "CC1-RETR3", "CC1-RETR4", "CC1-RETR5", "CC1-SWAB1", "CC1-SWAB2", "CC1-SWAB3", "CC1-SWAB4", "CC1-SWAB5")

Desulfobacterota_little<-prune_samples(NAMES, Desulfobacterota)
Desulfobacterota_2<-filter_taxa(Desulfobacterota_little, function(x) sum(x) >0.01, TRUE)
plot_bar(Desulfobacterota_2, fill="Genus")

#commands for converting dada2-like ASV/sample files to ASV/sample text file and ASV fasta file.
#taken from https://github.com/benjjneb/dada2/issues/48, comment by jeffkimbrel (go Beavs!).
seqs <- colnames(seqtab)
otab <- otu_table(seqtab, taxa_are_rows=FALSE)
colnames(otab) <- paste0("seq", seq(ncol(otab)))
otab = t(otab)
write.table(seqs, "dada_seqs.txt",quote=FALSE)
write.table(otab, "dada_table.txt",quote=FALSE,sep="\t")

#final command for producing fasta file using bash
#grep -v '^x' dada_seqs.txt | awk '{print ">seq"$1"\n"$2}' > dada_seqs.fa; rm dada_seqs.txt

#To make a phylogenetic tree in a phyloseq obect.
random_tree = rtree(ntaxa(physeq), rooted=TRUE, tip.label=taxa_names(physeq))

#add the tree to a physeq object
physeq1 = merge_phyloseq(ps, caddis_meta, random_tree)

#rename to original object
ps<-physeq1

#perform an ordination
ordu = ordinate(ps, "PCoA", "unifrac", weighted=TRUE)
#plot the result
plot_ordination(ps, ordu, color="Type")

#evaluate differential contributions of taxa that are statisitically significant
ps.prop <- transform_sample_counts(ps, function(otu) otu/sum(otu))

#anosim for testing for differneces between sample type 
ps_anosim<-anosim(distance(ps, "unifrac", weighted=FALSE), caddis_meta$TYPE)

install.packages("remotes")
remotes::install_github("Russel88/MicEco")
library(MicEco)
source("./caddis06212021.RDS")
pdf("./caddis_total_venn.pdf")
ps_venn1<-ps_venn(ps, "Type")
dev.off()
                                