import Link from "next/link";

export function MarketingFooter() {
  return (
    <footer className="mt-24 border-t border-[#2a2b2e] bg-[#121316]">
      <div className="mx-auto grid w-full max-w-6xl gap-8 px-4 py-14 sm:grid-cols-2 sm:px-6 lg:grid-cols-4">
        <div className="space-y-3">
          <p className="text-lg font-semibold text-[#f4f4f5]">FinWise</p>
          <p className="text-sm text-[#9ca3af]">AI-powered personal finance platform built for Bharat.</p>
        </div>

        <div className="space-y-3">
          <p className="text-sm font-medium text-[#f4f4f5]">Product</p>
          <div className="space-y-2 text-sm text-[#9ca3af]">
            <Link href="/features" className="block hover:text-[#f4f4f5]">Features</Link>
            <Link href="/pricing" className="block hover:text-[#f4f4f5]">Pricing</Link>
            <Link href="/dashboard/overview" className="block hover:text-[#f4f4f5]">Dashboard</Link>
          </div>
        </div>

        <div className="space-y-3">
          <p className="text-sm font-medium text-[#f4f4f5]">Company</p>
          <div className="space-y-2 text-sm text-[#9ca3af]">
            <Link href="/about" className="block hover:text-[#f4f4f5]">About</Link>
            <Link href="/blog" className="block hover:text-[#f4f4f5]">Blog</Link>
          </div>
        </div>

        <div className="space-y-3">
          <p className="text-sm font-medium text-[#f4f4f5]">Follow</p>
          <div className="flex gap-3 text-sm text-[#9ca3af]">
            <a href="#" className="hover:text-[#f4f4f5]">X</a>
            <a href="#" className="hover:text-[#f4f4f5]">LinkedIn</a>
            <a href="#" className="hover:text-[#f4f4f5]">YouTube</a>
          </div>
        </div>
      </div>
      <div className="border-t border-[#2a2b2e] px-4 py-4 text-center text-xs text-[#6b7280] sm:px-6">
        © {new Date().getFullYear()} FinWise. Made with care for Bharat.
      </div>
    </footer>
  );
}
