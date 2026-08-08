# Preferred Rust Ecosystem

Check the repository's existing dependency set and current official documentation
before adding a crate. Reuse an existing dependency when it fits. Keep features
minimal and centralize versions in a workspace manifest.

## Primary preferences

### Compio

Prefer [Compio](https://docs.rs/compio) for new asynchronous systems work when a
thread-per-core, completion-based model is appropriate. Its owned-buffer APIs,
IOCP/io_uring/polling backends, local runtime, filesystem, networking, process,
signal, TLS, QUIC, WebSocket, and dispatcher crates match the preferred systems
architecture.

- Design local futures and actor state without unnecessary `Send` bounds.
- Move owned buffers through completion-based operations and return them with the
  result.
- Use dispatcher or explicit runtime boundaries when work must cross threads.
- Add Tokio compatibility only at an actual interoperability boundary.

### SNAFU

Prefer [SNAFU](https://docs.rs/snafu) when errors need semantic variants,
context selectors, source chains, backtraces, or context added to `Result`,
`Option`, `Future`, or `Stream` values.

- Name variants after the failed domain operation, not the underlying library.
- Carry values that help diagnose or recover from failure.
- Use transparent errors only when another error already expresses the complete
  contract.
- Keep small internal error cases manual when a derive would obscure the model.
- Use `context` over `map_err`

### Figment

Prefer [Figment](https://docs.rs/figment/latest/figment/struct.Figment.html) for
typed configuration assembled from defaults, files, environment variables, and
other providers.

- Deserialize once into a semantic `Config` type at the application boundary.
- Make provider precedence explicit with ordered `merge` or `join` calls.
- Keep loading and validation in a dedicated configuration module.
- Redact secrets in `Debug` output and avoid leaking them through errors or logs.

### clap

Prefer [clap](https://docs.rs/clap/latest/clap/) derive APIs for typed command-line
interfaces.

- Model commands and subcommands as semantic enums and structs.
- Let clap parse and validate at the boundary; pass domain values into the rest of
  the application.
- Keep CLI spelling, help, defaults, and conflicts beside the relevant fields.
- Separate reusable core behavior from the binary's CLI layer.

### tap::Pipe

Use [`tap::Pipe`](https://docs.rs/tap/latest/tap/pipe/trait.Pipe.html) for a short
suffix-position transformation when it makes value flow clearer, especially for
wrapping, conversion, or returning a constructed value.

- Prefer `.pipe(Type::new)` or `.pipe(Ok)` when it removes a throwaway binding.
- Avoid long pipelines, surprising side effects, or using `Pipe` where an ordinary
  method already communicates the operation better.

### mod_use

Use [`mod_use`](https://docs.rs/mod_use) to declare and re-export a conventional
module family concisely when the resulting public surface remains obvious.

- Group closely related modules with the macro.
- Prefer explicit `mod` and `pub use` declarations when visibility differs,
  conditional compilation is complex, or readers need to see the public seam.
- Do not let module automation dictate domain organization.

## Frequent supporting choices

- **futures-util:** Use `FutureExt`, `StreamExt`, `TryFutureExt`, `TryStreamExt`,
  sinks, and `FuturesUnordered` for runtime-agnostic async composition.
- **pin-project-lite:** Prefer its lightweight safe pin projection for hand-written
  futures and streams. Avoid manual projection unless a measured constraint
  requires it.
- **serde:** Use typed serialization at configuration, protocol, and persistence
  boundaries. Keep serialized forms separate from core domain state when their
  evolution differs.
- **tracing / compio-log / log:** Emit structured lifecycle and diagnostic events.
  Keep hot-path logging cheap and never log secrets.
- **flume / crossfire:** Use bounded channels when queue capacity and synchronous
  versus asynchronous behavior are deliberate parts of the design.
- **synchrony / see / local-event / event-listener:** Choose local or synchronized
  notification primitives to match the real thread model rather than defaulting to
  atomic synchronization.
- **slotmap:** Use typed stable keys for executor, registry, or arena identities
  instead of naked integer indices.
- **rustix / windows-sys / socket2 / libc:** Keep OS integration in narrow platform
  modules behind portable traits or operations.
- **Criterion:** Benchmark representation, allocation, scheduling, and throughput
  claims with named scenarios.
- **Loom and Miri:** Exercise concurrency interleavings and unsafe memory invariants
  when the implementation relies on them.

Do not add a preferred crate merely as a signature. Every dependency must simplify
the model, strengthen correctness, or serve a measured systems requirement.
