## Amazon Aurora: Design Considerations for High Throughput Cloud-Native Relational Databases

### Links

* https://assets.amazon.science/dc/2b/4ef2b89649f9a393d37d3e042f4e/amazon-aurora-design-considerations-for-high-throughput-cloud-native-relational-databases.pdf

### Notes

#### Summary

Amazon Aurora redesigns the storage layer of a relational OLTP database for a cloud environment where compute and storage are separated. The paper argues that once storage is distributed, the main bottleneck shifts from disks to **network traffic**.

#### Key ideas

* The database compute node sends **redo log records** to storage rather than repeatedly shipping full modified database pages.
* Redo processing, page materialization, backup, and repair are pushed into a distributed storage service.
* Data is replicated six ways across three availability zones to tolerate correlated failures.
* Aurora uses quorum-style rules so a transaction does not need every replica to respond before progress can continue.
* Storage nodes can repair missing or damaged segments using peer replicas without blocking the database instance.
* Because the storage tier understands the log, crash recovery does not require replaying an enormous local log before service resumes.
* Read replicas share the same distributed storage volume, reducing replica lag and avoiding full storage duplication.
* The architecture separates the SQL/transaction/caching layer from the distributed logging and storage layer.

#### Takeaway

Aurora shows how cloud databases can improve throughput and recovery by moving database-specific work into a scale-out storage service. The important optimization is to minimize network amplification, not merely to make individual disks faster.
