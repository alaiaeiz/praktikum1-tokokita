# TokoKita

**A Flutter-based mobile e-commerce application currently under development.**

TokoKita is a mobile application project focused on building a simple e-commerce experience. It is being developed using Flutter and Dart, with features for browsing products, viewing product details, managing a shopping cart, and exploring a basic checkout flow.

> **Project Status:** In Development — Early Stage

## Overview

TokoKita is an ongoing development project created as part of a practical programming course. The project aims to explore mobile application development concepts, UI implementation, API integration, navigation, and basic state management using Flutter.

The application is still evolving, and some features currently use simplified or temporary implementations.

## Current Features

- **Product Catalog** — Displays products retrieved from an external API.
- **Product Details** — Shows product information, including name, price, category, and description.
- **Shopping Cart** — Supports adding products, updating quantities, and removing items.
- **Cart Summary** — Calculates the total number of items and shopping cost.
- **Checkout Flow** — Provides a basic checkout summary and simulated payment interaction.
- **User Profile** — Displays a basic user profile interface.
- **Favorite Interaction** — Allows users to toggle product favorites locally.

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile UI framework |
| Dart | Application programming language |
| GetX | Navigation and reactive state management |
| HTTP | API communication |
| Intl | Internationalization and formatting utilities |
| Fake Store API | External product data source |

## Project Structure

```text
lib/
├── controllers/
│   └── cart_controller.dart
├── models/
│   ├── cart_item.dart
│   └── product.dart
├── screens/
│   ├── cart_page.dart
│   ├── checkout_page.dart
│   ├── home_page.dart
│   ├── main_page.dart
│   ├── product_detail_page.dart
│   └── profile_page.dart
├── services/
│   └── product_service.dart
├── widgets/
│   └── product_card.dart
└── main.dart
```

## Getting Started

### Prerequisites

Make sure you have installed:

- Flutter SDK
- Dart SDK (included with Flutter)
- Android Studio or Visual Studio Code
- An Android emulator or physical device

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/alaiaeiz/praktikum1-tokokita.git
   ```

2. Navigate to the project directory:

   ```bash
   cd praktikum1-tokokita
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## Current Limitations

As the project is still in its early development stage, several parts have not been fully implemented:

- Product data is retrieved from an external API.
- Product stock values are currently assigned as sample data.
- Shopping cart data is stored temporarily in application memory.
- Checkout and payment are simulated; no real payment processing is implemented.
- Favorite interactions are currently local and not persisted.
- Search interface is present but its search functionality is not yet implemented.
- User profile information is currently static.

## Development Roadmap

The following items represent potential improvements as development continues:

- [ ] Improve application UI and user experience.
- [ ] Implement functional product search.
- [ ] Improve product and cart state management.
- [ ] Add persistent local storage for cart and favorite data.
- [ ] Develop a more complete user profile feature.
- [ ] Improve checkout flow and validation.
- [ ] Explore backend integration and database support.
- [ ] Add application screenshots and testing documentation.

## Project Status

TokoKita is an ongoing project. Features, architecture, and implementation details may change as development progresses.

This repository serves as a record of the development process and learning experience in building a Flutter-based mobile application.

---

**Built with Flutter and Dart.**
