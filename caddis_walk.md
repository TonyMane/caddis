An overview of importing phyloseq objects, performing multi-hypothesis testing, multivariate analyses.

We'll start by loading packages neccessary to perform analyses.

```
>library(phyloseq)
>library(tidyverse)
```

Next, we need to load the R-space that contains the phyloseq object. In this case, its on github
https://github.com/TonyMane/caddis/blob/main/caddis-stripped-06262021.RDS

Download by clicking the link. Then, we will load this into R. 

```
>load("/Users/stewartlab/Downloads/caddis-stripped-06262021.RDS")
```

We should have an object available in our work space called 'ps'.
Simply type 'ps' and enter (like below), and see what comes out.

```
>ps
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 46408 taxa and 95 samples ]
sample_data() Sample Data:       [ 95 samples by 4 sample variables ]
tax_table()   Taxonomy Table:    [ 46408 taxa by 6 taxonomic ranks ]
phy_tree()    Phylogenetic Tree: [ 46408 tips and 46407 internal nodes ]
```
We should see a phyloseq-class experiment-level object with 95 samples, 4 sample variables. 
Its important to note that the phyloseq object has a sample_data() portion that contains meta-data.
In this case, each sample has a designation of 'FLY', 'RETREAT', 'NET', 'SWAB. We can look at all, or a portion 
of the file. I typically like to look at just the start of a file with the 'head' function

```
>head(sample_data(ps))
Sample Data:        [6 samples by 4 sample variables]:
            Subject Type Color   Lty
CC1.FLY1   CC1-FLY1  FLY black solid
CC1.FLY10 CC1-FLY10  FLY black solid
CC1.FLY11 CC1-FLY11  FLY black solid
CC1.FLY12 CC1-FLY12  FLY black solid
CC1.FLY13 CC1-FLY13  FLY black solid
CC1.FLY14 CC1-FLY14  FLY black solid
```
Also included in the object are taxonomic assignments made previously (using 'assign_taxa'). 
We can look at the rankings using the rank names function. 

```
>rank_names(ps)
[1] "Kingdom" "Phylum"  "Class"   "Order"   "Family"  "Genus" 
```
We can also look at all or a portion of the tax-table. 

```
> head(tax_table(ps))
Taxonomy Table:     [6 taxa by 6 taxonomic ranks]:
     Kingdom    Phylum            Class                 Order             Family                       Genus              
Seq1 "Bacteria" "Elusimicrobiota" "Elusimicrobia"       "MVP-88"          NA                           NA                 
Seq2 "Bacteria" "Proteobacteria"  "Alphaproteobacteria" "Rhizobiales"     "Rhizobiales Incertae Sedis" "Phreatobacter"    
Seq3 "Bacteria" "Proteobacteria"  "Alphaproteobacteria" "Rhodobacterales" "Rhodobacteraceae"           "Tabrizicola"      
Seq4 "Archaea"  "Crenarchaeota"   "Bathyarchaeia"       NA                NA                           NA                 
Seq5 "Bacteria" "Fibrobacterota"  "Fibrobacteria"       "Fibrobacterales" "Fibrobacteraceae"           "possible genus 04"
Seq6 "Bacteria" "Proteobacteria"  "Alphaproteobacteria" "Rickettsiales"   "Mitochondria"               NA       
```

Right now the 'otu_table' is just that, a table of OTUs (actually approximate sequence variants, which are different that OTUsa, but don't worry, 
these are REALLY ASVs as we processed the data using dada2).  

We can evaulate the differential abundance of specific ASVs using this table. Or, we can look at the cummulative abundance (and differentation patterns) 
of different taxonomic rankings. Evaulating differences at the Genus is a good place to start. To do this, we can agglomerate the data at this level using the
'tax_glom' function in phyloseq.

```
>ps.glom<-tax_glom(ps, "Genus", NArm=TRUE)
```

Look to see what this command does:

```
>ps.glom
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 733 taxa and 95 samples ]
sample_data() Sample Data:       [ 95 samples by 4 sample variables ]
tax_table()   Taxonomy Table:    [ 733 taxa by 6 taxonomic ranks ]
phy_tree()    Phylogenetic Tree: [ 733 tips and 732 internal nodes ]
```
Note that because we collapsed this data-set, we've gone from 46408 unique approximate sequence variants to 733 genus level taxa. 
Now we need convert the raw abundances to relative abundances. We are basically R to calculate the relative abundance of each genera based on the
total number of sequences in sample. 

```
>ps.rel<-transform_sample_counts(ps.glom, function(x) x / sum(x) )
```
If we look at the output of this file, it shouldn't look different from 'ps.glom' (same taxa, samples, ranks).

```
>ps.rel
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 733 taxa and 95 samples ]
sample_data() Sample Data:       [ 95 samples by 4 sample variables ]
tax_table()   Taxonomy Table:    [ 733 taxa by 6 taxonomic ranks ]
phy_tree()    Phylogenetic Tree: [ 733 tips and 732 internal nodes ]
```

