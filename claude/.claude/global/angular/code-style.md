### Angular Conventions

- PascalCase components, camelCase services, kebab-case file names
- Smart (container) components coordinate data; suffix with nothing — `OrderDetailComponent`.
- Dumb (presentational) components render only; suffix with `-card`, `-list`, `-form` as appropriate.
- Facades wrap store access and are the only thing templates or smart components call directly.
- Never bind raw `Dto` types to templates; always map to a `Vm` first.
