# Randomness

Usage:
perl finalChiTest.pl -c renamedAdinetaV2.fa.fai -g extractedAliensCors -l 100000 -p 0 -s 100000 -m gene -p 1 -f 15 > seeData

For detail of usage, try finalChiTest.pl -h

USAGE:
```
Welcome to Randomness estimation, version 0.1

'chrfile|c=s'    	## Indexed genome file; samtools faidx genome.fa > genome.fa.fai file
'genefile|g=s' 	  ## Genefile in gff format; see sample 'extractedAliensCors'
'bin|l=i' 		    ## Bin to check for randomness
'size|s=i' 		    ## Size of sub-string
'mode|m=s' 		    ## gene
'plot|p=i' 		    ## 1 or 0
'finicalgene|f=i' ## minimum number of gene to consider 
```
It will generate one directory "plotted" with all the graphs.
