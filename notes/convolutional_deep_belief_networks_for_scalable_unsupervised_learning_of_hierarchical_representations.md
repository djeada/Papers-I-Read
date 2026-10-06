## Convolutional Deep Belief Networks for Scalable Unsupervised Learning of Hierarchical Representations

### Links

* https://web.eecs.umich.edu/~honglak/icml09-ConvolutionalDeepBeliefNetworks.pdf

### Notes

#### Summary

This paper introduces the **Convolutional Deep Belief Network (CDBN)**, a hierarchical generative model that brings convolution and unsupervised deep belief networks to realistically sized images.

#### Key ideas

* Convolutional weight sharing makes the learned representation translation invariant and avoids a separate parameter for every image location.
* Layers are based on convolutional restricted Boltzmann machines and can be trained greedily from unlabeled images.
* The paper introduces **probabilistic max-pooling**, which reduces spatial resolution while remaining part of a coherent probabilistic generative model.
* Stacking layers yields a hierarchy in which lower levels learn edges and simple local patterns while higher layers can represent object parts and larger structures.
* Unlike a purely feed-forward feature extractor, the model supports both bottom-up recognition and top-down probabilistic inference.
* Top-down information can help infer missing or ambiguous lower-level parts.
* Learned unsupervised features perform well on downstream visual recognition tasks.

#### Historical context

The work predates the dominance of supervised convolutional networks and shows an important route researchers explored for learning deep visual hierarchies without large labeled datasets.

#### Takeaway

Convolution provides scalable local parameter sharing, while probabilistic deep belief learning provides a generative hierarchy. Combining them made unsupervised multi-layer visual representations practical on full-sized images.
