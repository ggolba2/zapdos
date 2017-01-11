#!/bin/bash -i

module purge
module load paraview

OutputFile="NotWorking_out"

pvpython ToCSV.py "${OutputFile}"

for file in $( ls ${OutputFile}*0.csv ) ; do
	TempOutputFile=${file//"0.csv"/".txt"}
	mv ${file} ${TempOutputFile}
done

rm ${OutputFile}*.csv

for file in $( ls ${OutputFile}*.txt ) ; do
	NewOutputFile=${file//"_out"/""}
	NewOutputFile=${NewOutputFile//"Input"/"Output"}
	NewOutputFile=${NewOutputFile//".txt"/".csv"}

	mv ${file} ${NewOutputFile}
done
