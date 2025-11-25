# PantryPal 🥫

<p align="center">
  <img src="https://img.shields.io/badge/iOS-18.2+-blue.svg" alt="iOS 18.2+">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/SwiftUI-5.0-green.svg" alt="SwiftUI 5.0">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="MIT License">
</p>

A beautifully designed iOS app to track pantry items and prevent food waste by managing expiration dates with smart notifications and intuitive UI.

## ✨ Features

### 🎯 Core Functionality
- **Smart Item Management** - Add, edit, and delete pantry items with ease
- **Expiration Tracking** - Visual indicators for items expiring soon, today, or already expired
- **Intelligent Notifications** - Automatic reminders 3 days and 1 day before expiration (at 9:00 AM)
- **Dual View Modes** - Dashboard with cards and List view with detailed information
- **Fast Search** - Quickly find items by name or category
- **Dark Mode Support** - Toggle between light and dark themes

### 🎨 Enhanced UI/UX
- **Beautiful Animations** - Smooth spring animations and transitions
- **Haptic Feedback** - Tactile responses for all interactions
- **Category Emojis** - Visual identification with 🥛 🥩 🥬 🍞 💊 💄 icons
- **Color-Coded Status** - Red (expired), Orange (≤3 days), Yellow (≤7 days), Green (fresh)
- **Swipe Actions** - Quick edit and delete with intuitive gestures
- **Context Menus** - Long-press for additional options
- **Empty States** - Helpful guidance when no items exist

### 📊 Dashboard View
- **Statistics Cards** - Total items, expired, expiring soon, and fresh counts
- **Visual Grid** - Beautiful cards with gradient accents and shadows
- **Tap to Edit** - Quick access to edit item details
- **Theme Toggle** - Switch between light and dark modes instantly

### 📋 List View
- **Organized Sections** - Separate "Expiring Soon" and "Fresh Items"
- **Rich Details** - Category, location, quantity, and expiry date
- **Swipe Gestures** - Swipe left for edit/delete actions
- **Native Search** - Built-in iOS search bar with live filtering

### 📝 Add/Edit Form
- **Predefined Categories** - 7 categories (Dairy, Meat, Vegetables, Bakery, Medicine, Cosmetics, Other)
- **Location Presets** - 5 storage locations (Pantry, Fridge, Freezer, Cabinet, Counter)
- **Graphical Date Picker** - Easy-to-use calendar interface
- **Real-time Countdown** - See days until expiration while selecting dates
- **Smart Validation** - Helpful warnings for expired dates

## 📱 Screenshots
  <img width="250" height="500" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-25 at 22 13 37" src="https://github.com/user-attachments/assets/ac863ffc-4a72-4a92-83ff-9536ce3f4d61" />                     <img width="250" height="500" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-25 at 22 19 17" src="https://github.com/user-attachments/assets/cce123e6-d0fc-4bb5-be15-1315315b2e68" />                     <img width="250" height="500" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-25 at 21 37 44" src="https://github.com/user-attachments/assets/067ef153-c0b5-4549-9ea8-2ad9e2cad791" />                    <img width="250" height="500" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-25 at 21 38 06" src="https://github.com/user-attachments/assets/00e01aad-a013-4556-b47f-7d511c412fa3" />


## 🚀 Getting Started

### Prerequisites
- **Xcode 16.0+** with Swift 6.0
- **iOS 18.2+** deployment target
- **Apple Developer Account** (for device testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/PantryPall.git
   cd PantryPall
   ```

2. **Open the project**
   ```bash
   open PantryPall.xcodeproj
   ```

3. **Configure signing**
   - Select the `PantryPall` target
   - Go to **Signing & Capabilities**
   - Select your development team
   - Update the bundle identifier if needed

4. **Build and run**
   - Select a simulator or connected device
   - Press `Cmd + R` to build and run
   - Grant notification permissions when prompted

## 🏗️ Architecture

### Project Structure
```
PantryPall/
├── Models/
│   └── PantryItem.swift          # SwiftData model for items
├── ViewModels/
│   └── PantryViewModel.swift     # Business logic layer
├── Views/
│   ├── MainTabView.swift         # Tab container
│   ├── PantryDashboardView.swift # Dashboard with cards
│   ├── PantryListView.swift      # List view
│   ├── AddEditItemView.swift     # Add/Edit form
│   └── EmptyStateView.swift      # Empty state component
├── Services/
│   └── NotificationService.swift # Notification handling
├── Previews/
│   └── PreviewSupport.swift      # Preview helpers
└── Assets.xcassets/              # Images and colors
```

### Design Patterns
- **MVVM** - Clear separation of concerns
- **SwiftData** - Modern data persistence
- **Combine** - Reactive state management
- **Async/Await** - Modern concurrency for notifications

## 💻 Technical Details

### Technologies Used
- **SwiftUI** - Declarative UI framework
- **SwiftData** - Data persistence and modeling
- **UserNotifications** - Local notification scheduling
- **WidgetKit** - Home screen widget (planned)
- **AppIntents** - Siri shortcuts (planned)

### Key Features Implementation

#### Data Model
```swift
@Model
final class PantryItem {
    var id: UUID
    var name: String
    var category: String
    var quantity: Int
    var location: String
    var expiryDate: Date
    var createdAt: Date
    var updatedAt: Date
    
    var daysLeft: Int { /* calculated */ }
    var isExpired: Bool { /* computed */ }
    var isNearExpiry: Bool { /* computed */ }
}
```

#### Notification Service
- Schedules notifications 3 days and 1 day before expiration
- Automatically cancels notifications when items are deleted
- Includes item metadata for future action handling

#### UI Components
- Custom animations with spring physics
- Haptic feedback generators for tactile responses
- Material backgrounds and glassmorphism effects
- Adaptive layouts for all iPhone sizes

## 🎓 Usage Guide

### Adding Items
1. Tap the **+** button in the toolbar
2. Enter item name (required)
3. Select category from the picker (with emojis)
4. Choose storage location
5. Set quantity using the stepper
6. Pick expiry date from the calendar
7. Tap **Add** to save

### Editing Items
**From Dashboard:**
- Tap any card to edit
- Or tap the menu (⋯) and select "Edit"

**From List:**
- Swipe left on an item
- Tap the blue "Edit" button

### Deleting Items
**From Dashboard:**
- Tap the menu (⋯) on a card
- Select "Delete"

**From List:**
- Swipe left on an item
- Tap the red "Delete" button

### Searching Items
- Pull down on the list view to reveal the search bar
- Type to filter by name or category
- Results update in real-time

### Dark Mode
- Tap the sun/moon icon in the dashboard header
- Setting persists across app launches
- Overrides system theme preference

## 📚 Documentation

Comprehensive code documentation is available in:
- **[IMPROVEMENTS.md](IMPROVEMENTS.md)** - Full analysis, improvements, and roadmap
- **DocC Comments** - All major classes and methods are documented
- **Inline Comments** - Complex logic sections explained

### API Documentation
Generate documentation using DocC:
```bash
xcodebuild docbuild -scheme PantryPall \
  -destination 'generic/platform=iOS Simulator'
```

## 🧪 Testing

### Manual Testing
1. **Add Items** - Create items with various expiry dates
2. **Edit Items** - Modify existing items
3. **Delete Items** - Remove items and verify notification cancellation
4. **Search** - Test search functionality with different queries
5. **Notifications** - Wait for scheduled notifications or test with items expiring soon
6. **Dark Mode** - Toggle and verify UI appearance
7. **Empty State** - Delete all items to see empty state

### Build & Run Tests
```bash
xcodebuild -project PantryPall.xcodeproj \
  -scheme PantryPall \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  clean build
```

## 🗺️ Roadmap

### Version 2.0 (Planned)
- [ ] **iCloud Sync** - Sync items across devices
- [ ] **Widget** - Home screen widget with near-expiry count
- [ ] **Barcode Scanner** - Scan products to auto-fill information
- [ ] **Statistics** - Track food waste and savings

### Version 2.1 (Future)
- [ ] **Shopping List** - Convert expiring items to shopping list
- [ ] **Recipe Suggestions** - Get recipe ideas for expiring items
- [ ] **Family Sharing** - Share pantry with family members
- [ ] **Export/Import** - CSV and JSON support

### Version 3.0 (Vision)
- [ ] **AI Integration** - Smart categorization and suggestions
- [ ] **Photo Recognition** - Identify products from photos
- [ ] **Apple Watch** - Quick view on your wrist
- [ ] **Mac Catalyst** - Native macOS version

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'feat: add some amazing feature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Commit Convention
Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Arief Catur**
- GitHub: [@ariefcatur](https://github.com/ariefcatur)
- Email: muhammadariefcp@gmail.com

## 🙏 Acknowledgments

- **SwiftUI** - Apple's declarative UI framework
- **SwiftData** - Modern data persistence
- **Factory Droid** - AI assistance for code improvements
- **SF Symbols** - Beautiful system icons

## 📞 Support

If you have any questions or need help:
- **Open an issue** on GitHub
- **Email** the author
- **Check documentation** in IMPROVEMENTS.md

## ⭐ Star History

If you find this project useful, please consider giving it a star! ⭐

---

**Made with ❤️ using SwiftUI and SwiftData**

*Last Updated: November 25, 2025*
