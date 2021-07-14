Just some analyses as they come out. Read/evaluate at your own risk (i.e. this is just my own lil' work space of things i would prefer to not to forget).

```
library(phyloseq)
library(dada2)
library(reltools)
load("/Users/anthonyd.bertagnolli/Desktop/caddis/rds_or_dotR/caddis_total_07012021.rds")
library(Biostrings); packageVersion("Biostrings")
library(ggplot2); packageVersion("ggplot2")
dna <- Biostrings::DNAStringSet(taxa_names(ps))
names(dna) <- taxa_names(ps)
ps <- merge_phyloseq(ps, dna)
taxa_names(ps) <- paste0("ASV", seq(ntaxa(ps)))
ps_Phylum<-tax_glom(ps, "Phylum")
ps_Phylum.rel<-transform_sample_counts(ps_Phylum,function(OTU) OTU/sum(OTU))
Cyanobacteria <- subset_taxa(ps_Phylum.rel, Phylum =="Cyanobacteria")
pdf("./Cyanobacteria.pdf")
boxplot(psmelt(Cyanobacteria)[,3]~psmelt(Cyanobacteria)[,5], data=psmelt(Cyanobacteria), ylim=c(0,1), main="Phylum Cyanobacteria", ylab="Proportion of Cyanobacteria", xlab="Cherry Creek Samples")
dev.off()
```
