## Google File System

### Links

* https://static.googleusercontent.com/media/research.google.com/en//archive/gfs-sosp2003.pdf

### Notes

The Google File System (GFS) is designed as a scalable, fault-tolerant, and high-throughput distributed file system running on cheap commodity hardware. It primarily supports large, data-intensive applications at Google.

I. **Frequent Component Failures**  

 - Commodity machines often fail; the system must detect and recover automatically.

II. **Large Files Are Common**  

 - Multi-gigabyte or even multi-terabyte files.  
 - Traditional small-block designs become inefficient.

III. **Mostly Append-Only Access**  

 - Traditional overwrite patterns are rare.  
 - Concurrency requires special logic for atomic appends.

IV. **High Throughput is More Important than Low Latency**  

 - Focus on streaming reads, large-scale writes, and multi-GB data sets.

##### Design Choices

- **Relaxed Consistency Model**  
Emphasizes high throughput while tolerating “inconsistent but defined” regions if multiple writers overlap.

- **Custom API Extensions**  
- *Record append:* lets multiple clients append concurrently, guaranteeing atomic appends.  
- *Snapshot:* quickly clones a file or directory tree at a particular point in time.

#### System Architecture

##### Master, Chunkservers, and Clients

- **Single Master:**  
- Stores all metadata (namespace tree, file-to-chunk mappings, replica locations).  
- Minimal involvement in data path to avoid bottlenecks.
- **Chunkservers:**  
- Files are split into 64 MB “chunks,” each identified by a unique handle.  
- Each chunk is stored as a Linux file and replicated (default replication: 3).  
- Chunkservers handle read/write requests directly from clients.
- **Clients:**  
- Linked with GFS client libraries.  
- Query the master for chunk location info, then interact with chunkservers directly for data.

##### Chunk Size (64 MB)

- **Benefits:**  
- Reduces need to contact master frequently (fewer chunks per file).  
- Efficient sequential reads, pipelines, and large writes.  
- Decreases metadata stored at master.
- **Potential Drawback – Hotspots:**  
- Could cause hotspots if many clients simultaneously access the same small file.  
- Mitigated by higher replication or other usage patterns.

##### Metadata and Operation Log

- **Master Metadata:**  
- All in master’s memory:  
- File and chunk namespaces.  
- Mapping from file to chunk handles.  
- Locations of each chunk’s replicas.  
- Stored persistently via an **operation log** (write-ahead log) and **periodic checkpoints**.
- **Chunkserver Metadata:**  
- Each chunkserver periodically reports its chunks to the master.  
- No permanent chunkserver list is stored at the master; it is discovered at startup and kept updated via heartbeats.

##### Consistency Model

- **File regions can be:**  
- *Consistent:* all clients see the same data (though not necessarily latest).  
- *Defined:* consistent region reflecting the result of a completed mutation.  
- *Undefined but consistent:* overlapping concurrent writes, final data is consistent but may mix writes.  
- *Inconsistent:* if a mutation fails partway, different replicas can differ briefly until recovery.
- **Applications Cope with Non-POSIX Semantics:**  
- Usually rely on appends and periodic checkpoints.  
- Atomic record appends make sure that each client’s appended record is added exactly once, even if duplicates might appear in rare failure cases.

#### Data Flow and Mutation Protocol

##### Write Mutations with Leases

I. **Client → Master:** asks which chunkserver is the primary replica holder (leaseholder).  

II. **Master:** returns primary + location of other replicas.  

III. **Client → All Replicas:** pushes data in a pipeline (decoupled from control flow).  

IV. **Client → Primary:** sends write request referencing the newly pushed data.  

V. **Primary → Secondary Replicas:** forwards the serialized write requests in a specific order.  

VI. **Secondaries:** acknowledge completion to primary.  

VII. **Primary → Client:** final acknowledgment.  

- **Leases:**  
- The master grants a 60-second lease to a chosen primary replica for each chunk.  
- Primary enforces the mutation order among replicas.

###### Pipeline Data Flow

- **Linear Chain:**  
- Data flows in a pipeline among chunkservers, each forwarding to the next.  
- Improves bandwidth usage of each node’s full-duplex interface.

###### Record Append

- **Atomic Append at an Undefined Offset:**  
- Multiple clients can simultaneously append data to the same file chunk.  
- Primary decides final offset and makes sure all replicas apply the same offset.  
- **Failure Handling:**  
- Incomplete replicas are detected via checksums or version mismatches.  
- Region may contain some duplicates, which higher-level app logic can detect using checksums or unique IDs.

###### Snapshots

- **Copy-on-Write:**  
- Master revokes leases on the file’s chunks.  
- Creates metadata references pointing to existing chunks.  
- On next write, the affected chunk is duplicated on-demand.

##### Master Operations

###### Namespace Management and Locking

- **Namespace is a Flat Mapping:**  
- Full paths map to in-memory metadata.  
- Paths also locked with read/write locks for concurrency.  
- **Locks:**  
- Make sure safe concurrency for many operations (e.g., snapshot, renames, file creation).

###### Replica Placement

- **Strategy:**

I. Spread replicas across racks to improve reliability (tolerate rack failures) and load balancing.  

II. Aim for chunkservers with below-average utilization.  

III. Avoid placing too many new replicas on a single chunkserver.

###### Creation, Re-replication, and Rebalancing

- **Chunk Creation:**  
- Placed on chunkservers with space and balanced load.  
- **Re-replication:**  
- Kicks in when the number of live replicas < replication goal.  
- High priority for chunks that have lost multiple replicas or that block clients.  
- **Rebalancing:**  
- Moves replicas for better disk usage and load distribution.  
- Restricts concurrency to avoid overwhelming chunkservers or the network.

###### Garbage Collection

- **Lazy Deletion:**  
- Deleted files become hidden and remain briefly for possible recovery.  
- Orphaned chunks get reclaimed during regular master scanning.  
- **Advantages:**  

I. Simplified design: no immediate reference-count updates.  

II. Protects against accidental deletions.  

III. Batches reclaims for efficiency.

###### Stale Replica Detection

- **Chunk Version Numbers:**  
- Incremented when a new lease is granted.  
- Replicas that miss updates hold old version numbers.  
- **On Rejoin:**  
- Chunkserver with outdated replica is discovered by comparing version numbers.  
- Stale replica is removed in garbage collection.

#####. Fault Tolerance and Diagnosis

###### High Availability

I. **Fast Recovery:**  

- Master and chunkservers store minimal persistent state; they recover in seconds.  

II. **Replication:**  

- Each chunk is replicated on multiple chunkservers across racks.  
- Master operation log is replicated.

###### Data Integrity via Checksums

- **Chunk Splits:** each 64 MB chunk is subdivided into 64 KB blocks, each with a 32-bit checksum.  
- **On Reads:** chunkserver verifies block checksums.  
- If mismatch, it reports error to master, which re-replicates from valid replicas.  
- **Detecting Idle Corruption:** chunkservers can background-scan chunks to detect rarely read corrupted blocks.

###### Diagnostic Logging

- **All RPCs Logged:** including request and response (but not the actual file data).  
- **Usage:**  
- Problem diagnosis and performance analysis.  
- Offline replays for debugging.

##### Performance Measurements

###### Micro-Benchmarks

**Test Setup:**

- 1 master, 2 master replicas, 16 chunkservers, 16 clients, each with 100 Mbps link.

I. **Read Throughput:**  

- Single client: ~10 MB/s (80% of network limit).  
- 16 clients total: ~94 MB/s (75% of the 125 MB/s trunk limit).

II. **Write Throughput:**  

- Single client: ~6 MB/s, ~50% of ideal due to pipeline overhead.  
- 16 clients total: ~35 MB/s, about half of theoretical limit.

III. **Record Appends (N clients to one file):**  

- Single client: ~6 MB/s.  
- 16 clients: ~4.8 MB/s total, limited by chunkserver network capacity for the final chunk.

###### Production Clusters

| Metric                        | Cluster A         | Cluster B         |
|-------------------------------|-------------------|-------------------|
| Chunkservers                  | 342               | 227               |
| Total Disk Space             | 72 TB             | 180 TB            |
| Used Space (incl. replicas)  | 55 TB             | 155 TB            |
| Files                         | 735k              | 737k              |
| Chunks                        | ~1.0M             | ~1.55M            |
| Master Metadata              | 48 MB             | 60 MB             |

- **Read and Write Rates:**  
- Sustained read throughput (time of measurement) often hundreds of MB/s (e.g., ~580 MB/s in cluster A).  
- Writes typically < 30 MB/s, but can spike to ~100+ MB/s.
- **Recovery Time:**  
- Re-replicating ~600 GB of chunks after one chunkserver failure took ~23 minutes, ~440 MB/s effective rate.  
- Priority-based replication first recovers single-replica chunks.

##### Experiences and Lessons

- **Failures and Bugs:**  
- Encountered Linux disk driver mismatch issues leading to silent corruption, prompting checksums.  
- fsync cost overhead in older kernels forced migration to better I/O strategies.  
- Single reader-writer lock in older Linux versions caused stalls, leading to a switch from mmap to pread.
- **Simplicity:**  
- Centralized master simplifies replication, rebalancing, and metadata.  
- Lazy garbage collection helps handle failures gracefully.
- **Co-Design with Applications:**  
- GFS APIs (append, snapshot) align with application usage patterns.  
- System usage evolves quickly; GFS can integrate new needs (permissions, quotas) as required.

##### Related Function

- **AFS, xFS, Swift, NASD, Frangipani:**  
Other distributed file systems have influenced GFS’s design, but GFS differs through large-chunk design, replication scheme, relaxed consistency, and append-optimized interface.

- **Resemblance to NASD Architecture:**  
GFS uses commodity nodes instead of specialized disks, and chunk-level replication rather than more complicated RAID or parity schemes.
