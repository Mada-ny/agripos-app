// Design tokens for AgriPOS — Earthy agricultural theme
// Three theme variants exposed via Tweaks: earthy, forest, clean
// Each has light + dark mode

const THEMES = {
  earthy: {
    light: {
      // Surfaces
      bg: '#faf6ef',          // warm off-white
      surface: '#ffffff',      // pure white cards
      surfaceAlt: '#f3ede2',   // tinted alt surface
      surfaceSunken: '#ebe3d4',
      // Ink
      ink: '#231a10',          // deep cocoa
      inkMuted: '#6b5d48',     // muted brown-grey
      inkSubtle: '#a89a82',
      // Brand
      primary: '#2d5d3a',      // deep forest green
      primaryInk: '#1a3a23',
      primarySoft: '#dde8d8',
      onPrimary: '#ffffff',
      // Accent
      accent: '#c97a2b',        // ochre / burnt sienna
      accentSoft: '#f6e5cc',
      onAccent: '#ffffff',
      // Semantic
      danger: '#b3321b',
      dangerSoft: '#f7dcd4',
      success: '#2d5d3a',
      warning: '#d49521',
      info: '#3a5a8a',
      // Borders / dividers
      border: '#e3d8c2',
      borderStrong: '#cbbd9f',
      // Status
      shadow: 'rgba(60, 40, 16, 0.08)',
      shadowStrong: 'rgba(60, 40, 16, 0.16)',
    },
    dark: {
      bg: '#161310',
      surface: '#211d18',
      surfaceAlt: '#2a2520',
      surfaceSunken: '#0f0d0a',
      ink: '#f5ede0',
      inkMuted: '#b9a98e',
      inkSubtle: '#7a6c54',
      primary: '#7cb487',
      primaryInk: '#dff0e0',
      primarySoft: '#2a3d2e',
      onPrimary: '#0e1a12',
      accent: '#e09d4f',
      accentSoft: '#3d2c1a',
      onAccent: '#1a1108',
      danger: '#e87b62',
      dangerSoft: '#3d1f17',
      success: '#7cb487',
      warning: '#e0b04a',
      info: '#8ba8d4',
      border: '#332c23',
      borderStrong: '#4a4035',
      shadow: 'rgba(0, 0, 0, 0.4)',
      shadowStrong: 'rgba(0, 0, 0, 0.6)',
    },
  },
  forest: {
    light: {
      bg: '#f4f7f2',
      surface: '#ffffff',
      surfaceAlt: '#e8efe4',
      surfaceSunken: '#dde6d7',
      ink: '#0e2014',
      inkMuted: '#536456',
      inkSubtle: '#92a193',
      primary: '#1d4429',
      primaryInk: '#0e2014',
      primarySoft: '#d3e2cc',
      onPrimary: '#ffffff',
      accent: '#4a7a3a',
      accentSoft: '#dceacf',
      onAccent: '#ffffff',
      danger: '#a8311a',
      dangerSoft: '#f4d7d0',
      success: '#1d4429',
      warning: '#c98a1f',
      info: '#2d557a',
      border: '#d5dfcd',
      borderStrong: '#b3c2a8',
      shadow: 'rgba(20, 40, 24, 0.08)',
      shadowStrong: 'rgba(20, 40, 24, 0.16)',
    },
    dark: {
      bg: '#0d140f',
      surface: '#161e18',
      surfaceAlt: '#1c2620',
      surfaceSunken: '#080c09',
      ink: '#e8f0e6',
      inkMuted: '#9ab09c',
      inkSubtle: '#5d7060',
      primary: '#88c490',
      primaryInk: '#d6ead8',
      primarySoft: '#1f3525',
      onPrimary: '#0d140f',
      accent: '#a9d38c',
      accentSoft: '#26361b',
      onAccent: '#0d140f',
      danger: '#e07a62',
      dangerSoft: '#3a1c14',
      success: '#88c490',
      warning: '#e0b94a',
      info: '#8ba8d4',
      border: '#243028',
      borderStrong: '#3a4a3e',
      shadow: 'rgba(0, 0, 0, 0.4)',
      shadowStrong: 'rgba(0, 0, 0, 0.6)',
    },
  },
  clean: {
    light: {
      bg: '#ffffff',
      surface: '#ffffff',
      surfaceAlt: '#f5f5f3',
      surfaceSunken: '#ececea',
      ink: '#1a1a1a',
      inkMuted: '#666666',
      inkSubtle: '#999999',
      primary: '#1f6b3a',
      primaryInk: '#0e3320',
      primarySoft: '#dceadf',
      onPrimary: '#ffffff',
      accent: '#1f6b3a',
      accentSoft: '#dceadf',
      onAccent: '#ffffff',
      danger: '#c43a1f',
      dangerSoft: '#f7dcd4',
      success: '#1f6b3a',
      warning: '#cc8800',
      info: '#2a5a8c',
      border: '#e5e5e3',
      borderStrong: '#cccccc',
      shadow: 'rgba(0, 0, 0, 0.06)',
      shadowStrong: 'rgba(0, 0, 0, 0.14)',
    },
    dark: {
      bg: '#0e0e0e',
      surface: '#1a1a1a',
      surfaceAlt: '#252525',
      surfaceSunken: '#080808',
      ink: '#f0f0f0',
      inkMuted: '#a0a0a0',
      inkSubtle: '#666666',
      primary: '#67b97e',
      primaryInk: '#d0eed8',
      primarySoft: '#1f3525',
      onPrimary: '#0e0e0e',
      accent: '#67b97e',
      accentSoft: '#1f3525',
      onAccent: '#0e0e0e',
      danger: '#e07a62',
      dangerSoft: '#3a1c14',
      success: '#67b97e',
      warning: '#e0b94a',
      info: '#8ba8d4',
      border: '#2a2a2a',
      borderStrong: '#444444',
      shadow: 'rgba(0, 0, 0, 0.4)',
      shadowStrong: 'rgba(0, 0, 0, 0.6)',
    },
  },
};

const RADIUS = { sm: 6, md: 10, lg: 14, xl: 20, pill: 999 };
const SPACE = { 1: 4, 2: 8, 3: 12, 4: 16, 5: 20, 6: 24, 7: 32, 8: 40, 9: 48, 10: 64 };
const FONT = {
  sans: '"Inter", system-ui, -apple-system, sans-serif',
  mono: '"JetBrains Mono", "SF Mono", Menlo, monospace',
};

// Resolve theme
function getTheme(themeName, dark) {
  const t = THEMES[themeName] || THEMES.earthy;
  return dark ? t.dark : t.light;
}

// Format FCFA — XAF / XOF style (no decimals, space as thousands)
function fcfa(amount, opts = {}) {
  const n = Math.round(amount || 0);
  const s = Math.abs(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
  const out = (n < 0 ? '−' : '') + s;
  return opts.bare ? out : out + ' FCFA';
}

Object.assign(window, { THEMES, RADIUS, SPACE, FONT, getTheme, fcfa });
