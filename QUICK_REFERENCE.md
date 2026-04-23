# 🚀 Quick Reference

## File Locations

### 📦 Data Layer
```
lib/features/ticketing/data/
├── datasources/encryption_service.dart
├── models/
│   ├── station_model.dart
│   └── ticket_model.dart
└── repositories/ticket_repository.dart
```

### 🎯 Domain Layer  
```
lib/features/ticketing/domain/
├── models/station_model.dart
├── usecases/
│   ├── usecases.dart
│   └── usecases_impl.dart
└── service_locator.dart
```

### 🎨 Presentation Layer
```
lib/features/ticketing/presentation/
├── cubits/
│   ├── ticket_cubit.dart
│   ├── ticket_state.dart
│   └── ticket_event.dart
└── pages/ticket_page.dart
```

---

## Key Classes

### TicketCubit (ViewModel)
- **Location**: `presentation/cubits/ticket_cubit.dart`
- **Methods**: initializeTicket, selectStation, generateQR, etc.
- **State**: TicketState (immutable with copyWith)

### TicketRepository
- **Location**: `data/repositories/ticket_repository.dart`
- **Contains**: 44 stations, date calculations, QR generation

### Use Cases (5)
- **Location**: `domain/usecases/usecases_impl.dart`
- GenerateQrUsecase
- CalculateExpDateUsecase
- GenerateTicketIdUsecase
- GetStationsUsecase
- GetDestinationStationUsecase

### ServiceLocator (DI)
- **Location**: `domain/service_locator.dart`
- Singleton pattern
- Registers all dependencies once at app startup

---

## UI Entry Point

- **File**: `lib/main.dart`
- **Setup**: ServiceLocator().setup() in main()
- **Provider**: BlocProvider<TicketCubit>
- **Home**: TicketPage()

---

## Testing Commands

```bash
# Analyze code
flutter analyze

# Get dependencies
flutter pub get

# Check specific file
dart analyze lib/main.dart

# Run on device
flutter run
```

---

## State Flow

```
TicketPage (UI)
    ↓ (listens)
TicketState (state object)
    ↑ (emits)
TicketCubit (ViewModel)
    ↓ (calls)
Use Cases
    ↓ (uses)
Repository
    ↓ (uses)
Data Sources/Encryption
```

---

## Common Operations

### Change Ticket ID
```dart
context.read<TicketCubit>().updateTicketId("new_id");
```

### Select Station
```dart
context.read<TicketCubit>().selectStation(stationModel);
```

### Generate QR
```dart
context.read<TicketCubit>().generateQR();
```

### Listen to State
```dart
BlocBuilder<TicketCubit, TicketState>(
  builder: (context, state) {
    return Text(state.qrData);
  },
);
```

---

## 12 Files Created

| # | File | Purpose |
|---|------|---------|
| 1 | encryption_service.dart | AES encryption |
| 2 | ticket_repository.dart | Repository impl |
| 3 | ticket_model.dart | Data model |
| 4 | station_model.dart | Domain entity |
| 5 | service_locator.dart | DI container |
| 6 | usecases.dart | Abstract interfaces |
| 7 | usecases_impl.dart | Implementations |
| 8 | ticket_cubit.dart | ViewModel |
| 9 | ticket_state.dart | State class |
| 10 | ticket_event.dart | Events |
| 11 | ticket_page.dart | UI Page |
| 12 | main.dart | Entry point |

---

## ✅ Status

- **Build**: ✅ Passing
- **Errors**: ✅ None
- **Type Safe**: ✅ Yes
- **DI Setup**: ✅ Complete
- **Ready**: ✅ Production

---

Done! 🎉

