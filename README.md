# SnapEdit AI - SwiftUI MVP

## Overview

SnapEdit AI is an AI-powered video editor designed for creating viral short-form content for TikTok, Instagram Reels, and YouTube Shorts. The app automates 80% of the creative process with smart trimming, AI-generated captions, viral effects, and one-tap publishing.

## Features

### Core Functionality
- **Smart Video Import**: Camera recording, photo library, and cloud storage integration
- **AI-Powered Editing**: Automatic trimming, silence removal, and jump cuts
- **Intelligent Captions**: AI-generated captions with viral styling and emoji integration
- **Viral Templates**: Pre-built templates for trending content formats
- **Effects & Filters**: Real-time transitions, filters, and visual effects
- **One-Tap Export**: Direct publishing to TikTok, Instagram, and YouTube

### Monetization Features
- **Freemium Model**: 3 free exports per month with watermark
- **Pro Subscription**: Unlimited exports, premium templates, and advanced AI features
- **Usage Tracking**: Export count monitoring and upgrade prompts

## App Architecture

### Core Components

1. **SnapEditAIApp.swift** - Main app entry point and state management
2. **ContentView.swift** - Navigation controller and main tab interface
3. **OnboardingView.swift** - User onboarding flow with feature introduction
4. **EditorView.swift** - Main video editing interface with AI tools
5. **SupportingViews.swift** - Additional views for templates, profile, and export

### Key Classes

- **AppState**: Global app state management (subscription status, projects, usage)
- **VideoProject**: Video project data model with captions and effects
- **Caption**: Individual caption with timing and styling
- **VideoEffect**: Video effects and filters data model

## Technical Implementation

### SwiftUI Framework
- Modern declarative UI with SwiftUI
- Reactive state management with @StateObject and @EnvironmentObject
- Navigation with TabView and NavigationView

### Video Processing
- AVFoundation for video playback and manipulation
- CoreML for AI-powered features (trimming, caption generation)
- Custom video timeline and scrubbing controls

### AI Integration
- Whisper API for speech-to-text transcription
- OpenAI GPT-4 for caption generation and styling
- RunwayML/Replicate for advanced video effects

## User Experience

### Onboarding Flow
1. Feature introduction with visual demonstrations
2. Value proposition highlighting AI capabilities
3. Free trial offer with premium upgrade option

### Main Workflow
1. **Import**: Record new video or import from library
2. **Edit**: Use AI tools for trimming, captions, and effects
3. **Style**: Apply viral templates and filters
4. **Export**: Choose platform and quality settings
5. **Share**: Direct publishing or save to device

### Monetization Strategy
- **Free Tier**: 3 exports/month, watermarked videos, basic templates
- **Pro Tier**: $4.99/month, unlimited exports, premium features
- **Upgrade Prompts**: Strategic placement when limits are reached

## Development Notes

### Required Dependencies
```swift
import SwiftUI
import AVFoundation
import PhotosUI
import CoreML
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
```

### Key Features to Implement
1. Video import and playback functionality
2. AI caption generation integration
3. Real-time video effects processing
4. Export pipeline with platform optimization
5. Subscription management and payment processing

### Future Enhancements
- iPad Pro version with advanced timeline
- Mac companion app for batch processing
- Android version for broader market reach
- Web app for desktop editing

## Getting Started

1. Open the project in Xcode 15+
2. Configure signing and capabilities
3. Copy `Config.plist.example` to `Config.plist` and add your API keys, **or** create a `.env` file with the same keys.
4. Build and run on iOS 16+ device or simulator

## Running Tests

Run all unit and UI tests using Xcode:

```bash
xcodebuild test -scheme SnapEditAI-Package -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.4'
```

Or open the project in Xcode and press **Cmd+U** to execute the test suite.

## API Integration

### Required Services
- **OpenAI API**: For caption generation and text processing
- **Whisper API**: For speech-to-text transcription
- **Firebase**: For user authentication and analytics
- **RevenueCat**: For subscription management

### Configuration

API credentials are never committed to the repository. The app reads values from `Config.plist`, an optional `.env` file, or environment variables in that order.

1. Copy `Config.plist.example` to `Config.plist` and supply your own values, **or**
2. Create a `.env` file (also ignored by git) with the following keys.

Required keys:

- `OPENAI_API_KEY`
- `WHISPER_API_KEY`
- `FIREBASE_CONFIG`
- `REVENUECAT_KEY`

For Firebase Analytics and Crashlytics:

1. Create a Firebase project and enable Analytics and Crashlytics.
2. Download the `GoogleService-Info.plist` from the Firebase console and add it to the Xcode project.
3. Ensure Crashlytics run scripts are configured when archiving releases.


## Target Market

- **Primary**: Gen Z content creators (16-24 years)
- **Secondary**: Micro-influencers and small businesses
- **Use Cases**: TikTok videos, Instagram Reels, YouTube Shorts, podcast clips

## Competitive Advantage

1. **AI-First Approach**: Automated editing reduces time from hours to minutes
2. **Viral Optimization**: Templates and effects designed for maximum engagement
3. **Mobile-Native**: Optimized for smartphone content creation workflow
4. **Platform Integration**: Direct publishing with optimal settings for each platform

## Revenue Projections

- **Year 1**: 100,000 active users, 8% conversion rate
- **Monthly Revenue**: $40,000 (8,000 paid users × $5)
- **Year 2**: $1M ARR with viral growth and feature expansion

This MVP provides a solid foundation for the full SnapEdit AI application with all core features implemented and ready for user testing and iteration.

# SnapEditAI
