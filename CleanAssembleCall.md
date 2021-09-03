Example steps for cleaning, assembling Illumina paried end metagenomes.
Assuming you can access data through basemount/basespace, put somewhere with ample space (~5-10 Gbp for for each of 16 samples). 
For bacphile (one of gatech servers) our home directories are sufficient. 
For hyalite, i believe /mnt/lustrefs/scratch/NetID is has 700TB (but 'not for storage'). Should be able to put these there.
Below commands all used on bacphile.
```
(base) -bash-4.2$ pwd
/home/abertagnolli3/Well_G1_CC1_RETR11-339865359
(base) -bash-4.2$ ls -l
total 7627844
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt  993785009 Sep  2 18:50 Well-G1-CC1-RETR11_S9_L001_R1_001.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt 1007180187 Sep  2 18:51 Well-G1-CC1-RETR11_S9_L001_R2_001.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt  935583284 Sep  2 18:50 Well-G1-CC1-RETR11_S9_L002_R1_001.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt  950202251 Sep  2 18:51 Well-G1-CC1-RETR11_S9_L002_R2_001.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt  996505647 Sep  2 18:50 Well-G1-CC1-RETR11_S9_L003_R1_001.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt 1013458107 Sep  2 18:51 Well-G1-CC1-RETR11_S9_L003_R2_001.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt  948806870 Sep  2 18:51 Well-G1-CC1-RETR11_S9_L004_R1_001.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt  965376449 Sep  2 18:51 Well-G1-CC1-RETR11_S9_L004_R2_001.fastq.gz

```
I typically concatenate all forward and reverse files separate files. Forward designated by 'R1' reverse by 'R2'.
Then to save space i delete the 'L001' to 'L004' (the 'chunks' we just concatenated).
```
(base) -bash-4.2$ cat *R1* > Well-G1-CC1-RETR11_S1.R1.fastq.gz
(base) -bash-4.2$ cat *R2* > Well-G1-CC1-RETR11_S9.R2.fastq.gz
(base) -bash-4.2$ rm -f *L00*
(base) -bash-4.2$ ls -l
total 11471796
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt 7810897804 Sep  2 22:55 Well-G1-CC1-RETR11_S9.R1.fastq.gz
-rw-r--r--. 1 abertagnolli3 _gtperson_posix_groups_a-i_oit_departmental_gt 3936216994 Sep  2 22:55 Well-G1-CC1-RETR11_S9.R2.fastq.gz
```
For cleaning the reads i use sickle:
https://github.com/najoshi/sickle

seqkit is also a useful for program for checking/modifying/manipulating sequences
https://github.com/shenwei356/seqkit
```
(base) -bash-4.2$ /home/abertagnolli3/programs/sickle-master/sickle pe -g -f Well-G1-CC1-RETR11_S9.R1.fastq.gz -r Well-G1-CC1-RETR11_S9.R2.fastq.gz -r Well-G1-CC1-RETR11_S9.R2.fastq.gz -o Well-G1-CC1-RETR11_S9.R1.trimmed.fastq.gz -p Well-G1-CC1-RETR11_S9.R2.trimmed.fastq.gz -t sanger -s singles.fastq -n
```
Should see two more fastq files ('Well-G1-CC1-RETR11_S9.R1.trimmed.fastq.gz', 'Well-G1-CC1-RETR11_S9.R2.trimmed.fastq.gz').
These are the inputs i use for doing preliminary assemblies with megahit.
https://github.com/voutcn/megahit

```
(base) -bash-4.2$ /home/abertagnolli3/MEGAHIT-1.2.9-Linux-x86_64-static/bin/megahit -1 Well-G1-CC1-RETR11_S9.R1.trimmed.fastq.gz -2 Well-G1-CC1 RETR11_S9.R2.trimmed.fastq.gz
