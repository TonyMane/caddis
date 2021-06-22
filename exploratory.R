NAMES<-length(caddis_meta$Sample_NAME[c(1:5, 30:34, 50:54, 80:84)])

ps3<-transform_sample_counts(ps2, function(OTU) OTU/sum(OTU) * 100)
