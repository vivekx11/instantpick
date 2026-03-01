// Test script for new admin key
const ADMIN_KEY = 'Vivek2920SecureAdmin';
const BASE_URL = 'https://instantpick-backend.onrender.com/api';

console.log('🧪 Testing Admin API with new key...\n');
console.log('Admin Key:', ADMIN_KEY);
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

// Test 2: Admin Stats (with authentication)
async function testAdminStats() {
  console.log('2️⃣ Testing Admin Stats (Authentication)...');
  try {
    const response = await fetch(`${BASE_URL}/admin/stats`, {
      headers: {
        'adminKey': ADMIN_KEY
      }
    });
    
    console.log('   Status Code:', response.status);
    
    if (response.status === 403) {
      console.log('❌ Authentication Failed (403 Forbidden)');
      console.log('   This means ADMIN_KEY in Render is not updated yet!');
      console.log('   Please update ADMIN_KEY in Render Dashboard to:', ADMIN_KEY);
      return;
    }
    
    if (response.status === 500) {
      const data = await response.json();
      console.log('❌ Server Error:', data.message);
      return;
    }
    
    const data = await response.json();
    
    if (data.success) {
      console.log('✅ Admin Authentication Successful!');
      console.log('   Stats:', JSON.stringify(data.stats, null, 2));
    } else {
      console.log('❌ Failed:', data.message);
    }
  } catch (error) {
    console.log('❌ Admin Stats Failed:', error.message);
  }
  console.log('---\n');
}

// Test 3: Admin Users List
async function testAdminUsers() {
  console.log('3️⃣ Testing Admin Users List...');
  try {
    const response = await fetch(`${BASE_URL}/admin/users`, {
      headers: {
        'adminKey': ADMIN_KEY
      }
    });
    
    if (response.status === 403) {
      console.log('❌ Authentication Failed');
      return;
    }
    
    const data = await response.json();
    
    if (data.success) {
      console.log('✅ Users List Retrieved');
      console.log('   Total Users:', data.users.length);
    } else {
      console.log('❌ Failed:', data.message);
    }
  } catch (error) {
    console.log('❌ Users List Failed:', error.message);
  }
  console.log('---\n');
}

// Run all tests
async function runTests() {
  await testHealth();
  await testAdminStats();
  await testAdminUsers();
  
  console.log('🎯 Test Summary:');
  console.log('If you see ✅ for all tests, admin key is working!');
  console.log('If you see ❌ 403 errors, update ADMIN_KEY in Render Dashboard.');
  console.log('\n📝 Steps to update:');
  console.log('1. Go to: https://dashboard.render.com');
  console.log('2. Select: instantpick-backend');
  console.log('3. Click: Environment');
  console.log('4. Edit ADMIN_KEY to:', ADMIN_KEY);
  console.log('5. Save and wait 3 minutes');
  console.log('6. Run this test again!');
}

runTests();
