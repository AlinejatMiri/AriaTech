const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const multer = require('multer');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');
const session = require('express-session');

const app = express();
const PORT = process.env.PORT || 3000;

const ADMIN_USERNAME = 'admin';
const ADMIN_PASSWORD = 'ariatech123';

// Paths
const DATA_FILE = path.join(__dirname, 'data', 'products.json');
const UPLOADS_DIR = path.join(__dirname, 'uploads');
const PRODUCT_UPLOADS_DIR = path.join(UPLOADS_DIR, 'products');

// Ensure data directory/file
if (!fs.existsSync(path.dirname(DATA_FILE))) {
  fs.mkdirSync(path.dirname(DATA_FILE), { recursive: true });
}
if (!fs.existsSync(DATA_FILE)) {
  fs.writeFileSync(DATA_FILE, JSON.stringify([]));
}

// Ensure uploads/products directory exists
if (!fs.existsSync(PRODUCT_UPLOADS_DIR)) {
  fs.mkdirSync(PRODUCT_UPLOADS_DIR, { recursive: true });
}

function readProducts() {
  const raw = fs.readFileSync(DATA_FILE, 'utf-8');
  return JSON.parse(raw || '[]');
}

function writeProducts(products) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(products, null, 2));
}

// View engine & static
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use(bodyParser.urlencoded({ extended: true }));

app.use(session({
  secret: 'ariatech-admin-secret-key-2024',
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 24 * 60 * 60 * 1000 }
}));

function isAuthenticated(req, res, next) {
  if (req.session.isAdmin) {
    return next();
  }
  res.redirect('/admin/login');
}

// Multer configuration for product image uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, PRODUCT_UPLOADS_DIR);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const uniqueName = Date.now() + '-' + Math.round(Math.random() * 1e9) + ext;
    cb(null, uniqueName);
  }
});
 
// File filter (image-only)
const fileFilter = (req, file, cb) => {
  if (file.mimetype.startsWith('image/')) {
    cb(null, true);
  } else {
    cb(new Error('Only image files are allowed'), false);
  }
};
 
// 2 MB limit example
const upload = multer({
  storage,
  fileFilter,
  limits: { fileSize: 2 * 1024 * 1024 }
});
// Storefront routes
app.get('/', (req, res) => {
  const products = readProducts();
  res.render('store/index', { products });
});

app.get('/product/:id', (req, res) => {
  const products = readProducts();
  const product = products.find(p => p.id === req.params.id);
  if (!product) {
    return res.status(404).render('store/not-found');
  }
  res.render('store/product-detail', { product });
});

// Admin login page
app.get('/admin/login', (req, res) => {
  res.render('admin/login', { error: null });
});

app.post('/admin/login', (req, res) => {
  const { username, password } = req.body;
  if (username === ADMIN_USERNAME && password === ADMIN_PASSWORD) {
    req.session.isAdmin = true;
    return res.redirect('/admin');
  }
  res.render('admin/login', { error: 'Invalid credentials' });
});

app.get('/admin/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/admin/login');
});

// Protected admin routes
app.get('/admin', isAuthenticated, (req, res) => {
  const products = readProducts();
  res.render('admin/dashboard', { products });
});

app.get('/admin/products/new', isAuthenticated, (req, res) => {
  res.render('admin/new-product');
});

app.post('/admin/products', isAuthenticated, upload.single('imageFile'), (req, res) => {
  const products = readProducts();
  const { name, brand, price, category, imageUrl, description } = req.body;

  if (!name || !price) {
    return res.status(400).send('Name and price are required');
  }

  // Prefer uploaded file; fall back to URL or placeholder
  let finalImagePath = imageUrl || '/images/placeholder-laptop.jpg';
  if (req.file) {
    finalImagePath = '/uploads/products/' + req.file.filename;
  }

  const product = {
    id: uuidv4(),
    name,
    brand,
    price: parseFloat(price),
    category: category || 'Other',
    imageUrl: finalImagePath,
    description: description || ''
  };

  products.push(product);
  writeProducts(products);
  res.redirect('/admin');
});

// Basic error handler for upload-related errors
app.use((err, req, res, next) => {
  if (err && err instanceof multer.MulterError) {
    return res.status(400).send('File upload error: ' + err.message);
  }
  if (err && err.message === 'Only image files are allowed') {
    return res.status(400).send(err.message);
  }
  next(err);
});

app.post('/admin/products/:id/delete', isAuthenticated, (req, res) => {
  let products = readProducts();
  products = products.filter(p => p.id !== req.params.id);
  writeProducts(products);
  res.redirect('/admin');
});

app.listen(PORT, () => {
  console.log(`Computer store app listening on http://localhost:${PORT}`);
});
