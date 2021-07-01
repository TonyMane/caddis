Just an overview of unix commands that maybe useful.
To start, always good to know where you are on a new system/machine after logging on.
Print working directory (pwd) tells you this.

```
pwd
/Users/anthonyd.bertagnolli
```
Most of the time you start in your home directory. 
I typically like working on my Desktop (but you could work anywhere).
To get there, we change directories (cd).

```
cd Desktop/
```
Now that I am inside the Desktop directory, not a bad idea to see what is there.

```
ls
4226-261086836				Collection_localities.txt		MicrobeMiseq				Research Manuscript (Draft)_FJS.docx	WORKING					caddis					for_CO_proposal				test.csv				~$rtagnolli_Eval_v1_ADB.docx
CO_papers				DRIVE.txt				My EndNote Library.Data			SRR_Acc_List (1).txt			amplicon_key.pem			chab-microbial-ecology			hypocolypse				~$210623_labUpdate-caddisfly-AB-AM.pptx	~$rtagnolli_Eval_v1_FJS_2021.docx
CO_proposal				FIXED					OMZ-Pacbio				SRR_Acc_List.txt			astro_bio				enaBrowserTools				input_metagenomic			~$Fly-Microbiome.xlsx
Caddis_Toy				Fly-Microbiome.xlsx			REVIEWS					StewartCFLYPlate1.xlsx			bacphile.sh				examples_and_exercises			phylophlan				~$R-introduction.pptx
Caddis_Toy_gz				MUYIMPORTANTE.txt			R_tutorials-master			StewartCFLYPlate2.xlsx			bioproject_result.txt			fastq.sh				phylophlan_databases			~$lab-meeting-slides-06222021.pptx
```

There are lots of files and directories in this directory. 
This doesn't give us much information about what is here (other than that the user is sloppy). Some of the contents might be files, some might be folders,
some might be programs (and so on). List contents long form (ls -l) can give us this information.

```
ls -l
drwxr-xr-x    4 anthonyd.bertagnolli  staff     128 Jun 20 19:44 4226-261086836
drwxr-xr-x   59 anthonyd.bertagnolli  staff    1888 May 21 14:59 CO_papers
drwxr-xr-x    6 anthonyd.bertagnolli  staff     192 Jun  1 14:27 CO_proposal
drwxr-xr-x   27 anthonyd.bertagnolli  staff     864 Jun 22 02:02 Caddis_Toy
drwxr-xr-x   28 anthonyd.bertagnolli  staff     896 Jun 24 16:13 Caddis_Toy_gz
-rw-r--r--@   1 anthonyd.bertagnolli  staff   16623 Jun 30 13:51 Collection_localities.txt
-rw-r--r--    1 anthonyd.bertagnolli  staff     597 Jun 18 23:57 DRIVE.txt
drwxr-xr-x   73 anthonyd.bertagnolli  staff    2336 Apr 23 17:04 FIXED
-rw-r--r--@   1 anthonyd.bertagnolli  staff   10003 Jun 30 14:37 Fly-Microbiome.xlsx
-rw-r--r--    1 anthonyd.bertagnolli  staff     155 Jun 19 02:13 MUYIMPORTANTE.txt
drwxr-xr-x    7 anthonyd.bertagnolli  staff     224 May 25 01:33 MicrobeMiseq
drwxr-xr-x    5 anthonyd.bertagnolli  staff     160 Jun 20 19:14 My EndNote Library.Data
drwxr-xr-x   30 anthonyd.bertagnolli  staff     960 Feb  9 16:45 OMZ-Pacbio
drwxr-xr-x   38 anthonyd.bertagnolli  staff    1216 Jun  5 18:44 REVIEWS
drwxr-xr-x@  13 anthonyd.bertagnolli  staff     416 Jun  3 00:12 R_tutorials-master
-rw-r--r--@   1 anthonyd.bertagnolli  staff   31649 Jun 27 15:34 Research Manuscript (Draft)_FJS.docx
-rw-r--r--@   1 anthonyd.bertagnolli  staff     219 Jun 30 19:45 SRR_Acc_List (1).txt
-rw-r--r--@   1 anthonyd.bertagnolli  staff    1749 Jun 29 16:44 SRR_Acc_List.txt
-rw-r--r--@   1 anthonyd.bertagnolli  staff   15198 Jun 21 13:50 StewartCFLYPlate1.xlsx
-rw-r--r--@   1 anthonyd.bertagnolli  staff   13214 Jun 21 13:51 StewartCFLYPlate2.xlsx
drwxr-xr-x   66 anthonyd.bertagnolli  staff    2112 Jun 30 22:11 WORKING
-r--------@   1 anthonyd.bertagnolli  staff    1700 Jun 18 19:24 amplicon_key.pem
drwxr-xr-x@   4 anthonyd.bertagnolli  staff     128 May 20 22:57 astro_bio
-rw-r--r--    1 anthonyd.bertagnolli  staff      46 Jun 17 21:48 bacphile.sh
-rw-r--r--@   1 anthonyd.bertagnolli  staff      13 Jun 30 19:44 bioproject_result.txt
drwxr-xr-x   92 anthonyd.bertagnolli  staff    2944 Jun 29 16:36 caddis
drwxr-xr-x    8 anthonyd.bertagnolli  staff     256 May 25 01:45 chab-microbial-ecology
drwxr-xr-x    9 anthonyd.bertagnolli  staff     288 Jun 30 15:43 enaBrowserTools
drwxrwxr-x@   9 anthonyd.bertagnolli  staff     288 Apr 11  2016 examples_and_exercises
-rw-r--r--    1 anthonyd.bertagnolli  staff     224 Jun 29 22:01 fastq.sh
drwxr-xr-x   12 anthonyd.bertagnolli  staff     384 May 21 14:59 for_CO_proposal
drwxr-xr-x   25 anthonyd.bertagnolli  staff     800 May 29 15:21 hypocolypse
drwxr-xr-x  373 anthonyd.bertagnolli  staff   11936 Jun 17 15:56 input_metagenomic
drwxr-xr-x   18 anthonyd.bertagnolli  staff     576 Jun 17 17:07 phylophlan
drwxr-xr-x    2 anthonyd.bertagnolli  staff      64 Jun 17 15:58 phylophlan_databases
-rw-r--r--@   1 anthonyd.bertagnolli  staff  183454 Jun 22 23:11 test.csv
-rw-r--r--@   1 anthonyd.bertagnolli  staff     165 Jun 22 14:53 ~$210623_labUpdate-caddisfly-AB-AM.pptx
-rw-r--r--@   1 anthonyd.bertagnolli  staff     165 Jun 30 14:31 ~$Fly-Microbiome.xlsx
-rw-r--r--@   1 anthonyd.bertagnolli  staff     165 Jun 21 00:08 ~$R-introduction.pptx
-rw-r--r--@   1 anthonyd.bertagnolli  staff     165 Jun 22 16:08 ~$lab-meeting-slides-06222021.pptx
-rw-r--r--@   1 anthonyd.bertagnolli  staff     162 Jun 30 11:59 ~$rtagnolli_Eval_v1_ADB.docx
-rw-r--r--@   1 anthonyd.bertagnolli  staff     162 Jun 29 15:16 ~$rtagnolli_Eval_v1_FJS_2021.docx
```

This is a bit more informative. We now get information on file type (directory indicated by 'drwxr-xr-x', or file -rw-r--r--'), ownership, size, and date created. 
On the left hand side we see 'drwxr-xr-x', followed by more information. The drw-, or first 3 letters, tells us this file is a directory. 
We could move into it (as we did to the Desktop).
