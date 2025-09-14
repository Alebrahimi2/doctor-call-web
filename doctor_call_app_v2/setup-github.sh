#!/bin/bash

# 🚀 GitHub Repository Setup Script for Doctor Call App
# Run this script after manually creating the repositories on GitHub

echo "🏥 Doctor Call App - GitHub Setup Script"
echo "======================================="

# التحقق من أن المستخدم في المجلد الصحيح
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the Flutter project directory"
    echo "Expected location: C:/xampp/htdocs/games/Doctor_Call/doctor_call_app_v2"
    exit 1
fi

echo ""
echo "📋 Pre-Setup Checklist:"
echo "1. ✅ Created 'doctor-call-app' repository (Private) on GitHub"
echo "2. ✅ Created 'doctor-call-web' repository (Public) on GitHub"  
echo "3. ✅ Generated Personal Access Token with 'repo' and 'workflow' permissions"
echo ""

# طلب اسم المستخدم
read -p "🔸 Enter your GitHub username: " GITHUB_USERNAME
echo ""

# التحقق من صحة اسم المستخدم
if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ Error: GitHub username cannot be empty"
    exit 1
fi

echo "🔗 Setting up remote repositories..."

# إعداد remote URLs
git remote set-url private https://github.com/$GITHUB_USERNAME/doctor-call-app.git
git remote set-url public https://github.com/$GITHUB_USERNAME/doctor-call-web.git

echo "✅ Remote repositories configured:"
git remote -v

echo ""
echo "📤 Attempting to push to private repository..."

# محاولة الدفع للمستودع الخاص
if git push private master; then
    echo "🎉 SUCCESS! Code pushed to private repository successfully!"
    echo ""
    echo "🔗 Your repositories:"
    echo "   Private: https://github.com/$GITHUB_USERNAME/doctor-call-app"
    echo "   Public:  https://github.com/$GITHUB_USERNAME/doctor-call-web"
    echo ""
    echo "📊 Check your CI/CD status:"
    echo "   Actions: https://github.com/$GITHUB_USERNAME/doctor-call-app/actions"
    echo ""
    echo "⚙️  Next steps:"
    echo "   1. Go to https://github.com/$GITHUB_USERNAME/doctor-call-app/settings/secrets/actions"
    echo "   2. Add required secrets (PRIVATE_REPO_TOKEN, PUBLIC_REPO_TOKEN)"
    echo "   3. Enable GitHub Actions if prompted"
    echo "   4. Monitor the first workflow run!"
    echo ""
    echo "🌐 Your app will be available at:"
    echo "   https://$GITHUB_USERNAME.github.io/doctor-call-web"
else
    echo ""
    echo "⚠️  Push failed. This is normal for first-time setup."
    echo ""
    echo "🔐 Authentication Setup Required:"
    echo "   1. You may need to configure Git credentials"
    echo "   2. Use Personal Access Token instead of password"
    echo "   3. Run: git config --global credential.helper manager-core"
    echo ""
    echo "🔄 Manual push command:"
    echo "   git push private master"
    echo ""
    echo "💡 If repository doesn't exist, create it first:"
    echo "   https://github.com/new"
    echo "   Repository name: doctor-call-app (Private)"
    echo "   Repository name: doctor-call-web (Public)"
fi

echo ""
echo "📚 For detailed setup guide, see: GITHUB_SETUP_GUIDE.md"
echo "🏥 Doctor Call App setup complete!"