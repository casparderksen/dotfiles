### Architecture

#### General

- Prefer immutable objects (Record and sealed Classes/Interfaces) and functional programming
- Follow Domain-Driven Design (DDD) patterns
- Structure packages in a layered architecture combining Onion, Clean, and Hexagonal architecture  principles
- Domain classes and API contracts evolve independently and must not be coupled.

#### Java package structure

src/main/java/<base-package>/
├── domain/           # Innermost: pure Java, zero framework dependencies
│   ├── model/        # Entities, Value Objects, Aggregates
│   ├── service/      # Domain Services; logic that does not fit on a single entity or aggregate
│   ├── event/        # Domain Events
│   └── port/         # Repository and service interfaces (outbound ports)
├── application/      # Use cases / Application Services (orchestration only)
│   ├── usecase/      # One class per use case; no business logic here
│   └── port/         # Inbound ports (driving side interfaces)
├── infrastructure/   # Implements domain ports; Quarkus/framework code lives here
│   ├── persistence/  # Panache repositories implementing domain port interfaces
│   ├── messaging/    # Kafka producers/consumers
│   └── rest/         # REST clients (MicroProfile, etc.)
└── adapter/          # Driving adapters
    ├── rest/         # JAX-RS resources; map to/from DTOs, call use cases
    └── event/        # Incoming event consumers delegating to use cases

#### Dependency Rule

- Dependencies point inward only: `adapter → application → domain ← infrastructure`.
- The `domain` layer must never import from `application`, `infrastructure`, or `adapter`.
- The `domain` layer must never import Quarkus, Jakarta EE, or any framework annotations.

#### DDD patterns
 
- **Entities**: Have identity (`id`); encapsulate invariants; never expose setters.
- **Value Objects**: Immutable; equality by value; use Java `record` types.
- **Aggregates**: One Entity acts as root; enforce consistency boundaries; only the root is referenced externally.
- **Domain Services**: Stateless logic involving multiple aggregates or external resolution.
- **Domain Events**: Represent facts; named in past tense (`OrderPlaced`, `PaymentFailed`).
- **Repositories**: Interfaces in `domain/port`; return domain objects, not persistence entities.
- **Application Services / Use Cases**: Coordinate domain objects and ports; handle transactions; emit domain events

#### Ports & Adapters (Hexagonal)
 
- **Inbound ports**: Interfaces in `application/port` implemented by use case classes.
- **Outbound ports**: Interfaces in `domain/port` implemented by infrastructure classes.
- **Adapters** never contain business logic; they translate and delegate.

#### Quarkus-Specific Rules
 
- Quarkus annotations (`@ApplicationScoped`, `@Transactional`, `@Inject`, etc.) are allowed 
  only in `application` and `infrastructure` layers, never in `domain`.
- Panache entities or repositories live in `infrastructure/persistence` and implement the domain repository interface.
- CDI injection crosses layers only downward (outer injects inner via interface).
- Use `@Transactional` on Application Service / Use Case methods, not on domain or adapter methods.

#### Mapping Strategy

- Use MapStruct for all cross-boundary mapping; never write manual mapping methods
  unless the transformation contains logic — in which case it belongs in a domain
  service or use case, not a mapper.
- Define one mapper interface per boundary and direction, e.g. `OrderRestMapper`
  (domain ↔ REST DTO), `OrderPersistenceMapper` (domain ↔ JPA entity).
- Mappers live in the layer that owns the non-domain type: REST mappers in
  `adapter/rest`, persistence mappers in `infrastructure/persistence`.
- Annotate all mappers with `@Mapper(componentModel = "cdi")` for CDI injection.
- Mappers must never contain business logic; if a field requires computation or
  a rule, delegate to the domain or use case before mapping.
- Never expose domain classes in REST interfaces; always map to a dedicated
  request/response DTO in `adapter/rest`. Domain classes and API contracts evolve
  independently and must not be coupled.
- Use MapStruct's `nullValueMappingStrategy` and `nullValuePropertyMappingStrategy`
  explicitly on every mapper to avoid inconsistent null handling across the codebase.

#### Anti-patterns to Avoid
 
- Do not put `@Entity` or JPA annotations on domain model classes.
- Do not return JPA/Panache entities from repositories; map to domain objects.
- Do not call repositories directly from REST adapters; always go through a use case.
- Do not expose domain classes in REST op event interfaces; always map to a dedicated request/response
  DTO in `adapter/rest` or `adapter/event`.
- Do not share DTOs between layers; map at each boundary.
- Do not create "god" application services that duplicate domain logic.
