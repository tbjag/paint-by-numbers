# Paint by Numbers in Rust — Lesson Plan

Goal: learn Rust well enough to write it on my own with only basic internet resources, by porting
the TypeScript generator (`~/workspace/paintbynumbersgenerator`) to Rust. Not aiming for the most
idiomatic Rust on the first pass. Get it working, then refactor.

Method (from [amosblomqvist/learn](https://github.com/amosblomqvist/learn)'s teach skill):

1. **Probe**: quizzes find the edge of what I know for each module's prerequisites.
2. **Teach**: for each concept, why it's needed, what it is, how it maps to Go/Python/Odin, then a quiz.
3. **Build**: I write all the Rust. AI explains compiler errors and asks leading questions only.
4. **Checkpoint**: every milestone writes a debug PNG plus `#[test]`s on tiny hand-made grids.

## Tutor instructions (for future AI sessions)

Read this whole file at the start of every session. It is the source of truth for progress and pace.

**Session start**
- Read `## Progress notes` and `## Quiz log` to see where things stand and what was deferred.
- Read `src/`, then run `cargo build` and `cargo clippy` to see the current state of the code.
- Briefly say where things stand and what's next, then follow the learner's lead.

**Code ownership**
- Never write or edit the learner's project code (`src/*.rs`, `archive/*.odin`) unless explicitly asked.
- Allowed: one-line API usage examples taken from docs, small concept examples that aren't the milestone solution, and before/after snippets of the learner's *own* lines when explaining a style point.
- Toolchain and environment fixes are fine.
- Panics with `.expect("msg")` are fine until M9. Don't push error handling earlier.

**The learning loop (from the learn harness)**
1. **Probe** before each milestone with AskUserQuestion quizzes, up to 4 questions per call.
   - Options are bare claims of the same form, built as realistic misconceptions.
   - Vary where the correct answer sits, and don't mark it with length, emphasis or "Recommended".
   - If everything is right, escalate difficulty. Around a miss or an unsure answer, ask 2–3 follow-ups on the same strand to tell a slip from a gap.
2. **Teach** the gap: why it matters for this project, what it is, and a link to Odin/Go/Python (the learner's own Odin code is the best bridge). Use a small table or ASCII diagram when it helps.
3. **Check** with about 2 quiz questions.
4. **Log** to `## Quiz log`, and update the milestone checkboxes and `## Progress notes`.

**Code reviews** (when asked to "check my work")
- Read the file, build it, run clippy, and run the program. Verify output when possible (e.g. pixel-compare PNGs using the `poc/` uv environment with `python -I`).
- Give numbered pointers, most important first, with line numbers and the *why*.
- Say clearly what's already good. Say clearly when the milestone is done.

**Pace and style**
- Small questions get small, focused answers. One milestone step at a time.
- Defer concepts until the learner feels the friction (e.g. `usize` everywhere waits for M3). Mention "later, not now" items and record them under Deferred.
- When the learner pushes back with a valid point, say they're right and adjust.
- Teach *how to find* answers rather than handing over APIs:
  - name the docs page and section (docs.rs / `cargo doc --open`);
  - read signatures (`&self` vs `self`, generics, type aliases);
  - grep crate source in `~/.cargo/registry/src/*/<crate>-<version>/`.
- Verify API claims against the locally downloaded crate source before stating them (e.g. image 0.25.10).
- Be encouraging, not preachy. If the learner is hard on themselves, reassure briefly and move on.

**Learner profile**
- Background: Go, Python, Odin. Learning Rust to work without AI.
- Prefers working code first and idiomatic refactors later.
- Wants to stay close to the TS reference and their own Odin port.

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

## Progress notes

### M0 (done 2026-11-10)

`src/main.rs`: CLI arg → `ImageReader::open().decode()` → `into_rgb8()` → `Vec<Rgb>` (own struct, row-major) →
`ImageBuffer::from_fn` → `output/out.png`. Output verified pixel-identical to input.

Learned:
- **Vec vs slices:** a `Vec` is a (ptr, len, cap) header plus a heap buffer; a move copies only the header; `&mut Vec` → `&mut [T]` by deref coercion.
- **`to_*` vs `into_*`:** `&self` borrows and returns a copy; `self` consumes.
- **Shadowing:** reusing a name with `let` creates a new variable; the old value stays alive until scope end.
- **Patterns:** tuple structs (`Rgb(pub [T; 3])` → `.0`), destructuring `let [r, g, b] = rgb.0;`, field init shorthand `Rgb { r, g, b }`.
- **Closures and inference:** a first closure capturing by borrow (`from_fn`), with the image type inferred from the closure's return.
- **Casts:** `as` binds tighter than `*`/`+`; cast at the boundary (`usize` internally, `as u32` into the image API).
- **Tooling:** `cargo run -- <args>`, reading panics (first two lines, then the first frame in your own code), `.unwrap()` / `.expect()` / `?`.
- **Docs navigation:** sidebar Methods vs Trait Implementations, clicking through return types and type aliases, struct-level examples, grepping `~/.cargo/registry`.

Deferred (later, not now):
- Line 30 polish: `let p = img[idx];` instead of indexing 3 times.
- `cargo fmt` habit; add `output/` to `.gitignore`.
- `impl From<Rgb> for image::Rgb<u8>` once the conversion appears twice (M2).
- The `@TODO` map: `.pixels().map(...).collect()` (Book ch. 13).
- `Grid<T>` with `width: usize` and casts only at the edges (M2/M3).
- Real error handling instead of `expect` (M9).

### Next up: M1 (k-means)

Probe topics: `mod` files, `HashMap` for counting unique colors, `&[Rgb]` and `&mut [Rgb]` in one function,
`f32`/`f64` and casts, seeding your own RNG (port `src/random.ts`), `--release`.
First build step: `fn preprocess(pixels: &mut [Rgb])` (bit-chop, port of Odin `preprocess_image`).

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
| 2026-11-10 | M0 build | Shipped M0 independently after doc-navigation coaching; correctly pushed back on premature `usize` advice, then chose `usize` with boundary casts | Finding methods in docs (trait vs inherent, struct-level examples): improving. Tuple struct field syntax: taught |
