## symplectic neural flows for modeling and discovery

### Links

* https://arxiv.org/pdf/2412.16787
* https://people.cmm.minesparis.psl.eu/users/velasco/Barbaresco.pdf

### Notes

#### Summary

SympFlow is a neural architecture for learning continuous-time dynamics while preserving the **symplectic structure** of Hamiltonian systems. Rather than learning an unconstrained state update, the network is built from parameterized Hamiltonian flow maps.

#### Key ideas

* Hamiltonian dynamics have geometric structure that ordinary neural networks can easily violate.
* Preserving symplectic structure matters because small geometric errors can accumulate into unrealistic long-term trajectories and energy drift.
* SympFlow is time-dependent and represents dynamics as a composition of structure-preserving flow maps.
* The model can be trained directly from known differential equations to approximate a Hamiltonian flow.
* It can also learn an unknown dynamical system from observed trajectories.
* Because the architecture is symplectic by construction, the learned map preserves the appropriate phase-space geometry.
* The formulation supports backward-error analysis and provides a way to relate learned dynamics to a nearby Hamiltonian system.
* Experiments show improved long-term energy behavior and accurate reconstruction of dynamics from sparse or irregular observations.

#### Takeaway

When the governing physics has known geometric structure, building that structure into the model is often better than asking a generic network to rediscover it from data. Symplectic constraints act as a strong and physically meaningful inductive bias.
