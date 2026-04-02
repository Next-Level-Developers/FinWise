# 🎨 FinWise — UI Design Guide
### Screen-by-Screen Prompt Reference | Inspired by Dark Finance Dashboard Aesthetic

> **Design Philosophy:** Dark-first, data-forward, premium fintech feel.  
> **Color Palette:** Deep black (`#0A0A0A`) backgrounds, off-white text, mint/teal accent (`#4ECDC4`), coral/pink (`#F7A8B8`), golden yellow (`#F4C96B`), muted dark cards (`#1A1A1A` / `#222222`).  
> **Typography:** Monospaced or tabular numerics for all amounts. Bold large display numbers. Clean sans-serif for labels.  
> **Cards:** Rounded corners (~16–24dp radius), dark elevated surfaces, no harsh borders — depth via subtle shadow and background contrast.  
> **Charts:** fl_chart with custom dark-themed colors matching palette above.  
> **Bottom Nav:** Icon-only or icon + label, dark background, active indicator as accent underline or tinted icon.

---

## 🗂️ Design Token Reference

Use these tokens consistently across every screen prompt below.

```
Background Base:     #0A0A0A  (true black)
Surface Card:        #1A1A1A  (card background)
Surface Elevated:    #252525  (modals, bottom sheets)
Surface Subtle:      #141414  (inner sections)

Accent Mint:         #4ECDC4  (primary brand, positive amounts, progress)
Accent Coral/Pink:   #F7A8B8  (highlights, giveaway, secondary data)
Accent Gold:         #F4C96B  (warnings, offline, goals)
Accent Purple:       #A78BFA  (AI / Gemini features)
Accent Blue:         #60A5FA  (info, schemes, links)

Text Primary:        #F5F5F5
Text Secondary:      #9A9A9A
Text Muted:          #555555

Income Green:        #4ADE80
Expense Red:         #F87171

Border Subtle:       rgba(255,255,255,0.06)
Shadow:              0 4px 24px rgba(0,0,0,0.6)
```

---

## 1. AUTH FLOW

---

### 1.1 `SplashScreen`

> Design a **full-screen dark splash screen** for a fintech app called **FinWise**.
>
> - Background: true black `#0A0A0A`
> - Center: FinWise logo (stylized "FW" monogram or wordmark) in mint-teal (`#4ECDC4`) with a soft glow/bloom effect
> - Below logo: tagline text — *"Not just tracking money — improving financial intelligence"* in small muted gray
> - A Lottie animation plays on the logo (subtle pulse or reveal animation, ~2 seconds)
> - No navigation chrome, no buttons — purely a branded loading moment
> - Status bar: dark/transparent
> - Subtle radial gradient glow in teal behind the logo to add depth
> - Overall mood: premium, calm, trustworthy

---

### 1.2 `LoginScreen`

> Design a **dark-themed login screen** for FinWise, a personal finance app.
>
> **Layout (top → bottom):**
> - Top: FinWise logo + "Welcome back" heading in large bold white text, subtext in gray
> - Email input field: dark card surface, rounded corners, mint-teal focused border, email icon prefix
> - Password input field: same style, lock icon prefix, eye toggle suffix for visibility
> - "Sign In" primary button: full-width, mint-teal background, bold black label, 14dp radius
> - "or continue with" divider line with muted text in center
> - Google Sign-In button: dark card surface, Google logo on left, "Continue with Google" label in white
> - "Don't have an account? Register" text link at bottom
> - "Forgot Password?" link below password field, right-aligned in muted teal
>
> **Style:** True black background, card-style input fields with `#1A1A1A` surface, no harsh borders, rounded 16dp, generous padding. Inputs glow faintly in mint when focused.

---

### 1.3 `RegisterScreen`

> Design a **dark-themed registration screen** for FinWise.
>
> **Layout:**
> - "Create Account" heading bold white, subtext gray
> - Three input fields (Name, Email, Password) — dark card style, consistent with Login
> - Password field includes a **strength indicator bar** below it (red → yellow → green as strength grows), small label "Weak / Fair / Strong"
> - "Create Account" full-width primary button in mint-teal
> - "or" divider
> - Google Sign-In button (same as Login screen)
> - "Already have an account? Sign In" link at bottom
>
> **Style:** Same dark premium aesthetic as LoginScreen. The password strength bar uses: red `#F87171` / amber `#F4C96B` / green `#4ADE80`.

---

## 2. ONBOARDING FLOW

---

### 2.1 `OnboardingShellScreen` (container)

> Design the **shell/wrapper UI for a 5-step onboarding flow** in a dark fintech app.
>
> - Top: Step progress indicator — 5 dots or a segmented bar. Active step in mint-teal, completed steps in dim teal, upcoming in dark gray. Animate fill on progress.
> - Below progress: large step title text (bold white) + subtitle description (gray)
> - Center: content area (changes per step — see below)
> - Bottom: "Next →" primary mint-teal button (full-width), and a "Back" ghost text button above or beside it
> - No bottom nav bar visible during onboarding
> - Background: true black, content card area has subtle `#1A1A1A` surface

---

### 2.2 `StepOccupationScreen`

> Design the **occupation selection step** for FinWise onboarding.
>
> - Heading: "What best describes you?" bold white
> - 4 large tappable **occupation cards** in a 2×2 grid:
>   - 💼 Salaried Employee
>   - 🏪 Business Owner
>   - 🎓 Student
>   - 💻 Freelancer
> - Each card: dark `#1A1A1A` surface, rounded 20dp, centered emoji (large, ~40px), label below in white, subtext descriptor in gray
> - **Selected state:** card background shifts to mint-teal tint (`rgba(78,205,196,0.15)`), border glows mint, subtle scale-up animation (1.03)
> - Unselected: no border or very subtle dark border
> - Cards should feel premium and tactile, not flat/generic

---

### 2.3 `StepIncomeScreen`

> Design the **income range selection step** for FinWise onboarding.
>
> - Heading: "What's your monthly income?" bold white
> - Horizontally scrollable row of **income range chips** styled as pill buttons:
>   - e.g., "Under ₹15K" / "₹15K–₹30K" / "₹30K–₹50K" / "₹50K–₹1L" / "₹1L+"
> - Each chip: dark surface, rounded pill shape (radius 100dp), white label
> - **Selected chip:** mint-teal background, black bold label
> - Chips have a gentle horizontal scroll with left/right fade-out edges
> - Below chips: a soft motivational note in muted gray — *"This helps us personalize your budget and goals"*

---

### 2.4 `StepGoalsScreen`

> Design the **financial goals multi-select step** for FinWise onboarding.
>
> - Heading: "What are your financial goals?" bold white, subtext "Select all that apply"
> - Grid of emoji + label **goal chips** (3 per row or wrap layout):
>   - 🏠 Buy a Home / 🚨 Emergency Fund / ✈️ Vacation / 📈 Invest / 🎓 Education / 🚗 Vehicle / 💍 Wedding / 💰 Retire Early
> - Each chip: dark card surface, rounded 16dp, large emoji + label, compact size
> - **Selected:** mint-teal background tint + mint border + checkmark badge on top-right corner
> - Multi-select behavior: multiple can be selected simultaneously
> - Animate selection with a light bounce/scale effect

---

### 2.5 `StepLanguageScreen`

> Design the **language preference selection step** for FinWise onboarding.
>
> - Heading: "Choose your preferred language" bold white
> - 5 language tiles in a vertical list or 2-column grid:
>   - 🇬🇧 English / 🇮🇳 हिंदी / 🇮🇳 मराठी / 🇮🇳 தமிழ் / 🇮🇳 తెలుగు
> - Each tile: dark card surface `#1A1A1A`, flag emoji large on left, language name in native script + English name small below
> - **Selected tile:** left-side mint-teal accent bar + teal text highlight + soft background tint
> - Subtle separator lines between tiles

---

### 2.6 `OnboardingCompleteScreen`

> Design the **onboarding completion/celebration screen** for FinWise.
>
> - Full screen dark background with a **Lottie celebration animation** (confetti, sparkles, or check animation) playing in the center
> - Large emoji 🎉 or animated check
> - Bold heading: "You're all set, [Name]!" in white, large
> - Subtext: personalized message — *"We've built your financial profile. Let's start your journey to financial freedom."* in gray
> - "Get Started →" large primary button in mint-teal, full-width, at the bottom
> - Optionally: 3 small stat pills showing what was configured (e.g., "Income Range Set ✓", "3 Goals Selected ✓", "Language: English ✓") in dark chips with green checkmarks

---

## 3. DASHBOARD

---

### 3.1 `DashboardScreen`

> Design a **scrollable dark dashboard screen** for FinWise, a personal finance app. This is the main home screen.
>
> **Layout (top to bottom, full scroll):**
>
> **① GreetingHeader**
> - Top: user avatar (small circle, top-left) + "Good morning, Ravi 👋" bold white heading + date subtitle in gray
> - Top-right: notification bell icon with a small unread badge dot (mint or red)
>
> **② MonthlySpendCard**
> - Dark card `#1A1A1A`, rounded 24dp, horizontal layout
> - Left: "Total Spent" label gray + large bold amount display `₹24,575` in white monospaced font + "+23% vs last month" badge in a pill (green or coral depending on direction)
> - Right: small sparkline/line chart in mint showing spending trend
> - Card has a subtle color-gradient background (very subtle, not garish)
>
> **③ BudgetProgressRing (inside or below MonthlySpendCard)**
> - A donut/ring chart showing budget used vs remaining
> - Ring segments: mint (spent), dark gray (remaining)
> - Center text: percentage used, bold
> - Legend: "₹X spent of ₹Y budget"
>
> **④ CategoryBreakdownChart**
> - Card with title "Spending by Category"
> - Horizontal bar chart (fl_chart style): each bar a category (Food, Transport, Shopping, etc.)
> - Bars use mint, coral, gold, purple — color per category
> - Category icon + name left, amount right
>
> **⑤ AiInsightCard**
> - Distinctive card with a subtle purple/AI glow (`rgba(167,139,250,0.1)` background)
> - Top: ✨ Gemini icon + "AI Insight" label in purple
> - Body: 2–3 sentence insight summary in white/gray text
> - Bottom: "See Full Analysis →" link in purple
> - Collapsed by default with expand toggle
>
> **⑥ QuickActionRow**
> - 4 icon-button tiles in a horizontal row inside a dark card:
>   - ➕ Add Expense (mint)
>   - 📷 Scan Receipt (gold)
>   - 🤖 AI Chat (purple)
>   - 📊 Budget (coral)
> - Each tile: dark surface, rounded 16dp, centered icon + small label below
>
> **⑦ GoalSnapshotCard**
> - Card titled "Your Goals"
> - Shows top 2 goals: goal emoji + name + linear progress bar (mint fill) + "₹X of ₹Y" + days remaining chip
>
> **⑧ NextMonthForecastCard**
> - Card with AI icon, "Next Month Forecast" title
> - Predicted spend amount in large text, confidence % badge
> - Soft amber/gold accent for forecast warning if high
>
> **⑨ RecentTransactionsList**
> - Section header: "Recent Transactions" + "See All →" link
> - 5 transaction rows: circle avatar/icon (category color) + name + date + amount (green for income, red for expense)
>
> **⑩ DailyTipBanner**
> - Full-width card at bottom, mint-teal left border accent
> - 💡 icon + tip text in light gray
> - "Tip of the day" label above in muted text

---

## 4. TRANSACTIONS

---

### 4.1 `TransactionsScreen`

> Design a **dark transactions list screen** for FinWise.
>
> **Layout:**
> - AppBar: "Transactions" title + search icon (top right)
> - **MonthSelector:** Horizontal month navigation — left arrow `<` / current month label (e.g., "October 2024") / right arrow `>` — centered, styled as a dark pill with chevrons
> - **TransactionFilterBar:** Segmented control or chip row — "All" / "Expense" / "Income" / "Recurring" — active chip in mint-teal, inactive in dark gray
> - **MonthlySummaryStrip:** Compact card showing "Total In: ₹X" (green) and "Total Out: ₹X" (red) side by side
> - **TransactionListView:** Grouped by date (date label as section header in muted gray). Each transaction item (see below).
> - **AddTransactionFab:** Floating action button bottom-right, mint-teal background, "+" icon, expandable on long-press to show "Manual" and "Scan" options
>
> **TransactionListItem widget:**
> - Left: colored circle icon representing category (food = orange, transport = blue, etc.)
> - Center: transaction title (bold white) + timestamp (muted gray)
> - Right: amount — income in `#4ADE80` green with "+" prefix, expense in `#F87171` red with "−" prefix, bold monospaced font
> - Subtle divider between items, no harsh borders
> - Row has slight background highlight on press

---

### 4.2 `AddTransactionScreen`

> Design a **dark add transaction form screen** for FinWise.
>
> **Layout (scrollable form):**
> - AppBar: "Add Transaction" title + close/back icon
> - **AmountInputField:** Prominently large — centered, "₹" prefix in gray, large monospaced number input in white (48sp+). Type toggle "Expense / Income" as two pills above the amount, active type highlighted mint (income) or red (expense)
> - **Title field:** Standard dark input, "Transaction title" placeholder
> - **Category Grid:** 2×4 or 3×3 grid of rounded square tiles — emoji icon + label. Selected tile: mint-teal border + background tint. Categories: Food, Transport, Shopping, Health, Entertainment, Bills, Savings, Others
> - **PaymentMethodSelector:** Horizontal chip row — UPI / Cash / Card / Net Banking. Selected: mint fill.
> - **DatePickerField:** Dark input with calendar icon, shows selected date
> - **Recurring Toggle:** Row with label "Recurring?" + a styled iOS-style toggle switch (mint when on)
> - **Note field:** Multiline dark text input, "Add a note (optional)" placeholder
> - **Save Button:** Full-width mint-teal primary button at bottom, "Save Transaction" label

---

### 4.3 `OcrScanScreen`

> Design a **dark OCR receipt scanner screen** for FinWise.
>
> **Layout:**
> - Full screen camera preview as background
> - **ScanOverlayPainter:** Semi-transparent dark overlay everywhere except the scan zone. Scan zone is a rounded rectangle in center with glowing mint-teal corner brackets (not a full border — just 4 corners)
> - "Point camera at your receipt" instruction text below the scan zone in white with slight shadow
> - **CaptureButton:** Large circle button at the bottom center — white outer ring, mint-teal inner fill, camera/shutter icon. Tappable to trigger OCR.
> - Once captured: transition to result preview below the camera
>
> **OcrResultPreviewCard (bottom sheet after scan):**
> - Slides up from bottom as a dark bottom sheet
> - "Extracted Info" title with ✓ icon
> - Editable fields pre-filled: Amount / Merchant / Date / Category (each as dark inline input)
> - "Confirm & Save" mint primary button + "Retake" ghost button

---

## 5. BUDGET

---

### 5.1 `BudgetScreen`

> Design a **dark monthly budget overview screen** for FinWise.
>
> **Layout:**
> - AppBar: "Budget" title + current month label
>
> **① BudgetOverviewCard**
> - Large dark card at top
> - Donut ring chart (fl_chart): shows total spent vs total budget, segments in mint (spent) and dark gray (remaining)
> - Center of ring: "₹X remaining" in bold white
> - Below ring: "₹X spent of ₹Y budget" in gray
> - BudgetVarianceChip: pill badge — green "Under Budget ✓" or red "Over Budget ✗"
>
> **② AiBudgetGenerateButton**
> - Full-width card/button with purple AI glow, "✨ Generate AI Budget" label, Gemini icon
> - Loading state: shimmer + "Analyzing your spending..." text
>
> **③ CategoryBudgetBar list (8 categories)**
> - Each row: category icon (circle colored) + category name + horizontal progress bar + "₹X / ₹Y" right
> - Bar fill color: mint if under limit, amber if near limit (>80%), red if over
> - BudgetVarianceChip: small pill at end of each row
> - Tappable to expand inline editor (BudgetCategoryEditor) with a text input to override limit
>
> **④ BudgetReasoningTile**
> - Collapsed card at bottom: "AI Reasoning ✨" header with chevron
> - Expanded: Gemini's reasoning text in gray, styled cleanly

---

### 5.2 `BudgetSetupScreen`

> Design a **dark budget setup screen** for FinWise (shown for a new month).
>
> - AppBar: "Set Up Budget — [Month]"
> - Two large cards as options at top:
>   - 🤖 "Generate with AI" — purple glow card, description "Let Gemini analyze your history and suggest limits"
>   - ✏️ "Set Manually" — standard dark card
> - If "Set Manually" chosen: list of category rows with **slider or text-input** for budget limit per category
> - Category rows: icon + name + amount input (dark rounded field) + "₹" prefix
> - Bottom: "Save Budget" full-width mint button

---

### 5.3 `BudgetDetailScreen`

> Design a **dark budget detail/drill-down screen** for a single budget category in FinWise.
>
> - AppBar: category name (e.g., "Food Budget")
> - Top card: large donut ring showing category spend vs limit + center amount
> - Transactions list filtered to this category — same TransactionListItem style
> - Edit limit button (pencil icon, top right)
> - BudgetVarianceChip prominently displayed

---

## 6. GOALS

---

### 6.1 `GoalsScreen`

> Design a **dark financial goals overview screen** for FinWise.
>
> - AppBar: "Goals" + "+" add button top-right (mint-teal icon)
> - Scrollable list of GoalCard widgets
>
> **GoalCard widget:**
> - Dark card `#1A1A1A`, rounded 20dp, padding inside
> - Left: **GoalProgressArc** — small circular arc showing % complete, colored in mint-teal
> - Center: goal emoji (large) + goal title (bold white) + "₹X saved of ₹Y" in gray
> - Bottom of card: thin linear progress bar in mint + "X days remaining" pill badge in gold/amber
> - Tappable → GoalDetailScreen

---

### 6.2 `GoalDetailScreen`

> Design a **dark goal detail screen** for FinWise.
>
> - AppBar: goal title + status toggle (Active/Paused) top-right
>
> **① Large GoalProgressArc**
> - Big circular arc (180–270° sweep) centered on screen with % complete in large bold text center + goal emoji inside
> - Arc fills from left to right in mint-teal, unfilled portion in dark gray
> - Animated fill on screen entry
>
> **② Stats row** (below arc):
> - 3 stat chips: "₹X Saved" / "₹Y Remaining" / "Z Days Left"
>
> **③ MilestoneTimeline**
> - Vertical timeline with 4 milestones: 25% / 50% / 75% / 100%
> - Completed milestones: mint checkmark + filled circle
> - Upcoming: gray dotted circle
> - Current: pulsing mint circle
>
> **④ AiGoalAdviceCard**
> - Purple AI-glow card with ✨ icon + "AI Advice" title
> - Gemini suggestion text in white/gray
> - "Refresh Advice" button (ghost style, purple border)
>
> **⑤ "Add Contribution" Button**
> - Full-width mint button at bottom → opens GoalContributionSheet

---

### 6.3 `CreateGoalScreen`

> Design a **dark create goal screen** for FinWise.
>
> - AppBar: "New Goal"
> - **GoalCategoryPicker:** emoji grid (2×4 or scrollable row) — 🏠 🚗 ✈️ 🎓 💍 🚨 📈 💰 — selected emoji gets mint-teal ring
> - **Goal Title field:** dark input, pre-filled with selected category name, editable
> - **Target Amount field:** Large ₹ amount input (same style as AddTransaction)
> - **Target Date field:** Date picker input
> - **Priority Selector:** Low / Medium / High — 3 pill chips, selected in mint
> - **Monthly Contribution field:** "How much can you save monthly?" ₹ input + AI suggestion badge "AI suggests ₹X"
> - **Save button:** full-width mint-teal at bottom

---

## 7. AI CHAT ASSISTANT

---

### 7.1 `AiChatListScreen`

> Design a **dark AI chat sessions list screen** for FinWise.
>
> - AppBar: "AI Assistant" title + Gemini/bot icon
>
> **ChatSessionTile list:**
> - Each tile: dark card `#1A1A1A`, rounded 16dp
> - Left: AI avatar icon (purple gradient circle with ✨ or bot icon)
> - Center: session title (e.g., "Budget Analysis — Oct") bold white + last message preview in gray (1 line, ellipsis) + timestamp muted
> - Right: **ChatModeChip** — small pill: "Budget" (mint) / "Investment" (gold) / "General" (blue)
>
> **NewChatFab:**
> - Bottom-right FAB, purple background, ✨ + "New Chat" label (extended FAB style)

---

### 7.2 `AiChatScreen`

> Design a **dark AI chat screen** for FinWise's Gemini-powered assistant.
>
> **Layout:**
> - AppBar: session title + mode label chip on right
> - **ChatModeSelector:** horizontal tab bar below AppBar — "General" / "Budget" / "Investment" — active tab underline in mint-teal or respective mode color
>
> **MessageListView (main content):**
> - User bubbles: right-aligned, mint-teal background (`rgba(78,205,196,0.2)`), mint border, rounded (16dp bottom-left, 4dp bottom-right), white text
> - AI/model bubbles: left-aligned, dark `#1A1A1A` card surface, rounded (16dp bottom-right, 4dp bottom-left), gray/white text, small ✨ icon top-left of bubble
> - **TypingIndicator:** 3 pulsing dots (purple/mint) in an AI bubble while waiting for response
> - **SuggestedActionChips:** Below AI bubble, horizontal scroll of dark pill chips → tappable, routes to relevant screen
>
> **FollowUpSuggestions:** Horizontal scrollable chip row just above input bar, each chip is a quick question suggestion in dark pill style
>
> **ChatInputBar (bottom):**
> - Dark elevated bar, text input field (dark rounded), send button (mint icon), mic icon on left (for future voice)

---

## 8. LEARN HUB

---

### 8.1 `LearnHubScreen`

> Design a **dark financial education hub screen** for FinWise.
>
> **Layout:**
> - AppBar: "Learn" + streak counter badge (🔥 X day streak) top-right
>
> **① ProgressHeader**
> - Card showing overall learning progress: "X of Y modules complete" with linear progress bar (mint fill) + "Level: Beginner/Intermediate/Advanced" badge
>
> **② AiPathRecommendationBanner**
> - Purple-glow wide card: "✨ AI recommends for you: [Module Name]" — tap to go to module
>
> **③ BadgeShelf**
> - Horizontal scroll of earned badge icons (circle icons, colored) with names below. Locked badges shown in grayscale
>
> **④ ModuleCard list (scrollable)**
> - Each module: dark card `#1A1A1A`, 20dp radius
> - Module icon (emoji or illustration) in a colored rounded square top-left
> - Title bold white + description 2-line gray + "X lessons" chip + completion progress bar
> - "Start" or "Continue" CTA text in mint-teal on right

---

### 8.2 `ModuleDetailScreen`

> Design a **dark learning module detail screen** for FinWise.
>
> - AppBar: module title
> - Header card: module emoji large + title + description + progress "Lesson X of Y"
>
> **LessonListItem × N:**
> - Numbered list of lessons
> - Each row: step number circle (mint if done, dark if upcoming) + lesson title + estimated time chip
> - Completed lessons: checkmark ✓ in mint, strikethrough or lighter title
> - Tappable → LessonReaderScreen

---

### 8.3 `LessonReaderScreen`

> Design a **dark lesson reader screen** for FinWise's financial education content.
>
> - AppBar: "Lesson X of Y" + close
> - Top: **ReadingProgressBar** — thin mint linear bar at very top of screen (scroll-driven progress)
> - Content area: clean markdown-rendered article style
>   - H1/H2 headings in white
>   - Body text in light gray (`#D1D1D1`), comfortable 16sp, 1.6 line height
>   - Code/highlight blocks in dark surface `#252525` with mint accent left border
>   - Inline bold/italic with slight contrast shifts
> - Bottom: "Next Lesson →" full-width mint-teal button
> - If video lesson: embedded video player card with dark controls

---

### 8.4 `QuizScreen`

> Design a **dark financial quiz screen** for FinWise.
>
> - AppBar: "Quiz — [Module Name]" + "Question X / Y"
> - **QuizProgressBar:** Thin segmented bar at top (X segments, filled segments = answered, current = active)
> - **QuizQuestionCard:** Large dark card, question text in white bold, comfortable size
> - **4 option buttons:** Full-width dark rounded buttons with option label (A/B/C/D circle prefix)
>   - Normal: dark `#1A1A1A` surface
>   - Selected before submit: mint-teal border + light tint
>   - Correct answer revealed: green background `rgba(74,222,128,0.15)` + green border + ✓
>   - Wrong answer: red background `rgba(248,113,113,0.15)` + red border + ✗
> - **AnswerFeedbackOverlay (after answer):** Small card below options showing explanation text
> - **QuizResultScreenOverlay (final screen):** Full-screen overlay — score large (e.g., "8 / 10"), pass/fail badge, badge earned Lottie animation if passed, "Retry" and "Back to Module" buttons

---

## 9. YOUTUBE INSIGHT ANALYZER

---

### 9.1 `VideoInsightsScreen`

> Design a **dark YouTube video insights screen** for FinWise.
>
> - AppBar: "Video Insights" title
>
> **YoutubeUrlInputBar:**
> - Top: dark input field, YouTube icon prefix (red), "Paste YouTube URL..." placeholder, "Analyze →" button (mint pill)
>
> **VideoInsightLoadingAnimation:**
> - When analyzing: show Lottie loading animation (brain/AI thinking style) + "Analyzing video with Gemini..." text + animated progress steps: "Fetching transcript → Extracting insights → Summarizing..."
>
> **VideoThumbnailCard list (past analyzed videos):**
> - Section header: "Previously Analyzed"
> - Each card: dark `#1A1A1A`, YouTube thumbnail image (rounded 12dp left) + video title bold + channel name gray + date analyzed + "RelevanceScore" badge (e.g., "92% relevant" in gold)
> - Tappable → VideoInsightDetailScreen

---

### 9.2 `VideoInsightDetailScreen`

> Design a **dark video insight detail screen** for FinWise.
>
> - AppBar: "Video Insights" + share icon
> - **VideoThumbnailCard:** Wide card with thumbnail image, video title bold, channel name, video duration chip
> - **RelevanceScoreBadge:** Prominent colored badge — green/gold based on score
>
> **KeyTipsList:**
> - Section: "💡 Key Financial Tips" heading
> - Bulleted list of extracted tips — each bullet is a dark mini-card with mint left border accent and tip text
>
> **ActionPointsCard:**
> - "✅ Action Points" section
> - Each actionable step: checkbox (tappable, toggles check state in mint) + action text
>
> **RelatedGoalsChips:**
> - "Related to your goals:" label + horizontal chips linking to relevant user goals in mint

---

## 10. GOVERNMENT SCHEMES

---

### 10.1 `SchemesScreen`

> Design a **dark government financial schemes screen** for FinWise.
>
> - AppBar: "Schemes for You" title
>
> **FilterChips:** Horizontal scroll row — "All" / "Loan" / "Subsidy" / "Insurance" / "Savings" — active in mint-teal
>
> **SchemeCard list:**
> - Each card: dark `#1A1A1A`, rounded 20dp
> - Left: large emoji (government/scheme icon) in a colored rounded square
> - Center: scheme name bold white + tagline gray (1–2 lines)
> - Top-right: **MatchScoreBadge** — pill showing "XX% Match" color-coded: green (>75%) / amber (50–75%) / red (<50%)
> - Bottom row: **BenefitTypeChip** (small pill — e.g., "Loan" in blue, "Subsidy" in gold)

---

### 10.2 `SchemeDetailScreen`

> Design a **dark government scheme detail screen** for FinWise.
>
> - AppBar: scheme name
> - **SchemeHeaderCard:** Ministry name + large emoji/logo + scheme full name bold + tagline
> - **MatchScoreBadge:** Large prominent score + "Why you match:" subheader
> - **MatchReasonText:** AI-generated explanation in light gray card with purple AI glow accent
> - **EligibilityTagsList:** Horizontal wrap of chips — each eligibility criterion as a dark pill
> - Scheme description: MarkdownRenderer with styled headers, paragraphs, bullets
> - **SchemeApplyButton:** Full-width mint-teal button at bottom — "Apply on Official Website →" with external link icon

---

## 11. EXPERT CONNECT

---

### 11.1 `ExpertConnectScreen`

> Design a **dark expert/consultant listing screen** for FinWise.
>
> - AppBar: "Expert Connect" title
>
> **FilterBar:** Segmented chips — "All" / "Mutual Funds" / "Tax Planning" / "Retirement" + language filter. Active chip mint.
>
> **ConsultantCard list:**
> - Each card: dark `#1A1A1A`, rounded 20dp, horizontal layout
> - Left: consultant photo (circular, 56dp) — uses FwAvatar with fallback initials
> - Center: name bold white + designation gray + SpecializationChips (mini pills: "Mutual Funds", "Tax")
> - Right column: ⭐ rating (gold star + number) + "₹X / session" fee label
> - Bottom of card: "View Profile →" mint-teal text link

---

### 11.2 `ConsultantProfileScreen`

> Design a **dark consultant profile screen** for FinWise.
>
> - **ConsultantAvatarHeader:** Large hero section — blurred gradient background, large circular avatar (100dp), name bold white large, designation gray, ⭐ rating + "X reviews" below
> - **SpecializationChips:** Full list of chips below header
> - **SessionInfoCard:** 3-column card — "Fee: ₹X" / "Duration: 45 min" / "Mode: Google Meet" with icons
> - **BiographyText:** Expandable text card — bio in gray, "Show more / less" toggle
> - **ReviewsSection:** Rating stars visual + total count + 2–3 short review cards
> - **BookSessionButton:** Bottom sticky full-width mint-teal button — "Book a Session →"

---

### 11.3 `BookingSlotScreen`

> Design a **dark session booking screen** for FinWise.
>
> - AppBar: "Book with [Name]"
>
> **AvailabilityCalendar:**
> - Month calendar view, dark theme
> - Today: mint underline
> - Available dates: white labels
> - Unavailable: muted gray, non-tappable
> - Selected date: mint-teal filled circle background
>
> **SlotPicker:**
> - Grid of time slot chips for selected date — e.g., "10:00 AM", "2:00 PM", "4:30 PM"
> - Available: dark chip, white label
> - Selected: mint-teal chip, black label
> - Booked/unavailable: dark muted, strikethrough
>
> **SessionNotesField:**
> - Multiline dark input — "What would you like to discuss?" placeholder
>
> **BookingConfirmationSheet (bottom sheet):**
> - Summary: consultant name + date/time + fee
> - "Confirm Booking" full-width mint-teal button
> - "Payment via UPI / Card" note in gray below button

---

## 12. NOTIFICATIONS

---

### 12.1 `NotificationsScreen`

> Design a **dark notifications screen** for FinWise.
>
> - AppBar: "Notifications" + "Mark All Read" text button
>
> **NotificationListItem × N:**
> - Each item: dark card row, rounded 16dp
> - Left: large emoji or icon with a colored background circle (type-based):
>   - 💸 Overspend Warning → red circle
>   - 🏆 Goal Milestone → gold circle
>   - 🎖️ Badge Earned → purple circle
>   - 📋 Scheme Recommendation → blue circle
> - Center: title bold white + body text gray (2 lines max) + timestamp muted
> - Right: **UnreadBadge** — small filled mint or type-color dot for unread
> - **Accent left border** on card: colored per notification type (red/gold/purple/blue)
> - Swipe left to archive (slide action with trash icon background)

---

## 13. PROFILE & SETTINGS

---

### 13.1 `ProfileScreen`

> Design a **dark user profile screen** for FinWise.
>
> - **ProfileAvatar header section:**
>   - Top: large circular avatar (100dp), camera icon overlay for upload
>   - Below: display name bold white large + occupation chip (e.g., "Salaried Employee" pill) + income range chip
>
> - **ProfileInfoCard:** dark card with "Edit" button icon top-right
>   - Rows: occupation / income range / joined date (each row: label gray + value white)
>
> - **EligibilityTagsChips:** "Your Scheme Eligibility" section title + horizontal wrap of dark pills (eligibility tags)
>
> - **BadgeShelf:** "Badges Earned" section — horizontal scroll of circular badge icons (colored, named below). Locked badges: grayscale with lock icon overlay
>
> - **SettingsTile row:** "Settings →" with gear icon, chevron right
>
> - **SignOutButton:** Text button at bottom in muted red `#F87171` — "Sign Out"

---

### 13.2 `SettingsScreen`

> Design a **dark settings screen** for FinWise.
>
> - AppBar: "Settings" + back arrow
>
> **Grouped SettingsTile list (use section headers in muted gray ALL-CAPS):**
>
> **APPEARANCE**
> - ThemeSelector: label "Theme" + 3 pill options "Light / Dark / System" (active = mint)
> - LanguageSelector: label "Language" + current language + chevron (tap → picker sheet)
>
> **SECURITY**
> - Biometric toggle: label "Biometric Login" + iOS-style toggle switch (mint when on)
>
> **NOTIFICATIONS**
> - Notifications toggle: "Push Notifications" + toggle
>
> **PREFERENCES**
> - Currency display: "Currency Format" + current (₹ Indian Rupee) + chevron
>
> **LEGAL**
> - "Privacy Policy" tile + external link icon
> - "Terms of Service" tile + external link icon
>
> **DANGER ZONE (red-accented section)**
> - "Delete Account" tile in red `#F87171` text, trash icon, chevron → confirmation dialog

---

## 14. SHARED / REUSABLE WIDGETS

---

### 14.1 Shared Widget Prompts

> **FwAppBar:**  
> Design a dark AppBar for FinWise — background `#0A0A0A`, title in white bold, back arrow in white, action icons in white. No elevation line. Status bar dark/transparent.

> **FwButton (Primary):**  
> Full-width rounded button (14dp radius), mint-teal `#4ECDC4` background, bold black label, press state slightly darker. Loading state: circular spinner replacing label.

> **FwButton (Ghost):**  
> Full-width rounded button, transparent background, mint-teal border (1.5dp), mint-teal label text.

> **FwCard:**  
> Dark `#1A1A1A` background card, 20dp border radius, inner padding 16dp, shadow `0 4px 24px rgba(0,0,0,0.6)`. No visible border — depth from background contrast.

> **FwTextField:**  
> Dark `#1A1A1A` background input, 12dp radius, hint text in `#555555`, typed text white, focused: mint-teal border 1.5dp glow. Error state: red border + error text below.

> **FwLoadingIndicator (Shimmer):**  
> Dark shimmer skeleton — base `#1A1A1A`, shimmer highlight `#2A2A2A` moving left-to-right. Matches shape of content being loaded.

> **FwEmptyState:**  
> Centered Lottie animation (empty box / no data style) + title white + subtitle gray + optional CTA button. Dark background.

> **FwAvatar:**  
> Circular image widget. Fallback: colored circle with user initials in white, bold. Sizes: small (32dp), medium (48dp), large (80dp+).

> **FwAiThinkingIndicator:**  
> Animated three-dot indicator in purple (`#A78BFA`), pulsing/bouncing animation. Used in chat and wherever Gemini is processing.

> **FwChip (Status):**  
> Small pill badge. Variants:
> - Success: green `rgba(74,222,128,0.15)` bg + green text
> - Warning: amber `rgba(244,201,107,0.15)` bg + amber text
> - Error: red `rgba(248,113,113,0.15)` bg + red text
> - AI/Gemini: purple `rgba(167,139,250,0.15)` bg + purple text + ✨ prefix

> **FwBottomSheet:**  
> Dark `#1A1A1A` bottom sheet, 24dp top radius, drag handle bar at top center (small rounded pill in `#333333`), inner padding 20dp.

> **FwSnackbar:**  
> Compact floating bar at bottom, dark surface with colored left-border:
> - Success: mint border
> - Error: red border
> - Info: blue border

---

## 15. BOTTOM NAVIGATION BAR

---

> Design a **dark bottom navigation bar** for FinWise.
>
> - Background: `#111111` or `#0A0A0A` with a very subtle top border `rgba(255,255,255,0.05)`
> - 5 tabs: 🏠 Home / 🧾 Transactions / 📊 Budget / 🎯 Goals / 📚 Learn
> - **Active tab:** Icon in mint-teal (`#4ECDC4`) + label in mint-teal below + optional thin mint underline bar above icon
> - **Inactive tabs:** Icon in `#555555` (muted gray), no label or muted label
> - Icon size: 24dp, label size: 10sp
> - No background card on selected — just color change
> - Safe area aware (handles iPhone home indicator)

---

*FinWise UI Design Guide v1.0 — All prompts reference the design aesthetic from the dark finance dashboard mockup.*  
*Use these prompts with your preferred AI image/UI generator or pass them directly to Flutter widget implementation prompts.*
