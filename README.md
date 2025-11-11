<<<<<<< HEAD
# comics_reader
---

## Overview

This project follows the Clean Architecture pattern with BLoC for state management.
Each feature is structured into three main layers:

* **Data Layer** – implements repositories using local and remote data sources. This layer converts raw data (e.g., JSON, API responses) into domain entities and vice versa. It ensures the domain layer remains unaware of how and where data is fetched.
* **Domain Layer** – defines core entities, repository interfaces, and use cases. This layer is completely independent — it does not depend on external packages, or any specific implementation.
* **Presentation Layer** – handles UI and state using BLoC (events, states, blocs). BLoC pattern is used to clearly separate UI from business logic.

---

## Development Approach

I began with the **domain layer** since it represents the core business logic and has minimal external dependencies.
Next, I built the **data layer**, implementing the repository interfaces and managing data flow.
Finally, I developed the **presentation layer**, connecting the UI with the domain logic through BLoC to ensure reactive, testable, and maintainable code.

---

## Highlights

* Clean Architecture with clear separation of concerns
* Scalable project structure with consistent naming and formatting
* BLoC for predictable and testable state management
* Includes unit and integration testing
* Clean VCS history with meaningful commits


