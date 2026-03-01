// Test script for Admin API endpoints
// Run: node test_admin_api.js

const http = require('http');

const ADMIN_KEY = 'Vivek2920SecureAdmin';

// Your existing Render backend URL
const BASE_URL = 'https://instantpick-backend.onrender.com';

// For local testing, uncomment below:
// const BASE_URL = 'http://localhost:3000';

function makeRequest(path, method = 'GET', body = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: `/api${path}`,
      method: method,
      headers: {
        'adminKey': ADMIN_KEY,
        'Content-Type': 'application/json'
      }
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          resolve(data);
        }
      });
    });

    req.on('error', reject);
    
    if (body) {
      req.write(JSON.stringify(body));
    }
    
    req.end();
  });
}

async function testAdminAPI() {
  console.log('🧪 Testing Admin API Endpoints...\n');

  try {
    // Test 1: Dashboard Stats
    console.log('1️⃣ Testing Dashboard Stats...');
    const stats = await makeRequest('/admin/stats');
    console.log('✅ Stats:', stats.success ? 'Success' : 'Failed');
    if (stats.stats) {
      console.log(`   Users: ${stats.stats.totalUsers}`);
      console.log(`   Shops: ${stats.stats.totalShops}`);
      console.log(`   Products: ${stats.stats.totalProducts}`);
      console.log(`   Orders: ${stats.stats.totalOrders}\n`);
    }

    // Test 2: Get Users
    console.log('2️⃣ Testing Get Users...');
    const users = await makeRequest('/admin/users');
    console.log('✅ Users:', users.success ? `Found ${users.users?.length || 0} users` : 'Failed\n');

    // Test 3: Get Shops
    console.log('3️⃣ Testing Get Shops...');
    const shops = await makeRequest('/admin/shops');
    console.log('✅ Shops:', shops.success ? `Found ${shops.shops?.length || 0} shops` : 'Failed\n');

    // Test 4: Get Products
    console.log('4️⃣ Testing Get Products...');
    const products = await makeRequest('/admin/products');
    console.log('✅ Products:', products.success ? `Found ${products.products?.length || 0} products` : 'Failed\n');

    // Test 5: Get Orders
    console.log('5️⃣ Testing Get Orders...');
    const orders = await makeRequest('/admin/orders');
    console.log('✅ Orders:', orders.success ? `Found ${orders.orders?.length || 0} orders` : 'Failed\n');

    // Test 6: Get Logs
    console.log('6️⃣ Testing System Logs...');
    const logs = await makeRequest('/admin/logs');
    console.log('✅ Logs:', logs.success ? 'Success' : 'Failed\n');

    console.log('✅ All tests completed!');
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

testAdminAPI();
