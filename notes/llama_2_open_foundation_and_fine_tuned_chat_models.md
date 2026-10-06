## Llama 2 Open Foundation and Fine-Tuned Chat Models

### Links

* https://arxiv.org/abs/2307.09288

### Notes

#### Summary

Llama 2 is a family of pretrained and chat-oriented large language models released by Meta, with model sizes ranging from 7B to 70B parameters. The report focuses not only on pre-training but also on the post-training process used to turn a base language model into a helpful and safer conversational assistant.

#### Key ideas

* The base models are autoregressive transformers pretrained on a large corpus of publicly available text.
* Llama 2-Chat models are produced through supervised fine-tuning followed by reinforcement learning from human feedback.
* Human preference data is used to improve both helpfulness and safety.
* The post-training process includes iterative preference collection and model improvement rather than a single fine-tuning pass.
* Safety work includes adversarial testing, targeted data collection, safety-specific reward modeling, and extensive evaluation.
* The report compares the models with contemporary open and closed chat systems using automatic benchmarks and human judgments.
* It also documents limitations, risks, and intended-use considerations.

#### Takeaway

The report makes clear that a capable chat model is not just a pretrained transformer. Much of the user-facing behavior comes from the post-training loop: supervised examples, preference feedback, reward models, safety tuning, and repeated evaluation.
