# Albany performance testing framework
In today's fast-paced software development landscape, ensuring that applications perform optimally under varying conditions is crucial for delivering a seamless user experience. This framework enables developers to simulate real-world usage scenarios, measuring how the application behaves under different loads and stress conditions. By tracking key performance metrics, developers can proactively address performance issues, enhance application reliability, and ultimately deliver a better experience for end-users.

The framework is built on CMake and CTest. CMake is used to add new systems and tests and setup the testing environment while CTest is used to execute the performance tests. Performance metrics are stored [here](https://github.com/sandialabs/ali-perf-data) and performance tracking tools are provided [here](https://sandialabs.github.io/ali-perf-data/).

The framework currently supports the following:

## Systems/Architectures:

| Name  | Blake  |
|---|---|
| CPU  | Dual-socket Intel Xeon Platinum 8468 (Sapphire Rapids)  |
| Cores/Node  | 96  |
| Threads/Core  | 2  |
| Memory/Node  | 251 GB  |
| Compiler  | gcc/12.2.0  |
| MPI  | openmpi/4.1.5  |

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
| ant-2-10km\_vel\_cpu | Unstructured 2-10km AIS, Velocity problem, CPU preconditioner |
| ant-2-10km\_vel\_gpu | Unstructured 2-10km AIS, Velocity problem, GPU preconditioner |
| ant-4-20km\_vel\_cpu | Unstructured 4-20km AIS, Velocity problem, CPU preconditioner |
| ant-4-20km\_vel\_gpu | Unstructured 4-20km AIS, Velocity problem, GPU preconditioner |
| ant-8-30km\_popvel | Unstructured 8-30km AIS, Populate mesh + Velocity problem |
| ant-8-30km\_vel\_cheby\_adjt | Unstructured 8-30km AIS, Velocity problem, Chebyshev smoothers, Adjusting linear solve tolerance |
| ant-8-30km\_vel\_cheby\_fixt | Unstructured 8-30km AIS, Velocity problem, Chebyshev smoothers, Fixed linear solve tolerance |
| ant-8-30km\_veldep | Unstructured 8-30km AIS, Velocity depth integrated model |
| ant-8-30km\_vel\_lsbj | Unstructured 8-30km AIS, Velocity problem, Line smoothing Block Jacobi |
| ant-8-30km\_vel\_lsgs | Unstructured 8-30km AIS, Velocity problem, Line smoothing Gauss-Seidel |
| ant-8-30km\_velopt | Unstructured 8-30km AIS, Velocity optimization |
| green-1-10km\_vel\_cpu | Unstructured 1-10km GIS, Velocity problem, CPU preconditioner |
| green-1-10km\_vel\_gpu | Unstructured 1-10km GIS, Velocity problem, GPU preconditioner |
| green-3-20km\_ent | Unstructured 3-20km GIS, Enthalpy problem |
| green-3-20km\_vel\_cpu | Unstructured 3-20km GIS, Velocity problem, CPU preconditioner |
| green-3-20km\_vel\_gpu | Unstructured 3-20km GIS, Velocity problem, GPU preconditioner |
| humboldt-1-10km\_cop\_fea | Unstructured 1-10km Humboldt Glacier, Coupled problem, Finite element assembly only |
| humboldt-1-10km\_cop\_fro\_slu | Unstructured 1-10km Humboldt Glacier, Coupled problem, FROSch + SuperLU |
| humboldt-1-10km\_cop\_fro\_tch | Unstructured 1-10km Humboldt Glacier, Coupled problem, FROSch + Tacho |
| humboldt-1-10km\_cop\_if2\_slu | Unstructured 1-10km Humboldt Glacier, Coupled problem, Ifpack2 + SuperLU |
| humboldt-1-10km\_cop\_if2\_tch | Unstructured 1-10km Humboldt Glacier, Coupled problem, Ifpack2 + Tacho |
| humboldt-1-10km\_ent\_cpu | Unstructured 1-10km Humboldt Glacier, Enthalpy problem, CPU preconditioner |
| humboldt-1-10km\_ent\_fea | Unstructured 1-10km Humboldt Glacier, Enthalpy problem, Finite element assembly only |
| humboldt-1-10km\_ent\_gpu | Unstructured 1-10km Humboldt Glacier, Enthalpy problem, GPU preconditioner |
| humboldt-1-10km\_vel\_cpu | Unstructured 1-10km Humboldt Glacier, Velocity problem, CPU preconditioner |
| humboldt-1-10km\_vel\_fea | Unstructured 1-10km Humboldt Glacier, Velocity problem, Finite element assembly only |
| humboldt-1-10km\_vel\_gpu | Unstructured 1-10km Humboldt Glacier, Velocity problem, GPU preconditioner |
| humboldt-3-20km\_vel\_cpu | Unstructured 3-20km Humboldt Glacier, Velocity problem, CPU preconditioner |
| humboldt-3-20km\_vel\_gpu | Unstructured 3-20km Humboldt Glacier, Velocity problem, GPU preconditioner |
| mali-ais4km\_cpu | MALI, Unstructured 4-20km AIS, CPU preconditioner |
| mali-ais8km\_cpu | MALI, Unstructured 8-30km AIS, CPU preconditioner |
| mali-ais8km\_gpu | MALI, Unstructured 8-30km AIS, GPU preconditioner |
| thwaites-1-10km\_cop\_fro | Unstructured 1-10km Thwaites Glacier, Coupled problem, FROSch |
| thwaites-1-10km\_cop\_if2 | Unstructured 1-10km Thwaites Glacier, Coupled problem, Ifpack2 |
| thwaites-1-10km\_ent\_cpu | Unstructured 1-10km Thwaites Glacier, Enthalpy problem, CPU preconditioner |
| thwaites-1-10km\_ent\_gpu | Unstructured 1-10km Thwaites Glacier, Enthalpy problem, GPU preconditioner |
| thwaites-1-10km\_vel\_cpu | Unstructured 1-10km Thwaites Glacier, Velocity problem, CPU preconditioner |
| thwaites-1-10km\_vel\_gpu | Unstructured 1-10km Thwaites Glacier, Velocity problem, GPU preconditioner |
| ant-16km\_vel\_cpu | Structured 16km AIS, Velocity problem, CPU preconditioner |
| ant-16km\_vel\_gpu | Structured 16km AIS, Velocity problem, GPU preconditioner |
| ant-8km\_vel\_cpu | Structured 8km AIS, Velocity problem, CPU preconditioner |
| ant-8km\_vel\_gpu | Structured 8km AIS, Velocity problem, GPU preconditioner |
| ant-4km\_vel\_cpu | Structured 4km AIS, Velocity problem, CPU preconditioner |
| ant-4km\_vel\_gpu | Structured 4km AIS, Velocity problem, GPU preconditioner |
| ant-2km\_vel\_cpu | Structured 2km AIS, Velocity problem, CPU preconditioner |
| ant-2km\_vel\_gpu | Structured 2km AIS, Velocity problem, GPU preconditioner |
| ant-1km\_vel\_cpu | Structured 1km AIS, Velocity problem, CPU preconditioner |
| ant-1km\_vel\_gpu | Structured 1km AIS, Velocity problem, GPU preconditioner |
New cases can be added by modifying CMakeLists.txt.

## Timers:

| Albany Fwd Timer Name | Level | Description |
|---|---|---|
| Albany Total Time | 0 | Total wall-clock time of Albany simulation |
| Albany Setup Time | 1 | Setup Albany problem |
| Total Fill Time | 1 | Finite element assembly |
| Residual Fill | 2 | Residual assembly |
| Jacobian Fill | 2 | Jacobian assembly |
| Jacobian Fill: Evaluate | 3 | Compute the Jacobian, local/global assembly |
| Jacobian Fill: Export | 3 | Update global Jacobian across MPI ranks |
| NOX Total Preconditioner Construction | 2 | Construct Preconditioner |
| NOX Total Linear Solve | 2 | Linear Solve |

| Optimization Timer Name | Level | Description |
|---|---|---|
| DistParam Fill | 2 | Distributed parameter assembly |
| RespParamHesVec Fill | 2 | Response parameter Hessian-vector product assembly |
| RespDistParamHesVec Fill | 2 | Response distributed parameter Hessian-vector product assembly |
| ResDistParamHesVec Fill | 2 | Residual distributed parameter Hessian-vector product assembly |

| MALI Timer Name | Level | Description |
|---|---|---|
| MALI Total Time | 0 | Total wall-clock time of MALI simulation |
| MALI Extrude Time | 2 | Setup Albany problem |

These are other timers that are stored but not used in reporting:
| Other Timer Name | Description |
|---|---|
| Albany Velocity Solver: | Total wall-clock time of Albany simulation |
| Albany: SolveFO: | Total wall-clock time of Albany velocity solve |
| Residual Fill: Evaluate | Compute the Residual, local/global assembly |
| Residual Fill: Export | Update global Residual across MPI ranks |

New timers can be added by modifying jupyter\_nb/scripts/ctest2json.py

NOTE: Memory usage (MiB) is also stored as meta data
