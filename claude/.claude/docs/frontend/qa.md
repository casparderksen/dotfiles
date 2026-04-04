## Angular Testing Strategy

### Test Types

| Type        | Tool                    | Scope                                       |
|-------------|-------------------------|---------------------------------------------|
| Unit        | Jest                    | Components, services, pipes, facades, store |
| Integration | Angular Testing Library | Smart components with store wired           |
| E2E         | Playwright              | Critical user journeys only |

### Rules

- Dumb components: test inputs, outputs, and rendered output only; no store, no services.
- Smart components: test via Angular Testing Library with a real store; mock only API services.
- Facades: test state transitions via store selectors; mock effects.
- API services: mock `HttpClient` with `HttpTestingController`; assert on URL, method, and
  payload shape — not on mapped result.
- Never test NgRx reducers indirectly; test them as pure functions directly.
- Never bind raw `Dto` types to templates; tests should reflect `Vm` types throughout.
- E2E tests cover journeys, not components — do not duplicate unit test scenarios in Playwright.
- One `.spec.ts` file per production file; colocate with the file under test.

### Naming

- Unit tests: `order-list.component.spec.ts`, `order-facade.service.spec.ts`
- E2E tests: `place-order.e2e.ts`, `cancel-subscription.e2e.ts` — named after user journeys.

### Coverage Expectations

- `shared/` components and pipes: high coverage; they are pure and reused widely.
- `data-access/`: cover reducers and selectors thoroughly; effects via integration tests.
- `ui/` smart components: cover via integration tests, not unit tests.
- E2E: cover only the most critical and stable journeys to avoid brittle test suites.
