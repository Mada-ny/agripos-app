# AgriPOS — Project Progress

## Screens

| Screen | Route | Status | PR |
|--------|-------|--------|----|
| Login | `/login` | Done | #2 |
| Farmer Search | `/farmers` | Done | #3 |
| Farmer Account / Debt Detail | `/farmers/:id` | Done | #4 |
| Create Farmer | `/farmers/new` | Done | #6 |
| Product Browser | `/products` | Done | #7 |
| Order Checkout | `/orders/checkout` | Done | #8 |
| Record Repayment | `/repayments` | Done | #5 |

## Management

| Feature | Status | PR |
|---------|--------|----|
| Edit farmer | Done | #11 |
| Delete farmer | Done | #11 |

## Foundation

| Layer | Status |
|-------|--------|
| Auth (token storage, DioClient, AuthNotifier) | Done — PR #1 |
| GoRouter + auth redirect | Done — PR #1 |
| Farmer model + repository | Done — PR #3 |

## Notes

- `credit_limit` comes as a decimal string from the API — use `double.parse()`
- `outstanding_debt` and `available_credit` come as integers — cast as `num`
- Paginated collections: parse from `response.data['data']`
- Debt detail (`/farmers/:id/debts`) returns a plain `data` array — no pagination wrapper
- `debts_settled` is the key in repayment responses (not `debts_affected`)
- Search on farmer list is client-side (filter on name, identifier, phone)
