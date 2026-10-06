## Learning multiple layers of representation. Trends in cognitive sciences

### Links

* https://www.sciencedirect.com/science/article/pii/S1364661307002173?casa_token=3NmJWPX07FMAAAAA:oewEfz0g-5b0zl75B4uJmxY-ZhJhLFBchhaRrs9RxkttMw1vuocghaMJHjMLEV1SFUTNKnkv

### Notes

#### Summary

Hinton reviews the motivation for learning **multiple hierarchical levels of representation** and the then-recent advances that made training deep generative networks practical.

#### Key ideas

* Perception appears hierarchical: simple sensory features are transformed into increasingly abstract representations.
* Back-propagation provided an efficient way to train multi-layer networks, but deep networks were historically difficult to optimize and often depended on labeled data.
* Generative models provide an alternative learning signal by trying to model or reconstruct the sensory input itself.
* Restricted Boltzmann machines can be trained one layer at a time and stacked into deeper models.
* Greedy unsupervised layer-wise learning gives each layer a useful initialization before global fine-tuning.
* Higher layers can capture more abstract factors while lower layers represent local or low-level structure.
* Top-down generative connections also allow the model to explain sensory observations rather than only classify them.

#### Historical context

The paper captures the period just before the modern deep-learning boom, when unsupervised pre-training was a major technique for making deep networks trainable.

#### Takeaway

Useful abstractions can emerge by composing several learned representation layers. Depth matters because each layer can transform the representation into a form that makes higher-level structure easier to model.
