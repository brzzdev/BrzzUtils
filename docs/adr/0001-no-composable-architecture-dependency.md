# 1. No ComposableArchitecture dependency

Date: 2026-08-02

## Status

Accepted

## Context

BrzzUtils depended on `swift-composable-architecture` and, through it, resolved
`Dependencies`, `DependenciesMacros`, `IdentifiedCollections`, and `ConcurrencyExtras`
transitively — importing all four without ever declaring them.

It never used TCA itself. There were no reducers, stores, `TestStore`s, effects, or
navigation anywhere in `Sources`. The single file that imported `ComposableArchitecture`
(`Dep+OSLogStore.swift`) reached only `DependencyValues`, `DependencyKey`, and
`@DependencyClient` — all of which belong to swift-dependencies. TCA was, in effect, an
expensive way to spell `import Dependencies`.

That became load-bearing when the consuming apps wanted to adopt
[ComposableArchitecture 2.0](https://github.com/pointfreeco/TCA26). At the time of writing
TCA26 has no tags or releases — only `main` — and it pulls three further branch
dependencies of its own (swift-case-paths `26`, swift-clocks `clocks-2`, swift-navigation
`relax-sendable`). SwiftPM does not allow a version-resolved package to depend on a
branch, so pointing BrzzUtils at TCA26 would have forced every consuming app to pin
BrzzUtils by branch or revision too, ending its ability to ship stable tags. It would also
have raised the platform floor from iOS 16 / macOS 13 to iOS 17 / macOS 14, in exchange for
capabilities this package has no code to use.

## Decision

BrzzUtils does not depend on ComposableArchitecture. It depends directly on the underlying
Point-Free libraries it actually uses:

- `swift-dependencies` (`Dependencies`, `DependenciesMacros`)
- `swift-identified-collections`
- `swift-concurrency-extras`

## Consequences

BrzzUtils is TCA-version-agnostic. It works unchanged under TCA 1.x, under TCA26's
`ComposableArchitecture1` compatibility layer, and alongside `ComposableArchitecture2` — so
each app adopts TCA 2.0 on its own schedule while BrzzUtils keeps releasing stable SemVer
tags.

It is also insulated from TCA26's trait system. `ComposableArchitecture2` only vends
`Dependencies` when the consumer enables the `Dependencies` trait, which is **off** by
default (`.default(enabledTraits: ["ComposableArchitecture1Deprecations"])`), and it does
not vend `IdentifiedCollections` or `ConcurrencyExtras` at all. Declaring these packages
directly means BrzzUtils compiles regardless of how any app configures its traits.

The platform floor stays at iOS 16 / macOS 13, and the resolved dependency graph drops from
16 pins to 11.

**Do not add `swift-composable-architecture` (or TCA26) back.** Re-adding it looks like a
simplification — one dependency instead of three, and it re-exports everything — but it
silently re-couples this library's release model to whatever the apps happen to be tracking.
If a new utility genuinely needs a TCA type, that is a signal the utility belongs in an app,
not here.

## Revisit when

An app migrates to pure `ComposableArchitecture2` and declines to enable the `Dependencies`
trait. At that point `Dep+UserDefaults`, `Dep+OSLogStore`, and `Ext+Date` would drag
swift-dependencies into an app that deliberately shed it, and the answer is a default-on
SwiftPM trait guarding those files — not a target split, and not a return to TCA. Deferred
until a real consumer wants it, because only then will the seam be known.
