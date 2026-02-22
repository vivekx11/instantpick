# User Location ObjectId Error - FIXED

## Error
```
CastError: Cast to ObjectId failed for value "102489185495638472349" (type string) 
at path "_id" for model "User"
```

## Root Cause

The User model in MongoDB has two ID fields:
- `_id`: MongoDB's internal ObjectId (24 hex characters)
- `userId`: Google's user ID (long string like "102489185495638472349")

The location update endpoint was using `findByIdAndUpdate(userId, ...)` which tries to cast the Google userId string to MongoDB ObjectId, causing the error.

## Solution

Changed from `findByIdAndUpdate` to `findOneAndUpdate` with `userId` field:

### Before (WRONG):
```javascript
const user = await User.findByIdAndUpdate(
  userId,  // This expects MongoDB ObjectId
  { location: {...} },
  { new: true }
);
```

### After (CORRECT):
```javascript
const user = await User.findOneAndUpdate(
  { userId: userId },  // Query by userId field (string)
  { location: {...} },
  { new: true, upsert: true }
);
```

## Files Modified

### Backend
1. `routes/users.js`
   - Line ~187: POST `/:userId/location` - Changed to `findOneAndUpdate`
   - Line ~228: GET `/:userId/location/status` - Changed to `findOne`
   - Added `upsert: true` to create user if doesn't exist

## Why This Works

- `findByIdAndUpdate(id, ...)` searches by `_id` field (MongoDB ObjectId)
- `findOneAndUpdate({ userId: id }, ...)` searches by `userId` field (string)
- Google's userId is stored in the `userId` field, not `_id`
- `upsert: true` creates the user document if it doesn't exist

## User Model Structure

```javascript
{
  _id: ObjectId("507f1f77bcf86cd799439011"),  // MongoDB internal ID
  userId: "102489185495638472349",            // Google user ID (string)
  name: "John Doe",
  email: "john@example.com",
  location: {
    type: "Point",
    coordinates: [73.193, 19.197]
  },
  address: "Room 102, Building A",
  locationSet: true
}
```

## Deployment Status

✅ Changes pushed to GitHub
✅ Render will auto-deploy in 2-3 minutes

## Testing

After deployment, test user location save:

```bash
# Test endpoint
POST https://instantpick-backend.onrender.com/api/users/102489185495638472349/location

Body:
{
  "latitude": 19.197,
  "longitude": 73.193,
  "address": "Room 102"
}

Expected Response:
{
  "success": true,
  "message": "Location saved successfully",
  "data": {
    "userId": "102489185495638472349",
    "location": {
      "type": "Point",
      "coordinates": [73.193, 19.197]
    },
    "address": "Room 102"
  }
}
```

## Related Fixes

This is part of the complete location workflow fix:
1. ✅ MapController initialization errors
2. ✅ Shop location save errors
3. ✅ User location save errors (THIS FIX)
4. ✅ Order location data
5. ✅ Get directions feature

## Summary

The error was caused by trying to use Google's userId (string) as MongoDB's _id (ObjectId). Fixed by querying with the correct field name `userId` instead of using `findById`.
