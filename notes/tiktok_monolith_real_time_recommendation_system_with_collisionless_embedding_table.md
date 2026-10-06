## Monolith: Real Time Recommendation System With Collisionless Embedding Table

### Links

* https://arxiv.org/pdf/2209.07663

### Notes

#### Summary

Monolith is a production recommendation system designed for workloads with huge, sparse, rapidly changing feature spaces and a strong need to learn from user feedback in near real time.

#### Problems with generic ML infrastructure

Recommendation systems often differ from dense vision or language models:

* IDs and categorical features create enormous sparse embedding tables.
* New users, items, and features appear continuously.
* Popularity distributions are highly skewed and change quickly.
* Separating offline batch training from online serving makes the model react slowly to fresh behavior.

#### Key ideas

* Monolith uses a **collisionless embedding table** so different IDs do not accidentally share parameters because of hash collisions.
* Expirable embeddings remove stale entries and reduce memory consumption.
* Frequency filtering avoids allocating full embedding state to extremely rare features.
* The system supports online training so recent interactions can influence the model quickly.
* The distributed training and serving architecture is designed for fault tolerance at production scale.
* The paper explicitly accepts some systems tradeoffs in order to improve freshness and learning speed.

#### Takeaway

Large recommendation systems are not simply ordinary neural networks with more parameters. Sparse dynamic features, embedding lifecycle, freshness, and online feedback require a purpose-built training and storage architecture.
