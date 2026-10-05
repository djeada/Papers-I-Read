## Bigtable: A Distributed Storage System for Structured Data

### Links

* https://static.googleusercontent.com/media/research.google.com/en//archive/bigtable-osdi06.pdf

### Notes

#### Summary

Bigtable is a distributed storage system for very large structured datasets. It exposes a sparse, persistent, multidimensional sorted map and scales by splitting tables into independently managed **tablets** that can be distributed across many servers.

#### Data model

* Data is indexed by **row key**, **column key**, and **timestamp**.
* Rows are kept in lexicographic order, so choosing row keys well creates useful locality.
* Columns are grouped into **column families**, which are the main unit of access control and storage configuration.
* Multiple timestamped versions of a cell may be retained.

#### Architecture

* Tables are divided into tablets, each covering a contiguous range of rows.
* Tablet servers serve reads and writes for assigned tablets.
* A master coordinates tablet assignment and administrative operations, but clients communicate directly with tablet servers for data access.
* Bigtable builds on lower-level Google infrastructure such as GFS for storage and Chubby for coordination.
* Immutable sorted files and in-memory buffering make sequential storage efficient while background compaction reorganizes data over time.

#### Takeaway

Bigtable demonstrates how a deliberately restricted data model can provide flexible schema design, high throughput, and horizontal scalability without trying to reproduce all relational-database semantics.
