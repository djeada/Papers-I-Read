## hopfield_networks_is_all_you_need

### Links

https://arxiv.org/abs/2008.02217

### Notes

#### Summary

This paper introduces **modern Hopfield networks**, associative-memory models with continuous states and a new update rule. The striking result is that the update rule is mathematically equivalent to the attention mechanism used in transformers.

#### Key ideas

* Classical Hopfield networks store patterns as attractors of an energy function but have limited storage capacity.
* The modern formulation can store exponentially many patterns with respect to the dimension of the associative space under suitable conditions.
* Retrieval can happen in a single update and can have exponentially small retrieval error.
* The energy landscape contains several useful behaviors: global averaging, averaging over subsets of patterns, and retrieval of individual stored patterns.
* The update rule can be written in the same form as transformer attention.
* This gives an associative-memory interpretation of attention heads: a query retrieves or averages stored patterns based on similarity.
* Hopfield layers can be inserted into deep-learning systems for attention, pooling, memory, prototype retrieval, and multiple-instance learning.

#### Takeaway

Transformer attention can be viewed as a form of content-addressable associative memory. The paper links two historically separate ideas—Hopfield networks and attention—through a common energy-based formulation.
