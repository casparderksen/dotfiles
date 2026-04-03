### Angular Naming Conventions

#### Files

- Components:  `order-list.component.ts`
- Services:    `order-api.service.ts`, `order-facade.service.ts`
- Store:       `order.store.ts`, `order.effects.ts`, `order.selectors.ts`
- Models:      `order.model.ts` (domain/view model), `order.dto.ts` (API response shape)
- Routes:      `order.routes.ts`

#### Classes & Interfaces

- Components:  `OrderListComponent`
- Services:    `OrderApiService`, `OrderFacadeService`
- Interfaces:  prefix with `I` only for injectables; use plain names for models (`Order`, `Customer`)
- View models: suffix with `Vm` — `OrderSummaryVm`, `CustomerDetailVm`
- DTOs:        suffix with `Dto` — `OrderResponseDto`, `CreateOrderDto`
