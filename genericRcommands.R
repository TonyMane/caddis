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
