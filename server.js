require('dotenv').config();
const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const multer = require('multer');
const session = require('express-session');
const supabase = require('./lib/supabase');

const app = express();
const PORT = process.env.PORT || 3000;

const ADMIN_USERNAME = 'admin';
const ADMIN_PASSWORD = 'ariatech123';

const BUCKET_NAME = 'products';

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

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

const upload = multer({ 
  storage: multer.memoryStorage(),
  limits: { fileSize: 2 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed'), false);
    }
  }
});

async function getProducts(category = null) {
  let query = supabase
    .from('products')
    .select('*')
    .order('created_at', { ascending: false });
  
  if (category && category !== 'all') {
    query = query.eq('category', category);
  }
  
  const { data, error } = await query;
  if (error) {
    console.error('Error fetching products:', error);
    return [];
  }
  return data || [];
}

async function getProduct(id) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('id', id)
    .single();
  if (error) return null;
  return data;
}

async function addProduct(product) {
  const { data, error } = await supabase
    .from('products')
    .insert([product])
    .select();
  if (error) {
    console.error('Error adding product:', error);
    return null;
  }
  return data[0];
}

async function deleteProduct(id) {
  const { error } = await supabase
    .from('products')
    .delete()
    .eq('id', id);
  return !error;
}

async function getSliderImages() {
  const { data, error } = await supabase
    .from('slider_images')
    .select('*')
    .order('created_at', { ascending: false });
  if (error) {
    console.error('Error fetching slider images:', error);
    return [];
  }
  return data || [];
}

async function addSliderImage(imageUrl) {
  const { data, error } = await supabase
    .from('slider_images')
    .insert([{ image_url: imageUrl }])
    .select();
  if (error) {
    console.error('Error adding slider image:', error);
    return null;
  }
  return data[0];
}

async function deleteSliderImage(id) {
  const { error } = await supabase
    .from('slider_images')
    .delete()
    .eq('id', id);
  return !error;
}

async function uploadSliderImage(file) {
  const fileExt = file.originalname.split('.').pop();
  const fileName = `${Date.now()}-${Math.round(Math.random() * 1e9)}.${fileExt}`;
  const filePath = `slider/${fileName}`;

  const { data, error } = await supabase.storage
    .from(BUCKET_NAME)
    .upload(filePath, file.buffer, {
      contentType: file.mimetype,
      upsert: false
    });

  if (error) {
    console.error('Error uploading slider image to Supabase:', error);
    return null;
  }

  const { data: urlData } = supabase.storage
    .from(BUCKET_NAME)
    .getPublicUrl(filePath);

  return urlData.publicUrl;
}

async function uploadImage(file) {
  const fileExt = file.originalname.split('.').pop();
  const fileName = `${Date.now()}-${Math.round(Math.random() * 1e9)}.${fileExt}`;
  const filePath = `products/${fileName}`;

  const { data, error } = await supabase.storage
    .from(BUCKET_NAME)
    .upload(filePath, file.buffer, {
      contentType: file.mimetype,
      upsert: false
    });

  if (error) {
    console.error('Error uploading image to Supabase:', error);
    return null;
  }

  const { data: urlData } = supabase.storage
    .from(BUCKET_NAME)
    .getPublicUrl(filePath);

  return urlData.publicUrl;
}

app.get('/', async (req, res) => {
  const currentCategory = req.query.category || 'all';
  const allProducts = await getProducts();
  const sliderImages = await getSliderImages();
  const specialProducts = allProducts.filter(p => p.is_special === true);
  
  let products = allProducts;
  if (currentCategory && currentCategory !== 'all') {
    products = allProducts.filter(p => p.category === currentCategory);
  }
  
  const categories = ['computer-parts', 'oem-packages', 'computer', 'peripherals', 'storage', 'games-and-hobbies', 'network', 'office-supplies', 'software', 'accessory'];
  const categoryNames = {
    'computer-parts': 'Computer Parts',
    'oem-packages': 'OEM Packages',
    'computer': 'Computer',
    'peripherals': 'Peripherals',
    'storage': 'Storage',
    'games-and-hobbies': 'Games and Hobbies',
    'network': 'Network',
    'office-supplies': 'Office Supplies',
    'software': 'Software',
    'accessory': 'Accessory'
  };
  
  res.render('store/index', { products, sliderImages, currentCategory, categories, categoryNames, allProducts, specialProducts });
});

app.get('/product/:id', async (req, res) => {
  const product = await getProduct(req.params.id);
  if (!product) {
    return res.status(404).render('store/not-found');
  }
  
  const allProducts = await getProducts();
  const relatedProducts = allProducts.filter(p => p.category === product.category && p.id !== product.id);
  
  res.render('store/product-detail', { product, relatedProducts });
});

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

app.get('/admin', isAuthenticated, async (req, res) => {
  const products = await getProducts();
  const sliderImages = await getSliderImages();
  const specialProducts = products.filter(p => p.is_special === true);
  const regularProducts = products.filter(p => p.is_special !== true);
  res.render('admin/dashboard', { products: regularProducts, sliderImages, specialProducts });
});

app.get('/admin/products/new', isAuthenticated, (req, res) => {
  res.render('admin/new-product');
});

app.post('/admin/products', isAuthenticated, upload.single('imageFile'), async (req, res) => {
  const { name, brand, price, category, imageUrl, description, isSpecial } = req.body;

  if (!name || !price) {
    return res.status(400).send('Name and price are required');
  }

  let finalImageUrl = imageUrl || null;

  const product = {
    name,
    brand: brand || null,
    price: parseFloat(price),
    category: category || 'Other',
    image_url: finalImageUrl,
    description: description || null,
    is_special: isSpecial === 'true' ? true : false
  };

  const result = await addProduct(product);
  if (!result) {
    return res.status(500).send('Error creating product');
  }

  res.redirect('/admin');
});

app.use((err, req, res, next) => {
  if (err && err instanceof multer.MulterError) {
    return res.status(400).send('File upload error: ' + err.message);
  }
  if (err && err.message === 'Only image files are allowed') {
    return res.status(400).send(err.message);
  }
  next(err);
});

app.post('/admin/products/:id/delete', isAuthenticated, async (req, res) => {
  await deleteProduct(req.params.id);
  res.redirect('/admin');
});

app.post('/admin/upload-image', isAuthenticated, upload.single('imageFile'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file selected' });
  }

  try {
    const imageUrl = await uploadImage(req.file);
    
    if (!imageUrl) {
      return res.status(500).json({ error: 'Failed to upload image to Supabase' });
    }

    res.json({ success: true, imageUrl });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/admin/upload-slider', isAuthenticated, upload.single('sliderFile'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file selected' });
  }

  try {
    const imageUrl = await uploadSliderImage(req.file);
    
    if (!imageUrl) {
      return res.status(500).json({ error: 'Failed to upload slider image to Supabase' });
    }

    const sliderImage = await addSliderImage(imageUrl);
    if (!sliderImage) {
      return res.status(500).json({ error: 'Failed to save slider image record' });
    }

    res.json({ success: true, imageUrl });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/admin/slider/:id/delete', isAuthenticated, async (req, res) => {
  await deleteSliderImage(req.params.id);
  res.redirect('/admin');
});

app.listen(PORT, () => {
  console.log(`Computer store app listening on http://localhost:${PORT}`);
  console.log(`Connected to Supabase: ${process.env.SUPABASE_URL}`);
});
