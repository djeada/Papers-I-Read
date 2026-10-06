## understanding deep learning requires rethinking generalization

### Links

* https://openreview.net/pdf?id=Sy8gdB9xx

### Notes

#### Summary

The paper challenges the classical explanation that deep neural networks generalize because their hypothesis class is tightly constrained or because explicit regularization prevents them from fitting arbitrary data.

#### Key experiments

* Modern convolutional networks can fit a training set even when the labels are replaced with completely random labels.
* They can also fit inputs containing random noise rather than meaningful images.
* This memorization still occurs when common explicit regularizers are weakened or removed.
* The authors show theoretically that relatively simple neural networks can have enough finite-sample capacity to fit arbitrary labels when sufficiently overparameterized.

#### Implication

If a network can perfectly memorize random data, then low training error alone does not explain why it performs well on real test data. Traditional capacity measures that treat every parameter setting equally are therefore insufficient to explain practical deep-learning generalization.

The results point toward other explanations, including the structure of real-world data and the **implicit bias of optimization algorithms** such as stochastic gradient descent.

#### Takeaway

Deep networks generalize well despite having enough capacity to memorize nonsense. Understanding generalization therefore requires studying not just model size, but also data structure, optimization dynamics, and the particular solutions training tends to find.
