#for looking subset data, n=5 samples per group (fly, net, retreat, swab)
NAMES<-length(caddis_meta$Sample_NAME[c(1:5, 30:34, 50:54, 80:84)])

library(phyloseq)
library(tidyverse)
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               sample_data(samdf), 
               tax_table(taxa))

#produce relative abundance matrix
ps_Phylum_rel<-transform_sample_counts(ps_Phylum, function(OTU) OTU/sum(OTU)*100)

#collapse matrix by Genus abundance                                       
ps_Genus<-tax_glom(ps, "Genus", NArm=TRUE)
                                       
ps_genus_rel= transform_sample_counts(ps_Genus, function(x) x / sum(x) )
Desulfobacterota <- subset_taxa(ps_genus_rel, Phylum =="Desulfobacterota")
Desulfobacterota_little<-prune_samples(NAMES, Desulfobacterota)
Desulfobacterota_2<-filter_taxa(Desulfobacterota_little, function(x) sum(x) >0.01, TRUE)
plot_bar(Desulfobacterota_2, fill="Genus")
