How to get BioSample information from a list ('Meth_list.txt') of BioSample IDs.
```
for i in $(cat Meth_list.txt); do epost -db BioSample -id $i | efetch -format runinfo -mode text > $i.INFO ; done;
```
For getting information like 'isolation source' from each $.INFO file retrieved from efetch
```
for f in *SAM*; do grep "isolation source" $f || echo $f; done
```
