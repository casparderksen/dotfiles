### Java / Quarkus Standards

#### General

- Prefer interfaces of specifications (Jakarta EE, MicroProfile) over implementations
- Use CDI (`@ApplicationScoped`, `@RequestScoped`) — never `new`
- Prefer `@QuarkusTest` + REST Assured for integration tests
- Use Mutiny for reactive patterns; avoid raw CompletableFuture where Mutiny applies
- Application config via `@ConfigMapping` interfaces, not raw `@ConfigProperty` on classes
- Native image compatibility: register reflection in `@RegisterForReflection` or `reflect-config.json`
- API: RESTEasy Reactive with OpenAPI spec (include annotations for documentation)
- Auth: OIDC / Oauth2

#### Database

- Flyway for database migrations
- Database: H2 in memory for testing

#### Maven builds

- Portable maven builds
- plugin and dependency versions in central property list
