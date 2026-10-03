# Heaven Chrome - Master Roadmap & Architecture Guide

Heaven Chrome is a multi-platform celestial adventure game, time-dilation platformer, and cloud-native microservice. This document provides a complete breakdown of every directory, platform layer, and future roadmap phases.

---

## 1. Multi-Platform Matrix

| Platform | Technology / Language | Primary Location | Output / Package |
|---|---|---|---|
| **ZX Spectrum 48K** | C / Z80 ASM (z88dk) | `src/` | `build/chronos.tap` (Tape image for Fuse) |
| **Web Browser** | HTML5 Canvas + Vanilla JS | `web/` | `web/index.html` (Accessible via HTTP) |
| **Linux Desktop & Steam** | C99 + SDL2 (Hardware accelerated) | `linux/` | `linux/bin/heaven-chrome`, `heaven-chrome-linux.tar.gz` |
| **Windows 11 & Steam** | C99 + SDL2 (MinGW-w64) | `windows/` | `windows/bin/heaven-chrome.exe` |
| **Android & F-Droid** | Capacitor + Android SDK | `android/` | `android/app/build/outputs/apk/release/Heaven-Chrome.apk` |
| **Java Desktop** | Java 2D + Swing (OpenJDK 21) | `java/` | `java/target/heaven-chrome.jar` |
| **Python Microservice** | Python 3 + Flask + Gunicorn | `flask_app/` | `http://localhost:5000` (Web UI & APK download) |
| **Perl Microservice** | Perl 5 + IO::Socket::INET | `perl_app/` | `http://localhost:5050` (Web UI & APK download) |
| **Docker** | Nginx Alpine Container | `Dockerfile` | Container image `heaven-chrome:latest` |
| **Kubernetes (Helm)** | Helm 3 / 4 Chart | `helm/heaven-chrome/` | Multi-replica Deployment + Istio Gateway |
| **Kubernetes (KPT)** | KPT Declarative Blueprint | `kpt/heaven-chrome-kpt/` | `heaven-chrome-kpt` deployment with sidecars |
| **GitOps (ArgoCD)** | App of Apps Helm Pattern | `helm/argo-app-of-apps/` | Declarative multi-environment sync |

---

## 2. Directory Breakdown & Categories

```text
Heaven-Chrome/
├── .github/workflows/          # CI/CD automation (Android, Linux Steam, Docker)
├── android/                    # Android studio / Gradle native mobile wrapper
│   ├── app/                    # Android application module (Java, manifests, assets)
│   │   └── build/outputs/apk/  # Built APK files (release and debug)
│   └── fastlane/               # F-Droid and store automation metadata
├── bin/                        # Pre-compiled CLI tool binaries
│   ├── agy                     # Antigravity CLI (v1.2.12)
│   ├── argocd                  # ArgoCD CLI (v3.5.3)
│   ├── gemini                  # Gemini CLI (v0.61.0)
│   ├── istioctl                # Istio Service Mesh CLI (v1.31.1)
│   ├── jq                      # JSON processor (v1.7)
│   ├── kpt                     # KPT package manager (v1.0.0-beta.61)
│   └── yq                      # YAML processor (v4.54.1)
├── docs/                       # Comprehensive documentation library
│   ├── ANDROID_EMULATOR_TESTING.md # Emulator, scrcpy, and mobile testing
│   ├── ARGOCD_ISTIOCTL_KPT_PERL.md # ArgoCD, istioctl, kpt, and Perl guides
│   ├── DOCKER_AND_KUBERNETES.md    # Docker & initial cluster documentation
│   ├── FDROID.md                   # F-Droid metadata and publishing recipe
│   ├── FLASK.md                    # Python Flask server & wireless APK distribution
│   ├── KUBERNETES_ISTIO_ARGO_LVM.md# Istio mesh, ArgoCD, and LVM storage
│   ├── LINUX_REINSTALL_ZERO_TO_HERO.md # Complete rebuild from scratch guide
│   ├── LOCAL_SETUP_AND_CLEANUP.md  # System optimization & IDE configs
│   ├── NON_DEVELOPER_EXPLAINER.md  # Plain-English guide for non-developers
│   └── PUBLISHING_TUTORIAL.md      # Game distribution & store tutorials
├── flask_app/                  # Python Flask web server and APK distributor
│   ├── app.py                  # Flask server logic
│   └── requirements.txt        # Python dependency declarations
├── helm/                       # Kubernetes Helm Charts
│   ├── heaven-chrome/          # Main application chart (Deployment, Service, Istio)
│   └── argo-app-of-apps/       # ArgoCD App of Apps chart generating multiple environments
├── java/                       # Pure Java 2D + Swing desktop engine
│   └── src/main/java/com/heavenchrome/ # Java game engine, panel, audio synth
├── k8s/                        # Kubernetes raw manifests & port-forwarding helpers
│   ├── argo-app-of-apps/       # Static raw App of Apps manifests
│   ├── port-forward-app.sh     # Forward application port 8080
│   └── port-forward-argocd.sh  # Forward ArgoCD port 8081
├── kpt/                        # KRM declarative package management
│   └── heaven-chrome-kpt/      # Kptfile, deployment, service, istio resources
├── linux/                      # Native Linux 64-bit SDL2 application
│   ├── Makefile                # GCC compilation rules
│   ├── src/                    # C source files (main, game, audio, render)
│   └── steam_package/          # Steamworks depot release bundle
├── perl_app/                   # Standalone Perl HTTP web server
│   ├── app.pl                  # Pure Perl HTTP 1.1 server and API
│   ├── cpanfile                # CPAN dependencies
│   └── run.sh                  # Execution script
├── src/                        # Original Z80 / ZX Spectrum C source code
│   └── game/                   # Player, levels, input, physics, audio
├── tools/                      # Diagnostic, testing & generator scripts
│   ├── agy-cli.sh              # Antigravity CLI runner
│   ├── android-test-adb.sh     # ADB installation and log streamer
│   ├── argocd-connect.sh       # One-click ArgoCD login with user theratzul
│   ├── build_levels.py         # Level generator and JSON validator
│   ├── export_levels.py        # Level compressor and C/JS exporter
│   ├── gemini-cli.sh           # Gemini CLI runner
│   ├── istioctl-check.sh       # Istio health and diagnostic checker
│   ├── run-emulator.sh         # Android emulator runner with scrcpy display
│   └── setup-linux-from-scratch.sh # Disaster recovery rebuild script
├── web/                        # HTML5 Canvas web game edition
│   ├── index.html              # Canvas & responsive UI
│   ├── script.js               # 60 FPS JavaScript game engine
│   └── style.css               # Celestial glassmorphic styling
├── windows/                    # Native Windows 64-bit MinGW SDL2 application
│   ├── Makefile                # Cross-compilation rules
│   └── src/                    # Windows main and icon resources
├── build-android.sh            # One-click Android APK builder
├── build-linux.sh              # One-click Linux native binary builder
├── install-phone.sh            # One-click ADB phone installer (cable or wireless)
├── run-flask.sh                # Launcher for Python Flask server
├── run-linux.sh                # Launcher for native Linux game
└── run-perl.sh                 # Launcher for Perl server
```

---

## 3. Roadmap & Strategic Phases

### Phase 1: Core Retro Engine (Completed)
* Z80 48K engine with 20 levels.
* HTML5/Canvas recreation with responsive mobile viewport and time dilation.

### Phase 2: Native Desktop Releases (Completed)
* Native C99 + SDL2 for Linux (Steam Deck & Debian compatible).
* Native C99 + SDL2 for Windows 11 with resource icons.
* Pure Java 2D + Swing desktop edition.

### Phase 3: Cloud Native & GitOps (Completed)
* Docker multi-stage containerization with Nginx.
* Helm chart with native Istio Service Mesh (Sidecars, Gateway, VirtualService).
* KPT declarative blueprint (`heaven-chrome-kpt`).
* ArgoCD GitOps deployment with "App of Apps" pattern and `theratzul` admin user.
* Pre-packaged CLI toolkit (`istioctl`, `argocd`, `kpt`, `yq`, `jq`, `agy`, `gemini`).

### Phase 4: Mobile & Store Distribution (Active)
* F-Droid signed APK (`Heaven-Chrome.apk`) with reproducible builds.
* Direct wireless APK download endpoints via Python Flask and Perl.
* Android Emulator and `scrcpy` Linux desktop display integration.
