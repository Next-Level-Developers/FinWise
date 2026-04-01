import Link from "next/link";

const links = [
  { href: "/features", label: "Features" },
  { href: "/pricing", label: "Pricing" },
  { href: "/about", label: "About" },
  { href: "/blog", label: "Blog" },
];

export function MarketingNavbar() {
  return (
    <header className="sticky top-0 z-40 border-b border-white/8 bg-[#0e0f11cc] backdrop-blur-xl">
      <div className="mx-auto flex h-16 w-full max-w-6xl items-center justify-between px-4 sm:px-6">
        <Link href="/" className="flex items-center gap-2 font-semibold tracking-tight">
          <span className="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-[#4ade80] text-[#0e0f11]">
            ₹
          </span>
          <span className="text-lg text-[#f4f4f5]">FinWise</span>
        </Link>

        <nav className="hidden items-center gap-6 text-sm text-[#9ca3af] md:flex">
          {links.map((link) => (
            <Link key={link.href} href={link.href} className="transition hover:text-[#f4f4f5]">
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-2">
          <Link
            href="/auth/login"
            className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm text-[#f4f4f5] transition hover:border-[#4ade80]"
          >
            Login
          </Link>
          <Link
            href="/auth/register"
            className="rounded-lg bg-[#4ade80] px-3 py-2 text-sm font-semibold text-[#0e0f11] transition hover:bg-[#86efac]"
          >
            Get Started Free
          </Link>
        </div>
      </div>
    </header>
  );
}
