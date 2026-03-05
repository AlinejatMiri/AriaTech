// middleware/getLogos.js
const brands = [
  { name: "Intel", domain: "intel.com" },
  { name: "AMD", domain: "amd.com" },
  { name: "ASUS", domain: "asus.com" },
  { name: "MSI", domain: "msi.com" },
  { name: "Gigabyte", domain: "gigabyte.com" },
  { name: "Logitech", domain: "logitech.com" },
  { name: "Razer", domain: "razer.com" },
  { name: "Dell", domain: "dell.com" },
  { name: "HP", domain: "hp.com" },
  { name: "Lenovo", domain: "lenovo.com" }
];

export function getLogos(req, res, next) {
  const API_KEY = process.env.LOGO_API_KEY;

  res.locals.brandLogos = brands.map(brand => ({
    name: brand.name,
    logo: `https://img.logo.dev/${brand.domain}?token=${API_KEY}&size=70`
  }));

  next(); // continue to the next middleware or route
}