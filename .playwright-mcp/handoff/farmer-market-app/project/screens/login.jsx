// Login screen — email + password
function LoginScreen({ t, dark }) {
  return (
    <PhoneShell t={t} dark={dark}>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', padding: '0 28px', overflow: 'hidden' }}>
        {/* Brand block */}
        <div style={{ paddingTop: 56, paddingBottom: 32 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 28 }}>
            <div style={{
              width: 52, height: 52, borderRadius: 14,
              background: t.primary, color: t.onPrimary,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              boxShadow: `0 6px 20px ${t.shadow}`,
            }}>
              <Icons.leaf size={28} stroke={2.2} />
            </div>
            <div>
              <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.4, color: t.ink }}>AgriPOS</div>
              <div style={{ fontSize: 12, color: t.inkMuted, fontWeight: 500, letterSpacing: 0.3 }}>FIELD OPERATOR</div>
            </div>
          </div>
          <div style={{ fontSize: 30, fontWeight: 700, lineHeight: 1.1, color: t.ink, letterSpacing: -0.6, textWrap: 'balance' }}>
            Welcome back.
          </div>
          <div style={{ fontSize: 16, color: t.inkMuted, marginTop: 8, lineHeight: 1.5 }}>
            Sign in to manage farmer accounts and record sales.
          </div>
        </div>

        {/* Form */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          <Field t={t} label="Email" value="operator@coopcivoire.ci"
            leading={<Icons.user size={20} />} size="lg" />
          <Field t={t} label="Password" value="passwordSecret123" type="password"
            leading={<Icons.shield size={20} />}
            trailing={<Icons.eyeOff size={20} />} size="lg" focused />
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: 4 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <div style={{ width: 22, height: 22, borderRadius: 5, background: t.primary,
                display: 'flex', alignItems: 'center', justifyContent: 'center', color: t.onPrimary }}>
                <Icons.check size={14} stroke={3} />
              </div>
              <span style={{ fontSize: 14, color: t.ink, fontWeight: 500 }}>Keep me signed in</span>
            </div>
            <span style={{ fontSize: 14, color: t.primary, fontWeight: 600 }}>Forgot password?</span>
          </div>
        </div>

        <div style={{ marginTop: 28 }}>
          <Button t={t} size="lg" full trailing={<Icons.forward size={20} />}>Sign in</Button>
        </div>

        <div style={{ flex: 1 }} />

        <div style={{ textAlign: 'center', paddingBottom: 20, fontSize: 12, color: t.inkSubtle, fontWeight: 500 }}>
          Coopérative Agricole de Côte d'Ivoire
        </div>
      </div>
    </PhoneShell>
  );
}

window.LoginScreen = LoginScreen;
