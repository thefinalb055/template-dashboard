/** @type {import('next').NextConfig} */

const nextConfig = {
  eslint: {
    ignoreDuringBuilds: true,
  },
  redirects: async () => {
    return [
      {
        source: "/",
        destination: "/overview",
        permanent: true,
      },
    ]
  },
}

export default nextConfig
