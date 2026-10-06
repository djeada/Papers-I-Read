## Firestore: The NoSQL Serverless Database for the Application Developer

### Links

* https://storage.googleapis.com/gweb-research2023-media/pubtools/7076.pdf

### Notes

#### Summary

Firestore is a serverless NoSQL database aimed at web and mobile application developers. Its design combines automatic scaling and transactional storage with **real-time notifications** and client libraries that hide much of the complexity of intermittent network connectivity.

#### Key ideas

* Applications store data in documents organized into collections rather than fixed relational tables.
* Developers do not provision database servers or manually shard capacity.
* The service is designed to scale with workload spikes and use pay-as-you-go resource consumption.
* Clients can subscribe to queries and receive updates as the underlying data changes.
* Real-time listeners are integrated with Firebase client libraries so UI state can track server-side state with relatively little application code.
* Client libraries support local caching and synchronization, allowing applications to remain usable when network connectivity is unreliable.
* The system must maintain query semantics while efficiently identifying which active listeners are affected by each database change.
* Firestore combines developer-facing simplicity with a distributed backend that provides consistency, transactions, indexing, and availability.

#### Takeaway

Firestore treats synchronization as part of the database interface rather than an application-side afterthought. The main abstraction is not only "store and query documents" but also "keep clients continuously synchronized with changing query results."
