# Import libraries
import glob
import json
import os
import sys
import warnings

###################################################################################################
def ctest2json(file, allTimers):
    '''
    Extract information from ctest output file and load into json file
    '''
    # Print all warnings
    warnings.simplefilter("always")

    # Force warnings.warn() to omit the source code line in the message
    formatwarning_orig = warnings.formatwarning
    warnings.formatwarning = lambda message, category, filename, lineno, line=None: \
                formatwarning_orig(message, category, filename, lineno, line='')

    # ctest file specific information
    testNameKey = ' Testing: '
    trilinosGitCommitIdKey = 'Trilinos git commit id'
    albanyGitBranchKey = 'Albany git branch'
    albanyGitCommitIdKey = 'Albany git commit id'
    albanyCXXCompilerKey = 'Albany cxx compiler'
    albanyCudaCompilerKey = 'Albany cuda compiler'
    simulationStartKey = 'Simulation start time'
    wtimeAvgLoc = 0
    maxKokkosMemoryKey = 'MAX MEMORY ALLOCATED:'
    maxHostMemoryKey = 'Host process high water mark memory consumption:'
    testPassedKey = 'Test Passed'
    testFailedKey = 'Test Failed'

    # Extract information from ctest file
    ctestInfo = {}
    testName = ''
    timers = list()
    with open(file, 'r') as f:
        for line in f:
            # Extract test information
            if testNameKey in line:
                # Init test info
                testName = line.split(testNameKey)[1].split()[0]
                ctestInfo[testName] = {}
                testInfo = ctestInfo[testName]
                testInfo['case'] = '_'.join(testName.split('_')[:-1])
                testInfo['np'] = int(testName.split('_')[-1][2:])
                testInfo['date'] = int(file.split('_')[1].split('-')[0])

                # Init list of timers
                timers = list(allTimers)
                testInfo['timers'] = {}

            # Extract Trilinos git commit id
            if trilinosGitCommitIdKey in line:
                testInfo[trilinosGitCommitIdKey] = line.split()[-1]

            # Extract Albany git branch
            if albanyGitBranchKey in line:
                testInfo[albanyGitBranchKey] = line.split()[-1]

            # Extract Albany git commit id
            if albanyGitCommitIdKey in line:
                testInfo[albanyGitCommitIdKey] = line.split()[-1]

            # Extract Albany cxx compiler
            if albanyCXXCompilerKey in line:
                tmpList = line.split()
                testInfo[albanyCXXCompilerKey] = tmpList[-2] + ' ' + tmpList[-1]

            # Extract Albany cuda compiler
            if albanyCudaCompilerKey in line:
                tmpList = line.split()
                testInfo[albanyCudaCompilerKey] = tmpList[-2] + ' ' + tmpList[-1]

            # Extract simulation start time
            if simulationStartKey in line:
                testInfo[simulationStartKey] = line.split()[-1]

            # Extract timer information
            for timer in timers:
                if timer in line:
                    wtime = float(line.split(timer)[1].split()[wtimeAvgLoc]) # should work with MALI timers too
                    testInfo['timers'][timer] = wtime
                    #calls = int(line.split(timer)[1].split('[')[1].split(']')[0])
                    #testInfo['timers'][timer] = wtime / calls

                    # Remove timer from list
                    timers.remove(timer)
                    break

            # Extract maximum memory allocated by Kokkos
            if maxKokkosMemoryKey in line:
                testInfo['max kokkos memory'] = float(line.split()[-2])

            # Extract maximum memory allocated by Kokkos
            if maxHostMemoryKey in line:
                testInfo['max host memory'] = float(line.split()[-2])

            # Extract pass
            if testPassedKey in line:
                testInfo['passed'] = True

            # Extract fail
            if testFailedKey in line:
                testInfo['passed'] = False
                warnings.warn(testName+', '+file+' failed! Timers are not stored.', Warning)


    # Check if ctest data is empty
    if not ctestInfo:
        warnings.warn('Parsing of '+file+' failed. Check to see if testNameKey is valid.', Warning)

    # Check to see if test timers were captured
    timersCaptured = 0
    for name,info in ctestInfo.items():
        if info['timers']:
            timersCaptured = timersCaptured+1

        if info['passed'] and not info['timers']:
            info['passed'] = False
            warnings.warn(name+', '+file+' passed but parsing of timers failed. Setting test to failed.', Warning)

    # If timers were not captured in any tests, the timers might not be valid
    if timersCaptured == 0:
        warnings.warn('Parsing of timers failed for '+file+'. Check to see if timers are valid.', Warning)

    # Add date and save to json file
    date = file.split('_')[1].split('-')[0]
    jsonFile = 'ctest-' + date + '.json'
    with open(jsonFile, 'w') as jf:
        json.dump(ctestInfo, jf, indent=2, sort_keys=True)

###################################################################################################
if __name__ == "__main__":
    '''
    Import LastTest_* files and convert to json
    '''
    # Pass directory name
    if len(sys.argv) < 2:
        dir = ''
    else:
        dir = sys.argv[1]
        print('Converting ctest files in ' + dir + ' to json...')

    # Extract file names
    files = glob.glob(os.path.join(dir,'LastTest_*'))

    # Specify timers to extract from ctest file (note: must be unique names per test in file)
    timers = (
              '1 total time',
              'Albany Velocity Solver:',
              'Albany: Extrude 3D Grid:',
              'Albany: SolveFO:',
              'Albany Total Time:',
              'Albany: Setup Time:',
              'Albany: Total Fill Time:',
              'Albany Fill: Residual:',
              'Albany Residual Fill: Evaluate:',
              'Albany Residual Fill: Export:',
              'Albany Fill: Jacobian:',
              'Albany Jacobian Fill: Evaluate:',
              'Albany Jacobian Fill: Export:',
              'Albany Fill: Distributed Parameter Derivative:'
              'NOX Total Preconditioner Construction:',
              'NOX Total Linear Solve:',
              'Albany Fill: Response Distributed Parameter Hessian Vector Product:',
              'Albany Fill: Response Parameter Hessian Vector Product:',
              'Albany Fill: Residual Distributed Parameter Hessian Vector Product:'
              )

    # Loop over files
    for file in files:
        # Extract info and save in json file
        ctest2json(file, timers)

