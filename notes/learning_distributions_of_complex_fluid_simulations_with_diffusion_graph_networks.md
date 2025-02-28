## Learning Distributions of Complex Fluid Simulations with Diffusion Graph Networks

### Links

* https://openreview.net/pdf?id=uKZdlihDDn

### Notes

#### Denoising Diffusion Probabilistic Models (DDPMs)

Denoising Diffusion Probabilistic Models (DDPMs) learn to synthesize a sample z_0 from a data distribution q(z_0) by progressively denoising a sample z_R drawn from an isotropic Gaussian N(0, I). This denoising process reverses a forward (diffusion) process where Gaussian noise is progressively added to data samples z_0.

Forward (diffusion) process:

$$q(z_r \mid z_{r-1}) = N\bigl(z_r; \sqrt{1-\beta_r},z_{r-1},,\beta_r I\bigr)$$

where

$$\beta_r \in (0, 1),\quad 
\alpha_r = 1 - \beta_r,\quad 
\bar{\alpha}_r = \prod_{s=1}^{r} \alpha_s$$

A convenient shortcut (Ho et al., 2020) allows sampling z_r at step r directly from z_0:
$$z_r = \sqrt{\bar{\alpha}_r},z_0 + \sqrt{1 - \bar{\alpha}_r},\epsilon,\quad
\epsilon \sim N(0, I)$$

When R is large and $\beta_r$ is chosen appropriately, z_R approaches a Gaussian distribution. The reverse (denoising) process approximately inverts the forward one via learned Gaussian transitions:

$$p_{\theta}(z_{r-1} \mid z_{r})
= N\bigl(z_{r-1};\ \mu_{\theta}(z_r, r),\ \Sigma_{\theta}(z_r, r)\bigr)$$

A common parameterization (Ho et al., 2020; Nichol & Dhariwal, 2021) sets the mean and diagonal covariance in terms of a network output for epsilon-hat and v:

$$\mu_{\theta}(z_r, r)
= \frac{1}{\sqrt{\alpha_r}}
\Bigl(
z_r - \beta_r,\frac{\widehat{\epsilon}(z_r, r)}{\sqrt{1 - \bar{\alpha}_r}}
\Bigr)$$

$$\Sigma_{\theta}(z_r, r)
= \exp\bigl[
v_{\theta},\log(\beta_r)+(1-v_{\theta}),\log(\tilde{\beta}_r)
\bigr]$$

where $\tilde{\beta}_r = \frac{(1-\bar{\alpha}_{r-1})}{(1-\bar{\alpha}_r)},\beta_r$. The network outputs $\widehat{\epsilon}\in \mathbb{R}^{n\times F}$ and $v_{\theta}\in \mathbb{R}^{n\times F}$.

The loss function is

$$\mathcal{L} = \mathcal{L}_{\text{simple}} + \lambda_{\text{vlb}}\mathcal{L}_{\text{vlb}},\quad
\text{where}\quad
\mathcal{L}_{\text{simple}} =
\mathbb{E}_{r,,z_0,,\epsilon}\bigl[\|\epsilon - \widehat{\epsilon}(z_r,r)\|\bigr]$$

with $\epsilon \sim N(0,I)$ and z_r obtained via the forward process. The term $\mathcal{L}_{\text{vlb}}$ is a variational lower bound that makes sure proper weighting of entropy in the reverse denoising steps (Nichol & Dhariwal, 2021).

#### Additional Model Details

##### $(L)$DGN Architecture and Training

**Processor network**  
In Diffusion Graph Networks (DGN) and Latent Diffusion Graph Networks (LDGN), a multi-scale graph neural network (GNN) is employed at the core of the denoising transitions. The main building blocks are:

I. **Message passing** (edge update, node aggregation, node update). Each message-passing layer is defined as:

$$e_{ij} \leftarrow W_{e}\,e_{ij}+\mathrm{MLP}_e\Bigl(\mathrm{LN}[e_{ij}\,\Vert\,v_i\,\Vert\,v_j]\Bigr)$$

$$\overline{e}_j =\sum_{i\in \mathcal{N}(j)}e_{ij}$$

$$v_j \leftarrow W_{v}\,v_j+\mathrm{MLP}_v\Bigl(\mathrm{LN}[\overline{e}_j\,\Vert\,v_j]\Bigr)$$

where $W_e$ and $W_v$ are learnable linear transformations, $\mathrm{MLP}_e$ and $\mathrm{MLP}_v$ are 2-layer MLPs with hidden dimension $F_h$ and SELU activations, and $\mathrm{LN}$ is a Layer Normalization (Ba et al., 2016).

II. **Multi-scale GNN**  
A U-Net–like architecture (Ronneberger et al., 2015; Gao & Ji, 2019) is constructed over multiple coarsened versions of the input graph $\mathcal{G}$. At each scale, two message-passing layers are executed, followed by pooling of the node features to the next (lower) resolution. After reaching the lowest resolution, unpooling is performed back up to finer scales, with two message-passing layers per scale. This approach broadens the effective receptive field of the GNN, enabling the capture of both local and global correlations. (See Appendix B.3 for details.)

III. **Diffusion-step encoding**  
A diffusion-step embedding $\mathbf{r}_{\mathrm{emb}}\in\mathbb{R}^{F_{\mathrm{emb}}}$ is added to the node features to condition the denoising transitions on the current step $r$. A sinusoidal embedding (Vaswani et al., 2017) maps $r\mapsto \mathrm{SINEMB}(r)\in\mathbb{R}^{F_{\mathrm{emb}}}$, followed by a linear projection and an activation: $\mathbf{r}_{\mathrm{emb}}=\phi(\mathrm{LINEAR}[\mathrm{SINEMB}(r)])$. Then, $\mathrm{LINEAR}(\mathbf{r}_{\mathrm{emb}})$ is added to the node features at each step in the message-passing stack.

Hence, each forward pass $\bigl\{\mathbf{z}_r,\mathcal{G},\mathbf{V}^c,\mathbf{E}^c,r\bigr\}\mapsto \{\widehat{\boldsymbol{\epsilon}},\,v_\theta\}$ yields the predicted noise and variance-interpolation at each node.

**Training**  
All (L)DGNs are trained with the node-wise mean-squared error loss $\mathcal{L}_{\text{simple}}$, plus the variational bound $\mathcal{L}_{\text{vlb}}$ for variance learning (Nichol & Dhariwal, 2021); cf. Appendix A. Importance sampling is employed to reduce gradient noise. The learning rate is initialized to $10^{-4}$, decays by a factor of 10 when the training loss plateaus, and training continues until $10^{-8}$. At each epoch, one state is sampled from each training trajectory.

##### VGAE Architecture and Training

The Latent DGN (LDGN) relies on a **Variational Graph Auto-Encoder (VGAE)** to map physical states $\mathbf{Z}(t)$ to a lower-dimensional latent representation. Specifically,

- **Condition encoder** produces multi-scale encodings $\{\mathbf{V}^c_\ell,\,\mathbf{E}^c_\ell\}$ for $\ell\in[1\dots L]$, given the mesh node and edge features $\mathbf{V}^c,\mathbf{E}^c$. These encodings are used as conditioning in the node-encoder and node-decoder blocks below.
- **Node encoder** takes $\mathbf{Z}(t)$ along with the condition-encoder outputs, successively pools to coarser graphs, and outputs a latent distribution $\mathbf{\mu}_i,\mathbf{\sigma}_i$ at each node $i$ of the coarsest graph $\mathcal{G}_L$. A sample is then generated by computing $\boldsymbol{\zeta}_i = \mathbf{\mu}_i + \mathbf{\sigma}_i\,\boldsymbol{\epsilon}_i$ with $\boldsymbol{\epsilon}_i\sim\mathcal{N}(\mathbf{0},\mathbf{I})$.
- **Node decoder** expands these latent features up to the original mesh $\mathcal{G}_1$, returning reconstructed features $\mathbf{z}'_i$. Additionally, a skip connection from the condition encoder is employed.

The VGAE is trained by minimizing a reconstruction loss plus a low-weight KL penalty that enforces a standard normal prior on $\boldsymbol{\zeta}_i$:

$$\mathcal{L}_{\text{VGAE}}
=
\frac{1}{\lvert V\rvert}
\sum_{i\in V}\Bigl\|\mathbf{z}_i-\mathbf{z}'_i\Bigr\|_2^2
+\gamma\,\mathbb{E}\Bigl[\mathrm{KL}\Bigl(\mathcal{N}(\mathbf{\mu}_i,\mathbf{\sigma}_i)\,\Vert\,\mathcal{N}(\mathbf{0},\mathbf{I})\Bigr)\Bigr]$$

where $\gamma\ll1$ is determined by grid search.

During inference for the LDGN, the condition encoder first maps $\mathbf{V}^c,\mathbf{E}^c$ to coarse encodings $\{\mathbf{V}_\ell^c,\mathbf{E}_\ell^c\}$. The LDGN’s denoising steps operate in the coarsest latent graph, producing denoised $\boldsymbol{\zeta}_0$. Finally, the VGAE’s node decoder reconstructs $\mathbf{z}_0\in \mathbb{R}^{|V|\times F}$ in physical space.

##### Graph Pooling and Unpooling

To realize the multi-scale GNN architecture, the graph is repeatedly pooled to coarser levels $\{\mathcal{G}_\ell\}$ via node decimation. Guillard’s coarsening (Guillard, 1993) is adopted, which is a fast mesh-based approach commonly used in multi-grid CFD. For a mesh $\mathcal{G}_\ell$, a subset of nodes $\mathcal{G}_{\ell+1}\subset\mathcal{G}_\ell$ is constructed by iterating through nodes and marking neighbors for removal. Then each node $i$ in the original graph is assigned a single parent node $P_i$ in the coarser graph. Edges are created between coarse nodes if their children in the finer graph were linked.

**Graph pooling** from level $\ell$ to $\ell+1$ is carried out via message passing from each child node to its parent:

$$v_j^{(\ell+1)} =
\sum_{i\in \mathrm{Ch}_j}\mathrm{MLP}\Bigl(
\mathrm{LN}\Bigl[\mathrm{LINEAR}(x_i - x_j)\,\Vert\,v_i^{(\ell)}\Bigr]
\Bigr),\quad
\text{for each parent node }j\in V_{\ell+1}$$

**Graph unpooling** from $\ell$ to $\ell-1$ passes features back down from parent $P_i$ to each child $i$:

$$v_i^{(\ell-1)} \leftarrow
\mathrm{MLP}\Bigl(
\mathrm{LN}\Bigl[
\mathrm{LINEAR}(x_i - x_{P_i}),\,v_{P_i}^{(\ell)},\,v_i^{(\ell-1)}
\Bigr]\Bigr)$$

Edge features at each scale either originate from the coarser scale or are skip-connected from the encoder branch in a U-Net fashion.

##### Dirichlet Boundary Conditions

Some tasks (e.g., ELLIPSEFLOW) impose Dirichlet conditions on certain nodes—such as the inlet or walls with known velocity. To ensure that boundary constraints are satisfied exactly in the final sample, the diffusion transitions for boundary nodes are fixed as follows:

- In the forward/diffusion process, boundary nodes are not injected with random noise. Their states $\mathbf{v}_r$ are simply scaled by $\sqrt{\bar{\alpha}_r}\,\mathbf{v}_0$.
- In the backward/denoising process, boundary nodes are set via deterministic reverse transitions $\mathbf{v}_{r-1} = \tfrac{1}{\sqrt{\alpha_r}}\mathbf{v}_r$.

Thus, these node values remain consistent with the boundary conditions. For the LDGN and all baselines, boundary nodes’ predictions are simply overwritten with their known boundary values in the final step.

#### Experimental and Dataset Details

Three tasks are considered, each with a mesh-based discretization of fluid flow states:

I. **ELLIPSE**  

Pressure on a 1D boundary mesh around a 2D ellipse in laminar flow.  

- _Geometry & Data:_ 1D mesh along the ellipse boundary (70–80 nodes). Flow at Re=500–1000.  
- _Goal:_ Predict pressure $p_i$.  
- _Simulations:_ from Lino et al. (2022), partial dataset with 101 time-steps per ellipse.  
- _Training & Test splits:_ Table 2 in the main text.

II. **ELLIPSEFLOW**  

Velocity and pressure fields on a 2D mesh around an ellipse.  

- ~2,300 nodes.  
- More challenging due to the 2D flow field, vortex shedding, and multiple node types (inlet, wall, interior).  
- _Data Sources:_ The same data sources, domain parameters, and training/test splits as for ELLIPSE are used.

III. **WING**  

Pressure on a 2D surface mesh around a 3D wing in turbulent flow (Re~2×10^6).  

- ~6,800 nodes.  
- _Simulations:_ using Delayed Detached Eddy Simulation in OpenFOAM with standard turbulence modeling.  
- Each training wing has a few parameters (thickness, taper ratio, sweep angle, twist angle) randomly sampled; then a short (0.5s) snippet is simulated at 0.002s intervals (250 states). The test dataset uses 2,500 states.

### Condition Features

Each node or edge is provided with additional features encoding geometry and boundary conditions, summarized here:

| System          | Node conditions $v_i^c$                        | Edge conditions $e_{ij}^c$                                          | Predicted node output $z_i$  |
|-----------------|-------------------------------------------------|-------------------------------------------------------------------|------------------------------|
| **ELLIPSE**     | Reynolds number $\mathrm{Re}$; node type one-hot | Relative positions $(x_j - x_i)$; $\mathbf{u}_\infty\cdot\hat{t}_{ij}$ | Pressure $p_i$               |
| **ELLIPSEFLOW** | Reynolds number $\mathrm{Re}$; node type one-hot | Relative positions $(x_j - x_i)$                                  | Velocity $(u_i,v_i)$ & pressure $p_i$ |
| **WING**        | Outward normal $\hat{n}_i$ on the wing surface  | $(x_j - x_i,\, \mathbf{u}_\infty\cdot \hat{t}_{ij},\, \mathbf{u}_\infty\cdot \hat{n}_i,\,\mathbf{u}_\infty\cdot\hat{b}_{ij})$ | Pressure $p_i$               |

For ELLIPSEFLOW, Dirichlet conditions on the inlet and boundary nodes are also enforced as discussed (Appendix B.4).

#### Supplementary Results

Additional numerical results, ablation studies, and extended discussions are included below.

##### Performance and Speed

**Large 3D Wing Scenario**  
Table 10 in the main text compared the runtime of:

- **OpenFOAM** DES solver, limited to 8 CPU threads.  
- **DGN and LDGN** on CPU with 8 threads and on an RTX 3080 GPU.

A 2–3 order of magnitude speedup for multi-sample distribution estimation on the GPU was observed. For single-sample generation, the speedup is 4–5 orders of magnitude. Table 10 in the main text also shows that the LDGN outperforms the DGN by ~8× in sample generation speed, owing to denoising in a compressed latent space.

##### Influence of the Number of Scales in DGN

A key distinction in the approach is the use of a **multi-scale** GNN to capture both global and local correlations. Single-scale GNN-based diffusion typically struggles on large graphs because message passing alone may not propagate long-range signals effectively within the limited number of diffusion steps. (See Appendix B.3 for details of the multi-scale approach.)

A test was conducted using a single-scale DGN with the **same** number of message-passing layers, while ignoring coarse graphs. For ELLIPSE (∼70 nodes), performance was much worse. For ELLIPSEFLOW (∼2,300 nodes) and WING (∼6,800 nodes), the single-scale DGN failed entirely, producing near-random fields. Conversely, multi-scale DGNs with 4–5 scales succeeded (see Figure 15 and Table 11 in the PDF for details).

###### An Alternative VGAE Architecture for LDGN

The VGAE architecture (Section 3.2) includes a **condition encoder** that produces coarse-scale encodings $\{\mathbf{V}_\ell^c, \mathbf{E}_\ell^c\}$ required by the LDGN. An alternative, simpler approach that bypasses the condition encoder and directly assigns node/edge features in the coarsest latent graph was also considered; however, this discards high-frequency boundary details. In Tables 12–13 of the PDF, the alternative approach yielded worse performance in the ELLIPSE tasks, confirming the importance of a dedicated condition encoder.

###### High-Frequency Noise Analysis

An examination was conducted to determine whether DGNs or LDGNs exhibit spurious high-frequency noise in samples. Specifically, the top 10 graph Fourier modes in ELLIPSEFLOW and WING predictions were extracted and their energy compared to that of the ground truth. The LDGN exhibited only approximately 1–3× difference, while the DGN showed up to an 8× difference, indicating significantly more high-frequency error (see Table 14 in the PDF). This demonstrates that denoising in latent space (LDGN) better avoids unwanted high-frequency artifacts.

###### Efficiency in Using Training Trajectories

A highlight of the approach is the ability to learn full distributions from **short** partial trajectories across many systems. A study was performed to evaluate how performance scales with the number of short trajectories in ELLIPSE. In Figure 16 (PDF), both DGN and LDGN steadily improved distributional accuracy as more training examples were provided. In contrast, standard baselines (VGAE or GM-GNN) plateaued or degraded quickly, lacking the ability to interpolate among partial distributions effectively. This underscores the unique advantage of diffusion-based models in discovering shared patterns across systems and extrapolating beyond each partial trajectory.

###### Flow Statistics Derived from the Learned Distributions

Beyond generating random snapshots, flow statistics (e.g. mean flow, RMS, TKE, etc.) can be derived from the learned distributions. A comparison was made between:

- **Mean-Flow GNN**: a deterministic GNN trained directly on 10-step–averaged fields.  
- **Vanilla GNN**: a single-state deterministic GNN trained on the short 10-step data (Section B.5).  
- **(L)DGN**: where the mean is derived by averaging 200 samples from the learned distribution.

On ELLIPSEFLOW, the LDGN produced more accurate mean-flow fields than the baselines (see Table 15 in the PDF and Figure 17). Additionally, TKE predictions (Table 16) demonstrated that the LDGN again outperformed other methods, confirming that capturing the full distribution best recovers advanced flow statistics.

###### Faster Sampling with Flow Matching

DDPM sampling typically requires tens or hundreds of steps, which can be expensive for large domains. **Flow matching** (Lipman et al., 2023) provides an alternative that can reduce the number of denoising steps—sometimes to $\lesssim10$—albeit at the cost of lower final accuracy if many steps are allowed.

A flow-matching version of DGN (FM-GNN) and of LDGN (LFM-GNN) was tested. For very few steps ($\lesssim10$), these variants outperformed the standard (L)DGN, but for 20+ steps, diffusion-based models were superior (see Figure 19 in the PDF for details). It is believed that hybrid or advanced flow-matching methods might further improve speed and accuracy, an exciting direction for future work.
