## Map Reduce Big Data Algorithm

### Links

* https://static.googleusercontent.com/media/research.google.com/en//archive/mapreduce-osdi04.pdf

### Notes

#### Summary

MapReduce turns large-scale data processing into two user-defined functions—`map` and `reduce`—while the runtime hides most distributed-systems machinery. The abstraction made it possible for ordinary programmers to process terabytes of data across thousands of commodity machines without manually implementing scheduling, shuffling, fault recovery, or parallelization.

#### Key ideas

* `map(k, v)` transforms input key/value pairs into intermediate key/value pairs.
* The system groups all intermediate values with the same key and feeds them to `reduce(k, values)`.
* The runtime partitions input, schedules tasks, performs the shuffle, manages inter-machine communication, and writes outputs.
* Failed tasks can be re-executed because map and reduce computations are designed to be deterministic and side-effect-light.
* Scheduling work near the input data reduces network traffic and improves throughput.
* Intermediate data can be partitioned and sorted automatically before reduction.
* The model is intentionally simple. It does not express every computation elegantly, but the simplicity enables robust automatic parallel execution.

#### Takeaway

MapReduce's main contribution is not the `map` or `reduce` functions themselves; it is the runtime contract that turns a simple functional program into a fault-tolerant distributed computation.
