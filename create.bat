@echo off
REM —— Base path for your project
set "BASE=C:\YourProject"

REM —— Create presentation providers
mkdir "%BASE%\presentation\providers"
type nul > "%BASE%\presentation\providers\auth_provider.dart"
type nul > "%BASE%\presentation\providers\scan_provider.dart"
type nul > "%BASE%\presentation\providers\recommendation_provider.dart"
type nul > "%BASE%\presentation\providers\settings_provider.dart"

REM —— Create presentation screens
mkdir "%BASE%\presentation\screens\auth"
type nul > "%BASE%\presentation\screens\auth\login_screen.dart"
type nul > "%BASE%\presentation\screens\auth\signup_screen.dart"
mkdir "%BASE%\presentation\screens\home"
type nul > "%BASE%\presentation\screens\home\home_screen.dart"
mkdir "%BASE%\presentation\screens\scan"
type nul > "%BASE%\presentation\screens\scan\scan_screen.dart"
mkdir "%BASE%\presentation\screens\results"
type nul > "%BASE%\presentation\screens\results\results_screen.dart"
mkdir "%BASE%\presentation\screens\recommendations"
type nul > "%BASE%\presentation\screens\recommendations\recommendations_screen.dart"
mkdir "%BASE%\presentation\screens\profile"
type nul > "%BASE%\presentation\screens\profile\profile_screen.dart"

REM —— Create presentation widgets
mkdir "%BASE%\presentation\widgets"
type nul > "%BASE%\presentation\widgets\custom_button.dart"
type nul > "%BASE%\presentation\widgets\metric_card.dart"
type nul > "%BASE%\presentation\widgets\loading_widget.dart"

REM —— Create services
mkdir "%BASE%\services"
type nul > "%BASE%\services\notification_service.dart"
type nul > "%BASE%\services\analytics_service.dart"

REM —— Create root files
type nul > "%BASE%\app.dart"
type nul > "%BASE%\main.dart"

REM —— Create assets structure
mkdir "%BASE%\assets\images"
mkdir "%BASE%\assets\models"

REM —— Create test folders
mkdir "%BASE%\test\unit"
mkdir "%BASE%\test\widget"
mkdir "%BASE%\test\integration"

REM —— Create project manifest and README
type nul > "%BASE%\pubspec.yaml"
type nul > "%BASE%\README.md"

echo.
echo Folder and file structure created under %BASE%
pause
