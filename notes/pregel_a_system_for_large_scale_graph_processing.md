## Pregel: A System for Large-Scale Graph Processing

### Links

* https://15799.courses.cs.cmu.edu/fall2013/static/papers/p135-malewicz.pdf

### Notes

#### Summary

Pregel is a distributed system and programming model for processing graphs that are too large for one machine. It uses a **vertex-centric** abstraction inspired by Bulk Synchronous Parallel computation.

#### Programming model

* Computation proceeds in synchronized **supersteps**.
* During a superstep, each active vertex receives messages from the previous step, updates its local state, and sends messages to other vertices.
* A vertex can also modify outgoing edges or, in supported cases, mutate graph topology.
* Vertices can vote to halt and become active again if a later message arrives.
* Global synchronization between supersteps makes distributed execution easier to reason about than fully asynchronous message passing.

#### System features

* The runtime partitions vertices across workers and hides most distribution details.
* Checkpointing and re-execution provide fault tolerance.
* Combiners can reduce network traffic by merging messages with the same destination.
* Aggregators compute global statistics that can influence later supersteps.
* The model can express algorithms such as PageRank, shortest paths, connected components, and many iterative graph computations.

#### Takeaway

Pregel's core insight is to make each vertex look like a tiny independent program while the system handles partitioning, synchronization, communication, and recovery. This simple abstraction made large-scale graph algorithms easier to implement and inspired systems such as Apache Giraph.
