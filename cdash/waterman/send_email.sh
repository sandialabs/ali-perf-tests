#!/bin/bash
  
#source $1 

TTT=`grep "(Failed)" nightly_log_watermanAliPerfTests.txt -c`
TTTT=`grep "Not Run" nightly_log_watermanAliPerfTests.txt -c`
TTTTT=`grep "\*Timeout" nightly_log_watermanAliPerfTests.txt -c`
TT=`grep "...   Passed" nightly_log_watermanAliPerfTests.txt -c`


echo "Subject: ALI performance tests, waterman: $TT tests passed, $TTT tests failed, $TTTT tests not run, $TTTTT timeouts" >& a
echo "" >& b
cat a b >& c
cat c results >& d
mv d results
rm a b c
cat results | /usr/lib/sendmail -F ikalash@waterman.sandia.gov -t "ikalash@sandia.gov, jwatkin@sandia.gov"

