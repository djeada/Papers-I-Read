## Spanner: Google’s Globally-Distributed Database

### Links

* https://static.googleusercontent.com/media/research.google.com/en//archive/spanner-osdi2012.pdf

### Notes

#### Summary

Spanner is a globally distributed, synchronously replicated database that provides **externally consistent** transactions at large scale. Its distinguishing idea is to make clock uncertainty explicit through the **TrueTime** API and use that bounded uncertainty to assign transaction timestamps safely.

#### Key ideas

* Data is partitioned and replicated across geographically distributed servers.
* Replication groups use consensus to keep replicas consistent and tolerate failures.
* Read-write transactions combine locking and distributed commit with replicated state.
* **TrueTime** returns a time interval rather than pretending a machine knows the exact current time.
* By waiting out the uncertainty interval when necessary, Spanner can guarantee that committed transaction timestamps respect real-world ordering.
* Timestamped versions enable consistent snapshot reads and read-only transactions without taking ordinary read locks.
* The system supports moving and rebalancing data while preserving database semantics.

#### Takeaway

Spanner shows that strong transactional semantics and global distribution are not mutually exclusive, but achieving both requires careful coordination, replication, and an explicit model of time uncertainty.
