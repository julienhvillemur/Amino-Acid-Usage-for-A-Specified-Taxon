#User prompted to input taxon
echo 'Input Taxon:'
read userinput
taxon=${userinput// /%20}
#Check that the user hasn't just entered spaces
s=$(echo '$userinput' | wc -c)
if [ $s -eq 0 ]
	then
	echo 'No taxon entered'
	exit 1
fi
#Search for proteome of taxon via NCBI
#Organism:exp to receive data from taxon and all subtaxa
wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=protein&term=${taxon}[Organism:exp]&usehistory=y&retmode=json" -O aasearch.txt
#Check if the query taxon is correct/exists in the records
t=$(grep 'No items found.' aasearch.txt | wc -l)
if [ $t -ne 0 ]
	then
	echo 'No records for this taxon found. Considering changing spelling and checking that the taxon exists.'
	exit 1
fi
#Insert WebEnv from taxon search into an NCBI efetch to download a maximum of 10,000 sequences from proteome
webenvline=`grep webenv aasearch.txt`
userwebenv=`echo $webenvline | cut -f 4 -d '"'`
echo $webenvline
echo $userwebenv
wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?WebEnv=${userwebenv}&query_key=1&db=protein&rettype=fasta" -O proteome.fa
#Check if the downloaded file is a fasta file
q=$(grep '^>' proteome.fa | wc -l)
if [ $q -eq 0 ]
	then 
	echo 'Error during file download. No fasta files found' 
	exit 1
fi
#Remove header from proteome fasta file and place into a new file
grep -v '^>' proteome.fa >singleproteome.fa
#check if the fasta file contains protein sequences. (This could be improved by adding in features unique to protein sequences).
p=$(grep '[ABCDEFGHIJKLMNOPQRSTUVWXYZ*-abcdefghijklmnopqrstuvwxyz]' singleproteome.fa | wc -l)
if [ $p -eq 0 ]
	then 
	echo 'No protein sequences found.'
	exit 1
fi
#Summarise the data using pepstats with the headerless proteome fasta file
pepstats singleproteome.fa summary.pepstats
#Isolate the amino acid frequency and concentration data only
awk '/A = Ala/' RS="\n\n" ORS="\n\n" summary.pepstats | awk '{print $1,$4,$5}' | grep -v 'Residue' | sort -k2 -rn | column -t >table.txt
#Count the number of amino acids and protein sequences analysed
SequenceCount=`grep '^>' proteome.fa | wc -l`
AA_Count=`wc -c < singleproteome.fa`
#Could be done use grep -v 'Count' finaltable.txt | awk '{ sum += $2 } END { print sum }'

#Insert table headers
echo 'Amino_Acid Count Percentage' | cat - table.txt > aatable.txt
column -t aatable.txt > temp && mv temp aatable.txt
#Output data summary and convert to comma delimited .csv file in order to be imported into excel
echo > aatable.csv
echo 'Amino Acid Usage table for' $userinput':' >> aatable.csv
echo >> aatable.csv
cat aatable.txt | awk 'BEGIN{ OFS=","; print "Amino_Acid,Count,Percentage"}; NR > 1{print $1, $2, $3;}' | sed 's/,/:,/g' | column -t -s: | sed 's/ ,/,/g' >> aatable.csv 
echo >> aatable.csv
echo 'Number of protein sequences analysed within' $userinput':' $SequenceCount >> aatable.csv
echo 'Number of amino acids analysed within' $userinput':' $AA_Count >> aatable.csv
echo 'Table stored as file: aatable.csv'
cat aatable.csv
