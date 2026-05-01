# API Contracts

All requests require `Accept: application/json`.
All authenticated requests require `Authorization: Bearer {token}`.
Base URL is defined in `AppConstants.baseUrl` — never hardcode it.

## Response Envelope

Single resource:

```json
{ "data": { ... } }
```

Collection (paginated):

```json
{
  "data": [ ... ],
  "links": { "first": "", "last": "", "prev": null, "next": null },
  "meta": { "current_page": 1, "last_page": 1, "per_page": 15, "total": 3 }
}
```

Error:

```json
{ "success": false, "message": "string", "errors": {} }
```

> Note: `success` key is only present on auth endpoints and errors.
> Resource endpoints return `data` directly without the `success` wrapper.

---

## Dart Models

### UserModel

```dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role; // "admin" | "supervisor" | "operator"
}
```

### CategoryModel

```dart
class CategoryModel {
  final int id;
  final String name;
  final int? parentId;
  final List<CategoryModel> children;
}
```

### ProductModel

```dart
class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price; // parse from string "12000.00"
  final CategoryModel category;
}
```

### FarmerModel

```dart
class FarmerModel {
  final int id;
  final String identifier;
  final String firstname;
  final String lastname;
  final String phone;
  final double creditLimit;     // parse from string "400000.00"
  final double outstandingDebt; // number directly
  final double availableCredit; // number directly
}
```

### DebtModel

```dart
class DebtModel {
  final int id;
  final int transactionId;
  final double amountFcfa;      // parse from string "72600.00"
  final double remainingAmount; // parse from string "61350.00"
  final DateTime createdAt;
}
```

### TransactionItemModel

```dart
class TransactionItemModel {
  final int id;
  final ProductModel product;
  final int quantity;
  final double unitPrice; // parse from string
  final double subtotal;  // number directly
}
```

### TransactionModel

```dart
class TransactionModel {
  final int id;
  final FarmerModel farmer;
  final UserModel operator;
  final double totalFcfa;          // parse from string
  final String paymentMethod;      // "cash" | "credit"
  final double? interestRate;      // null if cash, parse from string
  final double? creditedAmount;    // null if cash, parse from string
  final List<TransactionItemModel> items;
  final DebtModel? debt;           // null if cash
  final DateTime createdAt;
}
```

### DebtSettledModel

```dart
class DebtSettledModel {
  final int id;
  final int transactionId;
  final double amountFcfa;      // parse from string
  final double remainingAmount; // parse from string
  final double amountApplied;   // parse from string
  final DateTime createdAt;
}
```

### RepaymentModel

```dart
class RepaymentModel {
  final int id;
  final FarmerModel farmer;
  final UserModel operator;
  final double kgReceived;      // parse from string "25.00"
  final double commodityRate;   // parse from string "450.00"
  final double fcfaValue;       // parse from string "11250.00"
  final List<DebtSettledModel> debtsSettled; // key: "debts_settled"
  final DateTime createdAt;
}
```

---

## Parsing Notes for Dart

These fields come as **strings** from the API — always parse with `double.parse(value)`:
`price`, `credit_limit`, `amount_fcfa`, `remaining_amount`, `total_fcfa`,
`credited_amount`, `interest_rate`, `kg_received`, `commodity_rate`, `fcfa_value`,
`unit_price`, `amount_applied`.

These fields come as **numbers** directly:
`outstanding_debt`, `available_credit`, `subtotal`.

Other: `created_at` → `DateTime.parse(value)` · `parent_id` → nullable `int`.

---

## Auth

### POST /api/v1/auth/login

No auth required.

**Request:**

```json
{ "email": "admin@farmmarket.ci", "password": "Admin1234!" }
```

**Response 200:**

```json
{
  "success": true,
  "data": {
    "token": "1|xKz8pLmN9qRt2vWy3uJhGfAc5eBdIoPs",
    "user": { "id": 1, "name": "Admin User", "email": "admin@farmmarket.ci", "role": "admin" }
  },
  "message": "Login successful."
}
```

**Response 422:**

```json
{
  "success": false,
  "message": "Validation failed.",
  "errors": { "email": ["The provided credentials are incorrect."] }
}
```

> Store `token` in `flutter_secure_storage`. Store `user` in Riverpod auth state.

---

### POST /api/v1/auth/logout

Authenticated.

**Response 200:** `{ "success": true, "message": "Logged out successfully." }`
**Response 401:** `{ "success": false, "message": "Unauthenticated." }`

> Clear token and reset auth state. Redirect to login.

---

## Users

### GET /api/v1/users

Admin / Supervisor only.

**Response 200:**

```json
{
  "data": [
    { "id": 1, "name": "Admin User", "email": "admin@farmmarket.ci", "role": "admin" },
    { "id": 2, "name": "Diallo Mamadou", "email": "superviseur1@farmmarket.ci", "role": "supervisor" },
    { "id": 3, "name": "Konan Kouamé", "email": "operateur1@farmmarket.ci", "role": "operator" }
  ],
  "links": { ... }, "meta": { "current_page": 1, "last_page": 1, "per_page": 15, "total": 3 }
}
```

**Response 403:** `{ "success": false, "message": "Forbidden." }`

---

### POST /api/v1/users

Admin / Supervisor only.

**Request:** `{ "name": "Kouamé Dje", "email": "operateur2@farmmarket.ci", "password": "Oper1234!", "role": "operator" }`

**Response 201:** `{ "data": { UserModel } }`

**Response 422:**

```json
{
  "success": false, "message": "Validation failed.",
  "errors": {
    "email": ["The email has already been taken."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

---

### GET /api/v1/users/{id}

**Response 200:** `{ "data": { UserModel } }`
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

### PUT /api/v1/users/{id}

**Request:** partial — any of `name`, `email`, `password`, `role`.
**Response 200:** `{ "data": { UserModel } }`
**Response 422:** `{ "success": false, "message": "Validation failed.", "errors": { ... } }`

---

### DELETE /api/v1/users/{id}

**Response 204:** no body.
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

## Categories

### GET /api/v1/categories

Authenticated.

**Response 200:**

```json
{
  "data": [
    {
      "id": 1, "name": "Céréales et grains", "parent_id": null,
      "children": [
        { "id": 4, "name": "Riz local", "parent_id": 1, "children": [] }
      ]
    },
    { "id": 2, "name": "Intrants agricoles", "parent_id": null, "children": [] },
    { "id": 3, "name": "Tubercules et racines", "parent_id": null, "children": [] }
  ],
  "links": { ... }, "meta": { ... }
}
```

> `children` is always present (empty array if none). Use for nested category navigation.

---

### POST /api/v1/categories

Admin / Supervisor only.

**Request (root):** `{ "name": "Épices et condiments" }`
**Request (child):** `{ "name": "Gingembre", "parent_id": 1 }`

**Response 201:** `{ "data": { CategoryModel } }`
**Response 422:** `{ "success": false, "message": "Validation failed.", "errors": { "name": ["The name field is required."] } }`

---

### GET /api/v1/categories/{id}

**Response 200:** `{ "data": { CategoryModel with children } }`
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

### PUT /api/v1/categories/{id}

**Request:** partial.
**Response 200:** `{ "data": { CategoryModel } }`

---

### DELETE /api/v1/categories/{id}

**Response 204:** no body.
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

## Products

### GET /api/v1/products

Authenticated.

**Response 200:**

```json
{
  "data": [
    {
      "id": 1,
      "name": "Fonio (sac 25 kg)",
      "description": "Fonio blanc décortiqué, production du nord de la Côte d'Ivoire.",
      "price": "12000.00",
      "category": { "id": 1, "name": "Céréales et grains", "parent_id": null, "children": [] }
    },
    {
      "id": 2,
      "name": "Maïs blanc (sac 50 kg)",
      "description": "Maïs blanc séché, qualité premium.",
      "price": "15000.00",
      "category": { "id": 1, "name": "Céréales et grains", "parent_id": null, "children": [] }
    }
  ],
  "links": { ... }, "meta": { ... }
}
```

> `price` is a string — parse to `double`.

---

### POST /api/v1/products

Admin / Supervisor only.

**Request:** `{ "name": "...", "description": "...", "price": 12000, "category_id": 1 }`

**Response 201:** `{ "data": { ProductModel } }`

**Response 422:**

```json
{
  "success": false, "message": "Validation failed.",
  "errors": {
    "name": ["The name field is required."],
    "price": ["The price must be at least 0."],
    "category_id": ["The selected category id is invalid."]
  }
}
```

---

### GET /api/v1/products/{id}

**Response 200:** `{ "data": { ProductModel } }`
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

### PUT /api/v1/products/{id}

**Request:** partial — e.g. `{ "price": 8000 }`
**Response 200:** `{ "data": { ProductModel } }`

---

### DELETE /api/v1/products/{id}

**Response 204:** no body.

---

## Farmers

### GET /api/v1/farmers

Authenticated. Supports search.

**Query params:** `?search=CI-ABJ-00001` or `?search=+2250700000001`
Search works on both `identifier` and `phone`.

**Response 200:**

```json
{
  "data": [
    {
      "id": 1, "identifier": "CI-ABJ-00001",
      "firstname": "Kouassi", "lastname": "Yao",
      "phone": "+2250700000001",
      "credit_limit": "400000.00",
      "outstanding_debt": 0,
      "available_credit": 400000
    },
    {
      "id": 2, "identifier": "CI-ABJ-00002",
      "firstname": "Adjoa", "lastname": "Koffi",
      "phone": "+2250700000002",
      "credit_limit": "300000.00",
      "outstanding_debt": 72600,
      "available_credit": 227400
    }
  ],
  "links": { ... }, "meta": { ... }
}
```

---

### POST /api/v1/farmers

Authenticated.

**Request:**

```json
{
  "identifier": "CI-ABJ-00016",
  "firstname": "Adjobi",
  "lastname": "Kra Kouamé",
  "phone": "+2250701234516",
  "credit_limit": 400000
}
```

**Response 201:** `{ "data": { FarmerModel } }`

**Response 422:**

```json
{
  "success": false, "message": "Validation failed.",
  "errors": {
    "identifier": ["The identifier has already been taken."],
    "phone": ["The phone has already been taken."]
  }
}
```

---

### GET /api/v1/farmers/{id}

**Response 200:** `{ "data": { FarmerModel } }`
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

### PUT /api/v1/farmers/{id}

**Request:** partial — e.g. `{ "credit_limit": 750000 }`
**Response 200:** `{ "data": { FarmerModel } }`

---

### DELETE /api/v1/farmers/{id}

**Response 204:** no body.

---

### GET /api/v1/farmers/{id}/debts

Authenticated. Returns outstanding debts only, ordered oldest first (FIFO).

**Response 200:**

```json
{
  "data": [
    {
      "id": 1, "transaction_id": 2,
      "amount_fcfa": "72600.00",
      "remaining_amount": "61350.00",
      "created_at": "2026-05-01T10:30:00.000000Z"
    },
    {
      "id": 3, "transaction_id": 4,
      "amount_fcfa": "27500.00",
      "remaining_amount": "27500.00",
      "created_at": "2026-05-01T14:00:00.000000Z"
    }
  ]
}
```

> No pagination wrapper — plain `data` array.

---

## Transactions

### GET /api/v1/transactions

Authenticated.

**Response 200:**

```json
{
  "data": [
    {
      "id": 1,
      "farmer": { "...FarmerModel..." },
      "operator": { "id": 3, "name": "Konan Kouamé", "email": "operateur1@farmmarket.ci", "role": "operator" },
      "total_fcfa": "39000.00",
      "payment_method": "cash",
      "interest_rate": null,
      "credited_amount": null,
      "items": [
        {
          "id": 1,
          "product": { "...ProductModel..." },
          "quantity": 2,
          "unit_price": "12000.00",
          "subtotal": 24000
        }
      ],
      "debt": null,
      "created_at": "2026-05-01T10:30:00.000000Z"
    }
  ],
  "links": { ... }, "meta": { ... }
}
```

---

### POST /api/v1/transactions — Cash

Operator only.

**Request:**

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

**Response 201:** `{ "data": { TransactionModel } }` — `debt: null`, `interest_rate: null`, `credited_amount: null`.

**Response 422:**

```json
{
  "success": false, "message": "Validation failed.",
  "errors": {
    "farmer_id": ["The selected farmer id is invalid."],
    "items": ["The items field must have at least 1 items."]
  }
}
```

---

### POST /api/v1/transactions — Credit

Operator only.

**Request:**

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

**Response 201:** `{ "data": { TransactionModel } }` — `debt` is populated.

Credit calculation example:

- `total_fcfa`: `"66000.00"` (base)
- `interest_rate`: `"10.00"`
- `credited_amount`: `"72600.00"` (= 66 000 × 1.10)
- `debt.amount_fcfa`: `"72600.00"`

**Response 422 — Credit limit exceeded:**

```json
{ "success": false, "message": "Credit limit exceeded for this farmer." }
```

---

### GET /api/v1/transactions/{id}

**Response 200:** `{ "data": { TransactionModel } }`
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

## Repayments

### GET /api/v1/repayments

Authenticated.

**Response 200:**

```json
{
  "data": [
    {
      "id": 1,
      "farmer": { "...FarmerModel..." },
      "operator": { "...UserModel..." },
      "kg_received": "25.00",
      "commodity_rate": "450.00",
      "fcfa_value": "11250.00",
      "debts_settled": [
        {
          "id": 1, "transaction_id": 2,
          "amount_fcfa": "72600.00",
          "remaining_amount": "61350.00",
          "amount_applied": "11250.00",
          "created_at": "2026-05-01T10:30:00.000000Z"
        }
      ],
      "created_at": "2026-05-01T11:00:00.000000Z"
    }
  ],
  "links": { ... }, "meta": { ... }
}
```

> Key is `debts_settled` (not `debts_affected`).

---

### GET /api/v1/repayments/{id}

**Response 200:** `{ "data": { RepaymentModel } }`
**Response 404:** `{ "success": false, "message": "Resource not found." }`

---

### POST /api/v1/repayments

Operator only.

**Request:**

```json
{ "farmer_id": 2, "kg_received": 25, "commodity_rate": 450 }
```

> System computes: `fcfa_value = kg_received × commodity_rate`
> FIFO applied automatically. Partial repayment supported.

**Response 201:** `{ "data": { RepaymentModel } }`

**Response 422 — No outstanding debt:**

```json
{ "success": false, "message": "This farmer has no outstanding debt to repay." }
```

**Response 422 — Validation:**

```json
{
  "success": false, "message": "Validation failed.",
  "errors": {
    "farmer_id": ["The selected farmer id is invalid."],
    "kg_received": ["The kg received must be at least 0."],
    "commodity_rate": ["The commodity rate must be at least 1."]
  }
}
```

---

## Error Reference

| Status | When | Flutter action |
|--------|------|----------------|
| 401 | Missing or invalid token | Clear storage, redirect to login |
| 403 | Role not allowed | Show "Access denied" message |
| 404 | Resource not found | Show error state in screen |
| 422 | Validation or business rule violation | Show field errors or `message` |
| 500 | Server error | Show generic error message |
