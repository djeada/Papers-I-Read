## Colossus under the hood: a peek into Google’s scalable storage system

### Links

* https://cloud.google.com/blog/products/storage-data-transfer/a-peek-behind-colossus-googles-file-system

### Notes

#### Summary

Colossus is Google's successor to the Google File System and acts as a foundational distributed storage layer for services ranging from Gmail and YouTube to BigQuery and Cloud Storage.

#### Architecture

* A client library contains substantial storage logic and lets applications choose durability, performance, and cost tradeoffs.
* **Curators** form a horizontally scalable metadata control plane.
* Curators store filesystem metadata in **Bigtable**, removing the single-master metadata scaling limit of GFS.
* Data flows directly between clients and **D file servers**, avoiding unnecessary data-plane hops.
* **Custodians** perform background work such as balancing storage, maintaining durability, and reconstructing missing data.
* Different redundancy encodings can be selected to match workload requirements, including replication and erasure-coding-style schemes.
* Separating scalable metadata management from the data path allows the system to support a very large number of files and highly diverse workloads.

#### Historical lesson

GFS was designed for an earlier Google scale. Colossus changes the metadata architecture so the storage system can grow by adding control-plane capacity rather than being constrained by one metadata server.

#### Takeaway

The key evolution from GFS to Colossus is **disaggregation and horizontal scaling of control state**. Metadata, data serving, client logic, and background maintenance are separate components that can scale independently.
