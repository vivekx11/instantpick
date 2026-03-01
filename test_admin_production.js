// Test script for Admin API endpoints (PRODUCTION)
// Usage: node test_admin_production.js <your-render-backend-url>
// Example: node test_admin_production.js https://marketplace-api-xyz.onrender.com

const https = require('https');
const http = require('http');

const ADMIN_KEY = 'V!v3k@29#20$Secure';

// Get backend URL from command line argument
const BACKEND_URL = process.argv[2];

if (!BACKEND_URL) {
  console.error('❌ Error: Please provide your Render backend URL');
  console.log('\nUsage:');
  console.log('  node test_admin_production.js <your-render-backend-url>');
  console.log('\nExample:');
  console.log('  node test_admin_production.js https://marketplace-api-xyz.onrender.com');
  process.exit(1);
}

// Parse URL
const url = new URL(BACKEND_URL);
const isHttps = url.protocol === 'https:';
const client = isHttps ? https : http;

console.log('🧪 Testing Admin API Endpoints...');
console.log(`📍 Backend URL: ${BACKEND_URL}`);
console.log(`🔑 Admin Key: ${ADMIN_KEY}`);
console.log('');

function makeRequest(path, method = 'GET', body = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: url.hostname,
      port: url.port || (isHttps ? 443 : 80),
      path: `/api${path}`,
      method: method,
      headers: {
        'adminKey': ADMIN_KEY,
        'Content-Type': 'application/json'
      }
    };

    const req = client.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve({
            statusCode: res.statusCode,
            data: JSON.parse(data)
          });
        } catch (e) {
          resolve({
            statusCode: res.statusCode,
            data: data
          });
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
  try {
    // Test 1: Health Check
    console.log('1️⃣ Testing Health Check...');
    try {
      const health = await makeRequest('/health');
      if (health.statusCode === 200) {
        console.log('✅ Health Check: OK');
        console.log(`   Status: ${health.data.status}`);
        console.log(`   Message: ${health.data.message}\n`);
      } else {
        console.log(`❌ Health Check Failed: ${health.statusCode}\n`);
      }
    } catch (error) {
      console.log(`❌ Health Check Error: ${error.message}\n`);
    }

    // Test 2: Dashboard Stats
    console.log('2️⃣ Testing Dashboard Stats...');
    try {
      const stats = await makeRequest('/admin/stats');
      if (stats.statusCode === 200 && stats.data.success) {
        console.log('✅ Dashboard Stats: Success');
        console.log(`   Total Users: ${stats.data.stats.totalUsers}`);
        console.log(`   Total Shops: ${stats.data.stats.totalShops}`);
        console.log(`   Total Products: ${stats.data.stats.totalProducts}`);
        console.log(`   Total Orders: ${stats.data.stats.totalOrders}`);
        console.log(`   Active Shops: ${stats.data.stats.activeShops}`);
        console.log(`   Pending Orders: ${stats.data.stats.pendingOrders}\n`);
      } else if (stats.statusCode === 403) {
        console.log('❌ Dashboard Stats: Unauthorized (Check admin key)\n');
      } else {
        console.log(`❌ Dashboard Stats Failed: ${stats.statusCode}\n`);
      }
    } catch (error) {
      console.log(`❌ Dashboard Stats Error: ${error.message}\n`);
    }

    // Test 3: Get Users
    console.log('3️⃣ Testing Get Users...');
    try {
      const users = await makeRequest('/admin/users');
      if (users.statusCode === 200 && users.data.success) {
        console.log(`✅ Users: Found ${users.data.users?.length || 0} users\n`);
      } else {
        console.log(`❌ Users Failed: ${users.statusCode}\n`);
      }
    } catch (error) {
      console.log(`❌ Users Error: ${error.message}\n`);
    }

    // Test 4: Get Shops
    console.log('4️⃣ Testing Get Shops...');
    try {
      const shops = await makeRequest('/admin/shops');
      if (shops.statusCode === 200 && shops.data.success) {
        console.log(`✅ Shops: Found ${shops.data.shops?.length || 0} shops\n`);
      } else {
        console.log(`❌ Shops Failed: ${shops.statusCode}\n`);
      }
    } catch (error) {
      console.log(`❌ Shops Error: ${error.message}\n`);
    }

    // Test 5: Get Products
    console.log('5️⃣ Testing Get Products...');
    try {
      const products = await makeRequest('/admin/products');
      if (products.statusCode === 200 && products.data.success) {
        console.log(`✅ Products: Found ${products.data.products?.length || 0} products\n`);
      } else {
        console.log(`❌ Products Failed: ${products.statusCode}\n`);
      }
    } catch (error) {
      console.log(`❌ Products Error: ${error.message}\n`);
    }

    // Test 6: Get Orders
    console.log('6️⃣ Testing Get Orders...');
    try {
      const orders = await makeRequest('/admin/orders');
      if (orders.statusCode === 200 && orders.data.success) {
        console.log(`✅ Orders: Found ${orders.data.orders?.length || 0} orders\n`);
      } else {
        console.log(`❌ Orders Failed: ${orders.statusCode}\n`);
      }
    } catch (error) {
      console.log(`❌ Orders Error: ${error.message}\n`);
    }

    // Test 7: Get Logs
    console.log('7️⃣ Testing System Logs...');
    try {
      const logs = await makeRequest('/admin/logs');
      if (logs.statusCode === 200 && logs.data.success) {
        console.log('✅ System Logs: Success\n');
      } else {
        console.log(`❌ System Logs Failed: ${logs.statusCode}\n`);
      }
    } catch (error) {
      console.log(`❌ System Logs Error: ${error.message}\n`);
    }

    console.log('========================================');
    console.log('✅ All tests completed!');
    console.log('========================================');
    console.log('\n📝 Next Steps:');
    console.log('1. If all tests passed, your backend is ready!');
    console.log('2. Deploy admin app with this backend URL');
    console.log('3. Login with admin key: V!v3k@29#20$Secure');
    console.log('');

  } catch (error) {
    console.error('❌ Fatal Error:', error.message);
  }
}

testAdminAPI();
