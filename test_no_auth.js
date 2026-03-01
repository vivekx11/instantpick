// Test script for no-auth admin API
const BASE_URL = 'https://instantpick-backend.onrender.com/api';

console.log('🧪 Testing Admin API (No Authentication)...\n');
console.log('Backend URL:', BASE_URL);
console.log('---\n');

// Test 1: Health Check
async function testHealth() {
  console.log('1️⃣ Testing Health Check...');
  try {
    const response = await fetch(`${BASE_URL}/health`);
    const data = await response.json();
    console.log('✅ Health Check:', data.status);
    console.log('   Message:', data.message);
  } catch (error) {
    console.log('❌ Health Check Failed:', error.message);
  }
  console.log('---\n');
}

// Test 2: Admin Stats (NO AUTH)
async function testAdminStats() {
  console.log('2️⃣ Testing Admin Stats (No Authentication)...');
  try {
    const response = await fetch(`${BASE_URL}/admin/stats`);
    
    console.log('   Status Code:', response.status);
    
    if (response.status === 403) {
      console.log('❌ Still requires authentication!');
      console.log('   Backend not deployed yet. Wait 2-3 minutes.');
      return;
    }
    
    if (response.status === 500) {
      const data = await response.json();
      console.log('❌ Server Error:', data.message);
      return;
    }
    
    const data = await response.json();
    
    if (data.success) {
      console.log('✅ Admin Stats Retrieved (No Auth Required)!');
      console.log('   Stats:', JSON.stringify(data.stats, null, 2));
    } else {
      console.log('❌ Failed:', data.message);
    }
  } catch (error) {
    console.log('❌ Admin Stats Failed:', error.message);
  }
  console.log('---\n');
}

// Test 3: Admin Users List (NO AUTH)
async function testAdminUsers() {
  console.log('3️⃣ Testing Admin Users List (No Authentication)...');
  try {
    const response = await fetch(`${BASE_URL}/admin/users`);
    
    if (response.status === 403) {
      console.log('❌ Still requires authentication!');
      console.log('   Backend not deployed yet.');
      return;
    }
    
    const data = await response.json();
    
    if (data.success) {
      console.log('✅ Users List Retrieved (No Auth Required)!');
      console.log('   Total Users:', data.users.length);
    } else {
      console.log('❌ Failed:', data.message);
    }
  } catch (error) {
    console.log('❌ Users List Failed:', error.message);
  }
  console.log('---\n');
}

// Test 4: Admin Shops List (NO AUTH)
async function testAdminShops() {
  console.log('4️⃣ Testing Admin Shops List (No Authentication)...');
  try {
    const response = await fetch(`${BASE_URL}/admin/shops`);
    
    if (response.status === 403) {
      console.log('❌ Still requires authentication!');
      return;
    }
    
    const data = await response.json();
    
    if (data.success) {
      console.log('✅ Shops List Retrieved (No Auth Required)!');
      console.log('   Total Shops:', data.shops.length);
    } else {
      console.log('❌ Failed:', data.message);
    }
  } catch (error) {
    console.log('❌ Shops List Failed:', error.message);
  }
  console.log('---\n');
}

// Run all tests
async function runTests() {
  await testHealth();
  await testAdminStats();
  await testAdminUsers();
  await testAdminShops();
  
  console.log('🎯 Test Summary:');
  console.log('---');
  console.log('If you see ✅ for all tests:');
  console.log('  → Backend deployed successfully!');
  console.log('  → No authentication required!');
  console.log('  → Admin app will work directly!');
  console.log('');
  console.log('If you see ❌ 403 errors:');
  console.log('  → Backend not deployed yet');
  console.log('  → Wait 2-3 minutes');
  console.log('  → Run this test again');
  console.log('');
  console.log('📱 Next Steps:');
  console.log('1. Install new APK: admin_app/build/app/outputs/flutter-apk/app-release.apk');
  console.log('2. Open app');
  console.log('3. Dashboard will open directly!');
  console.log('4. No login required! 🎉');
}

runTests();
