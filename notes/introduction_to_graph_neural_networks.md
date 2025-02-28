## Introduction to Graph Neural Networks

### Links

* https://arxiv.org/pdf/2412.19419

### Notes

I. **Graph Neural Networks (GNNs) Overview**  

- GNNs are deep neural models for graph-structured data where nodes or edges can have attributes.  
- They combine feature-learning (node embeddings) with structural (edge-based) information.  
- They address limitations of shallow embedding methods by jointly exploiting node features and graph connectivity.

II. **Encoder-Decoder Framework**  

- GNNs are described in an encoder-decoder format:  
 - **Encoder**: Produces low-dimensional embeddings for each node.  
 - **Decoder**: Converts those embeddings into outputs for a chosen task (e.g., classification, link prediction).  
- In many graph tasks, the decoder is simple (e.g., softmax for node classification, inner product for link prediction), while most learnable parameters lie in the encoder.

III. **Common Graph Tasks**  

- **Node Classification** (assign labels to nodes).  
- **Link Prediction** (predict whether an edge between two nodes exists).  
- **Community Detection** (group nodes into clusters).  
- **Node Regression & Edge Regression** (predict continuous values at nodes or edges).  
- **Graph Classification** (assign a label or value to an entire graph).

IV. **Shallow Methods vs. GNNs**  

- **Shallow approaches** like Laplacian eigenmaps, matrix factorization, or random-walk-based embeddings store learned parameters per node and generally cannot handle unseen nodes or use node features effectively.  
- **GNNs** share learnable parameters among nodes, combine node features with graph connectivity, and can be transferred to new/unseen data.

V. **Encoder Components in GNNs**  

- **Pre-processing layers** (optional): Single-layer or multi-layer feedforward networks that transform raw node attributes prior to neighborhood aggregation.  
- **Message-passing layers**: Core layers that aggregate information from neighboring nodes to produce updated node feature vectors.  
- **Post-processing layers** (optional): Feedforward networks acting after message passing to finalize node embeddings.

VI. **Message-Passing Mechanism**  

- Each message-passing layer transforms the feature of a node by combining its current feature vector with an aggregation over neighbor features.  
- The design of the node-to-node interaction function (often called “messages”) distinguishes three main GNN categories:  
 - **Convolutional** (e.g., GCN): Aggregation uses fixed weights based on adjacency, often summing or averaging neighbor features.  
 - **Attentional** (e.g., GATv2): Aggregation weights are learned (attention coefficients) for each edge.  
 - **Message-Passing / MP** (general category): Any learned pairwise interaction function $\psi(h_i, h_j)$ can define neighbor-to-node messages.

VII. **Decoder and Loss Examples**  

- **Node Classification**: Typically a softmax layer that predicts class membership for each node.  
- **Link Prediction**: Often a sigmoid applied to the inner product of two node embeddings.  
- **Graph Classification**: Pool node embeddings, then use a softmax for the entire graph.  
- **Community Detection**: Can optimize a modularity-based objective in a differentiable way.  
- **Node/Edge Regression**: Often an MSE or MAE loss over predicted real values.

VIII. **Learning Modes**  

- **Transductive**: All nodes (including test nodes) appear at training time (though test labels remain hidden).  
- **Inductive**: Training graph and test graph are disjoint, so the model must generalize to completely unseen nodes.

IX. **Experimental Setup**  

- Thirteen open-source homogeneous datasets are used, covering a range of node and edge complexities:  
 - **High homophily**: Cora, PubMed, CiteSeer, DBLP, AmazonComputers, AmazonPhoto, CoauthorCS.  
 - **Low homophily**: WikipediaSquirrel, WikipediaChameleon, WikipediaCrocodile, Actor, Cornell, Wisconsin.  
- Homophily measures fraction of edges connecting same-labeled nodes.  
- SNR (Signal-to-Noise Ratio) measures how separable node features are between classes.

X. **Baseline Models Compared**  

- **GCN** (Graph Convolutional Network): Uses fixed averaging of neighbor features.  
- **GATv2** (Attentional GNN): Learns attention weights for edges.  
- **GraphSAGE**: Convolutional aggregator that concatenates each node’s features with the aggregate of neighbors.  
- **MLP**: Fully connected neural network using node features only (ignores edges).  
- **DeepWalk**: A shallow embedding approach using random walks (ignores node features).

XI. **Default Hyperparameters in Baseline Runs**  

- GCN, GATv2, GraphSAGE each have 2 message-passing layers, 16 hidden dimensions, no pre-/post-processing.  
- MLP has 3 fully connected layers (128 → 64 → output).  
- DeepWalk uses 16-dimensional random-walk embeddings.  
- Models are trained for up to 200 epochs, with a 0.1 learning rate.

XII. **Computation Times Example**  

- On the Cora dataset, GCN/GraphSAGE/MLP each took around 2–3 minutes CPU time.  
- GATv2 took ~4 minutes.  
- DeepWalk took ~58 minutes (the slowest).

XIII. **Impact of Homophily**  

- **High-homophily data**: Neighbors typically share labels, so GCN excels by averaging consistent neighbor features.  
- **Low-homophily data**: Neighbors often have conflicting labels/features; GraphSAGE and attentional GNNs can cope better than plain GCN.  
- In extremely low-homophily, sometimes purely feature-based MLP can compete because neighbor information is harmful.

XIV. **Impact of Training Size**  

- With very small label sets (1% of nodes labeled), GNNs can exploit edges for better generalization in high-homophily graphs.  
- If the graph has low homophily and minimal training labels, the gains from edges are limited or can even degrade performance (conflicting neighbor info).

XV. **Performance Differences (Off-the-Shelf)**  

- On **high-homophily** graphs with enough training data, GCN or GATv2 typically yield the highest accuracy.  
- On **low-homophily** graphs with more training data, GraphSAGE often outperforms GCN/GATv2.  
- MLP does surprisingly well on low-homophily graphs with sufficiently rich node features.  
- DeepWalk performs similarly to GNNs in high-homophily but poorly in low-homophily because it lacks node feature usage.

XVI. **Hyperparameter Sensitivity**  

- Larger hidden dimensions help performance particularly on **medium difficulty** settings (moderate training size, moderate homophily).  
- In easy settings (high homophily, large training set), standard designs already perform near-optimal.  
- In hard settings (low homophily, tiny training set), hyperparameter tuning yields minimal gains.

XVII. **Deeper Message-Passing**  

- For high-homophily datasets, stacking more message-passing layers significantly improves accuracy (wider node neighborhoods aggregated).  
- For low-homophily datasets, many message-passing layers can dilute signals with contradictory neighbor info, so more pre/post layers (non-aggregating) help more than deeper aggregation.

XVIII. **Skip Connections and Other Design Choices**  

- Attentional GNNs often benefit from “skip sum” (residual) connections if more message-passing layers are used.  
- GraphSAGE’s built-in concatenation (between node features and neighbor-aggregates) sometimes makes extra skip connections less necessary.

XIX. **Noise vs. Signal in Learned Features**  

- Experiments measure “signal” as mean class-wise separation and “noise” as within-class variance.  
- In high-homophily graphs, message passing strongly reduces noise because neighbors share the same label/features.  
- In low-homophily graphs, message passing sometimes lowers signal if neighbors conflict, unless the architecture is designed to preserve each node’s own feature signal (e.g., GraphSAGE concatenation).

XX. **Training Stability**  

- On high-homophily graphs, models generally keep improving or remain stable for hundreds of epochs.  
- On low-homophily graphs with few layers or poor designs, accuracy can drop after ~25 epochs from overmixing contradictory neighbor info.  
- Adding pre- and post-processing layers helps maintain stable training on low-homophily data.

XXI. **Comparison with RevGNN**  

- RevGNN is a memory-efficient design allowing arbitrarily deep GCN/GATv2/GraphSAGE backbones.  
- In experiments, well-tuned GNNs match or exceed off-the-shelf RevGNN performance on these node classification tasks.

XXII. **Overall Experimental Findings**  

- GNN category choice should align with graph homophily:  
 - Convolutional GNNs (GCN) often best for strongly homophilic graphs.  
 - Attentional or GraphSAGE variants handle low homophily more effectively.  
- Tuning is most beneficial for medium difficulty scenarios (moderate homophily and moderate training size).  
- Very large or very small training sets reduce the relative impact of hyperparameter tuning beyond dimension size.

XXIII. **Conclusion**  

- GNNs unify node-feature learning and structural (edge) information.  
- Encoder-decoder viewpoint clarifies how GNN outputs tie to the task-specific decoder.  
- Experiments across multiple datasets underscore how homophily and training size shape GNN design choices.  
- In high-homophily tasks, deeper message-passing is key; in low-homophily tasks, the mixing must be carefully limited and augmented with more pre-/post-processing.  
- Tuning hidden dimensions is usually the first best improvement; other design tweaks (layers, skip connections) become more important in moderate difficulty settings.  
- GNNs remain strongly preferred for tasks where both node features and relationships matter, though shallow or MLP methods can compete when edges provide little useful signal.

XXIV. **Open-Source Libraries**  

- PyTorch Geometric, Deep Graph Library, and others (GeometricFlux.jl, Spektral, Jraph) provide reference implementations and standard data sets.  
- PyTorch Geometric and DGL are the most popular, widely supported for new GNN research.  
