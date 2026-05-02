// Shared UI components for AgriPOS
// Each accepts a `t` (theme) prop containing resolved tokens.

// ──────────────────────────────────────────────────────────────
// PhoneShell — replaces AndroidDevice with our themed surface.
// Adds a status bar, optional header, and content area.
// ──────────────────────────────────────────────────────────────
function PhoneShell({ t, children, dark, statusbarTone = 'auto', noBezel = false }) {
  const tone = statusbarTone === 'auto' ? (dark ? 'light' : 'dark') : statusbarTone;
  const cBg = dark ? '#0a0907' : '#26201a';
  const inner = (
    <div style={{
      width: 412, height: 892,
      background: t.bg, color: t.ink,
      fontFamily: FONT.sans,
      display: 'flex', flexDirection: 'column',
      overflow: 'hidden', position: 'relative',
    }}>
      <PhoneStatusBar tone={tone} />
      {children}
    </div>
  );
  if (noBezel) return inner;
  return (
    <div style={{
      width: 412, height: 892,
      background: cBg,
      borderRadius: 18, overflow: 'hidden',
      border: `8px solid ${cBg}`,
      boxSizing: 'border-box',
    }}>
      {inner}
    </div>
  );
}

function PhoneStatusBar({ tone = 'dark', bg }) {
  const c = tone === 'light' ? '#fff' : '#1a1310';
  return (
    <div style={{
      height: 36, flexShrink: 0,
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '0 18px', background: bg || 'transparent',
      position: 'relative', fontWeight: 600,
    }}>
      <span style={{ fontSize: 15, color: c, fontVariantNumeric: 'tabular-nums' }}>9:41</span>
      <div style={{ position: 'absolute', left: '50%', top: 6, transform: 'translateX(-50%)',
        width: 90, height: 24, borderRadius: 12, background: '#0a0907' }} />
      <div style={{ display: 'flex', gap: 5, alignItems: 'center', color: c }}>
        <svg width="16" height="11" viewBox="0 0 16 11" fill="currentColor">
          <rect x="0" y="7" width="3" height="4" rx="0.5" />
          <rect x="4.5" y="5" width="3" height="6" rx="0.5" />
          <rect x="9" y="2.5" width="3" height="8.5" rx="0.5" />
          <rect x="13.5" y="0" width="3" height="11" rx="0.5" />
        </svg>
        <svg width="16" height="11" viewBox="0 0 16 11" fill="none" stroke="currentColor" strokeWidth="1.4">
          <path d="M1 4a10 10 0 0114 0M3.5 6.5a6 6 0 019 0M6 9a2.5 2.5 0 014 0" />
        </svg>
        <svg width="22" height="11" viewBox="0 0 22 11" fill="none" stroke="currentColor" strokeWidth="1">
          <rect x="0.5" y="0.5" width="18" height="10" rx="2.2" />
          <rect x="2" y="2" width="13" height="7" rx="1.2" fill="currentColor" />
          <rect x="19.5" y="3.5" width="2" height="4" rx="1" fill="currentColor" stroke="none" />
        </svg>
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────
// AppBar — top bar with optional back button, title, and trailing slot.
// ──────────────────────────────────────────────────────────────
function AppBar({ t, title, subtitle, onBack, trailing, sticky = true, big = false, bg }) {
  return (
    <div style={{
      background: bg || t.bg,
      borderBottom: `1px solid ${t.border}`,
      padding: big ? '8px 12px 16px' : '8px 12px',
      display: 'flex', flexDirection: 'column', gap: big ? 8 : 0,
      position: sticky ? 'sticky' : 'static', top: 0, zIndex: 5,
      flexShrink: 0,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 4, minHeight: 48 }}>
        {onBack ? (
          <IconButton t={t} onClick={onBack}><Icons.back size={22} /></IconButton>
        ) : <div style={{ width: 8 }} />}
        {!big && (
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 17, fontWeight: 600, color: t.ink, lineHeight: 1.25,
              whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{title}</div>
            {subtitle && <div style={{ fontSize: 12, color: t.inkMuted, marginTop: 1 }}>{subtitle}</div>}
          </div>
        )}
        {big && <div style={{ flex: 1 }} />}
        {trailing}
      </div>
      {big && (
        <div style={{ padding: '0 4px' }}>
          <div style={{ fontSize: 28, fontWeight: 700, color: t.ink, letterSpacing: -0.4, lineHeight: 1.15 }}>{title}</div>
          {subtitle && <div style={{ fontSize: 14, color: t.inkMuted, marginTop: 2 }}>{subtitle}</div>}
        </div>
      )}
    </div>
  );
}

function IconButton({ t, onClick, children, tone = 'default', size = 44 }) {
  const colors = {
    default: { fg: t.ink, bg: 'transparent' },
    primary: { fg: t.primary, bg: 'transparent' },
    danger: { fg: t.danger, bg: 'transparent' },
    onPrimary: { fg: t.onPrimary, bg: 'transparent' },
  }[tone];
  return (
    <button onClick={onClick} style={{
      width: size, height: size, border: 'none', background: colors.bg,
      color: colors.fg, borderRadius: RADIUS.pill, cursor: 'pointer',
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>{children}</button>
  );
}

// ──────────────────────────────────────────────────────────────
// Button — primary, secondary, ghost, danger
// ──────────────────────────────────────────────────────────────
function Button({ t, variant = 'primary', size = 'md', children, full, leading, trailing, onClick, disabled }) {
  const sizes = {
    sm: { h: 36, fs: 14, px: 14 },
    md: { h: 48, fs: 15, px: 18 },
    lg: { h: 56, fs: 17, px: 22 },
  }[size];
  const variants = {
    primary: { bg: t.primary, fg: t.onPrimary, border: t.primary },
    secondary: { bg: t.surface, fg: t.ink, border: t.borderStrong },
    accent: { bg: t.accent, fg: t.onAccent, border: t.accent },
    ghost: { bg: 'transparent', fg: t.primary, border: 'transparent' },
    danger: { bg: t.danger, fg: '#fff', border: t.danger },
    dangerGhost: { bg: 'transparent', fg: t.danger, border: t.danger },
  }[variant];
  return (
    <button onClick={onClick} disabled={disabled} style={{
      height: sizes.h, padding: `0 ${sizes.px}px`,
      borderRadius: RADIUS.md,
      background: variants.bg, color: variants.fg,
      border: `1.5px solid ${variants.border}`,
      fontFamily: FONT.sans, fontSize: sizes.fs, fontWeight: 600,
      cursor: disabled ? 'not-allowed' : 'pointer',
      opacity: disabled ? 0.5 : 1,
      width: full ? '100%' : 'auto',
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      gap: 8, letterSpacing: 0.1, whiteSpace: 'nowrap',
    }}>
      {leading}{children}{trailing}
    </button>
  );
}

// ──────────────────────────────────────────────────────────────
// Field — labelled text input (large, field-friendly)
// ──────────────────────────────────────────────────────────────
function Field({ t, label, value, placeholder, leading, trailing, type = 'text', size = 'md', focused = false, hint, error }) {
  const h = size === 'lg' ? 60 : 52;
  const showValue = value !== undefined && value !== '' && value !== null;
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
      {label && <label style={{ fontSize: 13, fontWeight: 600, color: t.inkMuted, letterSpacing: 0.2 }}>{label}</label>}
      <div style={{
        height: h, display: 'flex', alignItems: 'center', gap: 10,
        background: t.surface,
        border: `1.5px solid ${error ? t.danger : focused ? t.primary : t.border}`,
        borderRadius: RADIUS.md,
        padding: '0 14px',
        boxShadow: focused ? `0 0 0 3px ${t.primarySoft}` : 'none',
      }}>
        {leading && <div style={{ color: t.inkMuted, display: 'flex' }}>{leading}</div>}
        <span style={{
          flex: 1, fontSize: 16, color: showValue ? t.ink : t.inkSubtle,
          fontWeight: showValue ? 500 : 400,
          fontVariantNumeric: type === 'number' ? 'tabular-nums' : 'normal',
          letterSpacing: type === 'password' ? 6 : 0,
        }}>{showValue ? (type === 'password' ? '•'.repeat(String(value).length) : value) : placeholder}</span>
        {trailing && <div style={{ color: t.inkMuted, display: 'flex' }}>{trailing}</div>}
      </div>
      {hint && !error && <div style={{ fontSize: 12, color: t.inkMuted }}>{hint}</div>}
      {error && <div style={{ fontSize: 12, color: t.danger, fontWeight: 500 }}>{error}</div>}
    </div>
  );
}

// ──────────────────────────────────────────────────────────────
// Money — FCFA display with optional emphasis
// ──────────────────────────────────────────────────────────────
function Money({ t, amount, size = 'md', tone = 'ink', strong = false, signed = false }) {
  const sizes = { sm: 13, md: 16, lg: 22, xl: 32, xxl: 44 }[size];
  const colors = { ink: t.ink, muted: t.inkMuted, primary: t.primary, danger: t.danger, accent: t.accent, onPrimary: t.onPrimary, onAccent: t.onAccent }[tone] || tone;
  const n = amount || 0;
  const sign = signed ? (n > 0 ? '+ ' : n < 0 ? '− ' : '') : '';
  return (
    <span style={{
      fontFamily: FONT.sans,
      fontVariantNumeric: 'tabular-nums',
      fontSize: sizes, fontWeight: strong ? 700 : 500,
      color: colors, letterSpacing: -0.2,
      whiteSpace: 'nowrap',
    }}>
      {sign}{fcfa(Math.abs(n), { bare: true })}
      <span style={{ fontSize: sizes * 0.55, fontWeight: 500, marginLeft: 4, opacity: 0.75, letterSpacing: 0.5 }}>FCFA</span>
    </span>
  );
}

// ──────────────────────────────────────────────────────────────
// Card — surface with optional padding
// ──────────────────────────────────────────────────────────────
function Card({ t, children, padding = 16, style = {}, onClick, accent }) {
  return (
    <div onClick={onClick} style={{
      background: t.surface,
      border: `1px solid ${t.border}`,
      borderLeft: accent ? `3px solid ${accent}` : `1px solid ${t.border}`,
      borderRadius: RADIUS.md,
      padding,
      cursor: onClick ? 'pointer' : 'default',
      ...style,
    }}>{children}</div>
  );
}

// ──────────────────────────────────────────────────────────────
// Avatar — circular initials avatar
// ──────────────────────────────────────────────────────────────
function Avatar({ t, name = '', size = 44, tone }) {
  const initials = name.split(/\s+/).filter(Boolean).slice(0, 2).map(p => p[0]).join('').toUpperCase();
  // Generate a stable hue from name
  const hash = [...name].reduce((a, c) => a + c.charCodeAt(0), 0);
  const tones = [t.primarySoft, t.accentSoft, t.surfaceAlt];
  const ftones = [t.primary, t.accent, t.inkMuted];
  const i = hash % tones.length;
  const bg = tone || tones[i];
  const fg = ftones[i];
  return (
    <div style={{
      width: size, height: size, flexShrink: 0,
      borderRadius: '50%', background: bg, color: fg,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      fontWeight: 700, fontSize: size * 0.36, letterSpacing: 0.5,
    }}>{initials}</div>
  );
}

// ──────────────────────────────────────────────────────────────
// Pill / Chip
// ──────────────────────────────────────────────────────────────
function Chip({ t, children, tone = 'default', size = 'md', leading }) {
  const palette = {
    default: { bg: t.surfaceAlt, fg: t.inkMuted, br: t.border },
    primary: { bg: t.primarySoft, fg: t.primary, br: 'transparent' },
    accent: { bg: t.accentSoft, fg: t.accent, br: 'transparent' },
    danger: { bg: t.dangerSoft, fg: t.danger, br: 'transparent' },
    success: { bg: t.primarySoft, fg: t.primary, br: 'transparent' },
    outline: { bg: 'transparent', fg: t.inkMuted, br: t.borderStrong },
  }[tone];
  const sizes = { sm: { h: 22, fs: 11, px: 8 }, md: { h: 26, fs: 12, px: 10 }, lg: { h: 32, fs: 13, px: 12 } }[size];
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 5,
      height: sizes.h, padding: `0 ${sizes.px}px`,
      background: palette.bg, color: palette.fg,
      border: `1px solid ${palette.br}`,
      borderRadius: RADIUS.pill,
      fontSize: sizes.fs, fontWeight: 600, letterSpacing: 0.2,
      whiteSpace: 'nowrap',
    }}>{leading}{children}</span>
  );
}

// ──────────────────────────────────────────────────────────────
// Divider
// ──────────────────────────────────────────────────────────────
function Divider({ t, gap = 0 }) {
  return <div style={{ height: 1, background: t.border, margin: `${gap}px 0` }} />;
}

// ──────────────────────────────────────────────────────────────
// Bottom nav (when applicable)
// ──────────────────────────────────────────────────────────────
function BottomNav({ t, items, active }) {
  return (
    <div style={{
      flexShrink: 0,
      borderTop: `1px solid ${t.border}`,
      background: t.surface,
      display: 'flex',
      paddingBottom: 16,
    }}>
      {items.map((it, i) => (
        <button key={i} style={{
          flex: 1, height: 56, border: 'none', background: 'transparent',
          color: active === i ? t.primary : t.inkMuted,
          display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
          gap: 2, cursor: 'pointer',
        }}>
          <div style={{ fontWeight: active === i ? 700 : 500 }}>{it.icon}</div>
          <span style={{ fontSize: 11, fontWeight: active === i ? 700 : 500, letterSpacing: 0.2 }}>{it.label}</span>
        </button>
      ))}
    </div>
  );
}

// ──────────────────────────────────────────────────────────────
// Bottom sheet / sticky action bar
// ──────────────────────────────────────────────────────────────
function ActionBar({ t, children, padding = '12px 16px 20px' }) {
  return (
    <div style={{
      flexShrink: 0,
      borderTop: `1px solid ${t.border}`,
      background: t.surface,
      padding,
      boxShadow: `0 -8px 24px ${t.shadow}`,
    }}>{children}</div>
  );
}

// ──────────────────────────────────────────────────────────────
// Section header (within scrollable content)
// ──────────────────────────────────────────────────────────────
function SectionHeader({ t, title, action }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '14px 16px 6px',
    }}>
      <div style={{ fontSize: 12, fontWeight: 700, color: t.inkMuted,
        letterSpacing: 1, textTransform: 'uppercase' }}>{title}</div>
      {action}
    </div>
  );
}

// ──────────────────────────────────────────────────────────────
// Stat block
// ──────────────────────────────────────────────────────────────
function Stat({ t, label, children, hint }) {
  return (
    <div>
      <div style={{ fontSize: 11, color: t.inkMuted, fontWeight: 600, textTransform: 'uppercase', letterSpacing: 0.8, marginBottom: 6 }}>{label}</div>
      <div>{children}</div>
      {hint && <div style={{ fontSize: 12, color: t.inkMuted, marginTop: 4 }}>{hint}</div>}
    </div>
  );
}

// ──────────────────────────────────────────────────────────────
// Progress bar
// ──────────────────────────────────────────────────────────────
function Progress({ t, value, max = 100, tone = 'primary', height = 8 }) {
  const pct = Math.max(0, Math.min(100, (value / max) * 100));
  const fill = { primary: t.primary, accent: t.accent, danger: t.danger, warning: t.warning }[tone] || t.primary;
  return (
    <div style={{ height, background: t.surfaceSunken, borderRadius: RADIUS.pill, overflow: 'hidden' }}>
      <div style={{ width: pct + '%', height: '100%', background: fill, borderRadius: RADIUS.pill, transition: 'width .3s' }} />
    </div>
  );
}

// ──────────────────────────────────────────────────────────────
// Tag / badge inline with text
// ──────────────────────────────────────────────────────────────
function Badge({ t, children, tone = 'primary' }) {
  const palette = {
    primary: { bg: t.primary, fg: t.onPrimary },
    accent: { bg: t.accent, fg: t.onAccent },
    danger: { bg: t.danger, fg: '#fff' },
    surface: { bg: t.surfaceAlt, fg: t.ink },
  }[tone];
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      minWidth: 20, height: 20, padding: '0 6px',
      background: palette.bg, color: palette.fg,
      borderRadius: RADIUS.pill,
      fontSize: 11, fontWeight: 700, lineHeight: 1,
    }}>{children}</span>
  );
}

Object.assign(window, {
  PhoneShell, PhoneStatusBar,
  AppBar, IconButton, Button, Field, Money, Card, Avatar, Chip,
  Divider, BottomNav, ActionBar, SectionHeader, Stat, Progress, Badge,
});
