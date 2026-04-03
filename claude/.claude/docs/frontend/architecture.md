### Angular Standards

#### General

- Angular 17+ control flow syntax (`@if`, `@for`, `@switch`) — never `*ngIf`, `*ngFor`
- Standalone components only — no NgModules unless integrating a legacy library
- Signals for state management
- `inject()` function for DI — no constructor injection
- All public methods must have JSDoc

#### Angular Project Structure

Follow a feature-based folder structure aligned with bounded contexts.
Each feature module is self-contained and maps to a single bounded context.

src/app/
├── core/                  # Singleton services, app-wide guards, interceptors
│   ├── auth/
│   └── http/
├── shared/                # Reusable dumb components, pipes, directives
│   ├── components/
│   └── pipes/
├── features/              # One folder per bounded context / feature
│   ├── feature1/         
│   │   ├── data-access/   # NgRx store, effects, selectors, API services
│   │   ├── ui/            # Smart (container) and dumb (presentational) components
│   │   └── util/          # Feature-specific pipes, helpers, validators
│   └── feature2/
│       ├── data-access/
│       ├── ui/
│       └── util/
└── app.routes.ts

- `core/` is imported once in `AppModule` or `app.config.ts`; never in feature modules.
- `shared/` must contain no business logic; components are dumb and input/output driven.
- Feature modules must not import from other feature modules directly; communicate via
  router or shared state.
- API response types live in `data-access/`; never reuse backend types in templates directly —
  map to view models first.
