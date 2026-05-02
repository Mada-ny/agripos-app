// Farmer search screen — no zone, no "Recent in your zone" section
function FarmerSearchScreen({ t, dark }) {
  const all = FARMERS;
  const FarmerRow = ({ f, last }) => (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 14,
      padding: '14px 16px',
      borderBottom: last ? 'none' : `1px solid ${t.border}`,
    }}>
      <Avatar t={t} name={f.name} size={44} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 16, fontWeight: 600, color: t.ink, lineHeight: 1.25 }}>{f.name}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 3,
          fontSize: 13, color: t.inkMuted, fontVariantNumeric: 'tabular-nums' }}>
          <span style={{ fontFamily: FONT.mono, fontWeight: 600, color: t.inkMuted, fontSize: 12 }}>{f.id}</span>
          <span style={{ width: 3, height: 3, borderRadius: '50%', background: t.inkSubtle }} />
          <span>{f.phone.replace('+225 ', '')}</span>
        </div>
      </div>
      <div style={{ textAlign: 'right' }}>
        {f.debt > 0 ? (
          <div>
            <div style={{ fontSize: 11, color: t.inkMuted, fontWeight: 600, letterSpacing: 0.5, textTransform: 'uppercase' }}>Owes</div>
            <Money t={t} amount={f.debt} size="md" tone="danger" strong />
          </div>
        ) : (
          <Chip t={t} tone="primary" size="sm" leading={<Icons.check size={11} stroke={3} />}>Clear</Chip>
        )}
      </div>
    </div>
  );

  return (
    <PhoneShell t={t} dark={dark}>
      <AppBar t={t} title="Farmers" subtitle={`${FARMERS.length} active accounts`}
        trailing={<>
          <IconButton t={t}><Icons.qr size={22} /></IconButton>
          <IconButton t={t}><Icons.more size={22} /></IconButton>
        </>} />

      {/* Search */}
      <div style={{ padding: '12px 16px', background: t.bg, borderBottom: `1px solid ${t.border}` }}>
        <Field t={t} value="kouam" placeholder="Search by name, ID or phone…"
          leading={<Icons.search size={20} />}
          trailing={<Icons.close size={18} />}
          focused size="lg" />
        <div style={{ display: 'flex', gap: 8, marginTop: 12, overflowX: 'auto', paddingBottom: 2 }}>
          <Chip t={t} tone="primary" size="md">All farmers</Chip>
          <Chip t={t} tone="default" size="md">With debt</Chip>
          <Chip t={t} tone="default" size="md">No debt</Chip>
        </div>
      </div>

      {/* List */}
      <div style={{ flex: 1, overflow: 'auto', background: t.bg }}>
        <SectionHeader t={t} title={`All farmers (${all.length})`} action={
          <span style={{ fontSize: 12, color: t.inkMuted, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 4 }}>
            A–Z <Icons.chevD size={12} />
          </span>
        } />
        <div style={{ background: t.surface, marginTop: 4, borderTop: `1px solid ${t.border}`, borderBottom: `1px solid ${t.border}` }}>
          {all.map((f, i, arr) => <FarmerRow key={f.id} f={f} last={i === arr.length - 1} />)}
        </div>
        <div style={{ height: 80 }} />
      </div>

      {/* FAB */}
      <div style={{ position: 'absolute', bottom: 20, right: 20 }}>
        <button style={{
          width: 60, height: 60, borderRadius: '50%',
          background: t.primary, color: t.onPrimary, border: 'none',
          boxShadow: `0 8px 24px ${t.shadowStrong}`, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icons.plus size={26} stroke={2.5} />
        </button>
      </div>
    </PhoneShell>
  );
}

window.FarmerSearchScreen = FarmerSearchScreen;
