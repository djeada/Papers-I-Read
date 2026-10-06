## Cpp design patterns for low-latency applications including high-frequency trading

### Links

* https://arxiv.org/pdf/2309.04259

### Notes

#### Summary

The paper studies practical C++ techniques for applications where **tail latency and predictable execution time** matter as much as average throughput, with high-frequency trading as the main motivating example.

#### Key ideas

* Low-latency programming requires understanding the hardware memory hierarchy rather than optimizing only source-level instruction counts.
* Heap allocation, cache misses, context switches, locks, unpredictable branches, and unnecessary copies can dominate latency.
* Preallocation and cache warming move expensive work away from the latency-critical path.
* Compile-time computation with techniques such as `constexpr` can eliminate runtime work.
* Data layout should favor locality and predictable access patterns.
* Lock-free or low-contention communication can reduce scheduler and synchronization overhead.
* The paper implements the **Disruptor** pattern in C++ and compares it with more conventional queues.
* Changes are evaluated statistically rather than relying on isolated benchmark runs, since nanosecond-scale measurements are noisy.
* The authors also apply the techniques to a statistical-arbitrage trading implementation to study their end-to-end impact.

#### Takeaway

Low-latency optimization is a whole-system exercise. The biggest gains often come from controlling memory access, allocation, synchronization, and predictability—not from clever arithmetic micro-optimizations.
