#!/bin/bash
# ============================================================
# TrendVault — Git Push Script
# Usage: ./push_to_git.sh <github-username> [tag-version]
# Example:
#   ./push_to_git.sh myusername
#   ./push_to_git.sh myusername v1.0.0
# ============================================================
set -e

GITHUB_USER=${1:-"YOUR_GITHUB_USERNAME"}
REPO_NAME="trending_videos_app"
TAG=${2:-""}

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   TrendVault — Push to GitHub        ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Configure git if needed
git config user.email "dev@trendvault.app" 2>/dev/null || true
git config user.name "TrendVault Dev" 2>/dev/null || true

# Set remote
REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
echo "🔗 Remote: $REMOTE_URL"

if git remote get-url origin > /dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# Force push all commits (includes all 4 fix commits)
echo ""
echo "⬆️  Force-pushing all commits to main..."
git push --force -u origin main

echo ""
echo "✅ Pushed commits:"
git log --oneline

# Tag & push release if version provided
if [ -n "$TAG" ]; then
  echo ""
  echo "🏷️  Creating tag: $TAG"
  git tag -a "$TAG" -m "TrendVault release $TAG" 2>/dev/null || git tag -f "$TAG" -m "TrendVault release $TAG"
  git push origin "$TAG" --force
  echo "✅ Tag $TAG pushed — GitHub Actions will build release APK!"
fi

echo ""
echo "═══════════════════════════════════════"
echo "✅ Done! GitHub Actions will now run."
echo "   https://github.com/${GITHUB_USER}/${REPO_NAME}/actions"
echo "═══════════════════════════════════════"
