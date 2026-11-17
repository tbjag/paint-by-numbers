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

**AI-free-first rule (added 2026-11-17, overrides the defaults below where they conflict)**
- The learner wants to learn *without* AI resources. The AI is a last resort, not the first stop. Default to withholding answers.
- When the learner asks a question that docs, `rustc --explain`, the Book or the std source can answer: don't answer it. Name where to look (page + section, or the command) and ask them to come back with what they found.
- Ladder for any stuck moment, one rung at a time: (1) read the full compiler error, (2) `rustc --explain`, (3) std/crate docs and the Book, (4) grep crate source, (5) a leading question from the AI, (6) a precise pointer (line + "compare with line N"), (7) only then a worked explanation. Ask which rungs they've already tried.
- Concept teaching: point at the Book chapter / Rust by Example first and have the learner explain it back in their own words. The AI corrects the explanation instead of lecturing up front.
- Quizzes stay, but run them *after* the learner has read the material, not as a replacement for reading it.
- Code reviews happen only after the learner has run `cargo build`, `cargo clippy` and the tests, and fixed what those flag. Pointers are for what the tools can't catch (logic, design).
- No AI-written explanations of the learner's own code unless they ask. Don't summarize what the compiler already said.
- Ask the learner to write a one-line "what I tried" before the AI helps. Log how many rungs they climbed on their own in the Quiz log.

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
- Background: Go, Python, Odin. Learning Rust to work without AI. Said on 2026-11-16 (commit c162507) that they need to be more disciplined about not using AI to teach them. Wants the plan to push that.
- Prefers working code first and idiomatic refactors later.
- Wants to stay close to the TS reference and their own Odin port.
- Finds Rust cumbersome and tends to polish small errors before the program works. Remind gently: lazy first, refactor after it runs.
- Learns well from reading panics and re-reading against the Odin code. Prefers leading questions to being handed the fix, but a precise pointer (line + "compare with line N") works.

## Independence habits

Order to try before asking AI (the ladder):

1. Read the whole compiler error, top to bottom, including the `help:` lines.
2. `rustc --explain E0XXX` for any error code.
3. `cargo doc --open` for offline docs of my crate and its dependencies; std docs for std types.
4. The Book chapter for the concept (see the Reading line on each milestone).
5. Grep crate source in `~/.cargo/registry/src/*/<crate>-<version>/` and read the examples and tests.
6. Rust by Example / [users.rust-lang.org](https://users.rust-lang.org/) / Stack Overflow search (reading, not posting).
7. Write a 3-line scratch file (`cargo new --bin scratch` or the playground) that isolates the question and run it.
8. Only then ask AI, and say what I tried.

Habits:
- `cargo clippy` once it compiles; `cargo fmt` always.
- Make a prediction before running ("this should print X / fail with Y") and check it.
- After reading a Book chapter, close it and explain the idea in my own words in the notes below. If I can't, reread.
- Keep a `NOTES.md` or the "Learned" lists below in my own words, not AI's.
- Rewrite, don't paste: retype any snippet from docs so I engage with every token.
- One AI-free milestone step per session as a minimum: try the whole step through rung 7 first.

References: [The Rust Book](https://doc.rust-lang.org/book/), [Rust by Example](https://doc.rust-lang.org/rust-by-example/), [std docs](https://doc.rust-lang.org/std/), [Rustlings](https://github.com/rust-lang/rustlings) for drills, [Rust std source on docs.rs ("source" links)](https://docs.rs/).

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
- [x] **M1: k-means.** (done 2026-11-17: bit chop, distance, step, run and weighted unique colors all work; seeded `StdRng` verified by hash (same seed same output, different seed different output); `i64` sums/counts.) `Rgb` struct, bit chop, distance, step/run, weighted unique colors, seeded RNG (the `rand` crate, no `random.ts` port).
  - Done when the quantized PNG looks right (decided 2026-11-16: no need to match the Odin output, this isn't a pure port).
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
- Still open from M0 (checked 2026-11-16): `output/` not in `.gitignore`; `main.rs:24` pixel loop still a `for` + `push` (`.map().collect()`).
- Clippy items in `kmeans.rs`: `.enumerate()` instead of `centroid_idx` counter, drop `.clone()` on `Copy`, unused `use std::vec`.
- `>> N << N` vs `& !0b11` (cosmetic; kept to mirror TS/Odin).
- `as` casts: recheck float→int saturation and int→int truncation when k-means centroid math is next touched (`kmeans.rs:61-63` uses `i32 / i32 as u8`, which is fine for 0–255 averages).

### M1 so far (2026-11-16)

`src/kmeans.rs` (~110 lines): `preprocess` (bit chop), `get_distance`, `count_colors` (`HashMap` entry API, sorted by `(r,g,b)`), `step_kmeans` (weighted by counts, over unique colors), `run_kmeans` (color→centroid `HashMap` to repaint every pixel). Wired from `main.rs` with `k = 10`.
Runs and writes `output/out.png`. `cargo build` clean, clippy clean (checked 2026-11-16). Tested on `hawaii.jpg` (visually correct), `testinputmedium.png` (0.35s release), `testinput.png` (4 unique colors with `k = 10`, handled by `k.min(unique.len())`).

Learned / fixed with coaching:
- **`vec![0, n]` vs `vec![0; n]`:** list literal vs repeat. Caused the index-out-of-bounds panic (len 2) in `assignments`.
- **Forgotten update:** `min_distance` was never assigned, so every pixel picked the last centroid. Found by re-reading against Odin.
- **Stop condition:** `DELTA_DIFF = 0.0` never settles with truncated integer centroids; `1.0` fixed the apparent infinite loop.
- **`cargo run --release -- <args>`** vs `cargo build --release` then `./target/release/paint-by-numbers <args>`.
- Module basics: `mod kmeans;` once in `main.rs`, `pub fn`, `use crate::Rgb;` (private fields are visible to child modules).
- Iterators: `for pixel in pixels` over `&mut [T]`, `.iter().enumerate()`, `iter_mut()`.

Also learned in the weighted step:
- **Refs vs values:** `.iter()` yields `&T`, `.into_iter()` yields owned `T` (the M0 `to_`/`into_` lesson); `*r` copies out of a `&T` when `T: Copy`; `.clone()` on an iterator clones the iterator, not the items.
- **Lazy iterators:** a bare `.zip(...)` does nothing until a `for` loop or `collect` consumes it.
- **Destructuring patterns:** `for (&(color, _), &idx) in a.iter().zip(b.iter())`.
- **`HashMap`:** entry API with `*` deref; `get()` returns `Option<&V>`; arbitrary iteration order means sort before sampling.
- **`index::sample(rng, length, amount)`:** argument order mattered, and `amount > length` panics.
- **Index spaces:** the bug where `assignments` (per unique color) was indexed by pixel position. Solved with a color→index `HashMap`.

Learner reflection (their own words, worth keeping): write the program the laziest way first, then go back and iron out
the kinks. A working program is useful; don't polish before it runs.

Still open in M1 (both small):
- **Seeded RNG (decided 2026-11-16: no `random.ts` port, the `rand` crate is fine):** `run_kmeans` still uses `rand::rng()` (non-deterministic). Seed it: `use rand::{SeedableRng, rngs::StdRng}; StdRng::seed_from_u64(...)` (verified in `rand_core-0.10.1/src/seedable_rng.rs:109`). `count_colors` already sorts, so seeded runs will repeat.
- **Overflow:** `sums` and `counts` in `step_kmeans` are `i32`; `255 * count` summed over a large image (e.g. 4000×4000) can pass 2.1 billion. Use `i64`.
- Cosmetic: `step_kmeans` uses `.iter_mut()` on `centroids` in a read-only loop; `.iter()` is enough.

Design note for M2: `run_kmeans` currently overwrites `pixels` with centroid colors and throws away `centroids` and `assignments`.
That is the same flaw as the Odin port (palette indices lost). M2 fixes it by returning them.

TS reference verified 2026-11-16 (`~/workspace/paintbynumbersgenerator`, now cloned):
- Weighted unique colors: `src/colorreductionmanagement.ts:95-115` (weight = pixels of color / total pixels), weighted mean in `src/lib/clustering.ts:21-46`. Integer counts give the same result (the total cancels).
- `kMeansMinDeltaDifference = 1` (`src/settings.ts:11`), matching the Rust `DELTA_DIFF = 1.0`.
- Seed: `randomSeed === 0 ? time : seed`. Initial centroids are random picks from the unique-color list (can repeat; Rust's `index::sample` avoids repeats).
- TS keeps centroids as floats; Rust truncates to `u8` each step. Possible small palette difference, fine for now.

### M1 finish (2026-11-17, AI-free mode)

- **Seeded RNG:** `let mut rng: StdRng = StdRng::seed_from_u64(2);` then `index::sample(&mut rng, ...)`. Verified with `sha256sum` on `hawaii.jpg` (same seed same hash, seed 1 vs 2 different hash). `testinput.png` isn't a valid test: only 4 unique colors, so `k` clamps and the RNG has no effect.
- **Learned about types:** a trait method call like `SeedableRng::seed_from_u64(1)` doesn't say which type implements it; the compiler needs to infer one, and failed. Fix: name the type (`<StdRng as SeedableRng>::...` or a `: StdRng` annotation on the `let`). `sample` takes `rng: &mut R` with `R: Rng + ?Sized`. (The tutor's early hints blamed the `&mut`, which was wrong.) `&mut` is a pointer to a value; `y = &mut 5` has type `&mut i32`, and `bump(y)` changes the `5` it points at (scratch-file test).
- **Overflow:** max sum for a 4000x4000 all-255 image is 4,080,000,000, about 1.9x `i32::MAX` (2,147,483,647). Debug panics, release wraps. `counts` is `i64` to match `sums` for the division, avoiding casts.
- **Left (cosmetic):** seed `2` could be a `const`; run `cargo fmt` (trailing space on the `StdRng` line); `output/` still not in `.gitignore`.

### Next up

AI-free mode is on (see the AI-free-first rule). For each item, the learner attempts it through the ladder first.

1. Commit M1. Add `output/` to `.gitignore` (and `git rm --cached` what's tracked), run `cargo fmt`.
2. Before M2, read Book ch. 10.1 (generics) and ch. 5 `impl` blocks, then explain `struct Grid<T>` in your own words in the notes. Then probe.
3. M2: change `run_kmeans` to return `(centroids, color→index lookup or per-pixel indices)` instead of overwriting `pixels`, and build `Grid<u8>` of palette indices (generics, `impl` blocks). Learner writes the design (struct fields, function signatures) in a comment first, then codes it.
3. Recheck `as` casts when `i64` appears (int→int truncates, float→int saturates). Still unprobed: `--release` details beyond the command.
4. Commit habit: the learner commits at the end of sessions (`output/` is still not in `.gitignore`).

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
| 2026-11-12 | M1 probe | `HashMap` key needs `Hash`+`Eq` (Q1), `mod x;` once in main + `pub` (Q2), `&mut [T]` can't change length (Q3), no implicit int conversion (check) | `as` casts: float→int saturates (guessed panic/wrap), int→int truncates bits (guessed clamp). Taught twice, follow-ups both missed (`-1 as u8` int vs float, `.round()` before cast), so learner to run it in a scratch file; recheck when casts first appear in k-means. Still unprobed: seeded RNG, `--release` |
| 2026-11-16 | M1 build | Wrote `preprocess`, `get_distance`, `step_kmeans`, `run_kmeans` mostly independently; diagnosed the `vec![0; n]` panic from a pointer; used `&[T]`/`&mut [T]` correctly | `vec![a, b]` vs `vec![a; n]`, forgetting to update `min_distance`, stop-threshold reasoning (`0.0` vs `1.0`), `--release` invocation |
| 2026-11-16 | M1 probe 2 | `entry().or_insert(0)` with `*` deref (Q1), `HashMap` iteration order is arbitrary (Q2) | Didn't connect map order to determinism: seeded RNG still gives different results if the `Vec` built from a `HashMap` isn't sorted. Taught (`sort_by_key` on `(r,g,b)`) |
| 2026-11-16 | M1 weighted build | Wrote `count_colors`, weighted `step_kmeans`, and the color→centroid lookup with pointers; fixed the `assignments` sizing and `sample` args after the panic and review; used `zip` + destructuring patterns; took the "lazy first" approach | Ref vs value conversions (`.iter()` vs `.into_iter()`, `*`, `.clone()` on an iterator), lazy iterators doing nothing unconsumed, index spaces (unique-color index vs pixel index), `sample(rng, length, amount)` order, determinism needs a sorted `Vec` |
| 2026-11-17 | M1 finish (AI-free mode) | Found `SeedableRng`/`make_rng` in docs; typo-diagnosed a path; fixed the trait-inference error from compiler output; verified determinism by hashing and a changed seed; correct overflow arithmetic; knew debug panics, release wraps; reasoned `counts` as `i64` for the division | Rungs climbed alone: 1-3 (error, docs, source). Gaps: `&mut` as a pointer vs the value (predicted `6 5`, was `6 6`); type vs reference-to-type (`y` is `&mut i32`); inference with trait methods (needs a named type); `StdRng` isn't from Rust's `std`; didn't check that `testinput.png` is too small to test the RNG until prompted |
| 2026-11-10 | M0 build | Shipped M0 independently after doc-navigation coaching; correctly pushed back on premature `usize` advice, then chose `usize` with boundary casts | Finding methods in docs (trait vs inherent, struct-level examples): improving. Tuple struct field syntax: taught |
