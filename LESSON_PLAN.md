# Paint by Numbers in Rust — Lesson Plan

Goal: learn Rust well enough to write it on my own with only basic internet resources, by porting
the TypeScript generator (`~/workspace/paintbynumbersgenerator`) to Rust. Not aiming for the most
idiomatic Rust on the first pass. Get it working, then refactor.

Method (from [amosblomqvist/learn](https://github.com/amosblomqvist/learn)'s teach skill):

1. **Probe**: quizzes find the edge of what I know for each module's prerequisites.
2. **Teach**: for each concept, why it's needed, what it is, how it maps to Go/Python/Odin, then a quiz.
3. **Build**: I write all the Rust. AI explains compiler errors and asks leading questions only.
4. **Checkpoint**: every milestone writes a debug PNG plus `#[test]`s on tiny hand-made grids.

## Independence habits

- Read the whole compiler error before doing anything.
- `rustc --explain E0XXX` for any error code.
- `cargo doc --open` for offline docs of my crate and its dependencies.
- docs.rs / std docs before asking AI.
- `cargo clippy` once it compiles.
- References: [The Rust Book](https://doc.rust-lang.org/book/), [Rust by Example](https://doc.rust-lang.org/rust-by-example/), [std docs](https://doc.rust-lang.org/std/).

## Odin progress (`archive/`)

| TS stage | Odin status |
|---|---|
| Load image, convert to RGB | ✅ Done (raylib) |
| Bit-chop preprocessing | ✅ Done |
| k-means | ✅ Works. No fixed random seed; runs over every pixel instead of unique colors weighted by count (slow) |
| Color map (`colorsByIndex` + color-index grid) | ❌ Pixels overwritten with centroid colors, so palette indices are lost |
| Facet building | 🟡 ~65%: all facets, pixel count, deduped border points. Missing pixel→facet map, bbox, neighbours, returning facets |
| Narrow-strip cleanup, facet reduction, border tracing, segmenting, labels, SVG | ❌ Not started |

Notes on `archive/fill.odin` to keep in mind when porting:

1. **Defer order frees memory too early.** Defers run last-in-first-out, so `delete(facets)` runs before
   the block that loops over `facets` to free each `border_points`, which then reads freed memory.
   In Rust, Drop handles this automatically and in the right order.
2. **Seeding the next facet is O(n²).** `slice.all_of(seen, true)` plus a rescan from index 0 for every facet.
   TS walks every pixel once: `for each (x, y): if !visited → build_facet`.
3. **Facets are thrown away.** They're freed when `create_facets` returns. Later stages need a returned
   `FacetResult` with a `facet_map` (each pixel's facet ID) for neighbours, reduction and tracing.
4. **Dead check.** `if pixels[curr_index] != curr_color do continue` never triggers, because only
   same-color neighbours are pushed.

## Milestones

- [x] **M0: Setup and image I/O.** (done 2026-11-10: output pixel-identical to input, built from `Vec<Rgb>`) CLI arg, load with the `image` crate, print dimensions, save a copy.
  - Done when `cargo run -- images/testinput.png` writes `out.png`.
  - Concepts: cargo/crates, `Result` and `?`, `Vec`, `as` casts, Drop vs `defer`.
  - Reading: Book ch. 1–3, 9.
- [ ] **M1: k-means.** `Rgb` struct, bit chop, distance, step/run, seeded RNG (port `src/random.ts`).
  - Done when the quantized PNG matches the Odin output. Then switch to unique colors weighted by count, as TS does.
  - Concepts: `&[T]` vs `&mut [T]`, ownership, `#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug)]`, `mod` files, `HashMap`, `--release`.
  - Reading: Book ch. 4, 5, 7, 8.
- [ ] **M2: Color map.** `colors_by_index: Vec<Rgb>` plus a `Grid<u8>` of indices; facets compare a `u8` index, not an `Rgb`.
  - Done when the index grid renders back to the same PNG.
  - Concepts: generics (`struct Grid<T>`), `impl` blocks, maybe the `Index` trait.
  - Reading: Book ch. 10.1.
- [ ] **M3: Facet building.** Port the Odin fill, then add single-pass seeding, `facet_map: Grid<u32>`, bbox,
  neighbours (a second pass over border points), and return a `FacetResult`.
  - Done when a debug PNG shows a random color per facet and tests on 4×4 grids pass (count, sizes, neighbours).
  - Concepts: `while let Some(i) = stack.pop()`, `HashSet`, `Option`, returning owned data, `#[test]`.
  - Reading: Book ch. 11.
- [ ] **M4: Narrow-strip cleanup and facet reduction** (merge facets under 20 px).
  - Done when small specks disappear from the debug PNG.
  - Concepts (main borrow-checker module): `Vec<Option<Facet>>`, the index pattern, `.clone()`, splitting borrows, `sort_by`.
  - Reading: revisit Book ch. 4 and 8.
- [ ] **M5: Border tracing** (`facetBorderTracer.ts`, the hardest algorithm).
  - Done when each facet's outline is drawn as a closed path.
  - Concepts: `enum Orientation` and `match`, enums carrying data.
  - Reading: Book ch. 6.
- [ ] **M6: Border segmentation.** Shared segments between neighbours, Haar-wavelet smoothing.
  - Done when outlines are smooth with no gaps between neighbours.
  - Concepts: data shared without `Rc` (indices again), iterators.
  - Reading: Book ch. 13.
- [ ] **M7: Label placement.** Port `src/lib/polylabel.ts`.
  - Done when there's a dot at each label position.
  - Concepts: `BinaryHeap`, implementing `Ord` (why `f64` isn't `Ord`).
  - Reading: std `BinaryHeap` docs.
- [ ] **M8: SVG output.** Outlines, numbers, palette legend.
  - Done when there's a paintable `.svg`.
  - Concepts: `String`, `format!`/`write!`, the `Display` trait, `std::fs::write`.
  - Reading: Book ch. 8.2.
- [ ] **M9 (stretch): Polish.** `Settings` struct with `Default`, then `clap`, idiomatic refactor, `rayon`.
  - Concepts: traits, closures and `FnMut`, lifetimes.
  - Reading: Book ch. 10.3, 13, 16.

M0–M3 are mostly porting logic I already understand. The genuinely new algorithms start at M4.

## Rust shifts from Go/Python/Odin

- **`defer delete` → Drop:** cleanup is automatic and correctly ordered.
- **`Maybe(T)` → `Option<T>`:** the compiler forces handling the empty case.
- **`map[Point]struct{}` → `HashSet<Point>`:** needs `#[derive(Hash, Eq, PartialEq)]` on `Point`.
- **No implicit integer conversions:** `int(a.r) - int(b.r)` → `a.r as i32 - b.r as i32`. Indexing uses
  `usize`, so `nx < 0` checks need signed math (`i32`/`isize`) or `checked_sub`.
- **Ownership:** expect borrow-checker fights in M3–M6. Reach for indices into a `Vec` first; TS uses numeric facet IDs the same way.
- **Build mode:** run k-means with `cargo run --release` (debug builds are ~10–50× slower).

## Quiz log

| Date | Module | Solid | Gaps |
|---|---|---|---|
| 2026-11-10 | M0 probe | Moves (Q1), Drop at scope end (Q2), `?` (Q3), debug overflow panic (Q4), borrow conflict on push (Q5), Copy rules (Q6), release-mode wrapping (Q8) | Vec memory layout and move cost (Q9), `&mut Vec` → `&mut [T]` coercion (Q10), Vec vs slice capabilities (Q11), prefers Vec in/out over `&mut [T]` (Q7) |
| 2026-11-10 | Lesson 1: Vec memory | Taught Vec = (ptr, len, cap) header + heap buffer, slices as views, deref coercion. Both checks correct (signature choice, clone vs move cost) | (closed) |
