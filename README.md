#Amino Acid Usage For A Specified Taxon

##Inputs and Outputs
Once the user has run the script, they will be prompted to ‘Input Taxon:’, to which the user must enter a valid taxon or NCBI taxid. The script outputs the file name under which the table is stored and a title to the amino acid usage table, this includes the query taxon entered by the user. Below this, three columns headed: ‘Amino_Acid’, ‘Count’ and ‘Percentage’ are printed. The columns contain the single letter amino acids, the frequency of amino acids found in the available sequences and the molar percentage respectively. The rows are sorted by the amino acid count in descending order. The number of protein sequences and amino acids analysed to form the data summary are printed below the columns. The columns are comma delimited and the whole file can be imported into excel.

##Summary of the Pipeline
First, the message prompting the user to enter a taxon is printed using echo. Then read is used to form the user input into a variable and ‘%20’ is inserted into any spaces that may be in the input in order to search the NCBI database correctly [1] [2]. The script then checks that the input is not an empty line, this however does not work correctly. All checks in this script are made using if, then and fi statements. An esearch of the NCBI protein database is made using the input via the use of wget. The script then checks if the search was successful. Using grep the webenv identifier is transferred to an efetch search of the NCBI protein database, from which sequences are downloaded into a fasta file [3]. The script then checks that the downloaded file is a fasta file. The headers are removed from the fasta files to form a single sequence to be analysed using pepstats [4]. This sequence is tested for the presence of an amino acid code using grep and wc -l to count lines. However, this is not a valid test as the characters identified by grep can be found in any other text-containing file, as such it can produce false-positives. This step is to demonstrate that a protein sequence check is required but unfortunately in this script it is not the correct type of check. 

Pepstats is then used to analyse the protein sequence and output information such as amino acid frequency and molar concentration. These two parameters and the single letter code of the amino acids are isolated from the previous output. Awk is used to identify the correct paragraph, grep -v to remove unnecessary information, sort to arrange the data into descending order by frequency and column -t to arrange into columns [5] [6]. Character counts (wc -c) and line counts are used to store the number of protein sequences and amino acids used in the analysis. The appropriate table headers are then added above the output table and aligned with the data columns. This change is stored in the original table file using temp && mv temp [7]. The file named ‘aatable.csv’ is formed by appending the output of multiple commands into this file with >> [8]. The table in the file is comma delimited via the use of awk, sed and column [9] [10]. The final lines appended into the file are the sequence count and the amino acid count used to produce the data in the amino acid usage table. The script then produces a screen output indicating where the table is stored and prints the table file itself onto the screen.

##Instructions
Open a Unix command line and type bash aausage.sh , and you will be provided the prompt: ‘Input taxon’. Below this, type the taxon name or NCBI taxid that you want to use to find the proportion of amino acids used in that taxon and press enter. If any error messages appear, follow the instructions and re-run the script. The script then outputs a table summary of amino acid usage for the taxon you entered and stores this table under ‘aatable.csv’ in your home directory or any directory that you ran the script in. Open ‘aatable.csv’ in excel, the data will be arranged into three columns, which can be used to carry out further processing.

##Examples of Use
| Taxon: | Limulus polyphemus (Atlantic horseshoe crab) | Mollusca |
| Input Text: | limulus polyphemus | mollusca |
| ----------- | ------------------ | -------- |
| Five Most Frequent Amino Acids: (Percentage = Molar%) | Amino_Acid 	Count  	Percentage
S          	479073 	9.329
L          	464315 	9.042
E          	357184 	6.956
K          	339594 	6.613
V          	338458 	6.591 | Amino_Acid 	Count  	Percentage
L          	310955 	15.546
G          	188901 	9.444
S          	155738 	7.786
A          	153771 	7.688
F          	147445 	7.371 |
| Number Of Sequences Used: |	10,000 |	10,000 |
| Number Of Amino Acids Used: |	5,223,504	| 2,044,072 |

##References
(Read command discovered on a page explaining the expr command)

[1]T. Tanuja, "expr command in Linux with examples - GeeksforGeeks", GeeksforGeeks, 2020. [Online]. Available: https://www.geeksforgeeks.org/expr-command-in-linux-with-examples/. [Accessed: 11- Mar- 2020].
[2]"Replace spaces", Unix.com, 2020. [Online]. Available: https://www.unix.com/shell-programming-and-scripting/84160-replace-spaces.html. [Accessed: 11- Mar- 2020].
[3]D. Barker, LECTURE 3 “shell scripts and automation 1”, School of Biological Sciences, The University of Edinburgh, 29JAN2020.
[4]"EMBOSS: pepstats manual", Embossgui.sourceforge.net, 2020. [Online]. Available: http://embossgui.sourceforge.net/demo/manual/pepstats.html. [Accessed: 11- Mar- 2020].
[5]K. P., "Grep whole paragraphs of a text containing a specific keyword", Stack Overflow, 2020. [Online]. Available: https://stackoverflow.com/questions/32379801/grep-whole-paragraphs-of-a-text-containing-a-specific-keyword. [Accessed: 11- Mar- 2020].
[6]M. Ryall and I. Vazquez-Abrams, "Sorting data based on second column of a file", Stack Overflow, 2020. [Online]. Available: https://stackoverflow.com/questions/6438896/sorting-data-based-on-second-column-of-a-file. [Accessed: 11- Mar- 2020].
[7]J. Alberts and S. Penny, "How do I add text to the beginning of a file in Bash?", Super User, 2020. [Online]. Available: https://superuser.com/questions/246837/how-do-i-add-text-to-the-beginning-of-a-file-in-bash. [Accessed: 11- Mar- 2020].
[8]"How do I save terminal output to a file?", Ask Ubuntu, 2020. [Online]. Available: https://askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file. [Accessed: 11- Mar- 2020].
[9]J. Lowden, "How to output some data to different cells of an Excel File?", Unix & Linux Stack Exchange, 2020. [Online]. Available: https://unix.stackexchange.com/questions/269935/how-to-output-some-data-to-different-cells-of-an-excel-file. [Accessed: 11- Mar- 2020].
[10]A. Harvey and E. Morton, "Align columns in comma-separated file", Stack Overflow, 2020. [Online]. Available: https://stackoverflow.com/questions/51471554/align-columns-in-comma-separated-file/51471616. [Accessed: 11- Mar- 2020].
