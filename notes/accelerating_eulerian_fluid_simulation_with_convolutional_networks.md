## Accelerating Eulerian Fluid Simulation with Convolutional Networks

### Links

* https://arxiv.org/pdf/1607.03597v2.pdf

### Notes

#### Summary

The paper accelerates Eulerian fluid simulation by replacing one of the most expensive numerical subproblems with a convolutional neural network while keeping the rest of a conventional physics solver intact.

#### Key ideas

* In incompressible fluid simulation, operator splitting separates advection, external forces, and pressure projection.
* The pressure-projection step requires solving a large sparse linear system so that the final velocity field is approximately divergence free.
* The authors train a convolutional network to approximate this expensive solve.
* The network architecture is designed around the spatial structure of the fluid grid and supports both 2D and 3D simulations.
* Training is **unsupervised with respect to pressure targets**: the loss is derived from physical properties of the resulting velocity field rather than requiring a reference pressure solution for every example.
* The learned component is embedded inside a standard simulator instead of replacing the complete numerical pipeline.
* This hybrid approach produces fast, visually realistic simulations and generalizes beyond individual training scenes.

#### Takeaway

A learned surrogate does not need to replace an entire physical simulator to be useful. Replacing a well-identified computational bottleneck while retaining the surrounding numerical structure can provide speedups with much better physical control than a fully black-box model.
