---
name: pop-rust
description: "Write, refactor, review, and organize Rust code in Pop's preferred style: idiomatic Rust APIs, short semantic names, strict formatting and module organization, typed ownership and lifecycle models, completion-based async with Compio, deliberate unsafe internals, and focused invariant-heavy tests. Use for Rust source, Cargo workspace, library API, async runtime, concurrency, error-modeling, CLI, configuration, benchmark, test, or Rust commit tasks where Pop's conventions should guide the result."
---

# Pop Rust

Write code that looks native to the repository first and to this style second.
Preserve established local choices unless the user explicitly requests a style
migration. Read `references/rust-guidelines.md` when designing or reviewing a
public API. Read `references/ecosystem.md` before adding dependencies or choosing
among common Rust libraries.

## Work from the repository

1. Read applicable instruction files, `Cargo.toml`, `rustfmt.toml`, lint
   configuration, representative neighboring modules, and recent commit subjects.
2. Identify the crate's public seam, ownership model, thread model, feature and
   platform matrix, and error boundary before editing.
3. Follow existing terminology. Extend a local abstraction instead of creating a
   competing vocabulary.
4. Make the smallest coherent change. Keep unrelated cleanup out of the patch.
5. Format and run the narrowest relevant checks, then broader tests when shared
   behavior, unsafe code, concurrency, or public APIs change.

## Name by meaning

- Prefer the shortest name that states the domain role precisely. Shortness never
  excuses ambiguity.
- Name public types after semantics or capabilities, not implementation mechanics.
  Favor names such as `Key`, `Carry`, `Frame`, `Slice`, `Broker`, `Call`, `Reply`,
  `Mailbox`, `ActorExit`, and `DeliverError`.
- Use conventional short locals when their role is immediate: `buf`, `cx`, `fut`,
  `ptr`, `tx`, `rx`, `op`, `key`, `id`, and `len`.
- Avoid filler suffixes such as `Manager`, `Helper`, `Utils`, `Data`, `Info`, and
  `Impl` unless they express a real domain distinction.
- Keep word order consistent across a family. Pair constructors and conversions
  predictably: `new`, `try_*`, `as_*`, `to_*`, `into_*`, and `*_unchecked`.
- Rename a concept rather than explaining a weak name with a comment.

## Model invariants in types

- Use ownership, borrowing, associated types, newtypes, typestate, generics, and
  capability handles to make invalid states difficult to express.
- Prefer typed handles over raw identifiers at public seams. Type-erase only at a
  narrow internal boundary, then recover the type before exposing a value.
- Let errors retain rejected owned values when callers can retry or recover them.
  Provide `into_inner` or `into_parts` when useful.
- Implement applicable common traits eagerly, especially `Debug`, `Clone`,
  `Default`, equality, ordering, hashing, `Display`, and `Error`.
- Use builders for optional configuration and consuming methods for state
  transitions. Keep the ordinary path obvious.
- Express thread restrictions deliberately. Use `Rc`, `Cell`, and `RefCell` for
  genuinely local code; use `Arc`, atomics, and locks only when crossing threads.
  Offer parallel `sync` and `unsync` modules when both are useful and can keep the
  same semantic API.

## Keep the surface simple and the module deep

- Expose a small, unsurprising public API over the complex implementation.
- Keep `lib.rs` focused on crate documentation, module declarations, and deliberate
  re-exports.
- Organize by domain concept, not by generic technical layer. Split a concept into
  a directory when it gains distinct runtime, state, error, handle, or platform
  responsibilities.
- Map source files to logical modules and use `mod.rs` for directory modules. Split
  large files when they contain distinct components, such as types and impls that
  are not closely coupled.
- Never use `include!` to split handwritten source files. Declare a module instead;
  reserve `include!` for generated source.
- Keep implementation modules private by default. Make visibility no wider than
  required.
- Mirror real implementation matrices explicitly, such as `sync`/`unsync`,
  `sys/{windows,unix}`, or backend-specific operation modules.
- Use macros to share a true family of implementations, not to hide ordinary
  control flow. Keep generated names, visibility, attributes, and documentation
  predictable.
- Put public integration tests in `tests/`, benchmarks in `benches/`, examples in
  `examples/`, and private invariant tests beside their implementation.

## Format strictly

- Run repository `rustfmt`; for a new project, start with the official Rust style
  and the preferred nightly settings in `references/rust-guidelines.md`.
- Always put every comment associated with an item before every attribute on that item.
  This rule applies to doc comments and ordinary explanatory comments.
- Separate a struct or union field or an enum variant that has an attribute or
  associated comment from adjacent fields or variants with a blank line.

  ```rust
  /// A typed reference to an actor.
  #[derive(Clone, Debug)]
  pub struct Mailbox<A> {
      inner: Arc<Inner<A>>,
  }

  // Only the io_uring backend supports this operation.
  #[cfg(io_uring)]
  fn submit(op: Op) {
      // ...
  }
  ```

- Put one attribute on each line. Consolidate derives into one `derive` attribute.
- Prefer line comments, complete sentences, block indentation, trailing commas in
  multiline lists, grouped imports, field-init shorthand, and early returns.
- Prefer `let ... else`, precise matches, RAII cleanup, and small helpers over
  nested control flow.
- Comment invariants, ownership, ordering, layout, and non-obvious reasons. Do not
  narrate syntax.

## Treat unsafe code as an encapsulated proof

- Use unsafe code when it provides a concrete representation, allocation,
  scheduling, FFI, or platform benefit that safe code cannot provide cleanly.
- Keep unsafe blocks small. Put a `SAFETY:` comment immediately before each block
  and state the exact invariant that makes the operation valid.
- Document every unsafe public function with a `# Safety` section. Validate what
  can be validated before crossing the unsafe boundary.
- Encapsulate pointers, layout tricks, manual drops, raw wakers, and atomic state
  behind a safe API. Name unchecked escape hatches explicitly.
- State `repr(C)` and `repr(transparent)` layout dependencies next to the affected
  fields. Add size, alignment, trait-bound, or object-safety assertions where they
  protect the design.
- Test unsafe concurrency with Miri or Loom where applicable. Benchmark before
  accepting complexity solely for performance.

## Handle errors at the right boundary

- Use domain-specific error types in libraries. Make variants semantic, retain
  useful context, implement `Error`, and document error conditions.
- Use SNAFU when contextual selectors and structured source chains improve the
  domain model. Use simpler standard or existing repository errors when SNAFU
  would add ceremony without information.
- Reserve `unwrap`, `expect`, and panic for tested invariants, impossible states,
  process bootstrap, examples explicitly demonstrating failure, or tests. Write an
  invariant-specific message.
- Preserve the first meaningful failure during cleanup unless the API explicitly
  specifies another precedence.

## Test contracts and performance

- Test observable contracts, state transitions, and failure paths: cancellation,
  panic, drop order, startup and shutdown, message recovery, wake races, reference
  counts, capacity, and cross-thread behavior.
- Add compile-time assertions for `Send`, `Sync`, object safety, size, and layout
  when those properties are part of the design.
- Prefer deterministic focused cases. Add stress tests only when they cover a
  distinct concurrency invariant; avoid mechanically repetitive suites.
- Use Criterion for performance claims and record the scenario and trade-off. Use
  Loom for atomic interleavings and Miri for unsafe memory behavior when supported.

## Commit Rust changes

- Make focused commits that keep tests with the behavior they verify.
- Write exactly one non-empty commit-message line. Never add a body, trailer, or
  co-author line.
- Use a concise Conventional Commit subject:
  `type(optional-scope): imperative summary`.
- Prefer `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, or
  `chore`. Name the affected semantic area when a scope helps.
