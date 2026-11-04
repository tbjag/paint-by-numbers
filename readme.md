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