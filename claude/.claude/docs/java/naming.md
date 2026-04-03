### Java Naming Conventions

#### Bounded Context & Packages

- Base package: `<company>.<product>.<boundedcontext>`
  e.g. `com.acme.shop.orders`, `com.acme.shop.payments`
- Package names are lowercase, singular, and map to a bounded context, not a layer.

#### Classes by Layer

| Layer                        | Type                  | Example                                                    |
|------------------------------|-----------------------|------------------------------------------------------------|
| `domain/model`               | Entity                | `Order`, `Customer`, `Payment`                             |
| `domain/model`               | Value Object (record) | `OrderId`, `Money`, `EmailAddress`                         |
| `domain/model`               | Aggregate Root        | Same as Entity — implied by design                         |
| `domain/service`             | Domain Service        | `PricingService`, `OrderAllocationService`                 |
| `domain/event`               | Domain Event          | `OrderPlaced`, `PaymentFailed`, `CustomerActivated`        |
| `domain/port`                | Outbound Port         | `OrderRepository`, `PaymentGateway`, `NotificationService` |
| `application/usecase`        | Use Case              | `PlaceOrderUseCase`, `CancelSubscriptionUseCase`           |
| `application/port`           | Inbound Port          | `PlaceOrderPort`, `CancelSubscriptionPort`                 |
| `application/usecase`        | Command               | `PlaceOrderCommand`, `CancelSubscriptionCommand`           |
| `infrastructure/persistence` | JPA Entity            | `OrderJpaEntity`, `CustomerJpaEntity`                      |
| `infrastructure/persistence` | Repository Impl       | `PanacheOrderRepository`, `PanacheCustomerRepository`      |
| `infrastructure/messaging`   | Producer              | `KafkaOrderEventProducer`                                  |
| `infrastructure/messaging`   | Consumer              | `KafkaPaymentEventConsumer`                                |
| `infrastructure/client`      | REST Client           | `PaymentGatewayClient`, `NotificationClient`               |
| `adapter/rest`               | Resource              | `OrderResource`, `CustomerResource`                        |
| `adapter/rest`               | Request DTO           | `CreateOrderRequestDto`, `UpdateCustomerRequestDto`        |
| `adapter/rest`               | Response DTO          | `OrderResponseDto`, `CustomerSummaryResponseDto`           |
| `adapter/rest`               | Mapper                | `OrderRestMapper`, `CustomerRestMapper`                    |
| `infrastructure/persistence` | Mapper                | `OrderPersistenceMapper`, `CustomerPersistenceMapper`      |

#### Methods

- Use case entry points: verb + noun — `place(PlaceOrderCommand)`, `cancel(CancelSubscriptionCommand)`.
- Repository methods: `findById`, `findAll`, `findByCustomerId`, `save`, `delete` — never `get` or `fetch`.
- Domain behaviour methods: imperative verb expressing intent — `confirm()`, `cancel()`, `allocate()`.
- Factory methods on aggregates: `create` prefix — `Order.create(...)`, or delegate to the
  aggregate root — `customer.createOrder(...)`.
- Avoid generic names: never `process()`, `handle()`, `execute()`, `doSomething()`.

#### Fields & Variables

- Boolean fields and variables: `is` or `has` prefix — `isConfirmed`, `hasPaymentFailed`.
- Collections: plural noun — `lines`, `payments`, `events`; never `list`, `items`, `data`.
- Avoid abbreviations unless universally understood — `id`, `dto`, `url` are acceptable;
  `ord`, `cust`, `svc` are not.

#### Constants & Enums

- Constants: `UPPER_SNAKE_CASE` — `MAX_ORDER_LINES`, `DEFAULT_CURRENCY`.
- Enum values: `UPPER_SNAKE_CASE` — `OrderStatus.PENDING`, `OrderStatus.CONFIRMED`.
- Enum class names: singular noun — `OrderStatus`, `PaymentMethod`, not `OrderStatuses`.

#### Tests

- Test class: `<ProductionClass>Test` — `PlaceOrderUseCaseTest`, `OrderResourceTest`.
- Integration test: `<ProductionClass>IT` — `PlaceOrderIT`.
- Test method: `should_<expectedBehaviour>_when_<condition>`
  e.g. `should_throw_when_order_has_no_lines`
  e.g. `should_return_confirmed_status_when_payment_succeeds`
