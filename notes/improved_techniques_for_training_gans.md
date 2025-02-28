## Improved Techniques for Training GANs

### Links

* https://arxiv.org/pdf/1606.03498v1.pdf

### Notes

**Goal:** Present new training procedures and architectural features to improve Generative Adversarial Networks (GANs) in two main contexts:

I. **Semi-supervised learning**: Use unlabeled data (plus a small amount of labeled data) to improve classification accuracy.

II. **High-quality image generation**: Produce visually realistic samples that humans find difficult to distinguish from real data.

**Context:**  

- GANs often suffer from *instabilities* (training may fail to converge).  
- There is *no explicit likelihood function* to measure progress, making models hard to evaluate.  
- Prior functions (e.g., DCGAN) show promise in generating plausible images but still face challenges like mode collapse and training instability.

#### Core Techniques for Stabilizing GAN Training

The authors propose several techniques to address the challenges of convergence and mode collapse. Each is intended to modify either the generator’s or the discriminator’s objective/architecture to yield more stable training dynamics.

##### Feature Matching

- **What It Is:**  
- A new objective for the generator that focuses on *matching certain statistics* of real data rather than directly fooling the discriminator on every update.
- **How It Functions:**  
- Let $f(x)$ denote the activations (features) at an intermediate layer of the discriminator.  
- Rather than maximize $\log D(x)$ or $\log(1 - D(x))$, the generator is trained to *match the expected value* of these discriminator features for real data vs. generated data.  
- Formally, the generator is updated to minimize the squared distance:
- 
$$\| \mathbb{E}_{x \sim p_{\text{data}}} [f(x)] - \mathbb{E}_{z \sim p_{z}} [f(G(z))] \|^2$$

**Benefits:**  

I. Reduces the generator’s overreliance on the current discriminator.  

II. Helps avoid the scenario where the generator “chases” short-lived signals.  

III. Empirically stabilizes training and can boost performance, especially in *semi-supervised classification* setups.

###### Minibatch Discrimination

- **Motivation:**  
- Standard GAN discriminators treat each sample independently, which can allow the generator to collapse to a single or few “modes” (mode collapse).  
- The discriminator should detect if multiple generated samples are too similar.
- **How It Functions:**  
- Introduces a “minibatch layer” in the discriminator to compare each sample $x_i$ not just in isolation but also *against other samples in the minibatch*.  
- One approach (proposed in the paper) uses a learned function to measure distance among features of each pair $(x_i, x_j)$.  
- For each sample, a set of *minibatch features* $\{c_b(x_i, x_j)\}$ is computed, then aggregated and concatenated with the sample’s original discriminator features.  
- This helps the discriminator penalize the generator for producing many identical (or near-identical) outputs within a minibatch.
- **Benefits:**  

I. Dramatically reduces mode collapse by encouraging sample diversity.  

II. Produces *visually appealing samples* for many datasets (e.g., MNIST, CIFAR-10).  

III. Often the quickest route to stable, high-quality generation in purely *unsupervised* or fully supervised contexts.

##### Historical Averaging

- **Concept:**  
- Motivated by the idea of “fictitious play” in game theory, the method penalizes large parameter deviations from the historical average of past parameter values.  
- **Implementation:**  
- Adds a penalty term $\|\theta - \frac{1}{t}\sum_{i=1}^{t} \theta^{[i]}\|$ to the cost, where $\theta^{[i]}$ is the parameter vector at the $i$-th iteration.  
- The sum can be maintained *online*, so it scales to large training runs.  
- **Intuition:**  

I. Encourages the model to stay near parameter configurations that have proven stable so far.  

II. Can help break cyclical or oscillatory training behaviors typical of adversarial setups.

##### One-Sided Label Smoothing

- **Basic Idea:**  
- Instead of training the discriminator with targets 0 (fake) and 1 (real), replace the real label “1” with a constant < 1 (e.g., 0.9).  
- Fake labels remain 0.  
- **Why Only One-Sided?:**  
- If *both* real and fake labels are smoothed, then in regions where the real-data distribution is nearly zero and the model distribution is large, the generator might exploit the label smoothing incorrectly.  
- Keeping the fake label as 0 makes sure that the discriminator does not become too permissive on fake samples.  
- **Benefits:**  

I. Reduces the discriminator’s overconfidence in real vs. generated classification.  

II. Empirically mitigates training instabilities and can reduce vulnerability to adversarial gradients.

##### Virtual Batch Normalization (VBN)

- **Problem with Standard Batch Normalization:**  
- BN depends on the statistics of the current minibatch, coupling samples together in ways that sometimes harm the stability in GANs (since generator updates can drastically shift data distributions).  
- **Proposed Solution:**  
- Keep a *fixed reference batch* of data from the start of training.  
- Each new sample is normalized using the combination of the reference batch’s statistics plus that sample’s own contribution (not the current minibatch).  
- **Implementation Details:**  
- The reference batch is set once and does not change.  
- The generator’s forward pass is done twice: once for the reference batch and once for the actual minibatch.  
- **Benefits:**  

I. Decouples the normalization of new samples from the rest of the minibatch, improving stability.  

II. Particularly helpful in large-scale or high-resolution tasks (e.g., ImageNet at 128×128).

#### Evaluation Methods

The paper emphasizes that standard GAN training lacks a straightforward likelihood metric. They propose two main approaches to evaluate generated images.

##### Human Evaluation (Visual Turing Test)

- **Setup:**  
- Display real and generated images side by side via Amazon Mechanical Turk (MTurk).  
- Annotators pick which they believe is real.  
- A 50% success rate means perfect “fooling” (i.e., images are indistinguishable from real).
- **Caveats:**  
- Results can vary with instructions, annotator skill, or feedback on correctness.  
- Observed that *adversarial feedback* can dramatically reduce how easily workers are fooled.

##### Inception Score (Automated Metric)

- **Rationale:**  
- A good image has a low-entropy class distribution $p(y|x)$, meaning it contains a recognizable object (sharp predictions in label space).  
- The *overall* set of generated images has a *high-entropy* marginal distribution $\int p(y|x) p(x)dx$, indicating diverse categories.  
- **Definition:**  

$$\exp \Bigl(\mathbb{E}_x \bigl[ KL\bigl( p(y|x) ,\|, p(y)\bigr)\bigr]\Bigr)$$

- A higher value is better, meaning that on average each sample yields a confident label *and* the distribution of labels across all samples is broad.  
- Uses a pretrained Inception network on the generated images.

#### Semi-Supervised Learning Approach

GANs are adapted to the semi-supervised regime by extending the discriminator to predict *K+1* classes:

- **K real classes** (e.g., digits 0–9 in MNIST) plus  
- **1 “fake” class** for generated images.

##### Loss Function

**Classifier training objective:**

$$L_{\text{total}} = L_{\text{supervised}} + L_{\text{unsupervised}}$$

- $L_{\text{supervised}}$ is the standard cross-entropy on the labeled portion.  
- $L_{\text{unsupervised}}$ treats unlabeled real samples as “one of the K real classes,” while generated samples feed into the “fake” class.  
- **Generator training:**  
- Minimizes the usual GAN objective, but crucially the generator may also incorporate *feature matching* or *other stabilizing techniques*.  
- The generator is thus forced to produce samples that the classifier sees as *some* real class or else classifies them as fake.

##### Empirical Advantages

- **Improved classifier accuracy:**  
- The unsupervised term helps shape the discriminator’s boundaries.  
- Achieves *state-of-the-art or near-SOTA* on MNIST, CIFAR-10, and SVHN with small labeled subsets.  
- **Enhanced sample quality:**  
- Not just about classification: when the discriminator must classify images into K real classes, it picks up features that humans also interpret as indicative of object identity.  
- In effect, the generator is guided to produce images with recognizable objects.

#### Experimental Results

The authors tested their methods on several datasets to demonstrate improvements both in classification accuracy (semi-supervised) and sample quality.

##### MNIST

- **Setup:**  
- 60,000 total images of handwritten digits.  
- Labeled subsets of size 20, 50, 100, or 200.  
- Remaining images used without labels.  
- 5-layer fully connected or small convolutional networks, with weight normalization and noise in the discriminator.
- **Semi-supervised performance:**  
- Surpasses or matches prior approaches; best error rates around ~0.8–0.9% with 200 labeled examples.  
- Additional ensemble averaging further reduces classification errors.
- **Generated samples:**  
- With *feature matching* in the objective, the generated images look somewhat less crisp.  
- With *minibatch discrimination,* they look identical to real MNIST digits by human inspection (reaching ~50% confusion on MTurk).

###### CIFAR-10

- **Dataset:** 32×32 color images, 10 classes, 50,000 training and 10,000 test.  
- **Semi-supervised setting:**  
- Use only 1k, 2k, 4k, or 8k labeled samples; the rest unlabeled.  
- Achieves strong performance, e.g. ~18% to ~14% test error, improving on or comparable to advanced baseline models like CatGAN or Ladder networks.  
- **Image generation:**  
- *Minibatch discrimination* helps produce more visually varied samples.  
- The best samples approach 78–80% “fooling” on MTurk but not perfect—some artifacts remain.  
- The authors also measure the *Inception score,* showing that adding these stabilizing techniques (label smoothing, VBN, etc.) significantly boosts the score.

###### SVHN

- **Dataset:** Street View House Numbers with 32×32 color images (digits 0–9).  
- **Results:**  
- Similar approach (semi-supervised with K+1 classes).  
- Achieves excellent error rates (down to 5.8–6.2% test error), improving on prior state-of-the-art.

### 5.4 ImageNet at 128×128

- **Challenge:**  
- 1.2 million images, 1,000 object classes, high resolution.  
- Standard DCGANs often do not produce coherent objects for large-scale data.  
- **Outcome with proposed methods:**  
- The generator produces *animal-like shapes* (e.g., fur, eyes, and partial features).  
- Still not anatomically correct or perfectly realistic, but a notable improvement over plain DCGAN.  
- VBN in the generator is particularly important for stability.

#### Observations and Conclusions

**Training Stability:**  

I. *Feature matching* helps produce stable *semi-supervised* classifiers but yields slightly less realistic images.  

II. *Minibatch discrimination* greatly improves sample variety and realism.  

III. *Label smoothing,* *virtual batch normalization,* and *historical averaging* all contribute to more strong convergence.

**Semi-Supervised Superiority:**  

I. State-of-the-art or near-SOTA accuracy on MNIST, CIFAR-10, and SVHN with limited labels.  

II. Generator and discriminator synergy helps the classifier shape “object-like” features in generated images.

**Evaluation:**  

I. *Human-based* Turing tests remain the gold standard but can be subjective and vary by instructions.  

II. The proposed *Inception score* automatically evaluates both *sample diversity* and *per-image class confidence.*  

III. Additional scores or tests could further refine the notion of “visual fidelity.”

**Large-Scale Generation (ImageNet):**  

- The advanced techniques yield partial success in recognizable objects, but generating fully coherent, large-scale images with complicated backgrounds and details remains challenging.

**Future Directions:**  

I. Formalize theoretical underpinnings: better mathematical understanding of how these techniques encourage equilibrium.  

II. Explore *transfer learning* aspects, e.g., how labeling helps shape the generator’s representation.  

III. Scale up to higher resolutions and more complicated real-world tasks beyond just classification.
