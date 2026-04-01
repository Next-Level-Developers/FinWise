const deepFeatures = [
  {
    name: "Expense Tracking",
    points: [
      "Fast add/edit transaction workflows",
      "Category-level budgeting visibility",
      "Search and filter by date, type, and merchant",
    ],
  },
  {
    name: "AI Chat Assistant",
    points: [
      "Context-aware financial guidance",
      "Budget and affordability suggestions",
      "Goal planning recommendations",
    ],
  },
  {
    name: "Video Insights",
    points: [
      "YouTube transcript extraction",
      "AI summaries with actionable tips",
      "Save insights for future reference",
    ],
  },
  {
    name: "Learning Modules",
    points: [
      "Occupation-based learning tracks",
      "Progressive module unlocks",
      "Quizzes, XP, and completion badges",
    ],
  },
  {
    name: "Goal Planning",
    points: [
      "Milestone-driven goal cards",
      "Contribution timelines",
      "AI pace projections",
    ],
  },
  {
    name: "Government Schemes",
    points: [
      "Eligibility-driven recommendations",
      "Clear benefit and criteria details",
      "Apply flow guidance",
    ],
  },
];

export default function FeaturesPage() {
  return (
    <div className="space-y-10 pb-12">
      <header className="mx-auto max-w-3xl space-y-3 py-10 text-center">
        <p className="inline-flex rounded-full border border-[#2a2b2e] bg-[#161719] px-3 py-1 text-xs text-[#9ca3af]">
          All Features
        </p>
        <h1 className="text-4xl font-semibold text-[#f4f4f5] sm:text-5xl">
          Everything you need to <span className="gradient-text">master</span> your finances
        </h1>
      </header>

      <div className="space-y-4">
        {deepFeatures.map((feature) => (
          <section key={feature.name} className="finwise-card grid gap-6 p-6 md:grid-cols-2">
            <div>
              <h2 className="mb-3 text-2xl font-semibold text-[#f4f4f5]">{feature.name}</h2>
              <ul className="space-y-2 text-sm text-[#9ca3af]">
                {feature.points.map((point) => (
                  <li key={point} className="flex items-start gap-2">
                    <span className="mt-1 h-2 w-2 rounded-full bg-[#4ade80]" />
                    <span>{point}</span>
                  </li>
                ))}
              </ul>
            </div>
            <div className="rounded-xl border border-[#2a2b2e] bg-[#121316] p-4">
              <div className="h-full min-h-36 rounded-lg border border-dashed border-[#2f3034] bg-[#0f1012]" />
            </div>
          </section>
        ))}
      </div>
    </div>
  );
}
