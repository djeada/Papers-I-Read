## The Chubby lock service for loosely-coupled distributed systems

### Links

* https://static.googleusercontent.com/media/research.google.com/en//archive/chubby-osdi06.pdf

### Notes

- Chubby is a distributed lock service developed by Google.
- Provides coarse-grained locking and reliable (low-volume) storage.
- Designed for loosely-coupled distributed systems with thousands of clients.
- Emphasizes availability and reliability over high performance.
- Similar interface to a distributed file system with advisory locks.
- Utilizes the Paxos protocol for distributed consensus.
- Typically consists of five replicas per Chubby cell to reduce correlated failures.
- Replicas elect a master who handles all read and write operations.
- Non-master replicas copy updates from the master.
- Clients interact with Chubby via a client library.
- Supports a strict tree structure of files and directories, similar to UNIX.
- Nodes can be permanent or ephemeral; ephemeral nodes are deleted when no longer held by clients.
- Implements Access Control Lists (ACLs) as files within a special ACL directory.
- Provides reader-writer locks with shared (reader) and exclusive (writer) modes.
- Locks are advisory, not mandatory.
- Introduces sequencers to maintain order and consistency in operations.
- Implements a lock-delay mechanism to handle lock reacquisition after client failure.
- Clients can subscribe to events such as file modifications, lock acquisitions, and master fail-overs.
- Events are delivered asynchronously to inform clients of state changes.
- Maintains sessions through periodic KeepAlive messages to ensure liveness.
- Each session has a lease that the master periodically renews.
- Includes a grace period to handle master fail-overs without losing session state.
- Handles master fail-over by electing a new master using Paxos.
- Uses proxies to reduce server load by handling KeepAlive and read requests for multiple clients.
- Supports partitioning of the namespace to distribute load across multiple servers.
- Commonly used for primary election in systems like Google File System (GFS) and Bigtable.
- Acts as a reliable repository for configuration files and metadata.
- Serves as an internal name service, replacing traditional DNS for high-demand scenarios.
- Achieves high read hit rates (~96%) through effective client-side caching.
- Handles thousands of concurrent clients with minimal failure rates.
- Experiences low failure rates, with most outages lasting less than 30 seconds.
- Initially used replicated Berkeley DB for its database implementation.
- Later transitioned to a custom simple database with write-ahead logging and snapshotting.
- Regularly writes database snapshots to Google File System (GFS) for disaster recovery.
- Allows mirroring of files from one cell to another for global distribution.
- Faced challenges with abusive clients and implemented measures to mitigate misuse.
- Java clients utilize protocol-conversion servers due to complexity with JNI.
- Unexpectedly became widely used as a name service, leading to additional protocol-conversion servers.
- Lessons learned include the importance of developer awareness, effective API design, and robust fail-over handling.
- Compared to related systems like Boxwood, Chubby combines locks, small-file storage, and session mechanisms into a single service.
- Continues to be a primary internal name service and synchronization mechanism within Google.

