# NovaPay Services

**Professional Digital Services Platform with Cryptocurrency Payment Support**

A complete, production-quality, full-stack web application for a digital services company featuring a service marketplace, customer accounts, order tracking, crypto payment integration, and an admin dashboard.

## Live Demo

- **Frontend (GitHub Pages):** https://freecash123.github.io/novapay-services/
- **GitHub Repository:** https://github.com/freecash123/novapay-services

## Quick Start

```bash
git clone https://github.com/freecash123/novapay-services.git
cd novapay-services/backend
npm install
cp .env.example .env
# Edit .env with your database URL and JWT secrets
npm run migrate
npm run dev
```

## Project Structure

- `frontend/` — Static HTML/CSS/JS frontend (16 pages)
- `backend/` — Node.js/Express API with PostgreSQL
- `database/` — SQL schema

## Pages

16 pages including: Home, About, Services, Pricing, How It Works, Crypto Payments, Checkout, Login, Register, Dashboard, Order Tracking, Admin, Contact, FAQ, Privacy Policy, Terms, Refund Policy

## Deployment

- **Frontend:** Deployable to GitHub Pages or Vercel
- **Backend:** Deployable to Railway, Render, or any Node.js host

## Security

- JWT authentication with bcrypt password hashing
- Server-side payment verification (never client-side)
- Crypto addresses stored in environment variables
- Never stores private keys or seed phrases

Built with ❤️ for the decentralized economy.