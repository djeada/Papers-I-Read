## Cassandra - A Decentralized Structured Storage System

### Links

* https://www.cs.cornell.edu/projects/ladis2009/papers/lakshman-ladis2009.pdf

### Notes

#### Summary

Cassandra is a decentralized distributed storage system designed at Facebook for workloads that need high write throughput, horizontal scalability, and continuous availability across many commodity servers.

#### Key ideas

* The data model combines ideas from **Bigtable** with distribution techniques inspired by **Dynamo**.
* Data is partitioned using consistent hashing so nodes can be added or removed incrementally.
* Each item is replicated across several nodes for fault tolerance and availability.
* There is no central master for ordinary operation, avoiding a single point of failure.
* Gossip protocols distribute membership and failure information.
* Writes are recorded durably and buffered in memory before being written to immutable on-disk structures.
* Read repair, hinted handoff, and anti-entropy mechanisms help replicas converge after failures.
* The system offers tunable consistency choices rather than enforcing one global consistency level for every request.

#### Design goal

Cassandra was built for applications such as inbox search, where the service must remain available under failures and handle heavy write traffic without making reads unusably expensive.

#### Takeaway

Cassandra combines a flexible column-oriented data model with decentralized replication. It is a good example of designing a database around failure tolerance and operational scalability rather than around full relational semantics.
