## Physics-Informed Geometric Operators to Support Surrogate, Dimension Reduction and Generative Models for Engineering Design

### Links

* https://arxiv.org/pdf/2407.07611v1

### Notes

#### Summary

The paper proposes **physics-informed geometric operators (GOs)** that enrich low-level shape parameterizations with higher-level geometric information before those shapes are used in surrogate models, dimensionality reduction, or generative design.

#### Key ideas

* Raw coordinates or design parameters may describe a shape numerically without exposing the geometric properties that strongly affect physical performance.
* The proposed operators derive compact descriptors from differential and integral geometry.
* Examples include Fourier descriptors, curvature integrals, geometric moments, and invariant combinations of these quantities.
* These features inject information about global and local shape characteristics into the learning problem.
* For surrogate modeling, geometric operators act partly as a physically meaningful regularizer and can improve generalization to unseen designs.
* For dimensionality reduction, they produce latent spaces that better reflect meaningful geometric similarity.
* For generative models, richer latent geometry helps produce more valid and diverse designs.
* The operators can also expose useful parametric sensitivities, improving downstream shape optimization.

#### Takeaway

A model should not have to infer every important geometric property from raw coordinates. Carefully chosen geometry-aware features can provide a compact inductive bias that improves prediction, representation learning, generation, and optimization even with relatively simple ML architectures.
