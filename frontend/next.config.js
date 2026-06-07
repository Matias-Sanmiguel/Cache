const withPWA = require('@ducanh2912/next-pwa').default({
  dest: 'public',
  disable: true,
})

/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  env: {
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
  },
}

module.exports = withPWA(nextConfig)
