## The Unreasonable Ineffectiveness of the Deeper Layers

### Links

* https://arxiv.org/abs/2403.17887

### Notes

- The study empirically examines a layer-pruning strategy for popular families of open-weight pretrained Large Language Models (LLMs).
- Minimal performance degradation occurs on various question-answering benchmarks until up to half of the model layers are removed.
- The pruning method identifies the optimal block of layers to prune by assessing similarity across layers.
- After pruning, a small amount of finetuning is performed to "heal" the model.
- Parameter-Efficient Finetuning (PEFT) methods used include quantization and Low Rank Adapters (QLoRA).
- Each experiment was conducted on a single A100 GPU.
- Layer pruning can complement other PEFT strategies to further reduce computational resources required for finetuning.
- Layer pruning can also improve the memory footprint and latency of inference.
- The robustness of LLMs to layer deletion suggests that current pretraining methods may not fully utilize parameters in deeper layers.
- Alternatively, shallow layers may play a critical role in storing knowledge within LLMs.
- The introduction highlights the evolution of LLMs from research artifacts to useful products due to increased training resources.
- Most of an LLM's lifetime FLOPs occur during inference after training.
- Efficient training of LLMs requires both compute-optimal training and inference awareness.
- Post-training techniques to reduce finetuning and inference costs include quantization, LoRA, and pruning.
- These post-training strategies are largely orthogonal and can be combined for greater efficiency.
- QLoRA enables 4-bit quantization of parameters and LoRA finetuning to work together effectively.
- The main result shows that up to roughly half of the deepest layers in models like Llama-2-70B can be removed before performance significantly degrades.
- Pruning not only reduces the model's footprint but also aids in understanding parameter utilization within the network.
- The residual structure of transformer architectures suggests that slowly changing representations across layers allow for effective pruning.
- Deleting shallow layers has a greater impact on performance than deleting deeper layers.
- The study formulates three hypotheses regarding the feasibility and effectiveness of layer pruning in residual networks.
- The principal layer-pruning algorithm involves selecting a number of layers to prune, computing angular distances, identifying optimal layers to prune, and optionally healing the model.
- Angular distance is calculated using the arccosine of the normalized dot product between layer representations.
- Healing involves finetuning the pruned model using QLoRA on a neutral pretraining dataset.
- An alternative simpler pruning strategy involves removing the deepest layers excluding the final layer and then healing.
- Experiments were conducted on models ranging from 2.7B to 70B parameters across families including Llama-2, Qwen, Mistral-7B, and Phi-2.
- Finetuning was performed using the Hugging Face Trainer API with specific configurations for each model.
- Evaluations were conducted using MMLU, BoolQ, and C4 Validation Loss benchmarks.
- MMLU accuracy remains robust until 20%-55% of layers are pruned, depending on the model family and size.
- Healing with finetuning modestly improves performance and delays the transition to random guessing.
- Larger and deeper models exhibit greater robustness to pruning compared to smaller models.
- Deeper layers in models show higher similarity, facilitating easier pruning.
- The Qwen family displays unique similarity patterns with "islands" of high similarity in shallow layers.
- Simple pruning strategies, such as removing the deepest layers, perform comparably to similarity-informed pruning after healing.
- Healing restores next-token prediction loss to near-unpruned levels while maintaining sharp transitions in QA performance.
- Ablation studies show that varying the order and number of few-shot examples does not significantly impact pruning robustness.
- Changing the finetuning seed does not meaningfully affect pruning robustness.
- Lowering the LoRA rank generally improves MMLU accuracy but worsens C4 validation loss, indicating potential overfitting at higher ranks.
- The study raises questions about developing better pruning and healing strategies and understanding the differential impact on various performance metrics.
- Future directions include exploring task-specific degradation, knowledge localization within model layers, and enhancing pretraining methods to better utilize deeper layers.
- The research demonstrates that significant pruning of deeper layers in LLMs can be achieved with minimal impact on downstream QA tasks.
- Finetuning can effectively heal pruned models, maintaining performance up to critical pruning thresholds.
- The findings suggest that shallow layers may be more critical for storing knowledge in LLMs.
- Combining layer pruning with quantization and PEFT methods offers substantial efficiency gains for running and finetuning large models on consumer-level GPUs.
  
