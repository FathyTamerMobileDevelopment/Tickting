# 🏗️ Clean Architecture Implementation Guide

## Project Structure Overview

Your Flutter project is now structured with **Clean Architecture**, **MVVM Pattern**, and **Cubit State Management**.

### Complete File Tree
```
lib/
├── features/
│   └── ticketing/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── encryption_service.dart
│       │   ├── models/
│       │   │   ├── station_model.dart (re-export)
│       │   │   └── ticket_model.dart
│       │   └── repositories/
│       │       └── ticket_repository.dart
│       ├── domain/
│       │   ├── models/
│       │   │   └── station_model.dart
│       │   ├── usecases/
│       │   │   ├── usecases.dart (abstract)
│       │   │   └── usecases_impl.dart
│       │   └── service_locator.dart (DI)
│       └── presentation/
│           ├── cubits/
│           │   ├── ticket_cubit.dart (MVVM ViewModel)
│           │   ├── ticket_state.dart
│           │   └── ticket_event.dart
│           └── pages/
│               └── ticket_page.dart (View)
├── core/
│   └── widget/
│       ├── custom_text_field.dart
│       ├── custom_drop_down.dart
│       └── date_picker.dart
└── main.dart
```

---

## 🎯 Layer Responsibilities

### 📊 **Data Layer** (`data/`)
Handles all data operations and external services.

**Files:**
- `encryption_service.dart` - Encrypts ticket QR data
- `ticket_repository.dart` - Implements repository pattern
- `ticket_model.dart` - Data transfer objects
- `station_model.dart` - Re-exports domain model

**Responsibilities:**
- API calls via Dio/Retrofit
- Database operations
- Local storage (SharedPreferences)
- Data encryption/decryption
- Caching

---

### 🎯 **Domain Layer** (`domain/`)
Contains business logic and use cases (independent of frameworks).

**Files:**
- `usecases.dart` - Abstract interface for all use cases
- `usecases_impl.dart` - Concrete implementations
- `station_model.dart` - Domain entities
- `service_locator.dart` - Dependency injection setup

**Key Use Cases:**
```dart
GenerateQrUsecase       // Creates encrypted QR data
CalculateExpDateUsecase // Computes ticket expiration
GenerateTicketIdUsecase // Generates unique ticket IDs
GetStationsUsecase      // Fetches station list
GetDestinationStationUsecase // Calculates destination
```

---

### 🎨 **Presentation Layer** (`presentation/`)
Handles UI and state management (MVVM pattern).

**Cubit (ViewModel equivalent):**
```dart
class TicketCubit extends Cubit<TicketState>
```

**State Management:**
```dart
TicketState {
  ticketId,
  stationCount,
  encryptionKey,
  issueDate,
  expDate,
  qrData,
  isLoading,
  error,
  stations,
  selectedStation,
  destinationStation
}
```

**UI Page:**
- `ticket_page.dart` - Displays form and QR ticket
- Listens to Cubit state changes
- Triggers Cubit methods on user action

---

## 🔄 Data Flow (MVVM)

```
┌─────────────────────────────────────────────────┐
│         Presentation Layer (View)              │
│                                                │
│  StatefulWidget / BlocBuilder                 │
│  - Renders UI                                 │
│  - Listens to state changes                   │
│  - Triggers user actions                      │
└────────────┬──────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│   Presentation Layer (ViewModel - Cubit)       │
│                                                │
│  TicketCubit                                  │
│  - Manages state (TicketState)               │
│  - Orchestrates use cases                    │
│  - Handles business logic calls              │
│  - Emits state updates                       │
└────────────┬──────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│          Domain Layer (Use Cases)              │
│                                                │
│  - GenerateQrUsecase                         │
│  - CalculateExpDateUsecase                   │
│  - GenerateTicketIdUsecase                   │
│  - GetStationsUsecase                        │
│  - GetDestinationStationUsecase              │
└────────────┬──────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│        Data Layer (Repository)                 │
│                                                │
│  TicketRepository                            │
│  - Data operations                           │
│  - Business rule implementations             │
│  - Encryption/Decryption                     │
└────────────┬──────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│   Data Layer (Services & Data Sources)        │
│                                                │
│  - EncryptionService                         │
│  - API Calls                                 │
│  - Local Storage                             │
│  - Database                                  │
└─────────────────────────────────────────────────┘
```

---

## 🚀 How to Use

### 1. **Adding a New Feature**

Create new feature folder:
```
lib/features/my_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── models/
│   ├── repositories/ (abstracts)
│   └── usecases/
└── presentation/
    ├── cubits/
    └── pages/
```

### 2. **Creating a New Use Case**

```dart
// domain/usecases/my_usecase.dart
abstract class MyUsecase {
  Future<Result> call(Params params);
}

// domain/usecases/my_usecase_impl.dart
class MyUsecaseImpl implements MyUsecase {
  final MyRepository repository;
  
  MyUsecaseImpl({required this.repository});
  
  @override
  Future<Result> call(Params params) async {
    return await repository.doSomething(params);
  }
}
```

### 3. **Creating a New Cubit (ViewModel)**

```dart
// presentation/cubits/my_cubit.dart
class MyCubit extends Cubit<MyState> {
  final MyUsecase myUsecase;
  
  MyCubit({required this.myUsecase}) : super(const MyState());
  
  Future<void> doAction(String param) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await myUsecase(param);
      emit(state.copyWith(data: result, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
```

### 4. **Updating Service Locator**

```dart
// domain/service_locator.dart
void setup() {
  // Register repositories
  _myRepository = MyRepositoryImpl();
  
  // Register use cases
  _myUsecase = MyUsecaseImpl(repository: _myRepository);
  
  // Register cubits
  _myCubit = MyCubit(myUsecase: _myUsecase);
}
```

---

## ✅ Build & Deployment

### Commands

```bash
# Get dependencies
flutter pub get

# Run analyzer
flutter analyze

# Build APK (Android)
flutter build apk --release

# Build iOS
flutter build ios --release

# Run on device
flutter run
```

### Current Build Status
- ✅ No critical errors
- ✅ Dependencies installed
- ✅ Type-safe implementation
- ✅ Proper separation of concerns

---

## 📚 Best Practices Implemented

1. **Separation of Concerns** - Each layer has clear responsibilities
2. **Dependency Injection** - ServiceLocator manages dependencies
3. **Single Responsibility** - Each class has one reason to change
4. **Open/Closed Principle** - Open for extension, closed for modification
5. **Type Safety** - Strong typing throughout
6. **Error Handling** - Proper error management with error states
7. **Immutability** - States are immutable with copyWith pattern
8. **Testability** - Each layer can be tested independently

---

## 🔧 Common Tasks

### Adding a new button action
1. Add method to Cubit
2. Update State if needed
3. Call Cubit method from UI
4. UI listens to state changes

### Handling API errors
1. Use try-catch in use case
2. Emit error state from Cubit
3. Display error message in UI

### Storing local data
1. Add method to Repository
2. Implement in RepositoryImpl
3. Use SharedPreferences in DataSource
4. Call from Use Case

---

## 📖 Useful Links

- **Flutter Bloc**: https://bloclibrary.dev
- **Clean Architecture**: https://resocoder.com/clean-code
- **MVVM Pattern**: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel
- **Dart Dependency Injection**: https://dart.dev

---

## 💡 Tips

- Keep domain layer framework-agnostic
- Don't let UI layer access data layer directly
- Use repositories as single point of data access
- Keep Cubit methods focused and testable
- Name use cases with verb (Generate, Calculate, Get)

---

**Your project is fully converted and ready for production!** 🎉

