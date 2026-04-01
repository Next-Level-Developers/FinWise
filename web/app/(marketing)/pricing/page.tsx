const plans = [
  {
    name: "Free",
    price: "₹0",
    period: "/mo",
    cta: "Start Free",
    highlight: false,
    features: ["Expense tracking", "Basic dashboard", "1 financial goal", "Weekly summary"],
  },
  {
    name: "Pro",
    price: "₹199",
    period: "/mo",
    cta: "Upgrade to Pro",
    highlight: true,
    features: ["Everything in Free", "AI chat assistant", "Video insights", "Advanced goal planning"],
  },
  {
    name: "Team",
    price: "₹499",
    period: "/mo",
    cta: "Contact Team",
    highlight: false,
    features: ["Shared workspaces", "Admin controls", "Priority support", "Analytics exports"],
  },
];

export default function PricingPage() {
  return (
    <div className="space-y-10 pb-12">
      <header className="space-y-3 py-10 text-center">
        <h1 className="text-4xl font-semibold text-[#f4f4f5] sm:text-5xl">Simple, Transparent Pricing</h1>
        <p className="text-sm text-[#9ca3af]">Monthly billing now. Yearly plans with 20% savings coming soon.</p>
      </header>

      <section className="grid gap-5 md:grid-cols-3">
        {plans.map((plan) => (
          <article
            key={plan.name}
            className={`rounded-2xl border p-6 ${
              plan.highlight
                ? "border-[#4ade80] bg-gradient-to-b from-[#132217] to-[#121316]"
                : "border-[#2a2b2e] bg-[#161719]"
            }`}
          >
            <p className="text-sm text-[#9ca3af]">{plan.name}</p>
            <p className="mt-2 font-mono text-4xl font-semibold text-[#f4f4f5]">
              {plan.price}
              <span className="text-base text-[#9ca3af]">{plan.period}</span>
            </p>
            <ul className="mt-5 space-y-2 text-sm text-[#c7cdd7]">
              {plan.features.map((feature) => (
                <li key={feature}>• {feature}</li>
              ))}
            </ul>
            <button
              type="button"
              className={`mt-6 w-full rounded-lg px-4 py-2 text-sm font-semibold ${
                plan.highlight
                  ? "bg-[#4ade80] text-[#0e0f11]"
                  : "border border-[#2a2b2e] text-[#f4f4f5]"
              }`}
            >
              {plan.cta}
            </button>
          </article>
        ))}
      </section>
    </div>
  );
}
