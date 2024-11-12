# Albany performance testing framework
In today's fast-paced software development landscape, ensuring that applications perform optimally under varying conditions is crucial for delivering a seamless user experience. This framework enables developers to simulate real-world usage scenarios, measuring how the application behaves under different loads and stress conditions. By tracking key performance metrics, developers can proactively address performance issues, enhance application reliability, and ultimately deliver a better experience for end-users.

The framework is built on CMake and CTest. CMake is used to add new systems and tests and setup the testing environment while CTest is used to execute the performance tests. Performance metrics are stored [here](https://github.com/sandialabs/ali-perf-data) and performance tracking tools are provided [here](https://sandialabs.github.io/ali-perf-data/).

The framework currently supports the following:

## Systems/Architectures:

| Name  | Blake  |
|---|---|
| CPU  | Dual-socket Intel<br/>Xeon Platinum 8468<br/>(Sapphire Rapids)  |
| Cores/Node  | 96  |
| Threads/Core  | 2  |
| Memory/Node  | 251 GB  |
| Compiler  | gcc/12.2.0  |
| MPI  | openmpi/4.1.5  |
|---|---|
|---|---|
| Name | Weaver |
|---|---|
| CPU | Dual-socket IBM POWER9 |
| GPU | Nvidia Tesla V100 |
| Cores/Node | 40 |
| Threads/Core | 8 |
| GPUs/Node | 4 |
| Memory/Node | 319 GB |
| Compiler | gcc/8.3.1 |
| GPU Compiler | cuda/11.2.2 |
| MPI | openmpi/4.1.1 |

New systems can be added by modifying CMakeLists.txt.

## Cases:

| Case Name  | Description |
|---|---|
| ant-4-20km\_vel\_cpu | Unstructured 4-20km AIS, Velocity problem, CPU preconditioner |
| ant-8-30km\_veldep | Unstructured 8-30km AIS, Velocity depth integrated model |
| ant-8-30km\_velopt | Unstructured 8-30km AIS, Velocity optimization |
| ant-8-30km\_vel\_cheby\_fixt | Unstructured 8-30km AIS, Velocity problem, Chebyshev smoothers, Fixed Newton step |
| ant-8-30km\_vel\_lsgs | Unstructured 8-30km AIS, Velocity problem, Line smoothing Gauss-Seidel |
| green-1-10km\_vel\_cpu | Unstructured 1-10km GIS, Velocity problem, CPU preconditioner |
| green-3-20km\_vel\_cpu | Unstructured 3-20km GIS, Velocity problem, CPU preconditioner |
| green-3-20km\_vel\_gpu | Unstructured 3-20km GIS, Velocity problem, GPU preconditioner |
| humboldt-1-10km\_vel\_cpu | Unstructured 1-10km Humboldt Glacier, Velocity problem, CPU preconditioner |
| humboldt-1-10km\_vel\_gpu | Unstructured 1-10km Humboldt Glacier, Velocity problem, GPU preconditioner |
| humboldt-1-10km\_ent\_cpu | Unstructured 1-10km Humboldt Glacier, Enthalpy problem, CPU preconditioner |
| humboldt-1-10km\_ent\_gpu | Unstructured 1-10km Humboldt Glacier, Enthalpy problem, GPU preconditioner |
| humboldt-1-10km\_cop\_fea | Unstructured 1-10km Humboldt Glacier, Coupled problem, Finite element assembly only |
| humboldt-1-10km\_cop\_fro\_slu | Unstructured 1-10km Humboldt Glacier, Coupled problem, FROSch + SuperLU |
| mali-ais4km\_cpu | MALI, Unstructured 4-20km AIS, CPU preconditioner |
| mali-ais8km\_cpu | MALI, Unstructured 8-30km AIS, CPU preconditioner |
| mali-ais8km\_gpu | MALI, Unstructured 8-30km AIS, GPU preconditioner |
| thwaites-1-10km\_vel\_cpu | Unstructured 1-10km Thwaites Glacier, Velocity problem, CPU preconditioner |
| thwaites-1-10km\_ent\_cpu | Unstructured 1-10km Thwaites Glacier, Enthalpy problem, CPU preconditioner |
| ant-16km\_vel\_cpu | Structured 16km AIS, Velocity problem, CPU preconditioner |

New cases can be added by modifying CMakeLists.txt.

## Timers:

| Timer Name | Level | Description |
|---|---|---|
| MALI Total Time | 0 | Total wall-clock time of MALI simulation |
| MALI Extrude Time | 1 | Setup Albany problem |
| Albany Total Time | 0 | Total wall-clock time of Albany simulation |
| Albany Setup Time | 1 | Setup Albany problem |
| Residual Fill | 1 | Residual assembly |
| Jacobian Fill | 1 | Jacobian assembly |
| DistParam Fill | 1 | Distributed parameter assembly |
| RespParamHesVec Fill | 1 | Response parameter Hessian-vector product assembly |
| RespDistParamHesVec Fill | 1 | Response distributed parameter Hessian-vector product assembly |
| ResDistParamHesVec Fill | 1 | Residual distributed parameter Hessian-vector product assembly |
| NOX Total Preconditioner Construction | 1 | Construct Preconditioner |
| NOX Total Linear Solve | 1 | Linear Solve |

New timers can be added by modifying jupyter\_nb/scripts/ctest2json.py
