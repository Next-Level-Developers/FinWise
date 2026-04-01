import Link from "next/link";

const posts = [
  {
    slug: "how-to-build-a-50-30-20-budget",
    title: "How to Build a 50/30/20 Budget That Works in India",
    excerpt: "A practical framework to split your salary into needs, wants, and savings.",
    category: "Budgeting",
  },
  {
    slug: "best-emergency-fund-strategy",
    title: "Emergency Fund Strategy: Where to Start and How Much to Save",
    excerpt: "A phased approach to build security without breaking monthly cashflow.",
    category: "Savings",
  },
  {
    slug: "ai-video-insights-for-finance-learning",
    title: "Using AI Video Insights to Learn Finance Faster",
    excerpt: "Turn long finance videos into concise notes and action checklists.",
    category: "Product",
  },
];

export default function BlogIndexPage() {
  return (
    <div className="space-y-8 pb-12">
      <header className="space-y-3 py-10 text-center">
        <h1 className="text-4xl font-semibold text-[#f4f4f5]">FinWise Insights</h1>
        <p className="text-sm text-[#9ca3af]">Financial tips, product updates, and money wisdom.</p>
      </header>

      <section className="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
        {posts.map((post) => (
          <article key={post.slug} className="finwise-card p-5">
            <p className="mb-3 inline-flex rounded-full bg-[#112016] px-2 py-1 text-xs text-[#4ade80]">
              {post.category}
            </p>
            <h2 className="mb-2 text-lg font-semibold text-[#f4f4f5]">{post.title}</h2>
            <p className="mb-4 text-sm text-[#9ca3af]">{post.excerpt}</p>
            <Link href={`/blog/${post.slug}`} className="text-sm font-semibold text-[#4ade80]">
              Read more →
            </Link>
          </article>
        ))}
      </section>
    </div>
  );
}
