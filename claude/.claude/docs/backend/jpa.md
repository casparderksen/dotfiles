## JPA Conventions

### Field Access

- Annotate fields, not getters (`@Access(AccessType.FIELD)`)
- Hibernate hydrates via reflection — no setters required

### Constructors

- `protected` no-arg constructor for Hibernate only — document as such
- All real constructors enforce invariants and are the intended entry point

### Mutation Control

- No public setters — state changes only through intent-revealing domain methods (e.g. `order.cancel()`,
  `order.addLine(...)`)

### Collections

- Initialised at field declaration
- Never expose raw collection — return unmodifiable view
- Domain methods do surgical `add`/`remove` — never replace the collection reference
- Use `orphanRemoval = true` for children with no meaning outside the parent

### Fetch Strategy

- `FetchType.LAZY` as default on all associations — no accidental over-fetching
- Fetch strategy is explicit per use case at the repository level (`JOIN FETCH` / `@EntityGraph`)
- No reliance on lazy loading as a safety net — fetch decisions are deliberate and inspectable

### Dirty Checking

- Keep entities managed within the transaction — Hibernate detects mutations automatically
- If re-attachment is needed, reload from repository before applying changes

### Accepted Trade-offs

- Hibernate field access bypasses constructor invariants — acceptable as it reconstitutes previously-valid state
- `final` fields avoided on entity state — incompatible with Hibernate field access in practice
- `protected` no-arg constructor is a minor purity compromise — mitigated by access modifier and documentation
