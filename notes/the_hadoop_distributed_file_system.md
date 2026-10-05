## The Hadoop Distributed File System

### Links

* https://pages.cs.wisc.edu/~akella/CS838/F15/838-CloudPapers/hdfs.pdf

### Notes

#### Summary

HDFS is a distributed file system optimized for storing very large files reliably and streaming them at high bandwidth on clusters of commodity machines. Its design favors large sequential access and data-intensive batch computation over low-latency random updates.

#### Architecture

* The **NameNode** stores filesystem metadata: the namespace, permissions, and the mapping from files to blocks.
* **DataNodes** store the actual file blocks on local disks.
* Files are split into large blocks and each block is replicated on multiple DataNodes for durability.
* Clients ask the NameNode for block locations and then transfer data directly to or from DataNodes.
* DataNodes send heartbeats and block reports so the NameNode can detect failures and trigger re-replication.

#### Design choices

* Replication on commodity servers provides fault tolerance without requiring specialized storage hardware.
* Large blocks and streaming access reduce metadata overhead and maximize throughput.
* Hadoop schedulers can place computation near the machines holding the needed blocks, reducing network traffic.
* The system is designed around a relatively simple write model rather than arbitrary in-place modification.

#### Takeaway

HDFS gains scale and reliability by specializing for large analytical workloads. Its constraints are deliberate: they make storage and computation across thousands of inexpensive machines manageable and efficient.
