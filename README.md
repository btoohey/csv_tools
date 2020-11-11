# CSV Tools

A set of simple shell scripts to assist in the parsing and manipulation of CSV files.

## compare.sh

A script that will compare a field in file2.csv to see if it exists in file1.csv. Useful in determining what might be missing in file1.csv as compared to file2.csv. The default compares the first fields from both files.
```
Usage: compare.sh [-h] [-i column number,column number] file1.csv file2.csv

    -h                   : Prints this usage message
    -i col num1,col num2 : Column numbers to compare, default is 1,1
    file1.csv            : First comparison file in CSV format
    file2.csv            : Second comparison file in CSV format
    Example: ./compare.sh -i 3,2 partial_list.csv complete_list.csv
```
