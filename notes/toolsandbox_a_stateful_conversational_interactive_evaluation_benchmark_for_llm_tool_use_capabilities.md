## ToolSandbox: A Stateful, Conversational, Interactive Evaluation Benchmark for LLM Tool Use Capabilities

### Links

* https://arxiv.org/pdf/2408.04682

### Notes

#### Summary

ToolSandbox is a benchmark for evaluating language models that use tools in **stateful, multi-turn, interactive environments**. It is designed to expose failures that are hidden by simpler benchmarks where every API call is independent and the correct tool sequence is fixed in advance.

#### Key ideas

* Tool calls change an environment whose state persists across turns.
* Later actions may depend implicitly on earlier tool results or side effects.
* A built-in user simulator enables on-policy interaction rather than scoring only a prerecorded conversation.
* Evaluation checks intermediate and final **milestones**, allowing multiple valid trajectories to solve the same task.
* The benchmark includes cases where models must resolve canonical forms, reason about state dependencies, or recognize that required information is missing.
* Success therefore requires more than choosing the right API name: the model must track state, ask for information when necessary, recover from intermediate outcomes, and sequence actions correctly.

#### Findings

The authors report a substantial gap between models and show that even strong systems struggle on more complicated state-dependent scenarios.

#### Takeaway

Real tool use is an interactive control problem, not a static function-calling quiz. A useful benchmark must evaluate what happens **after** each action and whether the model adapts its next step to the resulting state.
