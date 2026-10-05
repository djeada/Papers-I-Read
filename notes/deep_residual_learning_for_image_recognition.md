## Deep Residual Learning for Image Recognition

### Links

* https://youtu.be/jio04YvgraU
* https://arxiv.org/pdf/1512.03385.pdf

### Notes

#### Summary

ResNet makes very deep neural networks easier to optimize by having blocks learn a **residual function** relative to their input. Instead of forcing a stack of layers to directly learn a mapping (H(x)), the block learns (F(x) = H(x) - x) and outputs (F(x) + x).

#### Key ideas

* Simply adding layers to a conventional network can cause a **degradation problem**: training error becomes worse even when overfitting is not the explanation.
* Identity **skip connections** create short paths through the network and make it easier for gradients and information to propagate.
* If the ideal transformation is close to identity, a residual block only needs to learn a small correction.
* Residual connections add little computational cost and can be inserted throughout a deep architecture.
* Bottleneck blocks use (1 	imes 1) convolutions to reduce and then restore channel dimensionality around a (3 	imes 3) convolution.
* The paper demonstrates successful training of networks far deeper than earlier mainstream CNNs, including a 152-layer ImageNet model.

#### Takeaway

A small architectural change—learning residuals around identity shortcuts—removed a major optimization barrier and made substantially deeper visual models practical.
