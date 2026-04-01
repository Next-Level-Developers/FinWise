import Link from "next/link";

type Props = {
  params: Promise<{ slug: string }>;
};

export default async function BlogDetailPage({ params }: Props) {
  const { slug } = await params;

  return (
    <article className="mx-auto max-w-3xl space-y-6 pb-12 pt-10">
      <Link href="/blog" className="text-sm text-[#9ca3af] hover:text-[#f4f4f5]">
        ← Back to blog
      </Link>
      <p className="inline-flex rounded-full bg-[#112016] px-2 py-1 text-xs text-[#4ade80]">Article</p>
      <h1 className="text-4xl font-semibold text-[#f4f4f5] sm:text-5xl">{slug.replaceAll("-", " ")}</h1>
      <p className="text-sm text-[#9ca3af]">Published by FinWise Team • 6 min read</p>
      <div className="space-y-4 text-[#d1d5db]">
        <p>
          This blog route is now wired for dynamic slugs and ready for CMS or Firestore-backed
          content. We can plug in markdown or database content next.
        </p>
        <blockquote className="rounded-r-lg border-l-4 border-[#4ade80] bg-[#141519] p-4 text-sm text-[#c7cdd7]">
          FinWise helps you convert financial information into clear, practical action.
        </blockquote>
      </div>
    </article>
  );
}
