// Record commodity repayment — global, single repayment.
function RepaymentScreen({ t, dark }) {
  const debt = 318200;
  const operatorRate = 1650;
  const kg = 142;
  const value = kg * operatorRate;
  const remaining = Math.max(0, debt - value);
  const pct = Math.min(100, (value / debt) * 100);

  return (
    <PhoneShell t={t} dark={dark}>
      <AppBar t={t} title="Record repayment" subtitle="Awa Diallo · CIV-4421" onBack={() => {}} />

      <div style={{ flex: 1, overflow: 'auto', background: t.bg }}>
        {/* Commodity rate — editable input */}
        <SectionHeader t={t} title="Commodity rate" />
        <div style={{ padding: '0 16px' }}>
          <div style={{
            background: t.surface, border: `1.5px solid ${t.primary}`, borderRadius: RADIUS.lg,
            padding: '18px 18px', boxShadow: `0 0 0 4px ${t.primarySoft}`,
          }}>
            <div style={{ fontSize: 12, color: t.inkMuted, fontWeight: 700, letterSpacing: 0.5, textTransform: 'uppercase' }}>Rate</div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 6 }}>
              <span style={{
                fontSize: 44, fontWeight: 800, color: t.ink, letterSpacing: -1.2,
                fontVariantNumeric: 'tabular-nums', lineHeight: 1,
              }}>{operatorRate.toLocaleString('fr-FR').replace(/,/g, ' ')}</span>
              <span style={{
                width: 9, height: 22, background: t.primary, borderRadius: 2,
                animation: 'blink 1s steps(2) infinite', opacity: 0.5,
              }} />
              <div style={{ flex: 1 }} />
              <span style={{ fontSize: 18, color: t.inkMuted, fontWeight: 700 }}>FCFA / kg</span>
            </div>
          </div>
        </div>

        {/* Total kg received */}
        <SectionHeader t={t} title="Total received" />
        <div style={{ padding: '0 16px' }}>
          <div style={{
            background: t.surface, border: `1.5px solid ${t.primary}`, borderRadius: RADIUS.lg,
            padding: '20px 16px', boxShadow: `0 0 0 4px ${t.primarySoft}`,
          }}>
            <div style={{ fontSize: 12, color: t.inkMuted, fontWeight: 700, letterSpacing: 0.5, textTransform: 'uppercase' }}>Weight</div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 6 }}>
              <span style={{
                fontSize: 56, fontWeight: 800, color: t.ink, letterSpacing: -2,
                fontVariantNumeric: 'tabular-nums', lineHeight: 1,
              }}>{kg}</span>
              <span style={{ fontSize: 22, color: t.inkMuted, fontWeight: 700 }}>kg</span>
              <div style={{ flex: 1 }} />
              <span style={{
                width: 12, height: 28, background: t.primary, borderRadius: 2,
                animation: 'blink 1s steps(2) infinite', opacity: 0.5,
              }} />
            </div>
            <div style={{ marginTop: 14, paddingTop: 14, borderTop: `1px solid ${t.border}`,
              display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
              <span style={{ fontSize: 12, color: t.inkMuted, fontWeight: 600, letterSpacing: 0.3, textTransform: 'uppercase' }}>Total value</span>
              <Money t={t} amount={value} size="lg" strong tone="primary" />
            </div>
          </div>
        </div>

        {/* Debt impact — visualises how this repayment reduces the outstanding */}
        <SectionHeader t={t} title="Debt impact" />
        <div style={{ padding: '0 16px' }}>
          <div style={{
            background: t.surface, border: `1px solid ${t.border}`, borderRadius: RADIUS.md,
            padding: 14,
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 4 }}>
              <span style={{ fontSize: 13, color: t.inkMuted, fontWeight: 600 }}>Outstanding</span>
              <span style={{ fontSize: 14, color: t.ink, fontWeight: 700, fontVariantNumeric: 'tabular-nums' }}>{fcfa(debt)}</span>
            </div>
            <div style={{ height: 12, background: t.surfaceSunken, borderRadius: RADIUS.pill, overflow: 'hidden', marginTop: 6, marginBottom: 8 }}>
              <div style={{ width: pct + '%', height: '100%', background: t.primary }} />
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12, color: t.inkMuted, fontWeight: 600 }}>
              <span style={{ color: t.primary }}>− {fcfa(value)}  ({Math.round(pct)}%)</span>
              <span>Remaining <span style={{ color: t.ink, fontWeight: 700, fontVariantNumeric: 'tabular-nums' }}>{fcfa(remaining, { bare: true })}</span></span>
            </div>
          </div>
        </div>

        <div style={{ height: 24 }} />
      </div>

      <ActionBar t={t}>
        <Button t={t} size="lg" full leading={<Icons.check size={20} stroke={3} />}>
          Confirm · {fcfa(value, { bare: true })} FCFA
        </Button>
      </ActionBar>
    </PhoneShell>
  );
}

window.RepaymentScreen = RepaymentScreen;
