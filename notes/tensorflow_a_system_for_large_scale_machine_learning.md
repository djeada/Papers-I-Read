## TensorFlow: A System for Large-Scale Machine Learning

### Links

* https://www.usenix.org/system/files/conference/osdi16/osdi16-abadi.pdf

### Notes

#### Summary

TensorFlow is a machine-learning system built around a **dataflow graph** abstraction that can execute computations across heterogeneous devices and distributed clusters.

#### Key ideas

* Operations are represented as nodes in a graph and tensors flow along graph edges.
* The graph can include both pure computation and mutable state such as model parameters.
* Computation can be placed across CPUs, GPUs, TPUs, and machines in a cluster.
* A distributed runtime inserts communication edges between devices and coordinates graph execution.
* Automatic differentiation constructs the computations needed for gradient-based training.
* Because shared state is exposed through the graph rather than hidden inside a specialized parameter-server API, researchers can experiment with different training and synchronization strategies.
* The same programming model supports both training and inference.

#### Why it matters

Earlier large-scale ML systems often hard-coded a particular distributed-training pattern. TensorFlow instead provided a more general execution substrate in which a wide range of ML algorithms could be expressed as graph computations.

#### Takeaway

TensorFlow's important systems idea is not any particular neural-network layer. It is the separation between **what computation is expressed** as a graph and **where that computation runs** across a heterogeneous distributed system.
