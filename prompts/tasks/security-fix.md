# Security Fix Task Prompt

Use this prompt when delegating security vulnerability fixes.

## Prompt Template

```
# Task: Fix Security Vulnerability {ISSUE_ID}

You are fixing a security vulnerability identified in the code review.

## Issue Details

- Issue ID: {ISSUE_ID}
- Severity: {CRITICAL/HIGH}
- Location: {FILE_PATH} lines {LINE_NUMBERS}
- Description: {ISSUE_DESCRIPTION}

## Context

Please read:
1. Issue details: {PATH_TO_ISSUES}/critical.md#{ISSUE_ID}
2. Component review: {PATH_TO_COMPONENTS}/{COMPONENT}.md

## The Vulnerability

{DETAILED_DESCRIPTION_OF_VULNERABILITY}

## Required Fix

{DESCRIPTION_OF_EXPECTED_FIX}

## Implementation Steps

1. Locate the vulnerable code
2. Implement the secure alternative
3. Add appropriate error handling
4. Update any dependent code
5. Add tests verifying the fix
6. Update documentation

## Security Checklist

Before marking complete:
- [ ] No credentials in code or logs
- [ ] Input validation implemented
- [ ] Output encoding where needed
- [ ] Error messages do not leak internals
- [ ] Secure defaults used (fail closed, not open)
- [ ] Tests verify the security fix

## Output

Provide:
1. The fixed code
2. Explanation of the fix
3. Test cases
```

## Common Security Fix Patterns

### Remove Credential Logging

```javascript
// Before
console.log('API Key:', apiKey);

// After
console.log('API request initiated');
```

### Enable SSL Verification

```javascript
// Before
ssl: { rejectUnauthorized: false }

// After
const caCert = fs.readFileSync(process.env.CA_BUNDLE_PATH);
ssl: { rejectUnauthorized: true, ca: caCert }
```

### Add Rate Limiting

```javascript
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: { error: 'Too many attempts' }
});
router.post('/login', limiter, handler);
```

### Fix Insecure Token Storage

```javascript
// Before
localStorage.setItem('token', jwt);

// After
res.cookie('token', jwt, {
  httpOnly: true,
  secure: true,
  sameSite: 'strict'
});
```

### Use Constant-Time Comparison

```javascript
// Before
if (providedKey === expectedKey)

// After
const crypto = require('crypto');
if (crypto.timingSafeEqual(Buffer.from(providedKey), Buffer.from(expectedKey)))
```

### Fix Fail-Open to Fail-Closed

```javascript
// Before — DANGEROUS
if (!secret) { return true; } // allows bypass

// After — SAFE
if (!secret) {
  console.error('CRITICAL: Secret not configured');
  return false; // reject all requests
}
```

## See Also

- [[../quality-gates]] — Security fix quality criteria
- [[context-restore]] — Resume security work
