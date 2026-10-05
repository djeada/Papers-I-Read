## Mastering the Game of Go without Human Knowledge

### Links

* https://youtu.be/_x9bXso3wo4
* https://discovery.ucl.ac.uk/id/eprint/10045895/1/agz_unformatted_nature.pdf

### Notes

#### Summary

AlphaGo Zero learns Go from the game rules and self-play, without training on human games. A neural network and Monte Carlo Tree Search (MCTS) improve each other in a repeated loop until the system reaches superhuman strength.

#### Learning loop

* The current neural network guides MCTS during self-play.
* Search produces a stronger move distribution than the raw network policy.
* Completed games provide the final win/loss outcome.
* The network is trained to predict both the search-improved move distribution and the game outcome.
* The improved network then guides stronger searches and generates stronger self-play data.

#### Key ideas

* A single network produces both a **policy** over moves and a **value** estimating the probability of winning.
* MCTS combines the network's priors and value estimates with explicit lookahead.
* There is no supervised pretraining from expert games.
* The system can discover strong strategies through reinforcement learning rather than imitation.
* The result demonstrates how search and learned evaluation can form a powerful closed improvement loop.

#### Takeaway

AlphaGo Zero's central lesson is that a system can bootstrap high-level strategy from self-play when learning and search are tightly coupled and the environment supplies a clear objective.
