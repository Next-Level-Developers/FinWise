export default function AboutPage() {
  return (
    <div className="space-y-8 pb-12">
      <header className="mx-auto max-w-3xl space-y-4 py-10 text-center">
        <h1 className="text-4xl font-semibold text-[#f4f4f5] sm:text-5xl">Built for Bharat&apos;s Financial Future</h1>
        <p className="text-[#9ca3af]">
          FinWise helps users track expenses, improve money habits, and access practical financial
          guidance through AI-first tools.
        </p>
      </header>

      <section className="grid gap-5 md:grid-cols-3">
        {[
          ["Mission", "Make personal finance guidance simple, actionable, and accessible in India."],
          ["Vision", "Build the most trusted AI finance companion for everyday users."],
          ["Impact", "Enable better spending, stronger savings, and smarter decision-making."],
        ].map(([title, desc]) => (
          <article key={title} className="finwise-card p-5">
            <h2 className="mb-2 text-lg font-semibold text-[#f4f4f5]">{title}</h2>
            <p className="text-sm text-[#9ca3af]">{desc}</p>
          </article>
        ))}
      </section>

      <section className="grid gap-4 rounded-2xl border border-[#2a2b2e] bg-[#141519] p-6 text-center sm:grid-cols-2 lg:grid-cols-4">
        {[
          ["500M+", "Target Users"],
          ["6", "AI Features"],
          ["10+", "Languages"],
          ["1", "Unified Platform"],
        ].map(([value, label]) => (
          <div key={label}>
            <p className="font-mono text-3xl font-semibold text-[#4ade80]">{value}</p>
            <p className="text-sm text-[#9ca3af]">{label}</p>
          </div>
        ))}
      </section>
    </div>
  );
}
