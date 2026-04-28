#!/bin/bash
# ============================================================
# TrendVault — Git Push Script
# Usage: ./push_to_git.sh <github-username> [tag-version]
# Example: ./push_to_git.sh myusername
#          ./push_to_git.sh myusername v1.0.0
# ============================================================

set -e

GITHUB_USER=${1:-"YOUR_GITHUB_USERNAME"}
REPO_NAME="trendvault"
TAG=${2:-""}

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   TrendVault — Push to GitHub        ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Check git is configured
if ! git config user.email > /dev/null 2>&1; then
  echo "⚠️  Git user not configured. Running setup..."
  git config user.email "dev@trendvault.app"
  git config user.name "TrendVault Dev"
fi

# Stage all files
echo "📦 Staging all files..."
git add -A

# Commit
COMMIT_MSG="feat: TrendVault initial release

- Multi-platform trending video aggregator
- Location-based filtering (Country > State > District > City)  
- AI content insights for creators
- Trending hashtags with growth rate tracking
- GitHub Actions CI/CD with auto APK build"

git commit -m "$COMMIT_MSG" 2>/dev/null || echo "✓ Nothing new to commit"

# Set remote
REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
echo ""
echo "🔗 Remote: $REMOTE_URL"

if git remote get-url origin > /dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# Push main branch
echo ""
echo "⬆️  Pushing to main branch..."
git push -u origin main

# Tag & push release if version provided
if [ -n "$TAG" ]; then
  echo ""
  echo "🏷️  Creating tag: $TAG"
  git tag -a "$TAG" -m "TrendVault release $TAG" 2>/dev/null || echo "Tag already exists"
  git push origin "$TAG"
  echo "✅ Tag $TAG pushed — GitHub Actions will build release APK!"
fi

echo ""
echo "═══════════════════════════════════════"
echo "✅ Done! Check your repo:"
echo "   https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo ""
echo "📱 To trigger APK build, push a tag:"
echo "   git tag v1.0.0 && git push origin v1.0.0"
echo "═══════════════════════════════════════"
