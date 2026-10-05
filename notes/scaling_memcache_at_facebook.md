## Scaling Memcache at Facebook

### Links

* https://www.usenix.org/system/files/conference/nsdi13/nsdi13-final170_update.pdf

### Notes

#### Summary

Facebook uses memcached not as a single cache server but as a building block for a globally distributed caching layer. The paper is about the engineering needed to preserve low latency and protect databases when a simple in-memory cache is scaled to billions of requests per second.

#### Key ideas

* Web servers locate cache entries across many memcache servers, distributing objects throughout the pool.
* Cache reads absorb the dominant read traffic so backend databases do not need to serve every request.
* On database writes, Facebook generally **invalidates** cached entries rather than trying to update every cached copy.
* **Leases** help prevent stale writes and reduce the thundering-herd problem when many clients miss on the same popular key.
* Regional pools reduce long-distance traffic and isolate failures.
* Replication is used selectively: replicating frequently read data can save network capacity, but unnecessary replication wastes memory.
* Failure handling includes mechanisms that keep a small number of dead cache servers from redirecting an overwhelming amount of traffic to the databases.
* Operational design matters as much as the cache algorithm: warm-up, failover, observability, and load balancing are part of the system.

#### Takeaway

At large scale, "add a cache" becomes a distributed-systems problem. The difficult parts are consistency, failure amplification, hot keys, traffic shaping, and protecting the authoritative datastore.
