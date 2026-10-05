## Large-scale cluster management at Google with Borg

### Links

* https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43438.pdf

### Notes

#### Summary

Borg is Google's cluster manager for running large numbers of long-lived services and batch jobs across clusters containing thousands of machines. It combines scheduling, resource allocation, failure recovery, monitoring, and isolation so application teams do not have to manage individual machines.

#### Key ideas

* Users submit **jobs**, each made of one or more **tasks**.
* A Borg **cell** is a group of machines managed as one scheduling domain.
* The Borgmaster maintains cluster state and makes scheduling decisions; per-machine Borglets start, stop, and monitor tasks.
* Resource requests, priorities, quotas, admission control, and preemption let interactive services coexist with batch workloads.
* Borg improves utilization through task packing, machine sharing, and controlled overcommitment.
* Failed tasks are restarted automatically, and scheduling policies try to avoid correlated failures.
* Declarative configuration, naming, monitoring, and debugging tools are part of the platform, not afterthoughts.
* The paper emphasizes lessons from years of production operation, including the importance of hiding machine-level failure from applications.

#### Takeaway

Borg treats a datacenter as a shared computer. Its value comes from turning unreliable individual machines into a higher-level execution environment with scheduling and reliability guarantees.
