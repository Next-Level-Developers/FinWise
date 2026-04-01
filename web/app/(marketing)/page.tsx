import Link from "next/link";

const features = [
  "Expense Tracking",
  "AI Chat Assistant",
  "YouTube Insights",
  "Learning Modules",
  "Goal Planning",
  "Scheme Recommender",
];

export default function LandingPage() {
  return (
    <div className="space-y-20 pb-10">
      <section className="grid items-center gap-10 py-10 lg:grid-cols-[1.1fr_0.9fr]">
        <div className="space-y-6">
          <p className="inline-flex rounded-full border border-[#2a2b2e] bg-[#161719] px-3 py-1 text-xs text-[#9ca3af]">
            AI-Powered Finance For India
          </p>
          <h1 className="text-4xl font-semibold leading-tight text-[#f4f4f5] sm:text-5xl lg:text-6xl">
            Your Money, Finally
            <br />
            <span className="gradient-text">Under Control.</span>
          </h1>
          <p className="max-w-2xl text-base text-[#9ca3af] sm:text-lg">
            Track every rupee, understand your spending patterns, and build smarter habits with
            finance AI designed for Indian users.
          </p>
          <div className="flex flex-wrap items-center gap-3">
            <Link
              href="/auth/register"
              className="rounded-xl bg-[#4ade80] px-5 py-3 text-sm font-semibold text-[#0e0f11] transition hover:bg-[#86efac]"
            >
              Start for Free
            </Link>
            <Link
              href="/features"
              className="rounded-xl border border-[#2a2b2e] px-5 py-3 text-sm text-[#f4f4f5] transition hover:border-[#4ade80]"
            >
              Explore Features
            </Link>
          </div>
          <p className="text-sm text-[#6b7280]">Trusted by 10,000+ users across India.</p>
        </div>

        <div className="finwise-card p-6">
          <div className="mb-4 flex items-center justify-between">
            <p className="text-sm text-[#9ca3af]">Monthly Spending</p>
            <span className="rounded-md bg-[#12261a] px-2 py-1 text-xs text-[#4ade80]">-12%</span>
          </div>
          <div className="grid grid-cols-[120px_1fr] gap-5">
            <div className="relative h-[120px] w-[120px] rounded-full border-8 border-[#2a2b2e]">
              <div className="absolute inset-0 rounded-full border-[10px] border-l-[#7c3aed] border-r-[#2563eb] border-t-[#059669] border-b-[#d97706]" />
              <div className="absolute inset-6 rounded-full bg-[#0e0f11]" />
            </div>
            <div className="space-y-3">
              {[
                ["Groceries", "₹8,420"],
                ["Transport", "₹2,650"],
                ["Subscriptions", "₹1,120"],
              ].map(([label, amount]) => (
                <div key={label} className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2">
                  <span className="text-sm text-[#9ca3af]">{label}</span>
                  <span className="font-mono text-sm text-[#f4f4f5]">{amount}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="flex flex-wrap gap-3">
        {features.map((item) => (
          <span
            key={item}
            className="rounded-full border border-[#2a2b2e] bg-[#15161a] px-4 py-2 text-sm text-[#c1c6d0]"
          >
            {item}
          </span>
        ))}
      </section>

      <section className="grid gap-5 md:grid-cols-2 xl:grid-cols-3">
        {[
          {
            title: "AI Smart Assistant",
            desc: "Ask questions about spending, budgets, goals, and financial decisions.",
          },
          {
            title: "Live Transaction Tracking",
            desc: "Capture expenses quickly with category-first workflows and insights.",
          },
          {
            title: "Personalized Learning",
            desc: "Learn money concepts through role-based modules and quizzes.",
          },
          {
            title: "Goal Planning",
            desc: "Track progress to savings milestones with contribution timelines.",
          },
          {
            title: "Video Insights",
            desc: "Paste finance videos and get key takeaways and action points in seconds.",
          },
          {
            title: "Govt Scheme Recommender",
            desc: "Discover relevant schemes based on your profile and eligibility.",
          },
        ].map((card) => (
          <article key={card.title} className="finwise-card p-5">
            <p className="mb-2 text-base font-semibold text-[#f4f4f5]">{card.title}</p>
            <p className="text-sm text-[#9ca3af]">{card.desc}</p>
          </article>
        ))}
      </section>

      <section className="finwise-card flex flex-col items-start justify-between gap-4 p-6 sm:flex-row sm:items-center">
        <div>
          <p className="text-2xl font-semibold text-[#f4f4f5]">Ready to take control?</p>
          <p className="text-sm text-[#9ca3af]">Start free and upgrade when your finance journey grows.</p>
        </div>
        <Link
          href="/auth/register"
          className="rounded-xl bg-[#4ade80] px-5 py-3 text-sm font-semibold text-[#0e0f11] transition hover:bg-[#86efac]"
        >
          Get Started Free
        </Link>
      </section>
    </div>
  );
}
