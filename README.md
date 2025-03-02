# Trending Videos App

A cross-platform mobile application that aggregates trending videos from various social media platforms like YouTube, Instagram, Facebook, Twitter, and TikTok.

## Features

1. **Unified Platform**: View trending videos from multiple social media platforms in one place
2. **Geographic Filtering**: 
   - Country-wide top 10 most viewed videos from each platform
   - State/region-wise top 10 most viewed videos
3. **Content Analysis**: 
   - Top 3 content videos by analyzing video content
   - Country-wide and state/region-wise analysis

## Technology Stack

- **Kivy**: Python framework for cross-platform mobile applications
- **Buildozer**: Packaging tool for creating Android APKs
- **GitCloud**: For CI/CD and automated builds

## Setup Development Environment

1. Install Python 3.8+ and pip
2. Install required packages:
   ```
   pip install kivy pillow requests
   ```
3. For development, run:
   ```
   python main.py
   ```

## Building the APK

### Using Buildozer Locally

1. Install buildozer:
   ```
   pip install buildozer
   ```
2. Initialize buildozer (already done in this repo):
   ```
   buildozer init
   ```
3. Build the APK:
   ```
   buildozer android debug
   ```

### Using GitCloud

1. Commit your changes:
   ```
   git add .
   git commit -m "Your commit message"
   git push origin main
   ```
2. GitCloud will automatically build the APK based on the buildozer.spec file

## Project Structure

- `main.py`: Main application entry point
- `buildozer.spec`: Configuration for building the Android APK
- `.gitignore`: Git ignore file

## License

This project is licensed under the MIT License - see the LICENSE file for details.