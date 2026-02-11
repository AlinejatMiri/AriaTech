# Ariatech Computer Store

Responsive Amazon-style computer store with a simple admin dashboard, built with Node.js and Express.

## Features

- **Storefront**
  - Responsive layout inspired by Amazon (top nav, hero banner, product grid)
  - Product list and product detail pages
- **Admin dashboard**
  - View all products
  - Add new products
  - Delete products
- **Storage**
  - Products persist in `data/products.json` (no database required)

## Requirements

- Node.js 18+ installed

## Install

```bash
npm install
```

## Run in development

```bash
npm run dev
```

Then open:

- Storefront: http://localhost:3000/
- Admin dashboard: http://localhost:3000/admin

## Build notes

- Views rendered with EJS templates in `views/`
- Static assets (CSS, images) are in `public/`
- Backend logic and routes are in `server.js`
