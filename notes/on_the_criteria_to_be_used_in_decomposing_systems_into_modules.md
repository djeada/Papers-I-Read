## On the Criteria To Be Used in Decomposing Systems into Modules

### Links 

* https://www.researchgate.net/publication/200085877_On_the_Criteria_To_Be_Used_in_Decomposing_Systems_into_Modules

### Notes

#### Summary

Parnas argues that good modularity is determined not by the sequence of processing steps but by **information hiding**: each module should conceal a design decision that is likely to change.

#### The comparison

The paper uses the KWIC (Key Word in Context) indexing problem to compare two decompositions:

* a conventional decomposition based on processing stages,
* an alternative decomposition based on hidden design decisions and interfaces.

Both systems can produce the same output, but they respond very differently to change.

#### Key ideas

* A flowchart is usually a poor guide for deciding module boundaries.
* Modules should hide details such as data representation, storage format, ordering decisions, or algorithm choices.
* Other modules should depend on stable interfaces rather than on those hidden decisions.
* A good decomposition allows teams to work more independently because fewer internal assumptions leak across boundaries.
* Localizing likely changes improves maintainability, comprehensibility, and the ability to replace one implementation without rewriting the rest of the program.
* Some information-hiding decompositions may introduce small efficiency costs, but implementation techniques can often reduce them.

#### Takeaway

A module is valuable because of what it **hides**, not merely because it groups related functions. Put volatile decisions behind stable interfaces so future changes remain local.
