# 📱 FinWise — Flutter Application Architecture Document
### Version 1.0 | Gemini AI + Firebase | Full-Stack Mobile Architecture

> **Platform:** Flutter (Dart) — iOS & Android  
> **State Management:** Riverpod (code-gen)  
> **Backend:** Firebase (Auth, Firestore, Storage, Functions, FCM)  
> **AI Engine:** Google Gemini API (`gemini-1.5-flash` / `gemini-1.5-pro`)  
> **Architecture Pattern:** Feature-First Clean Architecture (Domain / Data / Presentation)

---

## 📋 Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [File & Folder Structure](#2-file--folder-structure)
3. [Navigation Architecture](#3-navigation-architecture)
4. [Screens & Widgets Catalogue](#4-screens--widgets-catalogue)
   - 4.1 [Auth Flow](#41-auth-flow)
   - 4.2 [Onboarding Flow](#42-onboarding-flow)
   - 4.3 [Dashboard](#43-dashboard)
   - 4.4 [Transactions](#44-transactions)
   - 4.5 [Budget](#45-budget)
   - 4.6 [Goals](#46-goals)
   - 4.7 [AI Chat Assistant](#47-ai-chat-assistant)
   - 4.8 [Learn Hub](#48-learn-hub)
   - 4.9 [YouTube Insight Analyzer](#49-youtube-insight-analyzer)
   - 4.10 [Government Schemes](#410-government-schemes)
   - 4.11 [Expert Connect](#411-expert-connect)
   - 4.12 [Notifications](#412-notifications)
   - 4.13 [Profile & Settings](#413-profile--settings)
5. [State Management (Riverpod)](#5-state-management-riverpod)
6. [Data Layer — Repositories & Models](#6-data-layer--repositories--models)
7. [AI Integration Layer](#7-ai-integration-layer)
8. [Firebase Integration](#8-firebase-integration)
9. [Shared Widgets Library](#9-shared-widgets-library)
10. [Theme & Design System](#10-theme--design-system)
11. [Dependency Injection & Services](#11-dependency-injection--services)
12. [Security & PII Safety](#12-security--pii-safety)
13. [Package Dependencies](#13-package-dependencies)

---

## 1. Architecture Overview

FinWise follows a **Feature-First Clean Architecture** pattern. Each product feature is a self-contained module with its own `data`, `domain`, and `presentation` layers. Cross-cutting concerns (auth, theme, routing, AI client) live in a shared `core` layer.

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                    │
│          Screens → Widgets → Riverpod Providers         │
├─────────────────────────────────────────────────────────┤
│                    DOMAIN LAYER                         │
│        Use Cases → Entities → Repository Interfaces     │
├─────────────────────────────────────────────────────────┤
│                     DATA LAYER                          │
│    Firebase Repositories → AI Client → Local Cache     │
├─────────────────────────────────────────────────────────┤
│                    CORE / SHARED                        │
│    Router · Theme · DI · Services · Constants · Utils   │
└─────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

| Decision | Choice | Reason |
|---|---|---|
| State Management | **Riverpod** (code-gen) | Compile-safe, no BuildContext leaks, testable |
| Navigation | **GoRouter** | Deep-link support, declarative, nested shells |
| DI | **Riverpod + get_it** | Provider scope + singleton service registration |
| Local persistence | **Hive** (+ **shared_preferences**) | Fast key-value + settings cache |
| Network | **Dio** + **Retrofit** | Typed HTTP client for AI API calls |
| Image loading | **cached_network_image** | Firebase Storage URL caching |
| OCR | **Google ML Kit** (on-device) | PII-safe — no raw image leaves device |
| Charts | **fl_chart** | Customizable, performant |
| Animations | **Lottie** + **flutter_animate** | Rich micro-interactions |

---

## 2. File & Folder Structure

```
finwise/
│
├── lib/
│   ├── main.dart                          # App entry point, ProviderScope
│   ├── app.dart                           # MaterialApp.router + theme wiring
│   │
│   ├── core/                              # Cross-cutting infrastructure
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── app_dimensions.dart
│   │   │   ├── firebase_constants.dart    # Collection path constants
│   │   │   └── ai_constants.dart          # Gemini model names, prompts
│   │   │
│   │   ├── di/
│   │   │   └── service_locator.dart       # get_it registrations
│   │   │
│   │   ├── error/
│   │   │   ├── app_exception.dart         # Typed exception hierarchy
│   │   │   ├── failure.dart               # Either<Failure, T> result type
│   │   │   └── error_handler.dart         # Global FirebaseException → Failure
│   │   │
│   │   ├── extensions/
│   │   │   ├── date_extensions.dart       # "2025-07" formatters
│   │   │   ├── currency_extensions.dart   # ₹ formatting
│   │   │   ├── string_extensions.dart
│   │   │   └── num_extensions.dart
│   │   │
│   │   ├── network/
│   │   │   ├── dio_client.dart            # Dio singleton + interceptors
│   │   │   └── api_endpoints.dart         # Gemini API base URLs
│   │   │
│   │   ├── router/
│   │   │   ├── app_router.dart            # GoRouter root definition
│   │   │   ├── app_routes.dart            # Route name constants
│   │   │   └── route_guards.dart          # Auth guard, onboarding guard
│   │   │
│   │   ├── services/
│   │   │   ├── auth_service.dart          # Firebase Auth wrapper
│   │   │   ├── fcm_service.dart           # FCM token + notification handler
│   │   │   ├── ocr_service.dart           # ML Kit text recognition
│   │   │   ├── local_storage_service.dart # Hive + SharedPreferences
│   │   │   ├── connectivity_service.dart  # Network status
│   │   │   └── analytics_service.dart     # Firebase Analytics
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # ThemeData light + dark
│   │   │   ├── app_text_styles.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_decorations.dart
│   │   │
│   │   └── utils/
│   │       ├── validators.dart
│   │       ├── date_utils.dart            # YYYY-MM helpers
│   │       ├── pii_filter.dart            # Strip PII before AI calls ⚠️
│   │       └── month_helper.dart          # Current month doc ID
│   │
│   ├── features/
│   │   │
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository_impl.dart
│   │   │   │   └── models/
│   │   │   │       └── user_model.dart        # Firestore ↔ Entity mapper
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart   # Abstract interface
│   │   │   │   └── usecases/
│   │   │   │       ├── sign_in_with_google.dart
│   │   │   │       ├── sign_in_with_email.dart
│   │   │   │       ├── sign_up_with_email.dart
│   │   │   │       ├── sign_out.dart
│   │   │   │       └── watch_auth_state.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart     # Riverpod AuthState notifier
│   │   │       ├── screens/
│   │   │       │   ├── splash_screen.dart
│   │   │       │   ├── login_screen.dart
│   │   │       │   └── register_screen.dart
│   │   │       └── widgets/
│   │   │           ├── google_sign_in_button.dart
│   │   │           ├── auth_text_field.dart
│   │   │           └── auth_divider.dart
│   │   │
│   │   ├── onboarding/
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── onboarding_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── onboarding_profile.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── save_onboarding_profile.dart
│   │   │   │       └── compute_eligibility_tags.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── onboarding_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── onboarding_shell_screen.dart
│   │   │       │   ├── step_occupation_screen.dart
│   │   │       │   ├── step_income_screen.dart
│   │   │       │   ├── step_goals_screen.dart
│   │   │       │   ├── step_language_screen.dart
│   │   │       │   └── onboarding_complete_screen.dart
│   │   │       └── widgets/
│   │   │           ├── onboarding_progress_bar.dart
│   │   │           ├── occupation_card.dart
│   │   │           ├── income_range_selector.dart
│   │   │           └── goal_chip_selector.dart
│   │   │
│   │   ├── dashboard/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── dashboard_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── monthly_summary_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── dashboard_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── monthly_summary.dart
│   │   │   │   │   └── ai_insight.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_monthly_summary.dart
│   │   │   │       ├── watch_monthly_summary.dart
│   │   │   │       └── fetch_ai_expense_insight.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── dashboard_provider.dart
│   │   │       │   └── ai_insight_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── dashboard_screen.dart
│   │   │       └── widgets/
│   │   │           ├── greeting_header.dart
│   │   │           ├── monthly_spend_card.dart
│   │   │           ├── budget_progress_ring.dart
│   │   │           ├── category_breakdown_chart.dart
│   │   │           ├── ai_insight_card.dart
│   │   │           ├── quick_action_row.dart
│   │   │           ├── goal_snapshot_card.dart
│   │   │           ├── recent_transactions_list.dart
│   │   │           ├── daily_tip_banner.dart
│   │   │           └── next_month_forecast_card.dart
│   │   │
│   │   ├── transactions/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── transaction_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── transaction_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── transaction_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── transaction_entity.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── add_transaction.dart
│   │   │   │       ├── edit_transaction.dart
│   │   │   │       ├── delete_transaction.dart
│   │   │   │       ├── watch_transactions.dart
│   │   │   │       ├── get_transactions_by_month.dart
│   │   │   │       └── scan_receipt_ocr.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── transactions_provider.dart
│   │   │       │   └── ocr_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── transactions_screen.dart
│   │   │       │   ├── add_transaction_screen.dart
│   │   │       │   ├── edit_transaction_screen.dart
│   │   │       │   ├── transaction_detail_screen.dart
│   │   │       │   └── ocr_scan_screen.dart
│   │   │       └── widgets/
│   │   │           ├── transaction_list_item.dart
│   │   │           ├── transaction_filter_bar.dart
│   │   │           ├── month_selector.dart
│   │   │           ├── category_icon_chip.dart
│   │   │           ├── add_transaction_fab.dart
│   │   │           ├── ocr_result_preview_card.dart
│   │   │           ├── payment_method_selector.dart
│   │   │           └── amount_input_field.dart
│   │   │
│   │   ├── budget/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── budget_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── budget_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── budget_entity.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_current_budget.dart
│   │   │   │       ├── generate_ai_budget.dart
│   │   │   │       ├── save_manual_budget.dart
│   │   │   │       └── update_category_limit.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── budget_provider.dart
│   │   │       │   └── ai_budget_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── budget_screen.dart
│   │   │       │   ├── budget_detail_screen.dart
│   │   │       │   └── budget_setup_screen.dart
│   │   │       └── widgets/
│   │   │           ├── budget_overview_card.dart
│   │   │           ├── category_budget_bar.dart
│   │   │           ├── budget_variance_chip.dart
│   │   │           ├── ai_budget_generate_button.dart
│   │   │           ├── budget_category_editor.dart
│   │   │           └── budget_reasoning_tile.dart
│   │   │
│   │   ├── goals/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── goal_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── goals_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── goal_entity.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── create_goal.dart
│   │   │   │       ├── update_goal_contribution.dart
│   │   │   │       ├── fetch_goal_ai_advice.dart
│   │   │   │       ├── watch_goals.dart
│   │   │   │       └── delete_goal.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── goals_provider.dart
│   │   │       │   └── goal_advisor_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── goals_screen.dart
│   │   │       │   ├── goal_detail_screen.dart
│   │   │       │   └── create_goal_screen.dart
│   │   │       └── widgets/
│   │   │           ├── goal_card.dart
│   │   │           ├── goal_progress_arc.dart
│   │   │           ├── milestone_timeline.dart
│   │   │           ├── ai_goal_advice_card.dart
│   │   │           ├── goal_contribution_sheet.dart
│   │   │           └── goal_category_picker.dart
│   │   │
│   │   ├── ai_chat/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── ai_chat_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── chat_session_model.dart
│   │   │   │   │   └── chat_message_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── ai_chat_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── chat_session.dart
│   │   │   │   │   └── chat_message.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── send_chat_message.dart
│   │   │   │       ├── create_chat_session.dart
│   │   │   │       ├── watch_chat_sessions.dart
│   │   │   │       └── archive_chat_session.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── chat_sessions_provider.dart
│   │   │       │   └── active_chat_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── ai_chat_list_screen.dart
│   │   │       │   └── ai_chat_screen.dart
│   │   │       └── widgets/
│   │   │           ├── chat_bubble.dart
│   │   │           ├── chat_input_bar.dart
│   │   │           ├── chat_mode_selector.dart
│   │   │           ├── suggested_action_chips.dart
│   │   │           ├── follow_up_suggestions.dart
│   │   │           ├── chat_session_tile.dart
│   │   │           └── typing_indicator.dart
│   │   │
│   │   ├── learn/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── learning_module_model.dart
│   │   │   │   │   ├── lesson_model.dart
│   │   │   │   │   ├── quiz_model.dart
│   │   │   │   │   └── learning_progress_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── learn_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── learning_module.dart
│   │   │   │   │   ├── lesson.dart
│   │   │   │   │   ├── quiz.dart
│   │   │   │   │   └── learning_progress.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_modules_for_user.dart
│   │   │   │       ├── get_ai_learning_path.dart
│   │   │   │       ├── complete_lesson.dart
│   │   │   │       ├── submit_quiz.dart
│   │   │   │       └── watch_progress.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── learn_provider.dart
│   │   │       │   ├── lesson_provider.dart
│   │   │       │   └── quiz_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── learn_hub_screen.dart
│   │   │       │   ├── module_detail_screen.dart
│   │   │       │   ├── lesson_reader_screen.dart
│   │   │       │   └── quiz_screen.dart
│   │   │       └── widgets/
│   │   │           ├── module_card.dart
│   │   │           ├── lesson_list_item.dart
│   │   │           ├── progress_header.dart
│   │   │           ├── ai_path_recommendation_banner.dart
│   │   │           ├── badge_shelf.dart
│   │   │           ├── streak_counter.dart
│   │   │           ├── quiz_question_card.dart
│   │   │           ├── quiz_result_screen_overlay.dart
│   │   │           └── lesson_content_renderer.dart  # Renders Markdown lesson
│   │   │
│   │   ├── video_insights/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── video_insight_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── video_insights_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── video_insight.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── analyze_youtube_video.dart
│   │   │   │       └── get_video_insights.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── video_insights_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── video_insights_screen.dart
│   │   │       │   └── video_insight_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── youtube_url_input_bar.dart
│   │   │           ├── video_thumbnail_card.dart
│   │   │           ├── key_tips_list.dart
│   │   │           ├── action_points_card.dart
│   │   │           └── video_insight_loading_animation.dart
│   │   │
│   │   ├── schemes/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── scheme_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── schemes_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── scheme_entity.dart
│   │   │   │   └── usecases/
│   │   │   │       └── get_recommended_schemes.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── schemes_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── schemes_screen.dart
│   │   │       │   └── scheme_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── scheme_card.dart
│   │   │           ├── match_score_badge.dart
│   │   │           ├── benefit_type_chip.dart
│   │   │           └── scheme_apply_button.dart
│   │   │
│   │   ├── expert_connect/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── consultant_model.dart
│   │   │   │   │   └── booking_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── expert_connect_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── consultant.dart
│   │   │   │   │   └── booking.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_consultants.dart
│   │   │   │       ├── get_availability_slots.dart
│   │   │   │       └── book_session.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── consultants_provider.dart
│   │   │       │   └── booking_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── expert_connect_screen.dart
│   │   │       │   ├── consultant_profile_screen.dart
│   │   │       │   ├── booking_slot_screen.dart
│   │   │       │   └── my_bookings_screen.dart
│   │   │       └── widgets/
│   │   │           ├── consultant_card.dart
│   │   │           ├── specialization_chips.dart
│   │   │           ├── availability_calendar.dart
│   │   │           ├── slot_picker.dart
│   │   │           └── booking_confirmation_sheet.dart
│   │   │
│   │   ├── notifications/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── notification_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── notifications_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── app_notification.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── watch_notifications.dart
│   │   │   │       └── mark_notification_read.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── notifications_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── notifications_screen.dart
│   │   │       └── widgets/
│   │   │           ├── notification_list_item.dart
│   │   │           ├── unread_badge.dart
│   │   │           └── notification_deep_link_handler.dart
│   │   │
│   │   └── profile/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   └── user_profile_model.dart
│   │       │   └── repositories/
│   │       │       └── profile_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── user_profile.dart
│   │       │   └── usecases/
│   │       │       ├── update_profile.dart
│   │       │       ├── update_avatar.dart
│   │       │       └── update_settings.dart
│   │       └── presentation/
│   │           ├── providers/
│   │           │   └── profile_provider.dart
│   │           ├── screens/
│   │           │   ├── profile_screen.dart
│   │           │   └── settings_screen.dart
│   │           └── widgets/
│   │               ├── profile_avatar.dart
│   │               ├── settings_tile.dart
│   │               ├── theme_selector.dart
│   │               ├── language_selector.dart
│   │               └── income_edit_sheet.dart
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── fw_app_bar.dart              # Branded AppBar
│       │   ├── fw_button.dart               # Primary / secondary / ghost buttons
│       │   ├── fw_card.dart                 # Elevated card with radius
│       │   ├── fw_chip.dart                 # Status chips
│       │   ├── fw_loading_indicator.dart    # Shimmer + spinner variants
│       │   ├── fw_error_view.dart           # Error state with retry
│       │   ├── fw_empty_state.dart          # Empty state with Lottie
│       │   ├── fw_bottom_sheet.dart         # Standard modal bottom sheet
│       │   ├── fw_snackbar.dart             # Success / error / info snackbar
│       │   ├── fw_dialog.dart               # Confirmation dialog
│       │   ├── fw_avatar.dart               # User avatar + fallback initials
│       │   ├── fw_badge.dart                # Notification dot badge
│       │   ├── fw_text_field.dart           # Standard input field
│       │   ├── fw_shimmer.dart              # Skeleton loader
│       │   ├── fw_category_icon.dart        # Category → Icon mapper
│       │   └── fw_ai_thinking_indicator.dart # Gemini "thinking" animation
│       │
│       └── providers/
│           ├── user_profile_provider.dart   # Global user profile stream
│           └── theme_provider.dart          # Theme mode notifier
│
├── test/
│   ├── unit/
│   │   ├── usecases/
│   │   ├── repositories/
│   │   └── providers/
│   ├── widget/
│   │   └── features/
│   └── integration/
│
├── assets/
│   ├── images/
│   ├── lottie/
│   │   ├── ai_thinking.json
│   │   ├── goal_completed.json
│   │   ├── empty_state.json
│   │   └── badge_earned.json
│   └── fonts/
│
├── pubspec.yaml
├── analysis_options.yaml
└── firebase.json
```

---

## 3. Navigation Architecture

FinWise uses **GoRouter** with a `ShellRoute` for the main bottom navigation and nested routes for feature flows.

```
/                          → Redirect (auth guard)
│
├── /splash                → SplashScreen
├── /login                 → LoginScreen
├── /register              → RegisterScreen
│
├── /onboarding            → OnboardingShellScreen (PageView)
│   ├── /onboarding/occupation
│   ├── /onboarding/income
│   ├── /onboarding/goals
│   ├── /onboarding/language
│   └── /onboarding/complete
│
└── /app  (ShellRoute — BottomNavBar)
    ├── /app/dashboard              → DashboardScreen
    │
    ├── /app/transactions           → TransactionsScreen
    │   ├── /app/transactions/add   → AddTransactionScreen
    │   ├── /app/transactions/scan  → OcrScanScreen
    │   └── /app/transactions/:id   → TransactionDetailScreen
    │
    ├── /app/budget                 → BudgetScreen
    │   ├── /app/budget/setup       → BudgetSetupScreen
    │   └── /app/budget/:id         → BudgetDetailScreen
    │
    ├── /app/goals                  → GoalsScreen
    │   ├── /app/goals/create       → CreateGoalScreen
    │   └── /app/goals/:id          → GoalDetailScreen
    │
    ├── /app/learn                  → LearnHubScreen
    │   ├── /app/learn/:moduleId          → ModuleDetailScreen
    │   ├── /app/learn/:moduleId/lesson/:lessonId → LessonReaderScreen
    │   └── /app/learn/:moduleId/quiz     → QuizScreen
    │
    ├── /app/ai-chat                → AiChatListScreen
    │   └── /app/ai-chat/:sessionId → AiChatScreen
    │
    ├── /app/more  (overflow menu)
    │   ├── /app/more/video-insights       → VideoInsightsScreen
    │   │   └── /app/more/video-insights/:id → VideoInsightDetailScreen
    │   ├── /app/more/schemes              → SchemesScreen
    │   │   └── /app/more/schemes/:id      → SchemeDetailScreen
    │   ├── /app/more/expert-connect       → ExpertConnectScreen
    │   │   ├── /app/more/expert-connect/:id       → ConsultantProfileScreen
    │   │   ├── /app/more/expert-connect/:id/book  → BookingSlotScreen
    │   │   └── /app/more/bookings                 → MyBookingsScreen
    │   ├── /app/more/notifications        → NotificationsScreen
    │   └── /app/more/profile              → ProfileScreen
    │       └── /app/more/settings         → SettingsScreen
```

### Bottom Navigation Bar Items

| Tab | Icon | Label | Route |
|-----|------|-------|-------|
| 0 | `home_rounded` | Home | `/app/dashboard` |
| 1 | `receipt_long` | Transactions | `/app/transactions` |
| 2 | `pie_chart` | Budget | `/app/budget` |
| 3 | `flag_rounded` | Goals | `/app/goals` |
| 4 | `school_rounded` | Learn | `/app/learn` |

---

## 4. Screens & Widgets Catalogue

---

### 4.1 Auth Flow

#### `SplashScreen`
**Route:** `/splash`  
**Purpose:** Check auth state, redirect to Login or Dashboard.

| Widget | Description |
|--------|-------------|
| `LottieAnimation` | FinWise logo animation (2s) |
| `StreamBuilder<User?>` | Listens to `authStateChanges` |

**Logic:** On load → `watchAuthState` → if authenticated + onboarding complete → `/app/dashboard`; if onboarding incomplete → `/onboarding`; else → `/login`

---

#### `LoginScreen`
**Route:** `/login`

| Widget | Description |
|--------|-------------|
| `FwTextField` (email) | Email input with validation |
| `FwTextField` (password) | Password with toggle visibility |
| `FwButton` (sign in) | Email/password sign in |
| `GoogleSignInButton` | Google OAuth button |
| `AuthDivider` | "or continue with" divider |
| `TextButton` | Navigate to Register |
| `TextButton` | Forgot password flow |

**Providers used:** `authProvider`, `authStateProvider`

---

#### `RegisterScreen`
**Route:** `/register`

| Widget | Description |
|--------|-------------|
| `FwTextField` (name) | Display name input |
| `FwTextField` (email) | Email input |
| `FwTextField` (password) | Password with strength indicator |
| `FwButton` (create account) | Calls `signUpWithEmail` use case |
| `GoogleSignInButton` | One-step registration |

---

### 4.2 Onboarding Flow

#### `OnboardingShellScreen`
**Route:** `/onboarding`  
**Purpose:** Multi-step PageView container managing 5 onboarding steps.

| Widget | Description |
|--------|-------------|
| `OnboardingProgressBar` | Animated step indicator (5 steps) |
| `PageView` | Horizontal swipe between steps |
| `FwButton` (Next/Finish) | Advance or complete onboarding |
| `TextButton` (Back) | Navigate to previous step |

---

#### `StepOccupationScreen`
Widgets: `OccupationCard` × 4 — Salaried / Business / Student / Freelancer (animated selection state)

#### `StepIncomeScreen`
Widgets: `IncomeRangeSelector` — horizontally scrollable range picker chips

#### `StepGoalsScreen`
Widgets: `GoalChipSelector` — multi-select emoji chips for goal categories (house, emergency fund, vacation, etc.)

#### `StepLanguageScreen`
Widgets: Language flag tiles — en / hi / mr / ta / te

#### `OnboardingCompleteScreen`
Widgets: Lottie celebration animation + personalized welcome message + "Get Started" button → triggers `computeEligibilityTags` use case and writes full profile to Firestore

---

### 4.3 Dashboard

#### `DashboardScreen`
**Route:** `/app/dashboard`  
**Purpose:** Central hub — spending overview, AI insights, quick actions, goals snapshot.

**Screen Layout (ScrollView):**

```
┌──────────────────────────────────┐
│  GreetingHeader                  │  Name + date + notification bell
├──────────────────────────────────┤
│  MonthlySpendCard                │  Total spent / total income
│    └── BudgetProgressRing        │  Donut ring for budget %
├──────────────────────────────────┤
│  CategoryBreakdownChart          │  Horizontal bar chart (fl_chart)
├──────────────────────────────────┤
│  AiInsightCard                   │  Gemini summary + expand toggle
├──────────────────────────────────┤
│  QuickActionRow                  │  Add Expense · Scan · Chat · Budget
├──────────────────────────────────┤
│  GoalSnapshotCard                │  Top 2 goals with progress bars
├──────────────────────────────────┤
│  NextMonthForecastCard           │  AI predicted spend + confidence
├──────────────────────────────────┤
│  RecentTransactionsList          │  Last 5 transactions
├──────────────────────────────────┤
│  DailyTipBanner                  │  Firestore daily_tips doc
└──────────────────────────────────┘
```

**Widgets Detail:**

| Widget | Data Source | Notes |
|--------|-------------|-------|
| `GreetingHeader` | `userProfileProvider` | "Good morning, Ravi 👋" |
| `MonthlySpendCard` | `monthlySummaryProvider` | Streams `monthly_summaries/{YYYY-MM}` |
| `BudgetProgressRing` | `monthlySummaryProvider` | `currentMonthSpent / currentMonthBudget` |
| `CategoryBreakdownChart` | `monthlySummaryProvider` | `categoryBreakdown` map → bars |
| `AiInsightCard` | `aiInsightProvider` | Reads cached `aiInsightSummary`; triggers refresh if stale |
| `QuickActionRow` | Static | 4 tappable action icons |
| `GoalSnapshotCard` | `goalsProvider` | Top 2 active goals |
| `NextMonthForecastCard` | `aiInsightProvider` | `nextMonthForecast` from cached insight |
| `RecentTransactionsList` | `transactionsProvider` | Last 5 docs ordered by `createdAt` |
| `DailyTipBanner` | `dailyTipProvider` | Reads today's `daily_tips` doc |

---

### 4.4 Transactions

#### `TransactionsScreen`
**Route:** `/app/transactions`

**Screen Layout:**

```
┌──────────────────────────────────┐
│  FwAppBar ("Transactions")       │
│  MonthSelector                   │  ← → month navigation
├──────────────────────────────────┤
│  TransactionFilterBar            │  All / Expense / Income / Recurring
├──────────────────────────────────┤
│  MonthlySummaryStrip             │  Total in / out for selected month
├──────────────────────────────────┤
│  TransactionListView             │  Grouped by date, real-time stream
│    └── TransactionListItem × N   │
├──────────────────────────────────┤
│  AddTransactionFab               │  Expandable: Manual / Scan
└──────────────────────────────────┘
```

#### `AddTransactionScreen`
**Route:** `/app/transactions/add`

| Widget | Purpose |
|--------|---------|
| `AmountInputField` | Large ₹ number input with keyboard |
| `FwTextField` (title) | Transaction title |
| `CategoryIconChip` (grid) | 8 category selector |
| `PaymentMethodSelector` | UPI / Cash / Card / etc. |
| `DatePickerField` | Transaction date |
| `SwitchTile` (recurring) | Toggle `isRecurring` |
| `FwTextField` (note) | Optional note |
| `FwButton` (save) | Writes to Firestore + updates summary |

#### `OcrScanScreen`
**Route:** `/app/transactions/scan`

| Widget | Purpose |
|--------|---------|
| `CameraPreview` | Live camera feed |
| `ScanOverlayPainter` | Receipt frame guide |
| `CaptureButton` | Trigger ML Kit OCR |
| `OcrResultPreviewCard` | Shows extracted data for review |
| `EditableOcrFields` | Allow correction before saving |
| `FwButton` (confirm & save) | Finalize transaction |

**Flow:** Camera → ML Kit (on-device) → extracted text → Gemini API (PII-stripped) → pre-filled `AddTransactionScreen`

---

### 4.5 Budget

#### `BudgetScreen`
**Route:** `/app/budget`

```
┌──────────────────────────────────┐
│  FwAppBar + month label          │
├──────────────────────────────────┤
│  BudgetOverviewCard              │  Total budget vs spent, variance
├──────────────────────────────────┤
│  AiBudgetGenerateButton          │  "Generate with AI ✨"
├──────────────────────────────────┤
│  CategoryBudgetBar × 8           │  Each category: spent/limit bar
├──────────────────────────────────┤
│  BudgetReasoningTile             │  AI reasoning text (expandable)
└──────────────────────────────────┘
```

**Widgets Detail:**

| Widget | Description |
|--------|-------------|
| `BudgetOverviewCard` | Ring chart + ₹ remaining |
| `AiBudgetGenerateButton` | Calls `generateAiBudget` use case; shows loading state |
| `CategoryBudgetBar` | Horizontal bar with color-coded over/under |
| `BudgetVarianceChip` | Green (under) / Red (over) badge |
| `BudgetCategoryEditor` | Inline editable limit field (manual override) |
| `BudgetReasoningTile` | Expandable card with Gemini's `reasoning` text |

#### `BudgetSetupScreen`
For new month — choose AI-generate or manual entry with amount sliders per category.

---

### 4.6 Goals

#### `GoalsScreen`
**Route:** `/app/goals`

```
┌──────────────────────────────────┐
│  FwAppBar + Add button           │
├──────────────────────────────────┤
│  GoalCard × N  (ListView)        │
│    ├── GoalProgressArc           │  Circular progress
│    ├── Goal title + emoji        │
│    ├── ₹ current / ₹ target      │
│    └── Days remaining chip       │
└──────────────────────────────────┘
```

#### `GoalDetailScreen`
**Route:** `/app/goals/:id`

| Widget | Purpose |
|--------|---------|
| `GoalProgressArc` | Large animated arc (0–100%) |
| `MilestoneTimeline` | Vertical timeline: 25% / 50% / 75% / 100% |
| `AiGoalAdviceCard` | Cached `aiSuggestion` text + "Refresh AI Advice" button |
| `GoalContributionSheet` | Bottom sheet to add contribution amount |
| `MonthlyContributionStepper` | Adjust `monthlyContribution` |
| `StatusToggle` | Active / Paused / Abandoned |

#### `CreateGoalScreen`
Widgets: `GoalCategoryPicker` (emoji grid), `AmountInputField`, `DatePickerField`, `PrioritySelector`, `MonthlyContributionField`

---

### 4.7 AI Chat Assistant

#### `AiChatListScreen`
**Route:** `/app/ai-chat`

| Widget | Purpose |
|--------|---------|
| `ChatSessionTile` | Session title, last message preview, timestamp |
| `ChatModeChip` | Budget / Investment / General label |
| `NewChatFab` | Create new session with mode selector |

#### `AiChatScreen`
**Route:** `/app/ai-chat/:sessionId`

```
┌──────────────────────────────────┐
│  FwAppBar + session title + mode │
├──────────────────────────────────┤
│  ChatModeSelector                │  Top tab bar: General/Budget/Investment
├──────────────────────────────────┤
│  MessageListView                 │  Streaming messages
│    ├── ChatBubble (user)         │  Right-aligned, brand color
│    ├── ChatBubble (model)        │  Left-aligned, card style
│    ├── TypingIndicator           │  Three dots while Gemini responds
│    └── SuggestedActionChips      │  Tappable quick action suggestions
├──────────────────────────────────┤
│  FollowUpSuggestions             │  Horizontal scroll chips
├──────────────────────────────────┤
│  ChatInputBar                    │  Text field + send button + mic icon
└──────────────────────────────────┘
```

**Key behaviors:**
- `contextSnapshot` is rebuilt from current user profile + monthly summary on each message send
- Messages array is appended in Firestore (cap at 50; older sessions `isArchived: true`)
- `suggestedActions` from AI response rendered as tappable chips that deep-link to relevant screens

---

### 4.8 Learn Hub

#### `LearnHubScreen`
**Route:** `/app/learn`

```
┌──────────────────────────────────┐
│  StreakCounter + BadgeShelf      │  🔥 5-day streak | badges row
├──────────────────────────────────┤
│  AiPathRecommendationBanner      │  "AI recommends: Start with EPF"
├──────────────────────────────────┤
│  ProgressHeader                  │  X of Y modules completed
├──────────────────────────────────┤
│  FeaturedModuleCard              │  Hero card for recommended module
├──────────────────────────────────┤
│  ModuleCard × N  (GridView)      │  Difficulty badge, time, progress %
└──────────────────────────────────┘
```

#### `LessonReaderScreen`
**Route:** `/app/learn/:moduleId/lesson/:lessonId`

| Widget | Purpose |
|--------|---------|
| `LessonContentRenderer` | Renders Markdown lesson content |
| `ProgressHeader` | "Lesson 2 of 5" |
| `ReadingProgressBar` | Scroll-driven linear progress indicator |
| `FwButton` (Next Lesson) | Triggers `completeLesson` use case |
| `VideoPlayerWidget` | Embedded video (if `contentType: "video"`) |

#### `QuizScreen`
**Route:** `/app/learn/:moduleId/quiz`

| Widget | Purpose |
|--------|---------|
| `QuizQuestionCard` | Question text + 4 option buttons |
| `AnswerFeedbackOverlay` | Green ✓ / Red ✗ + explanation text |
| `QuizProgressBar` | "3 / 10 questions" |
| `QuizResultScreenOverlay` | Score, pass/fail, badge earned animation |

---

### 4.9 YouTube Insight Analyzer

#### `VideoInsightsScreen`
**Route:** `/app/more/video-insights`

```
┌──────────────────────────────────┐
│  YoutubeUrlInputBar              │  Paste URL + "Analyze" button
│  VideoInsightLoadingAnimation    │  Lottie animation during analysis
├──────────────────────────────────┤
│  VideoThumbnailCard × N          │  Past analyzed videos (cached)
└──────────────────────────────────┘
```

#### `VideoInsightDetailScreen`
**Route:** `/app/more/video-insights/:id`

| Widget | Purpose |
|--------|---------|
| `VideoThumbnailCard` | Thumbnail + title + channel |
| `KeyTipsList` | Bulleted key financial tips |
| `ActionPointsCard` | Actionable next steps with checkboxes |
| `RelevanceScoreBadge` | AI-computed relevance % |
| `RelatedGoalsChips` | Links to relevant user goals |

**Flow:** Paste URL → YouTube Data API (title/thumbnail) → YouTube Transcript API → Gemini (`gemini-1.5-flash`) → parsed insight → saved to Firestore `video_insights`

---

### 4.10 Government Schemes

#### `SchemesScreen`
**Route:** `/app/more/schemes`

| Widget | Purpose |
|--------|---------|
| `SchemeCard` | Emoji + scheme name + tagline + `MatchScoreBadge` |
| `MatchScoreBadge` | Color-coded 0–100% eligibility match |
| `BenefitTypeChip` | Loan / Subsidy / Insurance / etc. |
| `FilterChips` | Filter by benefit type |

**Logic:** `getRecommendedSchemes` use case reads user `eligibilityTags` → Gemini ranks schemes → cached for 7 days

#### `SchemeDetailScreen`
**Route:** `/app/more/schemes/:id`

| Widget | Purpose |
|--------|---------|
| `SchemeHeaderCard` | Full name, ministry, logo |
| `MatchReasonText` | AI-generated match explanation |
| `EligibilityTagsList` | Eligibility criteria tags |
| `SchemeApplyButton` | Opens `officialURL` in in-app browser |
| `MarkdownRenderer` | Full scheme description |

---

### 4.11 Expert Connect

#### `ExpertConnectScreen`
**Route:** `/app/more/expert-connect`

| Widget | Purpose |
|--------|---------|
| `ConsultantCard` | Photo, name, designation, rating, fee |
| `SpecializationChips` | Mutual funds / Tax / Retirement chips |
| `FilterBar` | Filter by specialization, language |

#### `ConsultantProfileScreen`
| Widget | Purpose |
|--------|---------|
| `ConsultantAvatarHeader` | Large photo + name + rating |
| `SpecializationChips` | Full specialization list |
| `SessionInfoCard` | Fee / Duration / Meet mode |
| `BiographyText` | Consultant bio (expandable) |
| `ReviewsSection` | Rating stars + review count |
| `BookSessionButton` | → BookingSlotScreen |

#### `BookingSlotScreen`
| Widget | Purpose |
|--------|---------|
| `AvailabilityCalendar` | Tap-to-select date |
| `SlotPicker` | Available time slots for selected date |
| `SessionNotesField` | User writes what they want to discuss |
| `BookingConfirmationSheet` | Fee summary + payment status + confirm |

---

### 4.12 Notifications

#### `NotificationsScreen`
**Route:** `/app/more/notifications`

| Widget | Purpose |
|--------|---------|
| `NotificationListItem` | Emoji + title + body + timestamp |
| `UnreadBadge` | Blue dot for unread items |
| `NotificationDeepLinkHandler` | Parses `deepLink` field → navigation |
| `SwipeToDelete` | Archive notification on swipe |

**Types rendered differently:** `overspend_warning` (red accent) / `goal_milestone` (gold accent) / `badge_earned` (purple accent) / `scheme_recommendation` (blue accent)

---

### 4.13 Profile & Settings

#### `ProfileScreen`
| Widget | Purpose |
|--------|---------|
| `ProfileAvatar` | Firebase Storage avatar + upload button |
| `ProfileInfoCard` | Display name, occupation, income range |
| `IncomeEditSheet` | Bottom sheet to update income |
| `EligibilityTagsChips` | Computed scheme eligibility tags |
| `BadgeShelf` | All earned badges |
| `SettingsTile` (→ Settings) | Navigate to SettingsScreen |
| `SignOutButton` | Calls `signOut` use case |

#### `SettingsScreen`
| Widget | Purpose |
|--------|---------|
| `ThemeSelector` | Light / Dark / System toggle |
| `LanguageSelector` | Preferred language picker |
| `SettingsTile` (Biometric) | Toggle `biometricEnabled` |
| `SettingsTile` (Notifications) | Toggle `notificationsEnabled` |
| `SettingsTile` (Currency) | Currency display preference |
| `SettingsTile` (Privacy Policy) | Opens web URL |
| `SettingsTile` (Delete Account) | Destructive action with confirmation |

---

## 5. State Management (Riverpod)

All providers are generated with `@riverpod` annotations (code-gen).

### Global Providers

```dart
// Shared across entire app
@riverpod
Stream<User?> authState(AuthStateRef ref) { ... }

@riverpod
Stream<UserProfile> userProfile(UserProfileRef ref) { ... }

@riverpod
ThemeMode themeMode(ThemeModeRef ref) { ... }

@riverpod
int unreadNotificationCount(UnreadNotificationCountRef ref) { ... }
```

### Feature Providers — Dashboard

```dart
@riverpod
Stream<MonthlySummary> monthlySummary(MonthlySummaryRef ref, String month) { ... }

@riverpod
Future<AiInsight> aiExpenseInsight(AiExpenseInsightRef ref, String month) { ... }

@riverpod
Stream<DailyTip?> todaysTip(TodaysTipRef ref) { ... }
```

### Feature Providers — Transactions

```dart
@riverpod
Stream<List<TransactionEntity>> transactions(
  TransactionsRef ref, {
  required String month,
  String? filterType,        // expense | income | all
  String? filterCategory,
}) { ... }

@riverpod
class OcrNotifier extends _$OcrNotifier {
  // States: idle | scanning | processing | result | error
}
```

### Feature Providers — AI Chat

```dart
@riverpod
Stream<List<ChatSession>> chatSessions(ChatSessionsRef ref) { ... }

@riverpod
class ActiveChatNotifier extends _$ActiveChatNotifier {
  // Manages message send, stream updates, typing state
}
```

### Provider State Pattern

```dart
// All async providers follow AsyncValue<T> pattern
// Widgets use .when(data:, loading:, error:) for state rendering
ref.watch(aiExpenseInsightProvider(currentMonth)).when(
  data: (insight) => AiInsightCard(insight: insight),
  loading: () => FwShimmer(height: 120),
  error: (e, _) => FwErrorView(onRetry: () => ref.invalidate(aiExpenseInsightProvider)),
);
```

---

## 6. Data Layer — Repositories & Models

### Model Mapping Convention

Every Firestore document has a corresponding `*Model` (data layer) that maps to a pure `*Entity` (domain layer). Models handle `fromJson`/`toJson`/`fromFirestore`/`toFirestore`.

```dart
// Example — TransactionModel
class TransactionModel extends TransactionEntity {
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) { ... }
  Map<String, dynamic> toFirestore() { ... }
}
```

### Key Repositories

| Repository Interface | Implementation | Key Methods |
|---|---|---|
| `AuthRepository` | `AuthRepositoryImpl` | `signIn`, `signUp`, `signOut`, `watchAuthState` |
| `UserProfileRepository` | `UserProfileRepositoryImpl` | `watchProfile`, `updateProfile`, `uploadAvatar` |
| `TransactionRepository` | `TransactionRepositoryImpl` | `watchByMonth`, `add`, `edit`, `delete`, `batchUpdateSummary` |
| `MonthlySummaryRepository` | `MonthlySummaryRepositoryImpl` | `watch`, `incrementFields`, `updateAiInsight` |
| `BudgetRepository` | `BudgetRepositoryImpl` | `getCurrent`, `save`, `updateCategoryLimit` |
| `GoalsRepository` | `GoalsRepositoryImpl` | `watchAll`, `create`, `updateAmount`, `delete` |
| `AiChatRepository` | `AiChatRepositoryImpl` | `watchSessions`, `createSession`, `appendMessage`, `archive` |
| `LearnRepository` | `LearnRepositoryImpl` | `getModules`, `watchProgress`, `completeLesson`, `submitQuiz` |
| `VideoInsightsRepository` | `VideoInsightsRepositoryImpl` | `getAll`, `analyzeVideo`, `checkDuplicate` |
| `SchemesRepository` | `SchemesRepositoryImpl` | `getRecommended`, `getAll` |
| `NotificationsRepository` | `NotificationsRepositoryImpl` | `watchAll`, `markRead`, `getUnreadCount` |

### Monthly Summary Atomic Update

Every `add/edit/delete` transaction triggers an atomic batch write:

```dart
// Firestore batch in TransactionRepositoryImpl
final batch = _firestore.batch();
batch.set(txnRef, txnData);                        // Write transaction
batch.update(summaryRef, {                          // Update monthly summary
  'totalExpense': FieldValue.increment(amount),
  'txnCount': FieldValue.increment(1),
  'categoryBreakdown.${category}': FieldValue.increment(amount),
  'updatedAt': FieldValue.serverTimestamp(),
});
batch.update(userRef, {                             // Update user profile cache
  'currentMonthSpent': FieldValue.increment(amount),
});
await batch.commit();
```

---

## 7. AI Integration Layer

All AI calls route through a central `AiClient` that handles Gemini API communication, PII stripping, and response parsing.

### AI Client Architecture

```
lib/core/network/
├── ai_client.dart              # Dio-based Gemini HTTP client
├── ai_request_builder.dart     # Context builders for each AI feature
├── ai_response_parser.dart     # Typed response parsers
└── pii_filter.dart             # ⚠️ Strip PII before every AI call
```

### `AiClient` — Core Methods

```dart
class AiClient {
  Future<ExpenseInsightResponse>  getExpenseInsight(ExpenseInsightRequest req);
  Future<BudgetGenerationResponse> generateBudget(BudgetGenerationRequest req);
  Future<ChatReply>               sendChatMessage(ChatRequest req);
  Future<GoalAdviceResponse>      getGoalAdvice(GoalAdviceRequest req);
  Future<VideoInsightResponse>    analyzeVideo(VideoInsightRequest req);
  Future<SchemeRecommendation>    recommendSchemes(SchemeRequest req);
  Future<ExpensePrediction>       predictExpenses(PredictionRequest req);
  Future<OcrCategorizationResult> categorizeOcr(OcrRequest req);
  Future<LearningPathResponse>    getPersonalizedPath(LearningPathRequest req);
}
```

### Model Routing

| Feature | Gemini Model | Reason |
|---|---|---|
| Budget Generation | `gemini-1.5-pro` | Complex multi-field reasoning |
| Expense Prediction | `gemini-1.5-pro` | 6-month time-series analysis |
| Goal Advisor | `gemini-1.5-pro` | Nuanced financial planning |
| AI Chat | `gemini-1.5-flash` | Low-latency conversational |
| OCR Categorizer | `gemini-1.5-flash` | Fast structured extraction |
| Scheme Recommender | `gemini-1.5-flash` | Tag-matching + ranking |
| Learning Path | `gemini-1.5-flash` | Module ranking |
| Video Insights | `gemini-1.5-flash` | Transcript summarization |
| Smart Alerts | `gemini-1.5-flash` | Alert copy generation |

### Cache Strategy in Repositories

```dart
// AiInsight cache check before calling Gemini
Future<AiInsight> fetchExpenseInsight(String userId, String month) async {
  final summary = await _summaryRepo.get(userId, month);
  
  // Return cached if fresh (< 24 hours)
  if (summary.aiInsightSummary != null &&
      summary.aiInsightGeneratedAt != null &&
      DateTime.now().difference(summary.aiInsightGeneratedAt!).inHours < 24) {
    return AiInsight.fromCached(summary);
  }
  
  // Build PII-safe context and call Gemini
  final context = _piiFilter.buildSafeContext(userId, month);
  final result = await _aiClient.getExpenseInsight(context);
  
  // Cache result
  await _summaryRepo.updateAiInsight(userId, month, result);
  return result;
}
```

---

## 8. Firebase Integration

### Firestore Collection Constants

```dart
// lib/core/constants/firebase_constants.dart
class FirestoreCollections {
  static const users              = 'users';
  static const transactions       = 'transactions';
  static const monthlySummaries   = 'monthly_summaries';
  static const budgets            = 'budgets';
  static const goals              = 'goals';
  static const aiChats            = 'ai_chats';
  static const videoInsights      = 'video_insights';
  static const learningProgress   = 'learning_progress';
  static const quizResults        = 'quiz_results';
  static const badges             = 'badges';
  static const notifications      = 'notifications';
  static const consultantBookings = 'consultant_bookings';
  static const learningModules    = 'learning_modules';
  static const lessons            = 'lessons';
  static const quizzes            = 'quizzes';
  static const governmentSchemes  = 'government_schemes';
  static const expertConsultants  = 'expert_consultants';
  static const availability       = 'availability';
  static const dailyTips          = 'daily_tips';
}
```

### FCM — Push Notification Handling

```dart
// lib/core/services/fcm_service.dart
class FcmService {
  Future<void> initialize();        // Request permissions, get token, save to Firestore
  void handleForegroundMessage();   // Show FwSnackbar or in-app overlay
  void handleBackgroundMessage();   // Parse deepLink → navigate on app open
  Future<void> updateFcmToken();    // Called on login / token refresh
}
```

**Deep link handling from notifications:**
- `deepLink: "/budget/category/food"` → navigate to `BudgetDetailScreen` + scroll to food category
- `deepLink: "/goals/goalId_xyz"` → navigate to `GoalDetailScreen`
- `deepLink: "/learn/moduleId"` → navigate to `ModuleDetailScreen`

### Firebase Storage Paths

```dart
class StoragePaths {
  static String avatar(String userId) => 'users/$userId/profile/avatar.jpg';
  static String receipt(String userId, String txnId) => 'users/$userId/receipts/$txnId.jpg';
  static String moduleImage(String moduleId) => 'learning/$moduleId/cover.jpg';
  static String consultantPhoto(String consultantId) => 'consultants/$consultantId/photo.jpg';
}
```

### Security Rules Alignment

The Flutter app enforces Firestore security rules by:
- Always using Firebase Auth UID as the Firestore path segment (`users/{userId}`)
- Never attempting cross-user reads
- Read-only collections (`learning_modules`, `government_schemes`, `daily_tips`, `expert_consultants`) queried with authenticated user but never written to from client

---

## 9. Shared Widgets Library

### `FwButton`

```dart
// lib/shared/widgets/fw_button.dart
// Variants: primary, secondary, ghost, destructive
// States: idle, loading, disabled
FwButton(
  label: 'Generate Budget',
  onPressed: onPressed,
  isLoading: state.isGenerating,
  variant: FwButtonVariant.primary,
  prefixIcon: Icons.auto_awesome,
)
```

### `FwCard`

Consistent elevated card with `borderRadius: 16`, configurable padding, optional border gradient for AI-featured cards.

### `FwLoadingIndicator`

Two variants: `FwShimmer` (skeleton screens) and `FwSpinner` (inline action loading). Shimmer sizes match their corresponding widgets for smooth loading transitions.

### `FwAiThinkingIndicator`

Gemini-branded animated dots indicator shown while any AI API call is in progress. Used inside `AiInsightCard`, `AiChatScreen` typing indicator, `AiBudgetGenerateButton`.

### `FwCategoryIcon`

```dart
// Maps category string → Icon + Color
FwCategoryIcon(category: 'food')         // 🍔 amber
FwCategoryIcon(category: 'transport')    // 🚗 blue
FwCategoryIcon(category: 'shopping')     // 🛍 purple
FwCategoryIcon(category: 'health')       // 💊 green
FwCategoryIcon(category: 'bills')        // ⚡ orange
FwCategoryIcon(category: 'investment')   // 📈 teal
```

---

## 10. Theme & Design System

### Color Palette

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  // Brand
  static const primary     = Color(0xFF6C63FF);  // Indigo
  static const secondary   = Color(0xFF00C9A7);  // Teal
  static const accent      = Color(0xFFFFB703);  // Amber (AI elements)

  // Semantic
  static const success     = Color(0xFF2DC653);
  static const warning     = Color(0xFFFFA62B);
  static const error       = Color(0xFFE63946);
  static const info        = Color(0xFF4CC9F0);

  // Surfaces (Light)
  static const surfaceL    = Color(0xFFF8F9FA);
  static const cardL       = Color(0xFFFFFFFF);

  // Surfaces (Dark)
  static const surfaceD    = Color(0xFF0F0F13);
  static const cardD       = Color(0xFF1C1C22);

  // Categories
  static const catFood         = Color(0xFFFFB703);
  static const catTransport    = Color(0xFF4895EF);
  static const catShopping     = Color(0xFF7B2FBE);
  static const catHealth       = Color(0xFF2DC653);
  static const catEntertainment= Color(0xFFFF6B6B);
  static const catBills        = Color(0xFFFF8600);
  static const catInvestment   = Color(0xFF00C9A7);
  static const catOther        = Color(0xFF90A4AE);
}
```

### Typography

```dart
// lib/core/theme/app_text_styles.dart
// Font: Inter (primary) + Roboto Mono (amounts)
static const displayLarge  = TextStyle(fontSize: 32, fontWeight: FontWeight.w700);
static const headlineMedium= TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
static const titleLarge    = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
static const bodyLarge     = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
static const labelSmall    = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5);
static const amountDisplay = TextStyle(fontFamily: 'RobotoMono', fontSize: 28, fontWeight: FontWeight.w700);
```

### Spacing & Dimensions

```dart
// lib/core/constants/app_dimensions.dart
static const paddingS  = 8.0;
static const paddingM  = 16.0;
static const paddingL  = 24.0;
static const paddingXL = 32.0;
static const radiusS   = 8.0;
static const radiusM   = 16.0;
static const radiusL   = 24.0;
static const radiusXL  = 32.0;
static const cardElevation = 2.0;
```

---

## 11. Dependency Injection & Services

### Service Locator Registration

```dart
// lib/core/di/service_locator.dart
void setupServiceLocator() {
  // Firebase
  getIt.registerSingleton(FirebaseFirestore.instance);
  getIt.registerSingleton(FirebaseAuth.instance);
  getIt.registerSingleton(FirebaseStorage.instance);

  // Core services
  getIt.registerSingleton(AiClient());
  getIt.registerSingleton(OcrService());
  getIt.registerSingleton(FcmService());
  getIt.registerSingleton(LocalStorageService());
  getIt.registerSingleton(ConnectivityService());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl());
  // ... all feature repositories
}
```

### Initialization Sequence (`main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  setupServiceLocator();
  await getIt<FcmService>().initialize();
  await getIt<LocalStorageService>().initialize();
  runApp(ProviderScope(child: FinWiseApp()));
}
```

---

## 12. Security & PII Safety

All AI calls pass through `PiiFilter` before any data leaves the device to the Gemini API. This is a hard architectural constraint enforced at the `AiRequestBuilder` layer.

### `PiiFilter` — Stripped Fields

```dart
// lib/core/utils/pii_filter.dart
class PiiFilter {
  /// Fields NEVER sent to Gemini — matches FinWise PII Policy
  static const _blockedUserFields = [
    'email', 'displayName', 'phoneNumber', 'photoURL', 'uid'
  ];

  static const _blockedTransactionFields = [
    'title', 'merchantName', 'note', 'ocrRawText'
  ];

  static const _blockedGoalFields = ['title'];
  static const _blockedBookingFields = ['userNotes', 'sessionNotes'];

  Map<String, dynamic> sanitizeUserContext(Map<String, dynamic> raw) {
    return Map.fromEntries(
      raw.entries.where((e) => !_blockedUserFields.contains(e.key))
    );
  }

  Map<String, dynamic> sanitizeTransaction(Map<String, dynamic> raw) {
    return Map.fromEntries(
      raw.entries.where((e) => !_blockedTransactionFields.contains(e.key))
    );
  }
}
```

### Auth & Data Security

- Firebase Auth UID used as all Firestore document paths — server-side security rules enforce `request.auth.uid == userId`
- Biometric auth gating for app open (optional, user-controlled via `biometricEnabled`)
- `local_auth` package for fingerprint / Face ID before showing sensitive screens (transaction list, budget detail)
- FCM token stored in Firestore and invalidated on sign-out
- Receipt images (OCR scans) stored in Firebase Storage under `users/{userId}/receipts/` — only authenticated user can access

---

## 13. Package Dependencies

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.x
  firebase_auth: ^5.x
  cloud_firestore: ^5.x
  firebase_storage: ^12.x
  firebase_messaging: ^15.x
  firebase_analytics: ^11.x

  # State Management
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x

  # Navigation
  go_router: ^14.x

  # Network & AI
  dio: ^5.x
  retrofit: ^4.x

  # Local Storage
  hive_flutter: ^1.x
  shared_preferences: ^2.x

  # UI & Charts
  fl_chart: ^0.x
  lottie: ^3.x
  flutter_animate: ^4.x
  cached_network_image: ^3.x
  shimmer: ^3.x

  # OCR & Camera
  google_mlkit_text_recognition: ^0.x
  camera: ^0.x
  image_picker: ^1.x

  # Utils
  intl: ^0.x
  url_launcher: ^6.x
  flutter_markdown: ^0.x
  local_auth: ^2.x
  connectivity_plus: ^6.x
  uuid: ^4.x
  freezed_annotation: ^2.x
  json_annotation: ^4.x

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.x
  riverpod_generator: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  retrofit_generator: ^8.x
  mocktail: ^1.x
  flutter_lints: ^4.x
```

---

## Architecture Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                        FinWise Flutter App                      │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  SCREENS (13 feature areas · 35+ screens · 100+ widgets) │  │
│  └──────────────────────────┬───────────────────────────────┘  │
│                             │ Riverpod Providers                │
│  ┌──────────────────────────▼───────────────────────────────┐  │
│  │  DOMAIN (Use Cases + Entities + Repository Interfaces)   │  │
│  └──────────────────────────┬───────────────────────────────┘  │
│                             │                                   │
│  ┌──────────────────────────▼───────────────────────────────┐  │
│  │  DATA (Firebase Repos · AiClient · PiiFilter · Cache)    │  │
│  └──────────┬──────────────────────────┬────────────────────┘  │
│             │                          │                        │
│  ┌──────────▼──────────┐   ┌───────────▼───────────────────┐  │
│  │  Firebase           │   │  Google Gemini AI             │  │
│  │  Auth / Firestore   │   │  gemini-1.5-flash (fast)      │  │
│  │  Storage / FCM      │   │  gemini-1.5-pro  (complex)    │  │
│  └─────────────────────┘   └───────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

| Metric | Count |
|---|---|
| Feature Modules | 13 |
| Total Screens | 38 |
| Total Widgets | 105+ |
| Riverpod Providers | 30+ |
| Repository Interfaces | 12 |
| AI-Powered Features | 10 |
| Firestore Collections | 14 |

---

*Document Version: 1.0 | FinWise Flutter Architecture*  
*Gemini AI + Firebase Firestore + Flutter/Dart*  
*PII-Safe by Design | Feature-First Clean Architecture*
