## Angular Code Style Conventions

- Angular 17+ control flow syntax (`@if`, `@for`, `@switch`) — never `*ngIf`, `*ngFor`
- Standalone components only — no NgModules unless integrating a legacy library
- All public methods must have JSDoc
- Signals for state management
- `inject()` function for DI — no constructor injection
- Facades wrap store access and are the only thing templates or smart components call directly.
- Never bind raw `Dto` types to templates; always map to a `Vm` first.
- Smart (container) components coordinate data; suffix with nothing — `OrderDetailComponent`.
- Dumb (presentational) components render only; suffix with `-card`, `-list`, `-form` as appropriate.
