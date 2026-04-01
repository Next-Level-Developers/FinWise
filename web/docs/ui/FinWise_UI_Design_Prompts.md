# 🎨 FinWise — UI Design Prompt Guide
### Complete Page-by-Page UI Prompts | Dark Finance Theme
> **Design Reference:** Dark dashboard (near-black `#0E0F11` background), muted green/teal accents, charcoal card surfaces, monospace number fonts, minimal borders. Inspired by the CashMate dashboard reference image.
> **Stack:** Next.js 14 · Tailwind CSS · Recharts · shadcn/ui

---

## 🎨 Global Design System Prompt

```
Design a dark-mode financial dashboard UI system for FinWise — an AI-powered personal finance 
app for Indian users. Use the following design tokens throughout every page:

Background: #0E0F11 (near-black)
Card surface: #161719 (dark charcoal)
Card border: 1px solid #2A2B2E (subtle separator)
Primary accent: #4ADE80 (muted green — positive values, CTAs)
Danger accent: #F87171 (muted red — negative values, overspending)
Warning accent: #FBBF24 (amber — alerts, pending states)
Info accent: #60A5FA (blue — neutral data, info)
Text primary: #F4F4F5 (off-white)
Text secondary: #9CA3AF (cool gray)
Text muted: #4B5563 (dark gray — labels, captions)
Sidebar width: 220px (collapsible to 64px icon-only mode)
Font: Inter for UI, JetBrains Mono for numbers and amounts
Border radius: 12px for cards, 8px for inputs, 6px for badges
Spacing unit: 4px base grid
Chart colors: #7C3AED (purple), #2563EB (blue), #D97706 (amber), 
              #DC2626 (red), #059669 (green), #DB2777 (pink)

Every page sits inside a fixed sidebar + topbar shell. The sidebar is always visible on desktop.
All monetary amounts display in Indian Rupee format (₹ symbol, Indian comma system).
Positive values are green, negative values are red. 
Transitions: 150ms ease for hover states, 200ms for panel reveals.
```

---

## 🌐 PUBLIC / MARKETING PAGES

---

### 1. Landing Page — `/`

```
Design the FinWise landing page with a dark theme (#0E0F11 background). 

NAVBAR: Fixed top navbar with FinWise logo (wallet icon + wordmark in green), navigation links 
(Features, Pricing, About, Blog), and two CTA buttons — "Login" (ghost outline) and 
"Get Started Free" (solid green, rounded). On scroll, add a frosted glass blur to the navbar.

HERO SECTION: Full-width hero with a bold headline split across 2 lines:
"Your Money, Finally" on line 1, "Under Control." on line 2 (with "Under Control" in green 
gradient text). Subheadline: "AI-powered expense tracking, smart budgeting, and personalized 
financial education — built for India." Two CTA buttons: "Start for Free →" (green) and 
"Watch Demo" (ghost with play icon). Below CTAs, show social proof: "Trusted by 10,000+ users" 
with 5 avatar circles overlapping. Right side: floating animated preview of the dashboard 
widget — a dark card showing a donut chart and a mini transaction list, slightly tilted with 
a subtle glow border.

FEATURES STRIP: Horizontal scrolling strip with 5 icon+label pills:
Expense Tracking · AI Chat Assistant · YouTube Insights · Learning Modules · Goal Planning

FEATURES SECTION: 3-column grid of large feature cards, each with:
- Colored icon on dark card
- Feature title (bold, white)
- 2-line description (gray text)
- A mini screenshot/mockup of that feature UI
Cards: Expense Tracking, AI Smart Assistant, Financial Learning, Video Insights, 
Goal Planning, Government Scheme Recommender

HOW IT WORKS: 3-step horizontal flow with numbered steps, icons, and connecting dashed lines:
Step 1 "Set Your Profile" → Step 2 "Track & Analyze" → Step 3 "Grow Financially"

TESTIMONIALS: Dark card carousel with 3 testimonials, user avatar, name, occupation tag, 
star rating, and quote. Cards have a subtle left green border accent.

PRICING TEASER: 2 plan cards side by side — Free (dark card) and Pro (green gradient border 
glow card). List 4-5 features each with checkmarks. "Coming Soon" badge on Pro plan.

FOOTER: 4-column footer — Logo+tagline, Product links, Company links, Social icons. 
Bottom bar: copyright + "Made with ❤️ for Bharat" tagline.
```

---

### 2. Features Page — `/features`

```
Design the FinWise Features page with dark theme. 

PAGE HEADER: Centered hero with label pill "All Features", headline "Everything you need 
to master your finances", gray subtext. Green underline accent on "master".

FEATURE DEEP-DIVE SECTIONS: 6 alternating left-right sections, each with:
- Left: Text content (icon, label, headline, 3-4 bullet points with check icons)
- Right: Large dark mockup card showing the actual UI of that feature
- Sections alternate image left / text right for visual rhythm
Features in order: Expense Tracking, AI Chat Assistant, YouTube Video Insights, 
Learning Modules, Goal Planning, Government Schemes

COMPARISON TABLE: Full-width table comparing FinWise vs Walnut vs MoneyView vs ET Money.
Dark table with green checkmarks and gray X marks. FinWise column has a green header highlight.
Rows: Expense Tracking, AI Chat, Video Insights, OCR Bill Scan, Multi-language, 
Goal Planning, Govt Scheme Recommender, Financial Education.

TECH BADGES STRIP: Horizontal row of technology badge pills — Gemini AI, Google ML Kit, 
Next.js, Flutter, Firebase, Recharts. Dark pill with icon and label.

CTA BANNER: Full-width dark green gradient banner at bottom: "Ready to take control?" 
headline, subtext, and "Get Started Free" white button.
```

---

### 3. Pricing Page — `/pricing`

```
Design the FinWise Pricing page with dark theme.

PAGE HEADER: Centered — "Simple, Transparent Pricing" headline with a toggle switch 
for Monthly / Yearly billing (show 20% savings badge on Yearly).

PRICING CARDS: 3 cards in a row — Free, Pro (highlighted with green glow border + 
"Most Popular" badge), and Team. Each card:
- Plan name + tagline
- Large price display (₹0, ₹199/mo, ₹499/mo) with period label
- Divider line
- Feature list with colored checkmarks
- CTA button (outline for Free, solid green for Pro, outline for Team)
Pro card has a subtle animated gradient border glow.

FEATURE COMPARISON TABLE: Detailed table below cards showing all features row by row 
with plan availability. Group rows by category: Core, AI Features, Learning, Support.
Use green dots for included, gray dashes for not included.

FAQ ACCORDION: 5-6 common questions in collapsible accordion style. Dark card with 
chevron icon. Smooth expand/collapse animation.

BOTTOM CTA: "Still unsure? Try Free for 30 days" with ghost button.
```

---

### 4. About Page — `/about`

```
Design the FinWise About page.

HERO: Centered hero — "Built for Bharat's Financial Future" headline. Paragraph about 
FinWise's mission. Background has a subtle radial green glow behind the headline.

MISSION CARDS: 3 cards in a row — Mission, Vision, Impact. Each with icon and paragraph.

STATS ROW: 4 large number stats in a dark strip: "500M+ Target Users", "6 AI Features", 
"10+ Languages", "1 Unified Platform". Numbers in large green monospace font.

TEAM SECTION: Grid of team member cards — circular avatar (gradient placeholder), 
name, role, and 2 social icon links. Dark card with hover lift effect.

TECH STACK SECTION: Visual tech stack diagram — icons arranged in layers:
Frontend Layer → API Layer → AI Layer → Database Layer. 
Dark card background with subtle connecting lines.

STORY TIMELINE: Vertical timeline — hackathon inception → MVP → future roadmap. 
Each event has a dot, date label, and description. Green dot for current/active.
```

---

### 5. Blog Index — `/blog`

```
Design the FinWise Blog page.

PAGE HEADER: "FinWise Insights" headline, subtext "Financial tips, product updates, 
and money wisdom." Search bar with magnifier icon.

FEATURED POST: Large hero card spanning full width — dark card with background image 
(blurred/overlaid), post title in large white text, author info, date, category badge, 
and "Read More →" link.

CATEGORY FILTER: Horizontal scrollable pill tabs — All, Budgeting, Investing, 
Tax Tips, Government Schemes, Product Updates. Active pill is green filled.

POSTS GRID: 3-column grid of blog cards. Each card:
- Thumbnail image area (dark placeholder gradient)
- Category badge (colored by topic)
- Post title (bold, 2 lines max, truncated)
- Excerpt (2 lines, gray text)
- Author avatar + name + read time
- Hover: card lifts, green border appears

PAGINATION: Simple numbered pagination at bottom with prev/next arrows. 
Active page has green background.
```

---

### 6. Blog Post — `/blog/[slug]`

```
Design the FinWise Blog Post detail page.

BREADCRUMB: Blog > Category > Post Title (small gray text at top)

POST HEADER: Centered narrow column — Category badge, Post title (large, 2-3 lines), 
Author row (avatar + name + date + read time), Tags row.

COVER IMAGE: Wide dark card placeholder for cover image with subtle gradient overlay.

ARTICLE BODY: Clean readable typography — Inter font, 18px body size, 1.8 line height, 
max-width 720px centered. Subheadings in white, body in #D1D5DB. 
Code blocks in dark card with monospace font. Blockquotes with left green border.

SIDEBAR (desktop): Sticky right sidebar — Table of Contents (anchor links), 
"Share this post" icons, Related posts (3 cards stacked).

AUTHOR CARD: Dark card at post end — large avatar, name, bio, social links.

RELATED POSTS: 3-column grid of related article cards below author card.
```

---

## 🔐 AUTH PAGES

---

### 7. Login Page — `/auth/login`

```
Design the FinWise Login page.

LAYOUT: Full-screen split layout — Left half is a dark illustration panel with the FinWise 
logo, a decorative dashboard chart mockup (blurred/artistic), and a tagline quote. 
Right half is the auth form panel (slightly lighter dark card).

FORM PANEL: Centered vertically — FinWise logo + "Welcome back" headline, 
gray subtext "Sign in to continue". 

SOCIAL LOGIN: "Continue with Google" button (white icon on dark card, full width) 
with a subtle border.

DIVIDER: "or continue with email" with horizontal lines on each side.

EMAIL FORM:
- Email input field (dark background, subtle border, green focus ring)
- Password input with show/hide toggle eye icon
- "Forgot Password?" link aligned right
- "Sign In" button (full width, solid green, rounded-lg)

BOTTOM: "Don't have an account? Sign up" link.

FOOTER NOTE: "Protected by Firebase Auth · Your data is encrypted" with lock icon.

LEFT PANEL CONTENT: FinWise logo at top, decorative floating dashboard cards in the middle 
(spend chart, AI chat bubble, goal progress bar), testimonial quote at bottom with star rating.
```

---

### 8. Register Page — `/auth/register`

```
Design the FinWise Register/Sign Up page. Same split layout as Login.

FORM PANEL: "Create your account" headline, "Join 10,000+ users managing money smarter" subtext.

GOOGLE BUTTON: "Sign up with Google" (same style as login).

DIVIDER: "or create with email"

FORM FIELDS:
- Full Name input
- Email input  
- Password input with strength indicator bar below 
  (4 segments: weak red → fair amber → good blue → strong green)
- Confirm Password input

TERMS: Checkbox — "I agree to the Terms of Service and Privacy Policy" (links in green)

SUBMIT: "Create Account" full-width green button.

BOTTOM: "Already have an account? Sign in" link.

LEFT PANEL: Same style as login but with different decorative content — 
show the onboarding flow steps as a mini preview.
```

---

### 9. Onboarding Flow — `/auth/onboarding`

```
Design the FinWise 4-step Onboarding wizard page.

LAYOUT: Centered single-column with max-width 560px. Dark full-screen background 
with subtle radial glow. FinWise logo at top.

STEP PROGRESS INDICATOR: 4 connected dots/circles at top — active step is green filled, 
completed steps have checkmark, upcoming steps are gray outline. 
Step labels below each dot: "Who are you?", "Your Income", "Your Goals", "Preferences"

STEP 1 — OCCUPATION TYPE:
Headline "What best describes you?" with emoji illustration above.
4 large clickable selection cards in 2x2 grid:
- 👔 Salaried Employee
- 🏪 Business Owner  
- 🎓 Student
- 💻 Freelancer
Each card: large emoji, title, brief description. Selected state: green border + 
green icon tint + subtle green background glow. Hover: border highlights.
"Continue →" button (disabled until selection made).

STEP 2 — INCOME RANGE:
Headline "What is your monthly income?"
Radio button cards in a vertical list — 6 income range options 
(Under ₹10K, ₹10K-25K, ₹25K-50K, ₹50K-1L, ₹1L-2L, ₹2L+). 
Each option is a selectable row card with radio indicator on right.
Optional: "Enter exact amount" text input that reveals below selection.

STEP 3 — FINANCIAL GOALS:
Headline "Pick your top 3 financial goals"
Subtext "Select up to 3 goals you want to achieve"
Grid of 6 goal option cards (2 columns, 3 rows):
🏠 Buy a House, 🚗 Buy a Vehicle, 🛡️ Emergency Fund, 
✈️ Plan a Vacation, 📈 Start Investing, 🎓 Education Fund
Each card: emoji, goal name. Selected state: green tick badge on top-right corner 
of card, green border. Max 3 selectable (others dim after 3 selected).

STEP 4 — PREFERENCES:
Headline "Customize your FinWise experience"
Language selector: pill grid of 8 languages — English, Hindi, Marathi, Tamil, 
Telugu, Kannada, Bengali, Gujarati. Active: green filled pill.
Theme selector: 2 radio cards — Dark Mode (pre-selected), Light Mode.
Notification toggle: smart alerts on/off.

FINAL BUTTON: "Complete Setup 🎉" (green, full width). 
Shows loading spinner then confetti animation on success before redirecting.
```

---

### 10. Forgot Password — `/auth/forgot-password`

```
Design the FinWise Forgot Password page. Centered card layout on dark background.

CARD: Dark card (max-width 420px, centered) with:
- Back arrow link to login at top
- Lock icon with broken chain (or envelope icon) — large, centered
- "Reset your password" headline
- "Enter your email and we'll send you a reset link" subtext
- Email input field
- "Send Reset Link" green full-width button
- After submission: success state with green checkmark icon, 
  "Check your inbox" message, and "Resend email" link with countdown timer.
```

---

## 📊 DASHBOARD PAGES

> All dashboard pages share the fixed sidebar + topbar shell described below.

---

### 11. Dashboard Shell — Sidebar + Topbar

```
Design the FinWise dashboard shell that wraps all /dashboard/* pages.

SIDEBAR (220px wide, collapsible to 64px):
Top: FinWise logo (icon + wordmark). On collapse: icon only.
Navigation sections:
  GENERAL label (muted caps)
  - 📊 Overview (active state: green left border + green tinted text + subtle green bg)
  - 💸 Transactions
  - 💰 Budget
  - 🎯 Goals
  - 🤖 AI Assistant
  - 🎓 Learn
  - 🏦 Schemes
  - 👨‍💼 Experts
  
  PERSONAL label
  - 🔔 Notifications (with unread badge count in red)
  - ⚙️ Settings

Bottom: User profile mini-card — avatar circle, name, plan badge ("Free") 
and a "Log out" link with exit icon.

Collapse toggle: small arrow button at the top right edge of sidebar.
On mobile: sidebar becomes a slide-out drawer triggered by hamburger icon.

TOPBAR (full width, fixed, 60px height):
Left: Page title (changes per page) + breadcrumb (small, gray)
Center: Global search bar (dark input, magnifier icon, "Search transactions, goals..." 
placeholder, Cmd+K shortcut hint)
Right: Notification bell (with red dot if unread), Language selector pill, 
User avatar (click → dropdown: Profile, Settings, Log out)

TOPBAR notification dropdown: Dark popover card showing 3 recent notifications 
with icon, title, time ago. "View all" link at bottom.
```

---

### 12. Overview / Dashboard — `/dashboard/overview`

```
Design the FinWise main Overview dashboard page. This is the first page users see after login.

LAYOUT: 3-zone responsive grid layout inside the dashboard shell.

TOP STATS ROW: 3 summary stat cards side by side (each ~1/3 width):
Card 1 — TOTAL SPENDINGS: Small label "TOTAL SPENDINGS", large amount "₹28,450" in white 
monospace, change badge "-12%" in red pill, time period dropdown "THIS WEEK ▾". 
Below: mini stacked bar chart (5 bars, each showing category split as colored segments, 
percentage labels above each bar: 35% 12% 20% 9% 24%).
Card 2 — SAVINGS: "SAVINGS" label, "₹2,512.40" amount, "-2%" badge, "THIS YEAR ▾" dropdown.
Mini area chart (dark red/maroon fill, Jan-Jul x-axis).
Card 3 — INVESTMENTS: "INVESTMENTS" label, "₹1,215.25" amount, "+6%" badge in green, 
"THIS YEAR ▾" dropdown. Mini area chart (green fill, rising trend, Jan-Jul x-axis).

MIDDLE ROW: 2 panels side by side (40/60 split):
LEFT — TRANSACTIONS PANEL: "Transactions" header. Grouped list:
TODAY subheader (gray caps label), then 2-3 transaction rows — each row has: 
merchant icon/avatar, merchant name, date+time, amount (+green or -red), category tag.
YESTERDAY subheader, 3 more transaction rows.
DATE subheader (e.g. "JULY 18"), more rows.
Scrollable, thin scrollbar. "View all transactions →" link at bottom.

RIGHT — SPENDING CHART PANEL: "₹9,340.80 Spent" header with Day/Week/Month/Year 
tab switcher (Year tab active, underlined in green). 
Grouped bar chart (Recharts): x-axis Jan-Jul, y-axis ₹0-₹1200. 
Each bar is stacked/grouped with category colors (purple, blue, amber, red, green, pink). 
Hover tooltip showing "TOTAL SPENT ₹589.40" in dark card tooltip. 
Reference dashed horizontal line at average spend level with "₹183.15" label on left.
Legend strip at bottom: • EXPENSES • TRANSFERS • SUBSCRIPTIONS • GROCERY STORE • SHOPPING

BOTTOM ROW (optional): AI Insight Banner — dark card with green robot icon, 
"Your spending insight" heading, 1-2 sentence AI insight text (e.g. "You've spent 23% more 
on dining this month. Consider cooking at home 2 more days a week to save ₹1,800."), 
"Ask AI →" green link button. Dismiss X button top right.

CASHBACK / REWARDS WIDGET: Small card in sidebar bottom area — 
"MONTHLY CASHBACK" label, "₹215.50" in green monospace font.
```

---

### 13. Transactions List — `/dashboard/transactions`

```
Design the FinWise Transactions page.

PAGE HEADER: "Transactions" title, "+ Add Transaction" green button on right, 
"Import CSV" ghost button next to it.

FILTER BAR: Full-width filter strip below header — 
Date range picker (This Month dropdown), Category multi-select dropdown, 
Type toggle (All / Income / Expense / Transfer), Search input (magnifier icon). 
"Clear Filters" text link on far right. Active filters shown as dismissible green pills.

SUMMARY MINI-CARDS: 3 small stat cards in a row: Total Income (green), 
Total Expense (red), Net Balance (green or red based on value). Compact, no chart.

TRANSACTIONS TABLE: Full-width dark table/card:
Columns: Merchant (icon + name), Category (badge), Date, Payment Method, Amount.
Row hover: subtle darker row background.
Each row:
- Merchant: circular icon (first letter initial on gradient bg) + merchant name + note (gray sub-text)
- Category: small colored badge pill (Food 🍕, Transport 🚗, etc.)
- Date: "20 Jul, 6:22 PM" format
- Payment: UPI / Cash / Card chip
- Amount: right-aligned, green for income (+₹44.00), red for expense (-₹9.99)
- Row click → opens transaction detail panel or navigates to /transactions/[id]

GROUPING: Rows grouped by date with date header ("TODAY", "YESTERDAY", "Jul 18") 
as full-width gray separator rows.

PAGINATION: "Showing 1-20 of 143 transactions" + pagination controls at bottom.

EMPTY STATE: If no transactions — centered illustration (dark card with receipt icon), 
"No transactions yet" headline, "Add your first transaction" green button.
```

---

### 14. Add Transaction — `/dashboard/transactions/add`

```
Design the FinWise Add Transaction page.

LAYOUT: Centered form card (max-width 640px) on the dashboard background.

PAGE HEADER: "Add Transaction" title with back arrow ←.

TYPE TOGGLE: 3-segment pill toggle at top of form: EXPENSE | INCOME | TRANSFER.
Active segment has green solid background. This changes form field colors 
(red accent for expense, green for income).

FORM FIELDS in order:
1. AMOUNT: Large centered input — ₹ symbol on left, huge number input (48px font, monospace), 
   placeholder "0.00". Below: quick amount chips — ₹500 ₹1000 ₹2000 ₹5000 (tap to fill).

2. CATEGORY: Grid of category icon buttons (2 rows, 4 columns):
   🍕 Food, 🚗 Transport, 🛍️ Shopping, 🏥 Health, 
   🎬 Entertainment, 📱 Bills, 💰 Salary, 📈 Investment
   Selected: green border + icon tint. Sub-category field appears below on selection.

3. MERCHANT / TITLE: Text input — "Merchant name or description" placeholder.

4. DATE: Date picker input — defaults to today's date. Calendar icon on right.

5. PAYMENT METHOD: Horizontal chip selector — UPI | Cash | Debit Card | Credit Card | 
   Net Banking | EMI. Selected chip: green background.

6. NOTE (optional): Multiline textarea — "Add a note (optional)" placeholder. 
   Collapsible — click "+ Add Note" to expand.

7. RECEIPT SCAN: Dashed border upload area — camera icon + "Scan Receipt with OCR" text. 
   Tap to open camera/file picker. Show thumbnail preview when scanned.

SUBMIT BUTTON: Full-width "Save Transaction" green button (fixed at bottom on mobile).

VALIDATION: Inline red error messages below fields. Amount field shakes on invalid submit.
```

---

### 15. Transaction Detail / Edit — `/dashboard/transactions/[id]`

```
Design the FinWise Transaction Detail page.

LAYOUT: Centered card (max-width 560px) with back navigation.

TRANSACTION HEADER CARD: Large dark card with:
- Category icon (large colored circle) centered at top
- Merchant name (large bold text)
- Amount (very large, red for expense / green for income, monospace)
- Date and time (gray, centered)
- Payment method chip

DETAIL ROWS: Key-value rows in a dark card:
Category, Sub-category, Payment Method, Transaction ID, Note.
Each row: gray label on left, white value on right, subtle divider line.

AI INSIGHT: Small green-tinted banner — "💡 AI Insight: You've spent ₹450 on Apple 
subscriptions this month. Consider auditing your active subscriptions."

ACTIONS ROW: Two buttons — "Edit Transaction" (ghost outline) and "Delete" (red ghost outline). 
Delete shows a confirmation modal before proceeding.

SIMILAR TRANSACTIONS: Small section "More from this merchant" showing 3 past transactions 
as compact rows.
```

---

### 16. Import Transactions — `/dashboard/transactions/import`

```
Design the FinWise CSV / Bank Statement Import page.

PAGE HEADER: "Import Transactions" with back arrow.

STEP INDICATOR: 3-step progress — Upload → Map Columns → Review & Import.

STEP 1 — UPLOAD:
Large dashed-border drop zone card — cloud upload icon, "Drag & drop your CSV or bank 
statement here" text, "or Browse Files" green button.
Supported formats: CSV, XLS, XLSX (shown as small chips below).
Bank quick-select: "Download template for:" with bank logo chips 
— SBI, HDFC, ICICI, Axis, Kotak (tap to download their format).

STEP 2 — MAP COLUMNS:
Table showing detected CSV columns on left with dropdown selectors to map to 
FinWise fields (Date, Amount, Merchant, Type). Auto-mapping shown in green where confident.

STEP 3 — REVIEW:
Preview table of first 10 parsed transactions with edit-in-place for category.
"X transactions found, Y duplicates skipped" summary bar.
"Import All" green button.
```

---

### 17. Budget Overview — `/dashboard/budget`

```
Design the FinWise Budget page.

PAGE HEADER: "Budget" title + "This Month: July 2025" chip + "Edit Budget" ghost button.

OVERALL BUDGET CARD: Wide dark card at top — 
Left: Total budget amount "₹35,000" in large monospace, spent "₹22,450 spent" in gray.
Center: Large circular gauge/donut showing 64% spent — arc is green → amber → red 
gradient based on percentage. Percentage in center in large white text.
Right: "₹12,550 remaining" in green, days remaining "12 days left in July" in gray.

CATEGORY BUDGET GRID: 2-column responsive grid of category budget cards. Each card:
- Category icon + name
- Horizontal progress bar (green → amber → red as % increases past thresholds)
  Green: <70%, Amber: 70-90%, Red: >90%
- "₹4,200 / ₹6,000" spent/budget text
- "70% used" percentage label right-aligned
- If over budget: red "⚠ Exceeded by ₹800" warning text

Categories shown: 🍕 Food, 🚗 Transport, 🛍️ Shopping, 🏥 Health, 
🎬 Entertainment, 📱 Subscriptions, 🏠 Utilities, 🎯 Savings

AI RECOMMENDATION CARD: Green-tinted card at bottom — AI icon, "AI Budget Insight" label,
paragraph recommendation. "Adjust Budget" button.

BUDGET HISTORY CHART: Line chart showing last 6 months budget vs actual spending.
Budget line: dashed green. Actual line: solid white.
```

---

### 18. Create / Edit Budget — `/dashboard/budget/create`

```
Design the FinWise Create Budget page.

PAGE HEADER: "Create Monthly Budget" or "Edit Budget — July 2025" with back arrow.

TOTAL INCOME INPUT: Large input row — "Monthly Income" label, ₹ input field, 
"Update" button. Current value pre-filled.

AI SUGGEST BUTTON: "✨ Let AI Suggest Budget" green button — on click, 
shows loading state then auto-fills all category amounts based on income and spending history.
Show a "Based on your last 3 months average" info note.

CATEGORY BUDGET TABLE: Each category row:
- Category icon + label
- Slider input (drag to set amount, snaps to ₹500 increments)
- ₹ number input (synced with slider)
- "Last month: ₹X,XXX" hint in gray below input

BUDGET SUMMARY SIDEBAR (or bottom panel on mobile):
Donut chart updating in real-time as amounts change.
Total allocated: ₹XX,XXX | Unallocated: ₹X,XXX in green.
Warning if unallocated is negative (over-budgeted).

SAVE BUTTON: "Save Budget" full-width green button.
```

---

### 19. Goals List — `/dashboard/goals`

```
Design the FinWise Goals page.

PAGE HEADER: "My Financial Goals" title + "+ New Goal" green button.

ACTIVE GOALS SECTION: Grid of goal cards (2 columns desktop, 1 mobile). Each goal card:
- Goal icon (large emoji on gradient colored circle background)
- Goal name (bold) + target date chip
- Target amount + saved amount (₹ monospace)
- Progress bar (animated, green fill, rounded)
- Progress percentage + "₹X,XXX more to go" text
- "Add Money" ghost button + "View Details" link at bottom
- Card has a subtle left border in goal's theme color

STATUS BADGES: "On Track 🟢", "At Risk 🟡", "Behind 🔴" badge on top-right of each card.

COMPLETED GOALS SECTION: Collapsible section below — 
Header "Completed Goals ✅ (3)" with chevron toggle.
Completed goal cards: gray/muted styling with green checkmark badge, 
date completed, confetti emoji.

EMPTY STATE: If no goals — illustration of target with arrow, 
"Set your first financial goal" headline, descriptive subtext, "+ Create Goal" green button.
```

---

### 20. Goal Detail — `/dashboard/goals/[id]`

```
Design the FinWise Goal Detail page.

PAGE HEADER: Goal name + back arrow ← + "Edit Goal" ghost button top right.

GOAL HERO CARD: Large dark card:
- Goal emoji icon (large, 64px, on colored gradient circle)
- Goal name heading
- Target amount (large monospace) / Saved amount 
- Large circular progress ring (animated) with percentage in center
- "₹X,XXX to go" subtext
- Target date row with calendar icon
- Status badge: "On Track" green pill

CONTRIBUTION CHART: Bar chart showing monthly contributions over time. 
Each bar represents amount added that month. Hover tooltip shows amount + date.
"Total contributed: ₹X,XXX" summary below chart.

ADD CONTRIBUTION PANEL: Dark card — "Add Contribution" heading, ₹ amount input, 
date picker (defaults today), note input, "Add ₹" green button.
Quick amount chips: ₹500, ₹1000, ₹2000, ₹5000.

AI RECOMMENDATION: "💡 At your current pace, you'll reach your goal by [date]. 
Add ₹X,XXX/month to reach it by your target date." Green-tinted card.

CONTRIBUTION HISTORY LIST: Timeline of past contributions with date, amount, note.

MILESTONES: Horizontal milestone markers — 25%, 50%, 75%, 100% — 
achieved ones shown in green with checkmark.
```

---

### 21. Create Goal — `/dashboard/goals/create`

```
Design the FinWise Create Goal page.

LAYOUT: Centered form card (max-width 580px).

PAGE HEADER: "Create New Goal" with back arrow.

GOAL TYPE SELECTOR: Grid of preset goal types (3 columns):
🏠 House, 🚗 Vehicle, ✈️ Vacation, 🛡️ Emergency Fund, 
📈 Investment, 🎓 Education, 💍 Wedding, 🎯 Custom
Tap to select: green border + icon tint. "Custom" opens a text input for custom name.

FORM FIELDS:
- Goal Name: text input (pre-filled based on type selection)
- Target Amount: ₹ large number input
- Already Saved: ₹ input (starting amount)
- Target Date: date picker with calendar
- Priority: Low / Medium / High radio pills
- Reminder: toggle — "Monthly reminder to contribute" 
  (when on: shows day-of-month selector)

GOAL PREVIEW CARD: Live preview on the right (or below on mobile) — 
shows what the goal card will look like with entered data, 
and "At ₹X,XXX/month you'll reach this goal in Y months" AI calculation.

SAVE BUTTON: "Create Goal 🎯" full-width green button.
```

---

### 22. AI Hub — `/dashboard/ai`

```
Design the FinWise AI Hub page — the entry point for all AI features.

PAGE HEADER: "AI Assistant" title with a small "Powered by Gemini" badge chip (Google colors).

HERO BANNER: Wide gradient card (dark with subtle green radial glow) — 
Large robot/spark icon, "Your Personal Finance AI" heading, 
"Ask anything about your money, get insights, analyze videos" subtext.
Two CTA buttons: "Start Chatting" (green) and "Analyze Expense" (ghost).

AI TOOLS GRID: 3 large tool cards in a row:

Card 1 — AI CHAT ASSISTANT: 💬 icon, "Chat with FinWise AI" title, 
"Ask budget questions, get spending advice, plan your finances" description. 
Mini preview: show a chat bubble preview (user message + AI response snippet). 
"Open Chat →" green button.

Card 2 — VIDEO INSIGHTS: 🎥 icon, "YouTube Finance Insights" title,
"Paste any finance video link — get summary, tips, and action points" description.
Mini preview: show a URL input field mockup with a video thumbnail card.
"Analyze Video →" green button.

Card 3 — EXPENSE BREAKDOWN: 📊 icon, "AI Expense Analysis" title,
"Deep-dive into your spending patterns with AI commentary" description.
Mini preview: show a small donut chart with colored segments.
"View Analysis →" green button.

RECENT AI ACTIVITY: "Recent" section below — 3 recent chats/analyses listed as 
compact cards (icon, title, time ago, type badge).
```

---

### 23. AI Chat — `/dashboard/ai/chat`

```
Design the FinWise AI Chat page.

LAYOUT: Split panel — left 30% for chat history list, right 70% for active chat.

LEFT PANEL — CHAT SESSIONS:
"AI Chat" heading + "+ New Chat" button (green icon, small).
List of past chat sessions — each item: 
  - Robot icon
  - First message preview (truncated, 1 line)
  - Relative time (2 days ago, Yesterday)
  - Active session: green left border + slightly highlighted background.
Search input at top to filter past sessions.

RIGHT PANEL — ACTIVE CHAT:
TOPBAR: Session title (auto-generated from first message) + date.

MESSAGES AREA (scrollable, flex-column, newest at bottom):
User messages: Right-aligned bubble, dark green background (#1a3a2a), white text, 
rounded corners (no bottom-right radius), user avatar on right.
AI messages: Left-aligned bubble, dark charcoal card (#1e2022), white text, 
robot icon on left, subtle green left border accent.
AI message with data: Can include a mini chart or table inside the bubble.
Typing indicator: 3 animated dots (bouncing, green color) while AI is responding.
Timestamps: Small gray text below each message group.

USER CONTEXT PILL: At top of chat area — small pill showing 
"Context: Salaried · ₹45K/month · 2 goals active" — so user knows AI has their data.

INPUT AREA (fixed at bottom):
Textarea (dark, auto-resize, max 4 lines), placeholder "Ask me about your finances..."
Right side: Attach/context icon + Send button (green arrow icon, circular).
Quick prompt chips above input: "Can I afford a vacation?", "Analyze this month", 
"How to save more?", "Investment advice"
Character count shown when typing (right side, gray).
```

---

### 24. Video Insights — `/dashboard/ai/video-insights`

```
Design the FinWise YouTube Video Insights page.

PAGE HEADER: "YouTube Finance Insights" + "Powered by Gemini AI" badge.

INPUT SECTION: Centered card (max-width 720px) with:
YouTube icon (red) + "Paste a YouTube finance video link" label.
Large full-width input with YouTube URL placeholder + "Analyze →" green button.
Small note: "Works with any Hindi or English finance video. Average time: 15-20 seconds."
Recent video chips below (3 previously analyzed, shown as truncated title pills).

LOADING STATES (sequential animation after submitting):
Step 1: "🔍 Fetching video transcript..." with animated progress bar
Step 2: "🤖 Analyzing with Gemini AI..." with pulsing robot icon
Step 3: "✨ Generating insights..." near completion

RESULT CARD (appears after analysis):
Top: Video thumbnail (from YouTube), video title, channel name, duration.

SUMMARY SECTION: Dark card with 🗒️ icon, "Summary" heading, 
2-3 sentence paragraph in clean white text.

KEY FINANCIAL TIPS: Dark card with 💡 icon, "Key Financial Tips" heading,
Bulleted list (4-6 points) — each bullet has a green dot and tip text.

ACTION POINTS: Dark card with ✅ icon, "Your Action Points" heading,
Checklist items (3-5) — each is a checkbox row the user can tick off. 
Checkboxes are green when checked.

ACTION BUTTONS: "Save Insight" (green, saves to Firestore) + 
"Share" (ghost) + "Analyze Another Video" (ghost outline) buttons.

SAVED INSIGHTS SECTION: Below the result, a collapsible "Previously Analyzed (5)" 
section showing past insight cards as compact rows with thumbnail, title, date, arrow.
```

---

### 25. AI Expense Breakdown — `/dashboard/ai/expense-breakdown`

```
Design the FinWise AI Expense Breakdown analysis page.

PAGE HEADER: "AI Expense Analysis" + month selector dropdown (July 2025 ▾).

AI SUMMARY BANNER: Wide green-tinted dark card — 
Robot icon, "AI Summary for July" heading.
3-4 sentence paragraph from Gemini analyzing the month's spending 
(written in friendly conversational tone).
"Regenerate Analysis" ghost button (refresh icon).

VISUAL BREAKDOWN SECTION: 2-column grid:
Left: Large donut chart (Recharts) — category color segments, 
total amount in center "₹28,450 Total". 
Interactive: hover shows category name + amount + percentage tooltip.
Legend: colored dots + category names + amounts listed to the right of chart.

Right: Horizontal bar chart — category bars sorted by spend amount (highest to top).
Each bar shows: icon, category name, bar (with color matching donut), ₹ amount label on right.

MONTH-OVER-MONTH COMPARISON: Table card — 
Columns: Category, Last Month, This Month, Change.
Change column: colored +/- amounts with up/down arrows.
Rows with significant increase (>20%) highlighted with subtle amber tint.
Footer row: TOTAL in bold.

AI CATEGORY INSIGHTS: Stack of insight cards — one per top-3 categories:
Each card: category icon, category name, "You spent ₹X,XXX on [category]" headline,
1-2 sentence insight + recommendation. Small bar showing category vs budget.

TREND CHART: Line chart — last 6 months total expense as line. 
Reference line at average. Current month point highlighted with a green circle.
```

---

### 26. Learn Home — `/dashboard/learn`

```
Design the FinWise Learning Module home page.

PAGE HEADER: "Financial Learning" title + user's XP/points badge 
"⭐ 1,240 XP" on the right (green pill).

LEARNING PATH BANNER: Wide card — personalized greeting:
"Your learning path: Salaried Employee Track 👔"
Progress bar showing overall completion (35% of 12 modules).
"Continue Learning →" green button linking to last incomplete module.

CATEGORIES ROW: Horizontal scrollable pill tabs — 
All | 👔 Salaried | 🏪 Business | 🎓 Student | 📈 Investing | 🧾 Tax | 🏦 Banking

MODULES GRID: 2-column (desktop) / 1-column (mobile) grid of module cards. Each card:
- Colored category icon on gradient background (top of card)
- Module title (bold, e.g. "Understanding Your Salary Slip")
- Short description (2 lines, gray)
- "X lessons · Y min" metadata row
- Progress bar (green fill, 0-100%)
- Status badge: "New", "In Progress", "Completed ✅"
- Difficulty tag: Beginner / Intermediate / Advanced (colored badge)
- "Start" or "Continue" button at card bottom

DAILY TIP CARD: Pinned card at bottom or sidebar — 
💡 "Daily Financial Tip" heading, tip text, share icon. Changes daily.

BADGES/ACHIEVEMENTS STRIP: Horizontal scroll of earned badges — 
each badge: circular icon with label below. Unearned badges shown as gray/locked.
```

---

### 27. Module Detail — `/dashboard/learn/[moduleId]`

```
Design the FinWise Learning Module detail page.

MODULE HEADER: Wide card — module icon (large), module title, category badge, 
difficulty badge, "X lessons · Y min total · Z enrolled" metadata.
Progress bar + "X% Complete" label. "Start / Continue →" and "Take Quiz" buttons.

LESSON LIST: Ordered list of lessons — each lesson row:
- Lesson number (01, 02, etc.) in gray circle
- Lesson title
- Duration (e.g. "5 min read")
- Status icon: 🔒 locked, ○ not started, ◑ in progress, ✅ completed
- Completed rows: green checkmark, title in lighter gray
- Current lesson: green highlight row with "Continue" chip
Lessons unlock sequentially — locked ones are dimmed.

MODULE DESCRIPTION CARD: About section with learning objectives as bullet list 
with green checkmark bullets: "You will learn...", "After this module..."

RELATED MODULES: 3 compact horizontal cards at bottom — smaller module cards.

INSTRUCTOR/SOURCE NOTE: Small card — "Content curated by FinWise AI + 
Verified financial experts". Trust badge.
```

---

### 28. Lesson Content — `/dashboard/learn/[moduleId]/[lessonId]`

```
Design the FinWise individual Lesson page.

LAYOUT: 2-column — main content 70% + right sidebar 30%.

LEFT — LESSON CONTENT:
TOP BAR: Module name > Lesson name breadcrumb. 
Prev lesson ← → Next lesson navigation arrows. Lesson X of Y.

CONTENT BODY (max-width 680px):
Lesson title (large heading)
Estimated read time + author/source (small gray)
Body content: rich text — headings, paragraphs, callout boxes (green tinted for tips, 
amber for warnings, blue for info), numbered/bullet lists, key term highlights.
Inline formula cards for financial formulas (dark code-block style).
Images: dark card placeholder with caption text.

KEY TAKEAWAYS BOX: Green-bordered card at end — "Key Takeaways" heading + bullet list.

NAVIGATION: "← Previous Lesson" and "Next Lesson →" buttons at bottom of content. 
"Mark as Complete" green button (center, prominent).

RIGHT SIDEBAR:
- Module progress mini-card (circular progress ring, lesson checklist)
- "Take Notes" mini textarea (saves locally)
- Related tip or quote in amber callout box
- "Ask AI about this lesson" button → opens AI chat with lesson context pre-loaded
```

---

### 29. Quiz Page — `/dashboard/learn/quiz/[moduleId]`

```
Design the FinWise Quiz page.

LAYOUT: Centered column (max-width 680px) — clean, distraction-free.

QUIZ HEADER: Module name, "Quiz" badge, Question X of Y indicator (dots or fraction), 
Progress bar across the top (green fill advancing per question), Timer (if timed — 
red countdown when <30 seconds).

QUESTION CARD: Large dark card:
Question text (large, 20px, centered or left-aligned).
Answer options: 4 radio-button cards in a 2x2 grid or vertical list.
Each option card: letter badge (A/B/C/D in gray circle) + option text.
Selection states:
  - Hover: dark border highlight
  - Selected (before submit): green border + green bg tint
  - Correct (after submit): green border + checkmark icon + green fill
  - Wrong (after submit): red border + X icon + shows correct answer in green

SUBMIT BUTTON: "Check Answer" (green) → reveals feedback → "Next Question" (green).

RESULT SCREEN: After all questions:
Large score display — "8 / 10 Correct" in big text, 80% circular gauge.
XP earned: "+150 XP" in green badge (animated pop-in).
Performance label: "Excellent! 🎉" / "Good Job! 👍" / "Keep Practicing 📚"
Feedback breakdown: list of questions with correct/wrong indicator.
Buttons: "Retake Quiz" (ghost) | "Back to Module" (green).

BADGE AWARD (if first-time pass): Animated modal overlay — badge image, 
"You've earned the [Module Name] Badge!" headline, confetti particles, "Awesome!" button.
```

---

### 30. Government Schemes — `/dashboard/schemes`

```
Design the FinWise Government Scheme Recommender page.

PAGE HEADER: "Government Schemes" title + "Recommended for you based on your profile" 
subtext with profile summary pills (Salaried · ₹25K-50K · Maharashtrian).

RECOMMENDED SECTION: "⭐ Recommended for You" heading with green star.
Horizontal scroll of 3-4 highlighted SchemeCards:
Each card (slightly larger than standard):
  - Scheme emoji icon (🏦 / 🌾 / 📋)
  - Scheme name (bold)
  - Ministry/department (gray small)
  - Tagline (italic gray)
  - Benefit type badge: Loan / Subsidy / Insurance / Pension (colored)
  - Max benefit amount (green: "Up to ₹10 Lakhs")
  - "View Details →" green button
  - "✅ You may be eligible" green chip at card bottom

FILTER BAR: Horizontal pill tabs — All | Loan | Subsidy | Insurance | Pension | Education.
Below filter: Search input for scheme name search.

ALL SCHEMES GRID: 3-column (desktop) grid of standard SchemeCards.
Compact version of the card — icon, name, ministry, benefit badge, max benefit, button.

SCHEME ELIGIBILITY CHECKER WIDGET: Sidebar card — 
"Check Your Eligibility" heading, 3-4 key profile factors shown (income range, occupation, 
state), "Update Profile" ghost link to ensure best recommendations.
```

---

### 31. Scheme Detail — `/dashboard/schemes/[id]`

```
Design the FinWise Scheme Detail page.

SCHEME HEADER CARD: Dark card — large scheme icon, scheme full name, ministry, 
launch year, "Active" green status badge. "🔗 Apply on Official Site" green button 
(external link). Eligibility status: "✅ You appear to be eligible" / "⚠️ Check eligibility".

DETAIL SECTIONS in tabs or stacked cards:
Tab 1 — OVERVIEW: Description paragraph, tagline, target beneficiaries.
Tab 2 — BENEFITS: Benefits in bullet list, max amount, type of benefit.
Tab 3 — ELIGIBILITY: Eligibility criteria as checklist — 
  ✅ Income below ₹5L (user matches: green checkmark)  
  ✅ Resident of India  
  ❓ Must have Aadhaar-linked bank account (user unknown: gray question)
Tab 4 — HOW TO APPLY: Step-by-step numbered process, required documents list, 
  official portal link button.

AI EXPLANATION CARD: "🤖 AI Explanation" heading — plain language summary of the scheme, 
how it applies to the user, and what to do next. Green-tinted card.

RELATED SCHEMES: 3 compact scheme cards at bottom.
```

---

### 32. Experts — `/dashboard/experts`

```
Design the FinWise Expert Consultant Listings page.

PAGE HEADER: "Book a Financial Expert" title + "Verified certified consultants" subtext.

FILTER BAR: Specialty pills — All | Tax Planning | Investment | Retirement | Insurance | 
Debt Management. Availability toggle: "Available Today" switch.

EXPERT CARDS GRID: 3-column grid of expert profile cards. Each card:
- Circular avatar (gradient placeholder)
- Name (bold)
- Specialty tags (2 colored badge pills)
- Rating: ★★★★☆ (4.7) + review count
- Experience: "8 years" in gray
- Languages: "English, Hindi" small chips
- Session fee: "₹499 / 30 min" in green
- "Book Session" green button
- "✓ Verified Expert" small gray badge with checkmark
Cards have a subtle hover lift + green border transition.

FEATURED EXPERT BANNER: Top-width featured card — 
"Featured Consultant of the Month" banner across top. Slightly larger format.
```

---

### 33. Expert Profile — `/dashboard/experts/[id]`

```
Design the FinWise Expert Profile page.

PROFILE HEADER: Full-width card —
Large circular avatar (left), Name (large), Specialty tags, Rating + review count, 
Verification badge, Languages, Experience, Session fee. 
"Book a Session" prominent green button top right.

ABOUT SECTION: "About Me" paragraph card — bio text, certifications listed with 
official logo/badge icons (CFP, SEBI RIA, etc.).

SPECIALTIES CARD: Grid of specialty chips with icons.

REVIEWS SECTION: "Client Reviews (24)" heading. 
4-5 review cards: avatar, name, date, star rating, review text. 
"Load more" ghost button.

AVAILABILITY PREVIEW: "Available Slots" small calendar showing a week view 
with green available slots and gray booked slots.
"Book a Session →" bottom sticky button on mobile.
```

---

### 34. Book Session — `/dashboard/experts/[id]/book`

```
Design the FinWise Session Booking page.

EXPERT MINI-CARD: Small card at top showing expert avatar, name, specialty, fee.

BOOKING STEPS: 3-step progress — Select Date → Select Time → Confirm.

CALENDAR: Full month calendar (current month) — 
Available dates: white text on dark cells, hover: green bg.
Unavailable dates: gray text, no hover.
Selected date: solid green background, white text.

TIME SLOTS GRID: After selecting date — grid of time slot chips:
"10:00 AM", "11:30 AM", "2:00 PM", "4:30 PM" etc.
Available: dark card, hover green border. 
Selected: green filled chip.
Booked: gray, strikethrough text, not clickable.

SESSION DETAILS FORM:
- Topic / What you need help with: textarea
- Session type: Video Call / Phone Call radio toggle
- Language preference: dropdown

BOOKING SUMMARY CARD: Dark card — expert name, date, time, duration, 
fee with payment method. "Confirm & Pay ₹499" green button.

After confirm: Success page with calendar icon animation, booking details, 
"Add to Google Calendar" button.
```

---

### 35. Notifications — `/dashboard/notifications`

```
Design the FinWise Notification Center page.

PAGE HEADER: "Notifications" title + "Mark all as read" ghost button.

FILTER TABS: All | Unread | Alerts | AI Insights | Goals | Reminders.
Unread count badge on "Unread" tab (red pill).

NOTIFICATION LIST: Full-width list of notification rows. Each row:
- Left: colored icon in circle (🔴 Alert / 🟢 AI / 🟡 Reminder / 🔵 Goal)
- Middle: notification title (bold if unread) + description text (gray, 1-2 lines) + time ago
- Right: small action button if applicable ("View", "Dismiss")
- Unread rows: slightly lighter background + green left-border accent dot
- Row hover: darker bg
- Divider line between rows

NOTIFICATION TYPES shown:
🔴 "⚠️ Budget Alert: You've exceeded your Food budget by ₹1,200"
🟢 "💡 AI Insight: Your spending is 15% lower than last month! Keep it up."  
🟡 "📅 Reminder: EMI due in 3 days — ₹8,400"
🔵 "🎯 Goal Milestone: You've saved 50% toward your Emergency Fund!"
🟡 "📈 Weekly Summary: You spent ₹6,420 this week"

EMPTY STATE (when all read/dismissed): Centered — bell icon, "You're all caught up!" text.

NOTIFICATION SETTINGS LINK: "Manage notification preferences →" at page bottom.
```

---

### 36. Settings — Profile — `/dashboard/settings/profile`

```
Design the FinWise Profile Settings page.

SETTINGS SHELL: Secondary tab bar at top of content area (inside dashboard) —
[Profile] [Preferences] [Security] 
Active tab: green underline + white text. Tabs are text links, not full-width tabs.

PROFILE SECTION: 2-column layout — form fields left, profile card preview right.

AVATAR SECTION: Circular avatar with camera icon overlay on hover. 
"Upload Photo" and "Remove" text links below.

FORM FIELDS:
- Full Name (text input)
- Email (with "Verified ✅" badge, disabled/read-only)
- Phone Number (with "Add" or verified badge)
- Date of Birth (date picker)
- City / State (dropdowns)
- Occupation Type (Job / Business / Student / Freelancer — same cards as onboarding, 
  smaller version, already selected)
- Monthly Income Range (radio pills, 6 options)
- Preferred Language (dropdown)
- Financial Goals (multi-select tags — same as onboarding goal chips)

PROFILE COMPLETION BANNER: Progress bar showing profile completeness % 
(e.g. "Profile 80% complete — Add phone number to reach 100%").

SAVE BUTTON: "Save Changes" green button at bottom. 
Shows "Saved ✓" green success state for 3 seconds after save.
```

---

### 37. Settings — Preferences — `/dashboard/settings/preferences`

```
Design the FinWise App Preferences settings page.
(Same settings shell with 3 tabs as profile settings)

APPEARANCE SECTION: "Appearance" heading.
Theme toggle: Large card selector — Dark Mode (currently active, green check) | 
Light Mode (preview image, click to switch). 
Sidebar toggle: "Compact Sidebar" — toggle switch.

LANGUAGE SECTION: "Language & Region" heading.
Language selector: grid of language pill buttons — English, Hindi, Marathi, Tamil, 
Telugu, Kannada (same as onboarding). Selected: green fill.
Currency display: ₹ Indian Rupee (fixed, gray — non-changeable for now).
Date format: dropdown — DD/MM/YYYY vs MM/DD/YYYY.
Number format: Indian (1,00,000) vs International (100,000) — radio toggle.

NOTIFICATIONS SECTION: "Notification Preferences" heading.
Toggle row list — each row: label + description + toggle switch:
  - Budget Alerts (when category exceeds 90%)
  - Weekly Spending Summary (every Sunday)
  - Goal Milestone Alerts
  - AI Insights (new personalized tip)
  - Bill Reminders
  - Smart Spending Alerts (real-time)

AI PREFERENCES SECTION: "AI Behavior" heading.
Toggle: "Include my financial data in AI context" (on by default, with privacy note).
AI response style: Simple language / Detailed analysis — radio pills.

SAVE BUTTON: "Save Preferences" green button.
```

---

### 38. Settings — Security — `/dashboard/settings/security`

```
Design the FinWise Security Settings page.
(Same settings shell tabs)

CONNECTED ACCOUNT SECTION: "Sign-in Method" heading.
If Google OAuth: Google icon card + "Connected with Google" label + "Disconnect" ghost button.
If email: email displayed + "Change Email" ghost button.

PASSWORD SECTION: "Password" heading.
If email auth: Change password form — Current password, New password, Confirm password inputs. 
Each with show/hide toggle. Password strength meter below new password.
"Update Password" green button.

TWO-FACTOR AUTH: "Two-Factor Authentication" heading.
Toggle switch — when enabled: show QR code card + backup codes section.

ACTIVE SESSIONS: "Active Sessions" heading.
List of sessions — each row: device icon, device name, location, "Active now" or 
last active time, "Revoke" red ghost button.
"Sign out all other devices" full-width red ghost button at section bottom.

DANGER ZONE: Red-tinted card at bottom — "Danger Zone" heading.
"Delete Account" button (red outline) → triggers confirmation modal with 
"Type DELETE to confirm" input field.

DATA PRIVACY: "Your Data" heading. 
"Download all my data" button (exports JSON/CSV of transactions, goals, etc.)
"Request data deletion" link.
```

---

## 📐 SHARED COMPONENT PROMPTS

---

### Loading / Skeleton States

```
Design skeleton loading states for FinWise dashboard pages. Use animated shimmer effect 
(gradient sweeping left to right, #1e2022 to #2a2b2e to #1e2022 color transition, 
1.5 second loop). 

Skeleton shapes should exactly match the layout of the real content:
- Stat cards: 3 rectangle blocks with a smaller block below each (chart placeholder)
- Transaction list: alternating rows of [circle + rectangle + small rectangle] 
- Charts: rectangle block with wavy or flat bottom edge
- Text content: multiple lines of different widths (80%, 100%, 65%, 90%)
All skeleton blocks have border-radius matching the real component.
No text or labels shown during skeleton state.
```

---

### Empty States

```
Design empty state screens for FinWise. Each should have:
- A centered illustration (dark background, flat icon or simple SVG illustration — 
  muted colors matching the page theme, not overly colorful)
- A headline (e.g. "No transactions yet")
- A subtext line (e.g. "Start tracking by adding your first expense")
- A primary CTA button (green)
- Optional: secondary ghost button

Empty states needed for:
- Transactions (receipt icon)
- Goals (target/bullseye icon)
- Notifications (bell icon)
- AI Chat (chat bubble icon)
- Saved Video Insights (play/video icon)
- Learning (book/graduation cap icon)
```

---

### Confirmation Modals

```
Design confirmation modal dialogs for FinWise. 

MODAL SHELL: Dark overlay backdrop (rgba black 70% opacity). 
Centered dark card (max-width 420px, 12px border-radius) with subtle border.

MODAL TYPES:
1. DELETE CONFIRMATION: Red warning icon (triangle with !), 
   "Delete [item name]?" heading, "This action cannot be undone. [Description]" body text.
   Two buttons: "Cancel" (ghost, left) + "Delete" (solid red, right).

2. SUCCESS CONFIRMATION: Green checkmark animation (circle draws then check draws in).
   "[Action] Successful!" heading. Description text. Single "Done" green button.

3. AI ACTION CONFIRM: Robot icon, "AI will use your financial data for this analysis" 
   info text, "Proceed" green + "Cancel" ghost buttons.

All modals: ESC key to close, click outside to close, smooth fade+scale-in animation.
```

---

### Toast Notifications

```
Design toast notification components for FinWise.

Position: Top-right corner, 16px from edges, stack downward if multiple.
Width: 320px, border-radius: 10px, drop shadow.
Auto-dismiss: 4 seconds with progress bar at card bottom.
Dismiss X button on right.
Slide-in from right, slide-out to right.

Types:
SUCCESS: Green left border + green checkmark icon + "Transaction saved!" heading.
ERROR: Red left border + red X icon + "Something went wrong" heading + retry link.
WARNING: Amber left border + warning icon + message.
INFO: Blue left border + info icon + message.
AI INSIGHT: Green left border + robot icon + "New AI insight available" + "View →" link.
```

---

*FinWise UI Design Prompt Guide — v1.0*
*Design Reference: Dark Finance Dashboard | Next.js 14 + Tailwind CSS*
*Total Pages Covered: 38 pages + shared component systems*
