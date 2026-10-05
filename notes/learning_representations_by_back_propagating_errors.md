## Learning representations by back-propagating errors

### Links

* https://youtu.be/oq6Z76Gl0ho
* https://www.nature.com/articles/323533a0

### Notes

#### Summary

The paper presents back-propagation as a practical learning procedure for multi-layer networks. By repeatedly adjusting connection weights to reduce the difference between predicted and desired outputs, hidden units learn internal features that are useful for the task.

#### How it works

* Run the network forward to compute its output.
* Measure an error between the actual output and the desired output.
* Use the chain rule to propagate derivatives of that error backward through the layers.
* Each weight receives a gradient telling how a small change would affect the error.
* Update weights in the direction that reduces the error and repeat over training examples.

#### Why it matters

* Hidden layers are not given hand-designed meanings; useful internal representations emerge from the learning objective.
* Earlier simple learning rules were effective mainly for shallow or linearly separable problems.
* Back-propagation makes credit assignment through multiple differentiable layers computationally practical.
* The method is general: the same principle applies to many differentiable architectures and loss functions.

#### Takeaway

Back-propagation provides an efficient way to assign responsibility for an output error to parameters deep inside a network, enabling learned multi-layer representations.
