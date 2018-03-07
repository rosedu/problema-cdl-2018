#!/bin/bash

testsNumber=7
bonusTestsNumber=3
sum=0

make clean > /dev/null

make build > /dev/null

rm -r output
mkdir output

echo ""
echo "------------Regular tests------------"
for i in $(seq 1 $testsNumber); do
    cp ./in/test$i.in ./code.in
    make run > /dev/null
    cp code.out ./output/test$i.out
	diff -Z code.out ref/test$i.ref > /dev/null 
	if [ $? -eq 0 ]; then
		echo "Test $i ......................... passed"
		sum=$(($sum + 1))
	else
		echo "Test $i ......................... failed"
	fi
done

echo "------------Bonus tests------------"
for i in $(seq 1 $bonusTestsNumber); do
    cp ./in/test_bonus$i.in ./code.in
    make run > /dev/null
    cp code.out ./output/test_bonus$i.out
	diff -Z code.out ref/test_bonus$i.ref > /dev/null 
	if [ $? -eq 0 ]; then
		echo "Test $i ......................... passed"
		sum=$(($sum + 1))
	else
		echo "Test $i ......................... failed"
	fi
done

echo ""
echo "TOTAL: $sum/$(($testsNumber + $bonusTestsNumber)) tests passed"

rm code.out code.in

make clean > /dev/null
