#commands for converting dada2-like ASV/sample files to ASV/sample text file and ASV fasta file.
#taken from https://github.com/benjjneb/dada2/issues/48, comment by jeffkimbrel (go Beavs!).
library(phyloseq)
seqs <- colnames(seqtab)
otab <- otu_table(seqtab, taxa_are_rows=FALSE)
colnames(otab) <- paste0("seq", seq(ncol(otab)))
otab = t(otab)
write.table(seqs, "dada_seqs.txt",quote=FALSE)
write.table(otab, "dada_table.txt",quote=FALSE,sep="\t")
