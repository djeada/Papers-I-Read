## On floating point precision in computational fluid dynamics using OpenFOAM

### Links

* https://www.sciencedirect.com/science/article/pii/S0167739X23003813?via%3Dihub

### Notes

#### Summary

The paper studies how reducing floating-point precision affects both the accuracy and performance of computational fluid dynamics simulations in OpenFOAM.

#### Motivation

Modern CFD is often limited not only by arithmetic throughput but by **memory movement and communication**. Using fewer bits per value can reduce memory bandwidth, storage, and network costs, especially on accelerators.

#### Key findings

* Single and mixed precision can be accurate enough for many CFD workloads.
* Laminar and relatively well-conditioned problems are often tolerant of reduced precision.
* Turbulent and strongly nonlinear cases can be more sensitive because numerical noise may be amplified and iterative solvers may converge differently.
* The low formal order of some discretizations can make discretization error larger than the floating-point error, reducing the benefit of always using double precision.
* Performance gains vary significantly with hardware and parallel scaling; reducing arithmetic precision is useful only when the application is actually limited by resources that precision reduction improves.
* Mixed precision can preserve numerical robustness while reducing expensive data movement.
* GPU implementations can benefit particularly strongly because memory bandwidth and device throughput are closely tied to numerical precision.

#### Takeaway

Double precision should not be treated as an automatic requirement for every CFD operation. Precision is another numerical-design parameter that can be chosen according to conditioning, physics, solver behavior, and hardware.
