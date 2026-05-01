# Design System

Extracted from the Claude Design handoff (AgriPOS).
App name: **AgriPOS**. Default theme: **earthy / light**.

---

## Theme

**Earthy light** — single theme, no variants.

---

## Color Palette

| Token | Hex | Usage |
| ------- | ----- | ------- |
| `bg` | `#faf6ef` | App background |
| `surface` | `#ffffff` | Cards, modals |
| `surfaceAlt` | `#f3ede2` | Alternate surfaces, inputs |
| `surfaceSunken` | `#ebe3d4` | Sunken areas |
| `ink` | `#231a10` | Primary text |
| `inkMuted` | `#6b5d48` | Secondary text, labels |
| `inkSubtle` | `#a89a82` | Placeholder, disabled text |
| `primary` | `#2d5d3a` | Buttons, active states, brand |
| `primarySoft` | `#dde8d8` | Light primary backgrounds |
| `onPrimary` | `#ffffff` | Text on primary buttons |
| `accent` | `#c97a2b` | Highlights, badges, FCFA amounts |
| `accentSoft` | `#f6e5cc` | Light accent backgrounds |
| `onAccent` | `#ffffff` | Text on accent |
| `danger` | `#b3321b` | Errors, destructive actions |
| `dangerSoft` | `#f7dcd4` | Error backgrounds |
| `success` | `#2d5d3a` | Success states (same as primary) |
| `warning` | `#d49521` | Warnings |
| `border` | `#e3d8c2` | Card borders, dividers |
| `borderStrong` | `#cbbd9f` | Strong borders |
| `shadow` | `rgba(60,40,16,0.08)` | Card shadow |
| `shadowStrong` | `rgba(60,40,16,0.16)` | Elevated shadow |

---

## Typography

- **Font**: `Inter`, system-ui, -apple-system, sans-serif
- **Mono**: `JetBrains Mono` (for amounts, codes)

| Role | Size | Weight |
| ------ | ------ | -------- |
| Page title | 20px | 700 |
| Section header | 16px | 600 |
| Body | 14px | 400 |
| Label / caption | 12px | 500 |
| Amount (FCFA) | 16–24px | 700, mono |

---

## Spacing Scale

| Token | Value |
| ------- | ------- |
| `space1` | 4px |
| `space2` | 8px |
| `space3` | 12px |
| `space4` | 16px |
| `space5` | 20px |
| `space6` | 24px |
| `space7` | 32px |
| `space8` | 40px |

---

## Border Radius

| Token | Value | Usage |
| ------- | ------- | ------- |
| `sm` | 6px | Small chips, badges |
| `md` | 10px | Input fields |
| `lg` | 14px | Cards |
| `xl` | 20px | Bottom sheets, large cards |
| `pill` | 999px | Tags, buttons |

---

## Components

### Buttons

- **Primary**: background `primary`, text `onPrimary`, radius `pill`, padding `12px 24px`
- **Secondary**: background `primarySoft`, text `primary`, radius `pill`
- **Danger**: background `danger`, text `white`, radius `pill`
- Height: minimum 48px (large touch targets for field use)

### Cards

- Background: `surface`
- Border: 1px solid `border`
- Border radius: `lg` (14px)
- Shadow: `shadow`
- Padding: `space4` (16px)

### Input Fields

- Background: `surfaceAlt`
- Border: 1px solid `border`
- Border radius: `md` (10px)
- Padding: `12px 16px`
- Placeholder color: `inkSubtle`
- Height: minimum 48px

### AppBar (top navigation)

- Background: `primary` (`#2d5d3a`)
- Text / icons: `onPrimary` (`#ffffff`)
- Height: 56px

### Bottom Navigation

- Background: `surface`
- Active icon color: `primary`
- Inactive icon color: `inkSubtle`
- Border top: 1px solid `border`

### Badges / Status chips

- Radius: `pill`
- Padding: `4px 10px`
- Font size: 12px, weight 600

---

## FCFA Formatting

Always format amounts as: `12 000 FCFA` (space as thousands separator, no decimals).

```dart
// Helper
String formatFcfa(double amount) {
  final n = amount.round();
  final formatted = n.abs().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ' ',
  );
  return '${n < 0 ? '−' : ''}$formatted FCFA';
}
```

---

## Screens Designed

| Screen | File reference |
| -------- | --------------- |
| Login | `screens/login.jsx` |
| Farmer Search / Lookup | `screens/search.jsx` |
| Product Browser (view-only) | `screens/products.jsx` |
| Order Checkout | `screens/checkout.jsx` |
| Farmer Debt Summary | `screens/debt.jsx` |
| Record Repayment | `screens/repayment.jsx` |

Missing from handoff (to add):

- Create Farmer profile screen
- Product detail screen (view-only)

---

## Notes

- All touch targets minimum 48px height — app used in field conditions
- High contrast ratios — outdoor readability
- FCFA amounts always use accent color (`#c97a2b`) or mono font to stand out
- Destructive actions (delete, block transaction) always use `danger` color with confirmation
