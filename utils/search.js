/**
 * Search Algorithm for Product Search Box
 * 
 * Features:
 * - Multi-field search (name, description, brand, category)
 * - Case-insensitive matching
 * - Relevance scoring
 * - Fuzzy matching for typo tolerance
 */

// Normalize text for comparison
function normalizeText(text) {
  if (!text) return '';
  return text.toString().toLowerCase().trim();
}

// Calculate similarity between two strings (0-1)
function getSimilarityScore(query, target) {
  const normalizedQuery = normalizeText(query);
  const normalizedTarget = normalizeText(target);
  
  // Exact match
  if (normalizedTarget.includes(normalizedQuery)) {
    return 1.0;
  }
  
  // Calculate Levenshtein distance for fuzzy matching
  const distance = levenshteinDistance(normalizedQuery, normalizedTarget);
  const maxLength = Math.max(normalizedQuery.length, normalizedTarget.length);
  
  if (maxLength === 0) return 0;
  
  // Score based on similarity (1 - normalized distance)
  const similarity = 1 - (distance / maxLength);
  
  // Only return score if similarity is above threshold
  return similarity > 0.4 ? similarity : 0;
}

// Levenshtein distance algorithm
function levenshteinDistance(str1, str2) {
  const matrix = [];
  
  for (let i = 0; i <= str1.length; i++) {
    matrix[i] = [i];
  }
  
  for (let j = 0; j <= str2.length; j++) {
    matrix[0][j] = j;
  }
  
  for (let i = 1; i <= str1.length; i++) {
    for (let j = 1; j <= str2.length; j++) {
      if (str1[i - 1] === str2[j - 1]) {
        matrix[i][j] = matrix[i - 1][j - 1];
      } else {
        matrix[i][j] = Math.min(
          matrix[i - 1][j - 1] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j] + 1
        );
      }
    }
  }
  
  return matrix[str1.length][str2.length];
}

// Calculate relevance score for a product
function calculateRelevanceScore(product, query) {
  const normalizedQuery = normalizeText(query);
  let score = 0;
  
  // Field weights for relevance scoring
  const weights = {
    name: 10,        // Highest weight - product name is most important
    brand: 7,        // Brand name
    category: 5,     // Category match
    description: 3, // Description
  };
  
  // Search in product name (highest priority)
  if (product.name) {
    const nameScore = getSimilarityScore(normalizedQuery, product.name);
    if (nameScore === 1.0) {
      score += weights.name * 2; // Exact match bonus
    } else if (nameScore > 0) {
      score += weights.name * nameScore;
    }
  }
  
  // Search in brand
  if (product.brand) {
    const brandScore = getSimilarityScore(normalizedQuery, product.brand);
    if (brandScore === 1.0) {
      score += weights.brand * 1.5;
    } else if (brandScore > 0) {
      score += weights.brand * brandScore;
    }
  }
  
  // Search in category
  if (product.category) {
    const categoryScore = getSimilarityScore(normalizedQuery, product.category);
    if (categoryScore === 1.0) {
      score += weights.category * 1.5;
    } else if (categoryScore > 0) {
      score += weights.category * categoryScore;
    }
  }
  
  // Search in description
  if (product.description) {
    const descScore = getSimilarityScore(normalizedQuery, product.description);
    if (descScore > 0) {
      score += weights.description * descScore;
    }
  }
  
  return score;
}

/**
 * Main search function
 * @param {Array} products - Array of product objects
 * @param {String} query - Search query string
 * @param {Object} options - Search options
 * @returns {Array} - Filtered and sorted products
 */
function searchProducts(products, query, options = {}) {
  const {
    fuzzy = true,           // Enable fuzzy matching
    minScore = 0.1,         // Minimum relevance score to include
    limit = 50,             // Maximum results to return
    category = null,        // Optional category filter
  } = options;
  
  // Handle empty query
  if (!query || query.trim() === '') {
    let results = products;
    
    // Apply category filter if provided
    if (category && category !== 'all') {
      results = results.filter(p => p.category === category);
    }
    
    return results.slice(0, limit);
  }
  
  const normalizedQuery = normalizeText(query);
  
  // Score all products
  const scoredProducts = products.map(product => {
    let score = 0;
    
    if (fuzzy) {
      // Fuzzy search mode
      score = calculateRelevanceScore(product, normalizedQuery);
    } else {
      // Exact match mode
      const fields = [
        product.name,
        product.brand,
        product.category,
        product.description
      ].map(f => normalizeText(f));
      
      const matchesQuery = fields.some(field => field.includes(normalizedQuery));
      score = matchesQuery ? 1 : 0;
    }
    
    return { ...product, _searchScore: score };
  });
  
  // Filter by minimum score
  let filtered = scoredProducts.filter(p => p._searchScore >= minScore);
  
  // Apply category filter if provided
  if (category && category !== 'all') {
    filtered = filtered.filter(p => p.category === category);
  }
  
  // Sort by relevance score (highest first)
  filtered.sort((a, b) => b._searchScore - a._searchScore);
  
  // Remove internal score field from results
  return filtered.map(({ _searchScore, ...product }) => product).slice(0, limit);
}

/**
 * Autocomplete suggestions function
 * @param {Array} products - Array of product objects
 * @param {String} query - Search query
 * @param {Number} limit - Max suggestions
 * @returns {Array} - Array of suggestions with type
 */
function getAutocompleteSuggestions(products, query, limit = 5) {
  if (!query || query.trim().length < 2) {
    return [];
  }
  
  const suggestions = [];
  const normalizedQuery = normalizeText(query);
  const seen = new Set();
  
  // Get unique product names
  const uniqueNames = [...new Set(products.map(p => p.name))];
  
  // Find matching product names
  uniqueNames.forEach(name => {
    if (normalizeText(name).includes(normalizedQuery) && !seen.has(name)) {
      seen.add(name);
      suggestions.push({
        type: 'product',
        text: name,
        relevance: calculateRelevanceScore({ name }, query)
      });
    }
  });
  
  // Get unique brands
  const uniqueBrands = [...new Set(products.map(p => p.brand).filter(Boolean))];
  
  uniqueBrands.forEach(brand => {
    if (normalizeText(brand).includes(normalizedQuery) && !seen.has(brand)) {
      seen.add(brand);
      suggestions.push({
        type: 'brand',
        text: brand,
        relevance: calculateRelevanceScore({ brand }, query)
      });
    }
  });
  
  // Sort by relevance and return top suggestions
  suggestions.sort((a, b) => b.relevance - a.relevance);
  
  return suggestions.slice(0, limit);
}

module.exports = {
  searchProducts,
  getAutocompleteSuggestions,
  calculateRelevanceScore,
  normalizeText,
  getSimilarityScore,
  levenshteinDistance
};
