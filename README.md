# Snaply: Quick Edits, Stunning Results

Snaply is a cutting-edge image editing app powered by AI that allows users to quickly transform their photos with stunning results. Built using Flutter, Snaply leverages the latest in AI image generation technology via Google's Gemini 2.0 Flash native image generation API. With in-app purchases to unlock premium features and effortless sharing to social media platforms like Instagram, TikTok, and Facebook, Snaply makes photo editing fun and accessible—without the hassle of login or signup.

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
- **Implementation:** Utilizes Flutter’s in-app purchase plugins to ensure a secure and smooth transaction process.
- **No Account Needed:** Users can purchase premium features without creating an account.

## Social Media Sharing

Snaply integrates with the native sharing functionalities of mobile devices, allowing users to quickly share their edited images on:

- **Instagram**
- **TikTok**
- **Facebook**

Ensure that the relevant social media apps are installed on your device for a seamless sharing experience.

## License

This project is licensed under the [MIT License](LICENSE).
