# Import libraries
import os
import subprocess

###################################################################################################
# From Albany/tools - yaml read/write
# Need: pip install --user ruamel.yaml
from ruamel.yaml import YAML
yaml = YAML(typ='rt')  # Round trip loading and dumping
yaml.preserve_quotes = True
yaml.width = 1000

def read_yaml(filename):
    with open(filename) as file:
        dictionary = yaml.load(file)
    return dictionary

def write_yaml(dictionary, filename):
    with open(filename, 'w') as file:
        yaml.dump(dictionary, file)
        file.write('...\n')

###################################################################################################
def run_bash(command):
    '''
    Run a bash command
    '''
    return subprocess.run(command, check=True, shell=True, text=True, executable='/bin/bash')

###################################################################################################
def run_sim(iter, inFile):
    '''
    Run yaml input file
    '''
    # Check if mesh-pop exists
    if os.path.isdir('mesh-pop-wdg'):
      print('Populated mesh already exists!')
    else:
      run_bash('ctest -L "pop"')

    # Run simulation
    run_bash('ctest -L "tune"')

    # Generate output file
    run_bash('cp Testing/Temporary/LastTest.log LastTest_'+str(iter)+'-0.log')

###################################################################################################
def simple_param_list(inFile):
    '''
    Run multiple sims with a parameter list
    '''
    # Read input file
    inputDict = read_yaml(inFile)

    # Extract MueLu dictionary
    linsolDict = inputDict['ANONYMOUS']['Piro']['NOX']['Direction']['Newton']['Stratimikos Linear Solver']
    muDict = linsolDict['Stratimikos']['Preconditioner Types']['MueLu']

    # Parameter to change
    paramList = muDict['Factories']['mySmoother1']['ParameterList']
    rdfList = [0.5, 0.9]
    
    # Run simulations
    for iter, rdf in enumerate(rdfList):
      # Change parameter
      paramList['relaxation: damping factor'] = rdf

      # Write input file
      write_yaml(inputDict, inFile)
      
      # Run yaml input file
      run_sim(iter, inFile)
    
    # Convert logs to json
    run_bash('python ctest2json.py')

###################################################################################################
if __name__ == "__main__":
    '''
    Run example
    '''
    simple_param_list('input_albany_Velocity_MueLu_Wedge_Tune.yaml')

