// Farmer debt summary
function DebtSummaryScreen({ t, dark }) {
  const f = FARMERS.find(x => x.id === 'CIV-4421');
  const d = DEBT_DETAIL;
  const usedPct = (d.total / d.limit) * 100;

  return (
    <PhoneShell t={t} dark={dark}>
      <AppBar t={t} title="Account" subtitle={f.name} onBack={() => {}}
        trailing={<IconButton t={t}><Icons.more size={22} /></IconButton>} />

      <div style={{ flex: 1, overflow: 'auto', background: t.bg }}>
        {/* Hero — outstanding */}
        <div style={{ padding: '20px 20px 24px', background: t.primary, color: t.onPrimary }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 18 }}>
            <Avatar t={t} name={f.name} size={48} tone={t.primaryInk} />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 16, fontWeight: 700 }}>{f.name}</div>
              <div style={{ fontSize: 12, opacity: 0.75, fontFamily: FONT.mono, fontWeight: 600 }}>{f.id} · {f.village}</div>
            </div>
          </div>
          <div style={{ fontSize: 12, fontWeight: 600, opacity: 0.85, letterSpacing: 0.5, textTransform: 'uppercase' }}>Total outstanding</div>
          <div style={{ marginTop: 6, marginBottom: 14 }}>
            <Money t={t} amount={d.total} size="xxl" tone="onPrimary" strong />
          </div>
          {/* Credit usage bar */}
          <div style={{ height: 10, background: 'rgba(255,255,255,0.18)', borderRadius: RADIUS.pill, overflow: 'hidden', marginBottom: 8 }}>
            <div style={{ width: usedPct + '%', height: '100%',
              background: usedPct > 90 ? t.accent : '#fff',
              borderRadius: RADIUS.pill }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13 }}>
            <span style={{ opacity: 0.85 }}>{Math.round(usedPct)}% of credit limit</span>
            <span style={{ fontWeight: 700, fontVariantNumeric: 'tabular-nums' }}>{fcfa(d.limit - d.total, { bare: true })} <span style={{ opacity: 0.7 }}>available</span></span>
          </div>
        </div>

        {/* Quick actions */}
        <div style={{ display: 'flex', gap: 10, padding: '16px' }}>
          <Button t={t} variant="primary" size="md" full leading={<Icons.scale size={18} />}>Record repayment</Button>
          <Button t={t} variant="secondary" size="md" leading={<Icons.cart size={18} />}>New order</Button>
        </div>

        {/* Stats row */}
        <div style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          <Card t={t} padding={14}>
            <Stat t={t} label="Credit limit">
              <Money t={t} amount={d.limit} size="lg" strong />
            </Stat>
          </Card>
          <Card t={t} padding={14}>
            <Stat t={t} label="Available">
              <Money t={t} amount={d.limit - d.total} size="lg" strong tone="primary" />
            </Stat>
          </Card>
        </div>

        {/* Open orders */}
        <SectionHeader t={t} title={`Open orders (${d.orders.length})`} />
        <div style={{ background: t.surface, borderTop: `1px solid ${t.border}`, borderBottom: `1px solid ${t.border}` }}>
          {d.orders.map((o, i) => (
            <div key={o.id} style={{
              padding: '14px 16px',
              borderBottom: i === d.orders.length - 1 ? 'none' : `1px solid ${t.border}`,
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ width: 36, height: 36, borderRadius: RADIUS.sm, background: t.surfaceAlt,
                display: 'flex', alignItems: 'center', justifyContent: 'center', color: t.inkMuted, flexShrink: 0 }}>
                <Icons.receipt size={18} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span style={{ fontSize: 14, fontWeight: 700, color: t.ink, fontFamily: FONT.mono }}>{o.id}</span>
                  <span style={{ fontSize: 12, color: t.inkMuted }}>· {o.date}</span>
                </div>
                <div style={{ fontSize: 12, color: t.inkMuted, marginTop: 2,
                  whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{o.items}</div>
              </div>
              <Money t={t} amount={o.total} size="md" strong />
            </div>
          ))}
        </div>

        {/* Recent payments */}
        <SectionHeader t={t} title="Recent repayments" />
        <div style={{ background: t.surface, borderTop: `1px solid ${t.border}`, borderBottom: `1px solid ${t.border}` }}>
          {d.payments.map((p, i) => (
            <div key={i} style={{
              padding: '14px 16px',
              borderBottom: i === d.payments.length - 1 ? 'none' : `1px solid ${t.border}`,
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ width: 36, height: 36, borderRadius: RADIUS.sm, background: t.primarySoft,
                display: 'flex', alignItems: 'center', justifyContent: 'center', color: t.primary, flexShrink: 0 }}>
                <Icons.arrowDown size={18} stroke={2.4} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 600, color: t.ink }}>{p.kind}</div>
                <div style={{ fontSize: 12, color: t.inkMuted, marginTop: 2 }}>{p.date}</div>
              </div>
              <Money t={t} amount={p.amount} size="md" strong tone="primary" signed />
            </div>
          ))}
        </div>

        <div style={{ height: 32 }} />
      </div>
    </PhoneShell>
  );
}

window.DebtSummaryScreen = DebtSummaryScreen;
