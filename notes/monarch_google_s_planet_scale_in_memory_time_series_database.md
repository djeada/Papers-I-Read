## Monarch: Google’s Planet-Scale In-Memory Time Series Database

### Links

* https://storage.googleapis.com/gweb-research2023-media/pubtools/6348.pdf

### Notes

#### Summary

Monarch is Google's globally distributed, multi-tenant time-series database for monitoring large production systems. It ingests enormous streams of telemetry into memory and serves high-volume monitoring and debugging queries.

#### Key ideas

* The system is **regionalized** for reliability and scalability rather than relying on one global serving cluster.
* Global configuration and query layers make the separate regions appear as a unified service.
* Time-series data is kept primarily in memory to support low-latency operational queries.
* Data is sharded and routed according to monitored entities and locality.
* A hierarchical query architecture aggregates results from distributed storage and execution nodes.
* The data model is relational enough to support expressive filtering, grouping, aggregation, and joins over monitoring data.
* Configuration determines how metrics are collected, retained, routed, and queried across a large shared infrastructure.
* The architecture emphasizes failure isolation: problems in one region should not prevent monitoring of the rest of the system.

#### Scale

The paper describes production operation at Google scale, including ingest measured in terabytes per second and millions of queries per second.

#### Takeaway

Monitoring infrastructure must itself be one of the most reliable distributed systems in the company. Monarch achieves scale by keeping the serving path regional while adding global coordination only where it is necessary.
