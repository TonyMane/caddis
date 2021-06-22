#for looking subset data, n=5 samples per group (fly, net, retreat, swab)
NAMES<-length(caddis_meta$Sample_NAME[c(1:5, 30:34, 50:54, 80:84)])

#produce relative abundance matrix
ps_Phylum_rel<-transform_sample_counts(ps_Phylum, function(OTU) OTU/sum(OTU)*100)

#collapse matrix by Genus abundance                                       
ps_Genus<-tax_glom(ps, "Genus", NArm=TRUE)
                                       
