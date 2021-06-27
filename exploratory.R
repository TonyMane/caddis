#a collection of R commands for creating/manipulating phyloseq objects. 
library(phyloseq)
library(tidyverse)
caddis_meta<-read.csv("./caddis_meta.csv")
#for looking subset data, n=5 samples per group (fly, net, retreat, swab)
NAMES<-length(caddis_meta$Sample_NAME[c(1:5, 30:34, 50:54, 80:84)])

samdf <- data.frame(Subject=caddis_meta$Sample_NAME, Type=caddis_meta$Type, Color=caddis_meta$Color, Lty=caddis_meta$lty)
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               sample_data(samdf), 
               tax_table(taxa))

#produce relative abundance matrix
ps_Phylum_rel<-transform_sample_counts(ps_Phylum, function(OTU) OTU/sum(OTU)*100)

#collapse matrix by Genus abundance                                       
ps_Genus<-tax_glom(ps, "Genus", NArm=TRUE)

#for generic plotting of taxa abundances
ps_genus_rel= transform_sample_counts(ps_Genus, function(x) x / sum(x) )
Desulfobacterota <- subset_taxa(ps_genus_rel, Phylum =="Desulfobacterota")
Desulfobacterota_little<-prune_samples(NAMES, Desulfobacterota)
Desulfobacterota_2<-filter_taxa(Desulfobacterota_little, function(x) sum(x) >0.01, TRUE)
plot_bar(Desulfobacterota_2, fill="Genus")

                                #commands for converting dada2-like ASV/sample files to ASV/sample text file and ASV fasta file.
#taken from https://github.com/benjjneb/dada2/issues/48, comment by jeffkimbrel (go Beavs!).
library(phyloseq)
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
                                
