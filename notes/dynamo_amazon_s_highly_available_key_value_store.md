## Dynamo: Amazon’s Highly Available Key-value Store

### Links

* https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf

### Notes

#### Summary

Dynamo is a highly available key-value store designed for Amazon services where an outage is often worse than temporarily returning conflicting versions of data. It favors availability and partition tolerance, accepting eventual consistency and pushing some conflict resolution to applications.

#### Key ideas

* Data is partitioned using **consistent hashing** so nodes can join, leave, or fail with limited remapping.
* Each key is replicated across several nodes.
* Reads and writes use configurable quorum-like parameters (`N`, `R`, and `W`) to trade consistency, latency, and availability.
* **Sloppy quorums** allow requests to use healthy substitute nodes during failures rather than requiring the exact preferred replicas.
* **Hinted handoff** stores replicas temporarily on substitute nodes and forwards them when the intended node recovers.
* **Vector clocks** capture causal relationships between versions and expose concurrent updates that cannot be ordered automatically.
* Applications may reconcile divergent versions because business semantics can be better suited to conflict resolution than a generic storage layer.
* Gossip-based membership and failure detection keep the system decentralized.

#### Takeaway

Dynamo is a classic example of designing around the business requirement "the service must remain writable." It makes consistency an explicit tradeoff rather than assuming strong consistency is always the top priority.
