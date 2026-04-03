### Java / Quarkus Testing Strategy

### General

- All public methods must have Javadoc
- Tests must be written alongside implementation, never deferred

#### Test Types and Location

```
src/test/java/<base-package>/
├── domain/           # Pure unit tests; no mocks of domain internals
├── application/      # Use case tests; mock outbound ports
├── infrastructure/   # Integration tests; real DB via Testcontainers
└── adapter/rest/     # API tests via Quarkus @QuarkusTest + REST-assured
```

#### Rules

- Domain classes must be testable with plain `new` — no Quarkus context, no mocks.
- Use case tests mock only outbound ports (`OrderRepository`, `PaymentGateway`); never
  mock domain objects.
- Never test mappers in isolation unless they contain conditional logic; cover them
  implicitly through adapter or use case tests.
- Use Testcontainers for all infrastructure tests involving a real database or message broker.
- Use `@QuarkusTest` only in `adapter/rest` tests; do not use it for domain or use case tests.
- Use REST-assured for REST adapter tests; assert on HTTP contract (status, headers, body shape),
  not on internal domain state.
- One test class per production class; name it `<ProductionClass>Test`.
- Integration tests that require a running Quarkus instance are suffixed `IT` —
  `PlaceOrderIT` — and run in a separate Maven phase.

#### Coverage Expectations

- `domain/` and `application/`: high coverage expected; logic is pure and easily testable.
- `infrastructure/` and `adapter/`: cover happy path and key failure scenarios;
  exhaustive coverage here has diminishing returns.
