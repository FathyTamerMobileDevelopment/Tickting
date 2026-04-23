# Clean Architecture with MVVM & Cubit

## Project Structure

```
lib/
├── features/
│   └── ticketing/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── encryption_service.dart      # Service for data encryption
│       │   ├── models/
│       │   │   ├── station_model.dart           # Data layer model
│       │   │   └── ticket_model.dart            # Data layer model
│       │   └── repositories/
│       │       └── ticket_repository.dart       # Repository implementation
│       ├── domain/
│       │   ├── models/
│       │   │   └── station_model.dart           # Domain entity
│       │   ├── usecases/
│       │   │   ├── usecases.dart                # Abstract use cases
│       │   │   └── usecases_impl.dart           # Use case implementations
│       │   └── service_locator.dart             # Dependency injection
│       └── presentation/
│           ├── cubits/
│           │   ├── ticket_cubit.dart            # State management (Cubit)
│           │   ├── ticket_state.dart            # State definitions
│           │   └── ticket_event.dart            # Event definitions
│           └── pages/
│               └── ticket_page.dart             # UI Page (MVVM View)
├── core/
│   └── widget/
│       ├── custom_text_field.dart               # Reusable widgets
│       ├── custom_drop_down.dart                # Reusable widgets
│       └── date_picker.dart                     # Reusable widgets
└── main.dart                                     # App entry point

```

## Architecture Layers

### 1. Data Layer (`data/`)
- Handles data sources and persistence
- Contains models for API responses
- Implements repository interfaces
- Manages encryption services

### 2. Domain Layer (`domain/`)
- Business logic and use cases
- Defines abstract repositories
- Contains domain entities
- Dependency injection setup

### 3. Presentation Layer (`presentation/`)
- UI Components (Pages)
- Cubit for state management (MVVM ViewModel)
- Handles user interactions
- Manages UI state

## Technology Stack

- **State Management**: Flutter Bloc (Cubit)
- **Dependency Injection**: Service Locator pattern
- **Encryption**: Encrypt package
- **HTTP**: Dio + Retrofit
- **Storage**: SharedPreferences
- **UI**: Flutter ScreenUtil, Gap
- **Date/Time**: Intl package

## Flow

```
User Interaction (UI)
        ↓
    Cubit (ViewModel)
        ↓
    Use Cases
        ↓
    Repository
        ↓
    Data Sources / Encryption Service
        ↓
    Return Data → Update State → UI Rebuild
```

## Key Features

✅ Clean Architecture separation of concerns
✅ MVVM pattern with Cubit state management
✅ Dependency injection with ServiceLocator
✅ Reusable widgets
✅ Error handling
✅ Encryption support
✅ Type-safe data models
✅ Responsive UI with ScreenUtil

