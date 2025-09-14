# GitHub Repository Configuration

## Secrets المطلوبة

### للـ Private Repository (doctor-call-app):
```
PRIVATE_REPO_TOKEN - Personal Access Token للوصول للمستودع الخاص
PUBLIC_REPO_TOKEN - Personal Access Token للدفع للمستودع العام
CODECOV_TOKEN - رمز Codecov لتقارير التغطية
```

### للـ Public Repository (doctor-call-web):
```
GITHUB_TOKEN - يتم إنشاؤه تلقائياً
```

## Environment Variables

```yaml
API_BASE_URL: "https://api.doctor-call.your-domain.com"
WEB_BASE_URL: "https://doctor-call.your-domain.com"
WEBSOCKET_URL: "wss://ws.doctor-call.your-domain.com"
```

## Branch Protection Rules

### Master/Main Branch:
- ✅ Require pull request reviews before merging
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Include administrators
- ✅ Restrict pushes that create files larger than 100MB

### Required Status Checks:
- `test / Run Tests`
- `unit-tests / Unit Tests`
- `quality-checks / Code Quality Checks`

## Deployment Strategy

### Private Repository Workflow:
1. **Development** → `develop` branch
2. **Testing** → Pull Request to `master`
3. **Production** → Merge to `master` triggers:
   - Full test suite
   - Security scans
   - Build artifacts
   - Deploy to private infrastructure
   - Sync web build to public repository

### Public Repository Workflow:
1. **Auto-sync** from private repository
2. **GitHub Pages** deployment
3. **CDN** distribution
4. **Public downloads** (APK releases)

## Monitoring & Alerts

### GitHub Actions Notifications:
- ✅ Slack/Discord webhook for failed builds
- ✅ Email notifications for security alerts
- ✅ Status badges in README

### Performance Monitoring:
- ✅ Lighthouse CI for web performance
- ✅ Bundle size tracking
- ✅ Load time monitoring

## Security Configurations

### Dependabot:
```yaml
version: 2
updates:
  - package-ecosystem: "pub"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "your-team"
```

### CodeQL Analysis:
- ✅ Automatic security scanning
- ✅ Dependency vulnerability alerts
- ✅ Code injection detection

## Repository Settings

### Private Repository (doctor-call-app):
- 🔒 **Visibility**: Private
- 👥 **Team Access**: Development team only
- 🔍 **Features**: Issues, Projects, Wiki enabled
- 📋 **Templates**: Issue/PR templates configured

### Public Repository (doctor-call-web):
- 🌐 **Visibility**: Public
- 📱 **Pages**: Enabled for web app hosting
- 📦 **Releases**: APK downloads enabled
- 📊 **Analytics**: Traffic insights enabled

## CI/CD Pipeline Flow

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Development   │───▶│   Pull Request   │───▶│  Master Branch  │
│                 │    │                  │    │                 │
│ • Feature work  │    │ • Automated tests│    │ • Full test suite│
│ • Local testing │    │ • Code review    │    │ • Security scans │
│ • Unit tests    │    │ • Quality checks │    │ • Build & deploy │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
                              ┌─────────────────────────────────────┐
                              │          Deployment                 │
                              │                                     │
                              │ • Private: Internal infrastructure  │
                              │ • Public: GitHub Pages + APK       │
                              │ • Monitoring: Performance tracking │
                              └─────────────────────────────────────┘
```

## Quick Setup Commands

### 1. Clone and setup:
```bash
git clone https://github.com/USERNAME/doctor-call-app.git
cd doctor-call-app
flutter pub get
```

### 2. Add remotes (if not already done):
```bash
git remote add private https://github.com/USERNAME/doctor-call-app.git
git remote add public https://github.com/USERNAME/doctor-call-web.git
```

### 3. Setup GitHub CLI (optional):
```bash
gh auth login
gh repo create doctor-call-app --private
gh repo create doctor-call-web --public
```

### 4. Configure secrets:
```bash
gh secret set PRIVATE_REPO_TOKEN -R USERNAME/doctor-call-app
gh secret set PUBLIC_REPO_TOKEN -R USERNAME/doctor-call-app
gh secret set CODECOV_TOKEN -R USERNAME/doctor-call-app
```