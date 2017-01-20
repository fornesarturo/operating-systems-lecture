#!/bin/bash

echo Files per directory:

a=0
for i in $( ls -F linux | grep '/$' | cut -d/ -f1 ); do
	files=`ls -lR linux/$i | grep '^-' | wc -l`
	echo \#$i: $files
	echo $a $i $files >> data.dat
	a=`expr $a + 1`
done

touch plot.pg
echo "#!/usr/bin/gnuplot" >> plot.pg
echo "reset" >> plot.pg
echo "set terminal png size 2300,1000" >> plot.pg
echo "set boxwidth 0.5" >> plot.pg
echo "set style fill solid" >> plot.pg
echo "set grid" >> plot.pg
echo "plot \"data.dat\" using 1:3:xtic(2) with boxes" >> plot.pg

chmod +x plot.pg
./plot.pg > 1.png

xdg-open 1.png

rm -rf plot.pg

echo
echo Accumulation of files:

readme=`find linux -name README* | wc -l`
echo \#Number of README files \in linux: $readme

kconfig=`find linux -name [Kk]config* | wc -l`
echo \#Number of Kconfig files \in linux: $kconfig

kbuild=`find linux -name [Kk]build* | wc -l`
echo \#Number of Kbuild files \in linux: $kbuild

makefile=`find linux -name [Mm]akefile* | wc -l`
echo \#Number of Makefile files \in linux: $makefile

c=`find linux -name *.c | wc -l`
echo \#Number of .c files \in linux: $c

h=`find linux -name *.h | wc -l`
echo \#Number of .h files \in linux: $h

pl=`find linux -name *.pl | wc -l`
echo \#Number of .pl files \in linux: $pl

totalfiles=`ls -lR linux | grep '^-' | wc -l`
echo \#Total number of files: $totalfiles

totalfiles=`expr $totalfiles - $c - $h - $readme - $kconfig - $kbuild - $makefile - $pl`
echo \#Number of other files \in linux: $totalfiles

echo \<linux\/module\.h\>:
b=`grep -R '#include <linux/module.h>' linux | wc -l`
echo \#Number of inclusions of linux\/module \in linux: $b

echo
echo C and H files:

mkdir C_FILES
mkdir H_FILES

for i in $( find linux -name *.c | grep .c$ ); do
	cp --parents $i C_FILES
done

cf=`find C_FILES -name *.c | wc -l`
echo \#Number of .c files \in C_FILES: $cf

for i in $( find linux -name *.h | grep .h$ ); do
	cp --parents $i H_FILES
done

hf=`find H_FILES -name *.h | wc -l`
echo \#Number of .h files \in H_FILES: $hf

rm -rf 1.png
rm -rf data.dat
