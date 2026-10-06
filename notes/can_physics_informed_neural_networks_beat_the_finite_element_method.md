## Can Physics Informed Neural Networks beat the Finite Element Method

### Links

* https://arxiv.org/abs/2302.04107

### Notes

#### Summary

This paper performs a direct computational comparison between physics-informed neural networks (PINNs) and the finite element method (FEM) for solving several partial differential equations.

#### Comparison

The study considers multiple linear and nonlinear PDEs, including:

* Poisson equations in one, two, and three dimensions,
* the Allen-Cahn equation,
* semilinear Schrödinger equations.

The authors compare the methods in terms of approximation error, time required to obtain a solution, and the cost of evaluating the solution afterward.

#### Findings

* In the tested problems, PINNs do **not** outperform FEM on the combination of solution time and accuracy.
* FEM typically reaches a given accuracy substantially faster.
* PINN training introduces a difficult non-convex optimization problem in addition to the original PDE.
* Classical numerical methods benefit from decades of specialized algorithms, sparse linear algebra, adaptivity, and well-understood convergence theory.
* Once a PINN has been trained, evaluating the neural approximation can sometimes be faster than evaluating the corresponding numerical solution.

#### Takeaway

PINNs are not automatically superior because neural networks are universal approximators. For standard PDE solves, strong classical methods remain extremely competitive. PINNs are most compelling when they provide capabilities beyond a straightforward forward solve, such as inverse problems, data assimilation, or reusable learned representations.
