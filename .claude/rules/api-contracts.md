# API Contracts

All requests require `Accept: application/json`.
All authenticated requests require `Authorization: Bearer {token}`.
Base URL is defined in `AppConstants.baseUrl` — never hardcode it.

All responses follow this envelope:

```json
{
  "success": true,
  "data": {},
  "message": "string"
}
```

---

## Auth

### POST /api/v1/auth/login

No auth required.

**Request body:**

```json
{
  "email": "string",
  "password": "string"
}
```

**Response `data`:**

```json
{
  "token": "string",
  "user": {
    "id": 1,
    "name": "string",
    "email": "string",
    "role": "admin | supervisor | operator"
  }
}
```

Store `token` in `flutter_secure_storage`. Store `user` in Riverpod auth state.

---

### POST /api/v1/auth/logout

Authenticated.

**Request body:** none

**Response:** `success: true`

Clear token from storage and reset auth state.

---

## Users

### GET /api/v1/users

Authenticated. Admin / Supervisor only.

**Response `data`:** array of User objects.

```json
{
  "id": 1,
  "name": "string",
  "email": "string",
  "role": "admin | supervisor | operator"
}
```

---

### POST /api/v1/users

Authenticated. Admin / Supervisor only.

**Request body:**

```json
{
  "name": "string",
  "email": "string",
  "password": "string",
  "role": "operator"
}
```

---

### GET /api/v1/users/{id}

Authenticated.

**Response `data`:** User object.

---

### PUT /api/v1/users/{id}

Authenticated.

**Request body:** partial — any updatable field (`name`, `email`, `password`, `role`).

---

### DELETE /api/v1/users/{id}

Authenticated. Admin / Supervisor only.

---

## Categories

### GET /api/v1/categories

Authenticated.

**Response `data`:** array of Category objects (nested).

```json
{
  "id": 1,
  "name": "string",
  "parent_id": null,
  "children": []
}
```

Used for nested category navigation in the product browser.

---

### POST /api/v1/categories

Authenticated. Admin / Supervisor only.

**Request body:**

```json
{
  "name": "string",
  "parent_id": null
}
```

`parent_id` is optional — omit for root categories.

---

### GET /api/v1/categories/{id}

Authenticated.

**Response `data`:** Category object.

---

### PUT /api/v1/categories/{id}

Authenticated. Admin / Supervisor only.

**Request body:** partial.

---

### DELETE /api/v1/categories/{id}

Authenticated. Admin / Supervisor only.

---

## Products

### GET /api/v1/products

Authenticated.

**Response `data`:** array of Product objects.

```json
{
  "id": 1,
  "name": "string",
  "description": "string",
  "price": 12000.00,
  "category_id": 1,
  "category": {
    "id": 1,
    "name": "string"
  }
}
```

---

### POST /api/v1/products

Authenticated. Admin / Supervisor only.

**Request body:**

```json
{
  "name": "string",
  "description": "string",
  "price": 12000,
  "category_id": 1
}
```

---

### GET /api/v1/products/{id}

Authenticated.

**Response `data`:** Product object.

---

### PUT /api/v1/products/{id}

Authenticated. Admin / Supervisor only.

**Request body:** partial.

---

### DELETE /api/v1/products/{id}

Authenticated. Admin / Supervisor only.

---

## Farmers

### GET /api/v1/farmers

Authenticated.

Query params: `?search=identifier_or_phone` for farmer lookup.

**Response `data`:** array of Farmer objects.

```json
{
  "id": 1,
  "identifier": "CI-ABJ-00001",
  "firstname": "string",
  "lastname": "string",
  "phone": "+2250701234500",
  "credit_limit": 500000.00,
  "total_debt": 125000.00
}
```

`total_debt` is the sum of all `remaining_amount` on open debts.

---

### POST /api/v1/farmers

Authenticated.

**Request body:**

```json
{
  "identifier": "string",
  "firstname": "string",
  "lastname": "string",
  "phone": "string",
  "credit_limit": 500000
}
```

---

### GET /api/v1/farmers/{id}

Authenticated.

**Response `data`:** Farmer object (with `total_debt`).

---

### PUT /api/v1/farmers/{id}

Authenticated.

**Request body:** partial.

---

### DELETE /api/v1/farmers/{id}

Authenticated.

---

### GET /api/v1/farmers/{id}/debts

Authenticated.

**Response `data`:** array of Debt objects for this farmer (outstanding only).

```json
{
  "id": 1,
  "farmer_id": 1,
  "transaction_id": 3,
  "amount_fcfa": 13000.00,
  "remaining_amount": 8000.00,
  "created_at": "2025-01-15T10:00:00Z"
}
```

Ordered oldest first (FIFO order).

---

## Transactions

### GET /api/v1/transactions

Authenticated.

**Response `data`:** array of Transaction objects.

```json
{
  "id": 1,
  "farmer_id": 1,
  "operator_id": 2,
  "total_fcfa": 24000.00,
  "payment_method": "cash | credit",
  "interest_rate": null,
  "credited_amount": null,
  "created_at": "2025-01-15T10:00:00Z",
  "items": [
    {
      "product_id": 1,
      "product_name": "string",
      "quantity": 2,
      "unit_price": 12000.00
    }
  ]
}
```

---

### POST /api/v1/transactions

Authenticated. Operator only.

**Request body (cash):**

```json
{
  "farmer_id": 1,
  "payment_method": "cash",
  "items": [
    { "product_id": 1, "quantity": 2 },
    { "product_id": 3, "quantity": 1 }
  ]
}
```

**Request body (credit):**

```json
{
  "farmer_id": 2,
  "payment_method": "credit",
  "interest_rate": 10,
  "items": [
    { "product_id": 5, "quantity": 3 }
  ]
}
```

**Error 422** if credit would exceed farmer's credit limit.

**Response `data`:** created Transaction object.

---

### GET /api/v1/transactions/{id}

Authenticated.

**Response `data`:** Transaction object with items.

---

## Repayments

### GET /api/v1/repayments

Authenticated.

**Response `data`:** array of Repayment objects.

```json
{
  "id": 1,
  "farmer_id": 1,
  "operator_id": 2,
  "kg_received": 25.00,
  "commodity_rate": 450.00,
  "fcfa_value": 11250.00,
  "created_at": "2025-01-20T14:00:00Z",
  "debts_affected": [
    {
      "debt_id": 1,
      "amount_applied": 8000.00
    }
  ]
}
```

---

### GET /api/v1/repayments/{id}

Authenticated.

**Response `data`:** Repayment object.

---

### POST /api/v1/repayments

Authenticated. Operator only.

**Request body:**

```json
{
  "farmer_id": 1,
  "kg_received": 25,
  "commodity_rate": 450
}
```

System converts: `fcfa_value = kg_received × commodity_rate`.
FIFO applied automatically — oldest debt settled first.

**Response `data`:** created Repayment object with `debts_affected`.

---

## Error Responses

| Status | When |
| -------- | ------ |
| 401 | Missing or invalid token → redirect to login |
| 403 | Role not allowed for this endpoint |
| 404 | Resource not found |
| 422 | Validation error (incl. credit limit exceeded) |
| 500 | Server error |

**Error body:**

```json
{
  "success": false,
  "message": "string",
  "errors": {}
}
```
