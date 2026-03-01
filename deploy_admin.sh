#!/bin/bash

# Admin App Deployment Script
# Usage: ./deploy_admin.sh

echo "=========================================="
echo "Admin App Deployment Script"
echo "=========================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter found"
echo ""

# Navigate to admin_app directory
cd admin_app || exit

echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🔨 Building for web (release mode)..."
flutter build web --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "Choose deployment option:"
    echo "1) Firebase Hosting"
    echo "2) Vercel"
    echo "3) Manual (build/web folder ready)"
    echo ""
    read -p "Enter option (1-3): " option

    case $option in
        1)
            echo ""
            echo "🚀 Deploying to Firebase..."
            if command -v firebase &> /dev/null; then
                firebase deploy --only hosting
                echo ""
                echo "✅ Deployed to Firebase!"
            else
                echo "❌ Firebase CLI not found. Install with: npm install -g firebase-tools"
            fi
            ;;
        2)
            echo ""
            echo "🚀 Deploying to Vercel..."
            cd build/web || exit
            if command -v vercel &> /dev/null; then
                vercel --prod
                echo ""
                echo "✅ Deployed to Vercel!"
            else
                echo "❌ Vercel CLI not found. Install with: npm install -g vercel"
            fi
            ;;
        3)
            echo ""
            echo "✅ Build complete! Files are in: admin_app/build/web"
            echo "You can now:"
            echo "  - Upload to any static hosting"
            echo "  - Deploy to Render static site"
            echo "  - Use with any web server"
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
else
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
