## Machine Learning The High Interest Credit Card

### Links

* https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43146.pdf

### Notes

#### Summary

This paper argues that machine learning can create **technical debt** unusually quickly. A model may be easy to train and deploy, yet the surrounding production system can accumulate hidden dependencies and maintenance costs that compound over time.

#### Sources of ML technical debt

* **Entanglement:** changing one input feature or model component can alter behavior elsewhere because learned parameters interact.
* **Correction cascades:** teams may stack new models on top of earlier model outputs instead of fixing the original system.
* **Undeclared consumers:** other systems may begin depending on a prediction without the model owners knowing.
* **Data dependencies:** unstable, duplicated, legacy, or poorly understood features become long-lived interfaces.
* **Hidden feedback loops:** model predictions can change the future data on which later versions are trained.
* **Changes in the external world:** even unchanged code can degrade when users, markets, sensors, or upstream systems change.
* **Glue code and pipeline jungles:** the model itself can become a small fraction of a large and fragile production stack.

#### Engineering lesson

Model quality should not be evaluated separately from the cost of operating, debugging, retraining, monitoring, and evolving the complete system.

#### Takeaway

Machine learning makes it easy to borrow engineering complexity from the future. A small accuracy improvement may not be worth it if it creates brittle dependencies, opaque feedback loops, or permanent operational cost.
