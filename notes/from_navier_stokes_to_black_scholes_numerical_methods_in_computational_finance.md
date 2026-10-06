## from navier-stokes to black-scholes: numerical methods in computational finance

### Links

* https://www.maths.tcd.ie/pub/ims/bull75/Duffy.pdf

### Notes

#### Summary

This article surveys how numerical techniques familiar from computational physics—especially finite-difference methods for partial differential equations—also form the basis of computational finance.

#### Key ideas

* Many derivative-pricing problems can be written as time-dependent **convection-diffusion-reaction PDEs**.
* The Black-Scholes equation is structurally related to PDEs encountered in engineering and fluid mechanics, even though the interpretation of the variables is different.
* Closed-form formulas exist only for relatively simple financial contracts; realistic products often require numerical approximation.
* Finite-difference schemes discretize the price and time dimensions and evolve the PDE numerically.
* Explicit, implicit, and Crank-Nicolson-type time-stepping methods involve different tradeoffs between computational cost, stability, and accuracy.
* Boundary conditions and non-smooth payoff functions require careful treatment.
* The same numerical solution can be used to estimate sensitivities such as the Greeks, which are central to hedging and risk management.
* Techniques developed in numerical analysis can therefore transfer directly into financial modeling.

#### Takeaway

Computational finance is not an isolated branch of mathematics. Many of its core problems are standard numerical PDE problems in different clothing, so ideas from scientific computing—stability, consistency, convergence, discretization, and efficient linear solvers—carry over directly.
