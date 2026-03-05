const https = require('https');

const API_URL = 'https://instantpick-backend.onrender.com/api/admin/stats';

console.log('Testing backend connection...');
console.log('URL:', API_URL);
console.log('');

https.get(API_URL, (res) => {
    let data = '';
    
    console.log('Status Code:', res.statusCode);
    console.log('Headers:', JSON.stringify(res.headers, null, 2));
    console.log('');
    
    res.on('data', (chunk) => {
        data += chunk;
    });
    
    res.on('end', () => {
        console.log('Response:');
        try {
            const json = JSON.parse(data);
            console.log(JSON.stringify(json, null, 2));
            
            if (json.success) {
                console.log('\n✅ Backend is working!');
                console.log('Stats:', json.stats);
            } else {
                console.log('\n❌ Backend returned error');
            }
        } catch (e) {
            console.log('Raw response:', data);
            console.log('\n❌ Invalid JSON response');
        }
    });
}).on('error', (err) => {
    console.error('❌ Connection Error:', err.message);
    console.error('\nPossible issues:');
    console.error('1. Backend is not running on Render');
    console.error('2. Backend URL is incorrect');
    console.error('3. Network/firewall issue');
});
