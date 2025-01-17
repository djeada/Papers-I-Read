## Early Visual Concept Learning with Unsupervised Deep Learning

### Links

* http://arxiv.org/pdf/1606.05579v1.pdf

### Notes

* Looks at disantagleing variables of the learned latent space of variational autoencoders. Often times in varaitional autoencoders some of the variables tend to never be used. This is sometimes called the componet collapse problem. Before I read this paper I thought this was a undisirable trait however they argue that it is adventagous in some tasks because it builds better more independent features. They report a trade off between reconstruction accuracy and ability to disantagle variables. Their whole approach reliys on a tempeture coefficient Beta on the VAE loss.
