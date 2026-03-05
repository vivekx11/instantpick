const https = require('https');

const API_URL = 'https://instantpick-backend.onrender.com/api/admin/stats';
const ADMIN_KEY = 'Vivek2920SecureAdmin'; // From .env file

console.log('Testing with Admin Key...');
console.log('URL:', API_URL);
console.log('Admin Key:', ADMIN_KEY);
console.log('');

const options = {
    headers: {
        'adminKey': ADMIN_KEY
    }
};

https.get(API_URL, options, (res) => {
    let data = '';
    
    console.log('Status Code:', res.statusCode);
    console.log('');
    
    res.on('data', (chunk) => {
        data += chunk;
    });
    
    res.on('end', () => {
        try {
            const json = JSON.parse(data);
            console.log('Response:', JSON.stringify(json, null, 2));
            
            if (json.success) {
                console.log('\n✅ Backend is working with Admin Key!');
            } else {
                console.log('\n❌ Backend returned error:', json.message);
            }
        } catch (e) {
            console.log('Raw response:', data);
        }
    });
}).on('error', (err) => {
    console.error('❌ Error:', err.message);
});
