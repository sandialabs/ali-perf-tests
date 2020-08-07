#!/bin/bash
  
#source $1 

TTT=`grep "(Failed)" nightly_log_weaverAliPerfTests.txt -c`
TTTT=`grep "Not Run" nightly_log_weaverAliPerfTests.txt -c`
TTTTT=`grep "\*Timeout" nightly_log_weaverAliPerfTests.txt -c`
TT=`grep "...   Passed" nightly_log_weaverAliPerfTests.txt -c`


echo "Subject: ALI performance tests, weaver: $TT tests passed, $TTT tests failed, $TTTT tests not run, $TTTTT timeouts" >& a
echo "" >& b
cat a b >& c
cat c results >& d
mv d results
rm a b c
cat results | /usr/lib/sendmail -F ikalash@weaver.sandia.gov -t "ikalash@sandia.gov, jwatkin@sandia.gov"

