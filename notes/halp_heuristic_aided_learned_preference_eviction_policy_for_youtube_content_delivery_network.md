## HALP: Heuristic Aided Learned Preference Eviction Policy for YouTube Content Delivery Network

### Links

* https://www.usenix.org/system/files/nsdi23-song-zhenyu.pdf

### Notes

#### Summary

HALP is a production cache-eviction policy for YouTube's CDN that combines a conventional heuristic with a learned preference model. The goal is to obtain the benefits of machine learning without making cache management too expensive or fragile for production use.

#### Challenges

The authors identify three practical obstacles to deploying learned cache policies:

* inference and training overhead can consume too much CPU,
* an algorithm must improve **byte miss ratio** robustly rather than only look good in simulation,
* real production traffic is noisy, making small improvements difficult to measure reliably.

#### Approach

* A fast heuristic narrows the eviction decision to a manageable set of candidates.
* A learned model ranks or compares those candidates using signals related to future cache value.
* This hybrid design limits ML computation while preserving much of the quality improvement.
* The paper also introduces **impact distribution analysis** for measuring deployment effects under production noise.

#### Result

HALP was deployed in YouTube's DRAM cache layer and reported roughly a 9.1% reduction in peak byte misses for about 1.8% additional CPU overhead.

#### Takeaway

The paper is a strong example of production ML engineering: the winning solution is not "replace the heuristic with a neural network," but use learning exactly where it adds enough value to justify its operational cost.
