// Order checkout — interest rate (no VAT, no discount)
function CheckoutScreen({ t, dark }) {
  const subtotal = CART.reduce((s, i) => s + i.unit * i.qty, 0);
  const interestRate = 0.08; // 8% interest on credit
  const interest = Math.round(subtotal * interestRate);
  const total = subtotal + interest;
  return (
    <PhoneShell t={t} dark={dark}>
      <AppBar t={t} title="Checkout" subtitle="Order draft · ORD-8917" onBack={() => {}}
        trailing={<IconButton t={t}><Icons.more size={22} /></IconButton>} />

      <div style={{ flex: 1, overflow: 'auto', background: t.bg }}>
        {/* Customer */}
        <div style={{ padding: '14px 16px' }}>
          <div style={{ background: t.surface, border: `1px solid ${t.border}`, borderRadius: RADIUS.md,
            padding: 14, display: 'flex', alignItems: 'center', gap: 12 }}>
            <Avatar t={t} name="Kouamé Yao" size={44} />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 15, fontWeight: 700, color: t.ink }}>Kouamé Yao</div>
              <div style={{ fontSize: 12, color: t.inkMuted, fontFamily: FONT.mono, fontWeight: 600 }}>CIV-2148</div>
            </div>
            <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Change</span>
          </div>
        </div>

        {/* Items */}
        <SectionHeader t={t} title={`Items (${CART.length})`} action={
          <span style={{ fontSize: 12, color: t.primary, fontWeight: 600 }}>+ Add product</span>
        } />
        <div style={{ background: t.surface, borderTop: `1px solid ${t.border}`, borderBottom: `1px solid ${t.border}` }}>
          {CART.map((it, i) => (
            <div key={it.id} style={{
              display: 'flex', alignItems: 'center', gap: 12, padding: '12px 16px',
              borderBottom: i === CART.length - 1 ? 'none' : `1px solid ${t.border}`,
            }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 600, color: t.ink }}>{it.name}</div>
                <div style={{ fontSize: 12, color: t.inkMuted, marginTop: 2 }}>
                  {it.size} · <span style={{ fontVariantNumeric: 'tabular-nums' }}>{fcfa(it.unit, { bare: true })} ea.</span>
                </div>
              </div>
              {/* Qty stepper */}
              <div style={{ display: 'flex', alignItems: 'center', gap: 0, border: `1px solid ${t.border}`, borderRadius: RADIUS.md, overflow: 'hidden' }}>
                <button style={{ width: 32, height: 32, border: 'none', background: t.surface, color: t.ink, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <Icons.minus size={16} stroke={2.5} />
                </button>
                <div style={{ width: 30, textAlign: 'center', fontSize: 14, fontWeight: 700, fontVariantNumeric: 'tabular-nums', color: t.ink }}>{it.qty}</div>
                <button style={{ width: 32, height: 32, border: 'none', background: t.primary, color: t.onPrimary, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <Icons.plus size={16} stroke={2.5} />
                </button>
              </div>
              <div style={{ width: 96, textAlign: 'right' }}>
                <Money t={t} amount={it.unit * it.qty} size="md" strong />
              </div>
            </div>
          ))}
        </div>

        {/* Totals */}
        <div style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: 8 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 14, color: t.inkMuted }}>
            <span>Subtotal</span><span style={{ fontVariantNumeric: 'tabular-nums', color: t.ink, fontWeight: 600 }}>{fcfa(subtotal, { bare: true })}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 14, color: t.accent, fontWeight: 600 }}>
            <span>Interest · {Math.round(interestRate * 100)}% (credit)</span>
            <span style={{ fontVariantNumeric: 'tabular-nums' }}>+ {fcfa(interest, { bare: true })}</span>
          </div>
          <Divider t={t} gap={4} />
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={{ fontSize: 16, fontWeight: 700, color: t.ink }}>Total</span>
            <Money t={t} amount={total} size="xl" strong />
          </div>
        </div>

        {/* Payment method */}
        <SectionHeader t={t} title="Payment method" />
        <div style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          {[
            { k: 'cash', name: 'Cash', icon: <Icons.cash size={26} />, sub: 'Pay now', selected: false },
            { k: 'credit', name: 'Credit', icon: <Icons.credit size={26} />, sub: 'On account', selected: true },
          ].map(p => (
            <div key={p.k} style={{
              padding: 14, borderRadius: RADIUS.md, cursor: 'pointer',
              background: p.selected ? t.primarySoft : t.surface,
              border: `2px solid ${p.selected ? t.primary : t.border}`,
              display: 'flex', flexDirection: 'column', gap: 8,
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div style={{ color: p.selected ? t.primary : t.inkMuted }}>{p.icon}</div>
                <div style={{
                  width: 22, height: 22, borderRadius: '50%',
                  border: `2px solid ${p.selected ? t.primary : t.borderStrong}`,
                  background: p.selected ? t.primary : 'transparent',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: t.onPrimary,
                }}>{p.selected && <Icons.check size={12} stroke={3.5} />}</div>
              </div>
              <div>
                <div style={{ fontSize: 16, fontWeight: 700, color: t.ink }}>{p.name}</div>
                <div style={{ fontSize: 12, color: t.inkMuted, marginTop: 2 }}>{p.sub}</div>
              </div>
            </div>
          ))}
        </div>

        {/* Credit summary */}
        <div style={{ margin: '12px 16px', padding: 14, background: t.accentSoft, borderRadius: RADIUS.md,
          border: `1px solid ${t.accent}33` }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
            <span style={{ fontSize: 13, fontWeight: 700, color: t.accent, letterSpacing: 0.3 }}>CREDIT IMPACT</span>
            <Icons.alert size={18} {...{ style: { color: t.accent } }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, color: t.ink, marginBottom: 4 }}>
            <span>Current debt</span><span style={{ fontVariantNumeric: 'tabular-nums', fontWeight: 600 }}>{fcfa(142500)}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, color: t.ink, marginBottom: 8 }}>
            <span>After this order</span><span style={{ fontVariantNumeric: 'tabular-nums', fontWeight: 700 }}>{fcfa(142500 + total)}</span>
          </div>
          <Progress t={t} value={(142500 + total)} max={250000} tone="accent" />
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: t.inkMuted, marginTop: 6, fontWeight: 600 }}>
            <span>Limit {fcfa(250000)}</span><span>{Math.round(((142500 + total) / 250000) * 100)}% used</span>
          </div>
        </div>

        <div style={{ height: 100 }} />
      </div>

      <ActionBar t={t}>
        <Button t={t} size="lg" full trailing={<Icons.check size={20} stroke={3} />}>
          Confirm order · {fcfa(total, { bare: true })}
        </Button>
      </ActionBar>
    </PhoneShell>
  );
}

window.CheckoutScreen = CheckoutScreen;
