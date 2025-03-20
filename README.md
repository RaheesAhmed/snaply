# Snaply: Quick Edits, Stunning Results

A premium, minimalistic Flutter app for AI-powered image editing, leveraging Google's Gemini 2.0 Flash API.

## About Snaply

Snaply is a cutting-edge image editing application that combines the power of artificial intelligence with an elegant, user-friendly interface. The app allows users to make quick edits to their images while delivering stunning, professional-quality results.

## Design Philosophy

Snaply's UI is built on a foundation of premium minimalism, featuring:

- **Clean aesthetics** with refined neutrals and elegant accent colors
- **Ample whitespace** for an uncluttered, sophisticated feel
- **Intuitive interactions** that provide clear visual feedback
- **Responsive layouts** that adapt seamlessly to various device sizes

## Key Features

- **AI-Powered Editing**: Utilize Google's Gemini 2.0 Flash API for intelligent image enhancement
- **Chatbot Interface**: Interact conversationally with the AI for natural editing workflows
- **Premium Experience**: Enjoy a sophisticated, high-end design that elevates the editing process
- **Responsive Design**: Access a consistent experience across all mobile devices

## UI Components

The app's design system includes:

- A comprehensive color palette with primary, secondary, and tertiary accents
- Typography hierarchy using Poppins (for headings) and Inter (for body text)
- Custom UI components including buttons, cards, and form elements
- Consistent spacing and layout principles

## Development

### Dependencies

- Flutter
- google_fonts
- flutter_animate
- flutter_svg
- provider
- shared_preferences

### Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app

## Design Documentation

For detailed information about the UI design system, refer to the [Snaply UI Theme Guide](lib/theme/snaply_theme_guide.md).

## Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [API Integration](#api-integration)
- [Installation](#installation)
- [Usage](#usage)
- [In-App Purchases](#in-app-purchases)
- [Social Media Sharing](#social-media-sharing)
- [License](#license)

## Features

- **Quick and Intuitive Edits:** Rapidly transform images with our AI-driven editing engine.
- **Stunning Results:** Achieve professional-quality photo enhancements.
- **In-App Purchases:** Unlock premium features and advanced editing tools.
- **Seamless Social Sharing:** Share your creations directly to Instagram, TikTok, and Facebook.
- **No Login/Signup:** Enjoy a frictionless user experience without the need to register.

## Technology Stack

- **Framework:** [Flutter](https://flutter.dev/) for cross-platform mobile development.
- **Programming Language:** Dart.
- **AI Integration:** Google's Gemini 2.0 Flash native image generation API  
  (Learn more at: [Google Developers Blog](https://developers.googleblog.com/en/experiment-with-gemini-20-flash-native-image-generation/)).
- **In-App Purchases:** Integrated via Flutter plugins to enable secure transactions.
- **Social Sharing:** Utilizes native sharing capabilities of mobile platforms for Instagram, TikTok, and Facebook.

## API Integration

Snaply leverages the advanced image generation capabilities provided by Google's Gemini 2.0 Flash native image generation API. This integration enables:

- **AI-Powered Enhancements:** Apply creative and transformative edits using state-of-the-art AI.
- **Customizable Effects:** Experiment with various parameters to produce unique and appealing results.

For more detailed documentation, refer to the [Gemini 2.0 Flash API documentation](https://developers.googleblog.com/en/experiment-with-gemini-20-flash-native-image-generation/).

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/raheesahmed/snaply.git
   cd snaply
   ```
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Set Up API Keys:**

   - Follow the instructions provided by the Gemini 2.0 Flash API documentation to obtain your API key.
   - Add your API key to the appropriate configuration file or environment variables.

4. **Run the App:**
   ```bash
   flutter run
   ```

## Usage

1. **Editing Images:**

   - Launch the app and select an image from your gallery.
   - Apply a variety of quick edits powered by AI.
   - Preview the results in real-time.

2. **Unlock Premium Features:**

   - Use the in-app purchase mechanism to unlock additional editing tools and effects.
   - Follow the in-app prompts to complete your purchase.

3. **Share Your Creation:**
   - Once satisfied with your edit, use the share button to post your image directly to Instagram, TikTok, or Facebook.

## In-App Purchases

- **Premium Features:** Additional filters, advanced editing options, and exclusive effects.
- **Implementation:** Utilizes Flutter's in-app purchase plugins to ensure a secure and smooth transaction process.
- **No Account Needed:** Users can purchase premium features without creating an account.

## Social Media Sharing

Snaply integrates with the native sharing functionalities of mobile devices, allowing users to quickly share their edited images on:

- **Instagram**
- **TikTok**
- **Facebook**

Ensure that the relevant social media apps are installed on your device for a seamless sharing experience.

## License

This project is licensed under the [MIT License](LICENSE).
