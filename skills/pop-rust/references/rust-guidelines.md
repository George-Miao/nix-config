# Rust API and Style Baseline

Use the [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/) as the
public-API baseline and the
[Rust Style Guide](https://doc.rust-lang.org/stable/style-guide/) as the formatting
baseline. Treat them as defaults, then apply repository conventions and the
stronger rules in `SKILL.md`.

## Public API checklist

- Follow Rust casing and conversion conventions. Use `as_` for cheap borrowed
  views, `to_` for potentially expensive conversions, and `into_` for consuming
  conversions.
- Use standard conversion traits such as `From`, `TryFrom`, `AsRef`, and `AsMut`
  where they express the relationship.
- Implement applicable common traits eagerly.
- Make errors meaningful, source-aware, and recoverable when possible.
- Prefer methods when there is a clear receiver. Avoid out-parameters.
- Use newtypes and custom argument types to convey meaning and reject invalid
  states statically.
- Use builders for complex construction. Keep fields private when future
  evolution matters.
- Use generics to avoid needless assumptions, but keep signatures readable.
- Keep potentially useful traits object-safe or explicitly assert object safety.
- Validate inputs. Prefer type-level validation, then construction-time checks,
  then runtime errors or documented panics.
- Document crate purpose, examples, errors, panics, and safety requirements.
- Make examples demonstrate why an API is useful and use `?` for ordinary error
  propagation.

## Formatting baseline

- Use four spaces, a 100-character maximum line width, block indentation, and
  trailing commas in multiline lists.
- Prefer line comments. Put comments on their own line and write complete sentences
  when practical.
- Put doc comments before attributes. Pop's stronger rule extends this ordering to
  any ordinary comment associated with the attributed item.
- Put each attribute on its own line and use one combined `derive` attribute.
- Let `rustfmt` decide mechanical layout. Do not hand-align code against formatter
  output.

For a new Rust 2024 project using nightly rustfmt, prefer:

```toml
unstable_features = true
style_edition = "2024"

group_imports = "StdExternalCrate"
imports_granularity = "Module"
reorder_imports = true

wrap_comments = true
normalize_comments = true

reorder_impl_items = true
condense_wildcard_suffixes = true
enum_discrim_align_threshold = 20
use_field_init_shorthand = true

format_strings = true
format_code_in_doc_comments = true
format_macro_matchers = true
```

Retain a repository's existing granularity or deliberate deviation rather than
rewriting it solely to match this template.
