## Kafka: a Distributed Messaging System for Log Processing

### Links

* https://notes.stephenholiday.com/Kafka.pdf

### Notes

- Kafka is a distributed messaging system focused on high-volume log data collection and delivery with low latency.  
- It treats log data as a real-time feed for both offline and online consumption.  
- The design takes concepts from existing log aggregators and traditional messaging systems but adapts them specifically for log processing.  
- Kafka can handle hundreds of gigabytes of new log data daily, achieving high throughput and scalability.  

**Motivation and Related Work**  
- Internet services generate huge amounts of log data (e.g., pageviews, clicks, system metrics) for both offline analytics (data warehouse, Hadoop) and real-time applications (search relevance, recommendations, ads).  
- Traditional messaging systems (e.g., JMS, WebSphere MQ) prioritize complex delivery guarantees and often do not offer sufficient throughput or easy distribution for massive log ingestion.  
- Log aggregation tools (e.g., Facebook Scribe, Flume) are typically designed for bulk offline loading, not near-real-time consumption; most employ “push” models, which can overwhelm slow consumers.  
- Kafka’s architecture “pulls” data from brokers, letting each consumer control consumption speed, simplifying backpressure handling and enabling easy rewinds on errors.  

**Kafka’s Main Concepts**  
- A **topic** represents a data category or feed name to which messages are published.  
- A **producer** publishes batches of messages to topics.  
- A **broker** is a Kafka server that stores published messages; a cluster can have multiple brokers.  
- A **consumer** subscribes to one or more topics and pulls messages at its own pace.  
- A **partition** is the unit of parallelism: each topic is split into multiple partitions, each stored at one or more brokers.  

**Data Storage and Access**  
- Each partition is a logically continuous log, physically segmented into files (segments) on disk.  
- New messages are appended sequentially at the end of the last segment.  
- Appends are batched to disk, and message retrieval uses sequential reads, leveraging OS page cache and read-ahead.  
- Message IDs are simply byte offsets in the log, avoiding separate indexing structures.  
- Consumers make explicit pull requests with an offset, and the broker returns messages from that offset onward.  
- Time-based retention automatically deletes older messages (e.g., after 7 days), enabling storage to remain bounded.  
- Consumers can rewind to re-process data if needed (e.g., upon consumer errors), which is simpler under pull-based delivery.  

**Performance Optimizations**  
- A “zero-copy” transfer uses the `sendfile` API on Linux/Unix to directly stream data from file to socket, reducing CPU overhead and data copying.  
- Broker does not track individual consumer read positions; consumers store these offsets themselves, lowering broker overhead.  
- Producer-side batching (e.g., sending sets of messages in one request) massively improves throughput.  
- No forced acknowledgement from the broker to the producer by default, allowing higher publish rates at the risk of some data loss in certain failure scenarios.  
- Smaller data overhead: Kafka’s message format has minimal per-message metadata compared to typical JMS-based systems.  

**Distributed Coordination**  
- **Consumer groups** define how messages in a topic are divided among consumers: each partition is consumed by exactly one consumer in the group.  
- Multiple groups can independently consume the same topic, each group receiving the full data feed.  
- **Zookeeper** is used to detect broker and consumer membership changes and to trigger rebalancing.  
- A consumer that joins or leaves the group, or a change in broker partitions, prompts group-wide rebalancing.  
- The rebalancing process is decentralized: each consumer reads from Zookeeper the sets of available partitions and group membership, deterministically claims a subset of partitions, and starts pulling messages.  

**Delivery Semantics**  
- Kafka guarantees in-order delivery per partition but not across partitions.  
- By default, the system provides at-least-once delivery; exactly-once would require heavier transactional mechanics.  
- Duplicate messages can occur if a consumer fails mid-processing, because the replacement consumer will start from the last committed offset. Applications can deduplicate by offset or unique keys if necessary.  

**Usage at LinkedIn**  
- Kafka instances run in each datacenter, co-located with user-facing services that generate log events.  
- A load balancer spreads incoming producer requests among the local Kafka brokers.  
- Real-time services in the same datacenter consume messages directly (for search, recommendations, etc.).  
- A separate Kafka cluster in a dedicated “analysis” datacenter pulls data from the production clusters; that cluster feeds Hadoop and data warehouses for offline processing.  
- End-to-end pipeline latency is typically around 10 seconds.  
- Kafka processes hundreds of gigabytes and close to a billion messages daily at LinkedIn.  
- A monitoring scheme ensures no data loss: producers publish periodic “monitoring events” with counters, so consumers can cross-check the number of messages actually received.  
- Loading into Hadoop uses a custom Kafka input format within MapReduce, benefiting from the stateless broker design.  
- Avro is used for message serialization, enabling flexible schema evolution and consistent consumer-producer contracts.  

**Performance Experiments**  
- Compared Kafka to Apache ActiveMQ (JMS) and RabbitMQ under similar test conditions.  
- **Producer Throughput**: Kafka achieved ~50,000 msg/s (batch=1) or ~400,000 msg/s (batch=50), which far exceeded ActiveMQ and doubled RabbitMQ’s best results.  
- **Consumer Throughput**: Kafka retrieved messages at ~22,000 msg/s, around four times faster than ActiveMQ/RabbitMQ in the same test setup.  
- Key reasons for Kafka’s advantage: minimal overhead in message format, efficient log-based storage, zero-copy data transfer, and no broker-side per-message state tracking.  

**Conclusions and Future Work**  
- Kafka’s pull-based, log-centric design offers high throughput, scalability, and flexible data retention.  
- It replaces specialized log aggregators plus separate messaging solutions, unifying both offline and online log processing.  
- Future improvements include:  
  - **Replication** for durability and availability (messages stored on multiple brokers).  
  - Allowing different levels of synchronous or asynchronous replication depending on application needs.  
  - Adding stream-processing capabilities (windowing, joins, etc.) to handle distributed event streams more directly in Kafka.  

- Kafka’s stateless brokers and time-based retention, combined with consumer-managed offsets, minimize complexity and deliver strong performance for large-scale log data pipelines.
