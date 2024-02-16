How to get BioSample information from a list ('Meth_list.txt') of BioSample IDs.
```
for i in $(cat Meth_list.txt); do epost -db BioSample -id $i | efetch -format runinfo -mode text > $i.INFO ; done;
```
For getting information like 'isolation source' from each $.INFO file retrieved from efetch
```
for f in *SAM*; do grep "isolation source" $f > $f.OUT || echo $f > $f.OUT; done;
cat *.OUT* > LIST.txt
```
The above line will simply print the file name if the pattern is not found.
Can then concatanete all the results into a single file, LIST.txt.
To just get the information between the quotations, use:
```
sed 's/=/\t/g' LIST.txt | cut -f 2
```
