// Product browser — chips already serve as category nav. No "ordering for" banner,
// no popularity badges, no stock mention, no app-bar cart (checkout bar suffices).
function ProductBrowserScreen({ t, dark }) {
  const cat = CATEGORIES.find(c => c.id === 'fert');

  return (
    <PhoneShell t={t} dark={dark}>
      <AppBar t={t} title="Fertilizer" subtitle="NPK Compounds · 9 products" onBack={() => {}}
        trailing={<IconButton t={t}><Icons.search size={22} /></IconButton>} />

      {/* Sub-category chips */}
      <div style={{
        display: 'flex', gap: 8, padding: '12px 16px', borderBottom: `1px solid ${t.border}`,
        overflowX: 'auto', flexShrink: 0, background: t.bg,
      }}>
        {cat.sub.map((s, i) => (
          <div key={s.id} style={{
            padding: '8px 14px', borderRadius: RADIUS.pill,
            background: i === 0 ? t.primary : t.surfaceAlt,
            color: i === 0 ? t.onPrimary : t.inkMuted,
            fontSize: 13, fontWeight: 600, whiteSpace: 'nowrap',
            border: `1px solid ${i === 0 ? t.primary : t.border}`,
          }}>{s.name} · {s.count}</div>
        ))}
      </div>

      {/* Products */}
      <div style={{ flex: 1, overflow: 'auto', padding: '14px 16px 0' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, paddingBottom: 16 }}>
          {NPK_PRODUCTS.map(p => (
            <div key={p.id} style={{
              background: t.surface, borderRadius: RADIUS.md, border: `1px solid ${t.border}`,
              padding: 12, display: 'flex', gap: 12, alignItems: 'center',
            }}>
              {/* Product image placeholder */}
              <div style={{
                width: 64, height: 64, flexShrink: 0,
                borderRadius: RADIUS.sm,
                background: `repeating-linear-gradient(45deg, ${t.surfaceSunken}, ${t.surfaceSunken} 4px, ${t.surfaceAlt} 4px, ${t.surfaceAlt} 8px)`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: t.inkSubtle,
              }}>
                <Icons.pkg size={26} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: 700, color: t.ink, lineHeight: 1.25 }}>{p.name}</div>
                <div style={{ fontSize: 13, color: t.inkMuted, marginTop: 2 }}>{p.size}</div>
                <div style={{ marginTop: 6 }}>
                  <Money t={t} amount={p.price} size="md" strong />
                </div>
              </div>
              <button style={{
                width: 40, height: 40, borderRadius: RADIUS.md,
                background: t.primary, color: t.onPrimary, border: 'none',
                display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
                flexShrink: 0,
              }}>
                <Icons.plus size={20} stroke={2.5} />
              </button>
            </div>
          ))}
        </div>
        <div style={{ height: 80 }} />
      </div>

      {/* Sticky cart bar — single entry to checkout */}
      <ActionBar t={t}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 12, color: t.inkMuted, fontWeight: 600 }}>7 items in cart</div>
            <Money t={t} amount={183300} size="lg" strong />
          </div>
          <Button t={t} variant="primary" size="md" trailing={<Icons.forward size={18} />}>
            Checkout
          </Button>
        </div>
      </ActionBar>
    </PhoneShell>
  );
}

window.ProductBrowserScreen = ProductBrowserScreen;
