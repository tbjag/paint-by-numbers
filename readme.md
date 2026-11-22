# paint by numbers

- https://github.com/drakarah/paintbynumbersgenerator/tree/master
- https://discourse.mcneel.com/t/create-a-paint-by-numbers-script/147595/3

1. README.md: explains every setting (k-means colors, minimum facet size, border smoothing, and so on). Read this first to learn the vocabulary.
2. src/guiprocessmanager.ts: the process() method (about lines 20–100) is the whole pipeline in order. It's the best map of what happens to the image.
3. Then the stage files, in the order process() calls them:
   - colorreductionmanagement.ts: k-means clustering reduces the image to N colors, then builds a color-index map and removes narrow pixel strips.
   - facetCreator.ts: flood-fills regions of the same color into "facets" (each one a region to paint).
   - facetReducer.ts: merges tiny facets into their neighbors so the result is paintable.
   - facetBorderTracer.ts: traces the outline of each facet.
   - facetBorderSegmenterments shared between neighboring facets, then smooths them.
   - facetLabelPlacer.ts:r label goes inside afacet.
4. src/facetmanagement.ts and src/structs/: the data types (Facet, FacetResult, Point, and so on) the stages pass around.
5. src/gui.ts and src-cli/main.ts: where the final SVG is drawn from the facets. The CLI version is simpler to read than the GUI.

Two pieces of background help with the middle stages:
- k-means clustering (color quantization).
- Flood fill and connected components, for the facet building.



## todos
- find logging library
- do we need to defer images/data if we have pulled everything out of it?
- automatic conversion using ffmpeg or something if raylib cant parse the image

## etc
i get a color map results
imgColor indices which is a 2D array of uints
and colors by index which is an rgb[]
im assuming they map where the number in the 2d array maps to a color on the index
poor mans hashmap?

for N number of pixel clean up runs:
	run pixel cleanup
	builds facets // i dont know if these are needed
	reduces facets // ^^

pixel cleanup function:
	create a color matrix - 2D array of rgb index, go through each one and find the distance between each point
	get surrounding and current pixel (top bottom left right)
	if all are the same as curr pixel do nothing
	if top and bottom are the same
		get color distance between curr and top/bottom
		colorDistances[cur][top];
		set current pixel to whatever has the lowest distance
	else if left/right same as curr
		do the same as top/bottom
	whats interesting is that its else if so only one of the cleanups happens

then build facets & reduce facets once after that

build_facets:

reduct_facets: