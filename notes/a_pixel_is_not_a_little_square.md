## A Pixel Is Not a Little Square!

### Links

* https://www.cs.princeton.edu/courses/archive/fall00/cs426/papers/smith95b.pdf

### Notes

#### Summary

A pixel is a **point sample**, not a tiny geometric square. The square-looking blocks we often associate with pixels come from a particular reconstruction choice—usually a box filter—or from nearest-neighbor magnification. Confusing the sample with the area used to reconstruct or display it leads to incorrect reasoning about image coordinates, scaling, filtering, and resampling.

#### Key ideas

* A digital image is a rectangular array of samples taken from an underlying continuous image.
* To turn those samples back into a continuous image, a **reconstruction filter** is required.
* Different filters have different spatial footprints. Good reconstruction filters generally overlap neighboring samples, so there is no unique square area that belongs to a pixel.
* The familiar "little square" picture corresponds to a box-filter approximation. It is valid in some applications, but it is only one model—not the definition of a pixel.
* Zooming an image until it looks blocky does not reveal the physical shape of a pixel; it usually means each sample has been replicated into many display samples.
* Image boundaries and coordinate conventions depend on the reconstruction model. Treating pixel centers and pixel edges as universal geometric facts can create half-pixel and resampling errors.
* The same argument applies in 3D: a voxel is a sample, not inherently a little cube.

#### Takeaway

Keep **samples**, **reconstruction filters**, and **display geometry** conceptually separate. A square is sometimes a convenient model for a pixel's influence, but the pixel itself is the sample value at a point.
