````text
You are a senior Flutter architect.

Your task is to START IMPLEMENTING the REAL AUTH ENDPOINTS, beginning with **login**, following the existing project patterns:
- Fake vs Real services
- Repository interface abstraction
- Riverpod state management
- AR/EN localization
- Clean navigation structure
- Local storage for token + userId

====================================================
1. LOGIN ENDPOINT DETAILS
====================================================

**Endpoint:**  
POST `mobile/login`

**Request body:**  
- phone (String) — e.g. "0592182025"  
- password (String) — e.g. "12345678"  
- fcm_token (String? optional)

**Successful response (HTTP 200):**
```json
{
    "token": "JWT_TOKEN_HERE",
    "payment": {
        "type1": "https://payment.liven-sa.com/type1.php?user_id=616",
        "type2": "https://payment.liven-sa.com/type2.php?user_id=616"
    },
    "id": 616,
    "profile_completed": false,
    "status": true
}


From this response we only need to **save**:

* `token`
* `id`

And use `profile_completed` to decide navigation:

* If `false` → go to **CompleteProfileScreen** (empty placeholder for now)
* If `true` → go to **MainScreen**

**Error response (HTTP 422):**

```json
{
    "message": "Password missmatch",
    "status": false
}
```

This must show a **clear, localized AR/EN message** to the user.

====================================================
2. ARCHITECTURE REQUIREMENTS
   ============================

### Auth Repository Interface

Update the existing `IAuthService` / `AuthRepository` with a new method:

* `Future<AuthResult> login({required String phone, required String password, String? fcmToken})`

### RealAuthService

Implement `login()` using the ApiClient:

* POST to `mobile/login`
* Send JSON body with phone, password, fcm_token
* On success:

    * Parse `token`, `id`, `profile_completed`
    * Save token + id using AuthStorage
    * Return `AuthResult.success(...)`
* On failure:

    * For HTTP 422:

        * Use server message (localized fallback)
    * For 400, 401, 500, timeouts:

        * Return properly mapped ApiFailure → localized message

### FakeAuthService

* Update to match the new interface.
* Return mocked token, id, profileCompleted values.

### Env-based Switching

Use existing flag `USE_FAKE_AUTH=true|false` to choose Fake or Real implementation through a provider.

====================================================
3. LOCAL STORAGE
   ================

Update AuthStorage / LocalStorageService:

* `saveAuthToken(String token)`
* `saveUserId(int id)`
* `getAuthToken()`
* `getUserId()`

Ensure token & id are stored **before** navigating after login.

====================================================
4. UI & NAVIGATION
   ==================

Login ViewModel / Controller:

1. Validate phone + password
2. Call:
   `authRepository.login(phone: phone, password: password, fcmToken: currentFcmToken)`
3. On success:

    * If `profile_completed == false` → navigate to **CompleteProfileScreen**
    * If `profile_completed == true` → navigate to **MainScreen**
4. On failure:

    * Show AR/EN localized error message from result

**CompleteProfileScreen**

* Create a placeholder screen (empty content for now).
* Should be ready for future logic.

====================================================
5. LOCALIZATION
   ===============

Add AR/EN keys for:

* Incorrect credentials (422)
* Generic login error
* Network/server error messages

Example keys:

* `auth_login_failed`
* `auth_invalid_credentials`
* `error_network`
* `error_server`

====================================================
6. OUTPUT REQUIREMENTS
   ======================

Provide fully working Dart code for:

1. Updated AuthRepository / IAuthService interface
2. RealAuthService login implementation
3. Updated FakeAuthService
4. AuthStorage updates (save/get token + userId)
5. Login ViewModel / Controller with navigation logic
6. Placeholder `CompleteProfileScreen`
7. Suggested AR/EN translations in ARB format

All code must:

* Compile successfully
* Follow existing architecture and patterns
* Provide strong error handling
* Use clean separation between network, storage, and UI
* Support AR/EN localization

````
