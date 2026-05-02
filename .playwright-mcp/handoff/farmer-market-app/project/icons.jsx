// Lightweight inline SVG icons. 24x24 viewBox, currentColor stroke.

const Icon = ({ d, size = 24, fill = false, stroke = 2, ...rest }) => (
  <svg width={size} height={size} viewBox="0 0 24 24"
    fill={fill ? 'currentColor' : 'none'}
    stroke={fill ? 'none' : 'currentColor'}
    strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round" {...rest}>
    {typeof d === 'string' ? <path d={d} /> : d}
  </svg>
);

const Icons = {
  search: (p) => <Icon {...p} d="M11 4a7 7 0 100 14 7 7 0 000-14zm9 16l-4.35-4.35" />,
  back: (p) => <Icon {...p} d="M15 18l-6-6 6-6" />,
  forward: (p) => <Icon {...p} d="M9 18l6-6-6-6" />,
  close: (p) => <Icon {...p} d="M6 6l12 12M18 6L6 18" />,
  user: (p) => <Icon {...p} d={
    <>
      <circle cx="12" cy="8" r="4" />
      <path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" />
    </>
  } />,
  phone: (p) => <Icon {...p} d="M5 4h4l2 5-2.5 1.5a11 11 0 005 5L15 13l5 2v4a2 2 0 01-2 2A16 16 0 013 6a2 2 0 012-2z" />,
  plus: (p) => <Icon {...p} d="M12 5v14M5 12h14" />,
  minus: (p) => <Icon {...p} d="M5 12h14" />,
  cart: (p) => <Icon {...p} d={
    <>
      <path d="M3 4h2l2.5 12a2 2 0 002 1.5h8a2 2 0 002-1.5L21 7H6" />
      <circle cx="9" cy="20" r="1.5" fill="currentColor" stroke="none" />
      <circle cx="18" cy="20" r="1.5" fill="currentColor" stroke="none" />
    </>
  } />,
  check: (p) => <Icon {...p} d="M5 12l5 5L20 7" />,
  cash: (p) => <Icon {...p} d={
    <>
      <rect x="2" y="6" width="20" height="12" rx="2" />
      <circle cx="12" cy="12" r="2.5" />
      <path d="M5 9v.01M19 15v.01" />
    </>
  } />,
  credit: (p) => <Icon {...p} d={
    <>
      <rect x="2" y="5" width="20" height="14" rx="2" />
      <path d="M2 10h20M6 15h4" />
    </>
  } />,
  scale: (p) => <Icon {...p} d={
    <>
      <path d="M12 3v18M6 8h12" />
      <path d="M3 14l3-6 3 6a3 3 0 11-6 0zM15 14l3-6 3 6a3 3 0 11-6 0z" />
    </>
  } />,
  alert: (p) => <Icon {...p} d={
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 8v4M12 16v.01" />
    </>
  } />,
  chevR: (p) => <Icon {...p} d="M9 6l6 6-6 6" />,
  chevD: (p) => <Icon {...p} d="M6 9l6 6 6-6" />,
  chevU: (p) => <Icon {...p} d="M6 15l6-6 6 6" />,
  filter: (p) => <Icon {...p} d="M4 6h16M7 12h10M10 18h4" />,
  bag: (p) => <Icon {...p} d={
    <>
      <path d="M5 7h14l-1.5 13a2 2 0 01-2 2h-7a2 2 0 01-2-2L5 7z" />
      <path d="M9 7V5a3 3 0 116 0v2" />
    </>
  } />,
  history: (p) => <Icon {...p} d={
    <>
      <path d="M3 12a9 9 0 109-9 9 9 0 00-7 3.5L3 9" />
      <path d="M3 4v5h5M12 7v5l3 2" />
    </>
  } />,
  receipt: (p) => <Icon {...p} d={
    <>
      <path d="M5 3h14v18l-3-2-2 2-2-2-2 2-2-2-3 2V3z" />
      <path d="M8 8h8M8 12h8M8 16h5" />
    </>
  } />,
  leaf: (p) => <Icon {...p} d="M5 19c0-9 8-13 16-13 0 8-4 16-13 16-2 0-3-1-3-3zM5 19l8-8" />,
  pkg: (p) => <Icon {...p} d={
    <>
      <path d="M3 7l9-4 9 4v10l-9 4-9-4V7z" />
      <path d="M3 7l9 4 9-4M12 11v10" />
    </>
  } />,
  shield: (p) => <Icon {...p} d="M12 3l8 3v6c0 5-3.5 8.5-8 9-4.5-.5-8-4-8-9V6l8-3z" />,
  drop: (p) => <Icon {...p} d="M12 3s7 7.5 7 12a7 7 0 01-14 0c0-4.5 7-12 7-12z" />,
  seed: (p) => <Icon {...p} d={
    <>
      <ellipse cx="12" cy="12" rx="5" ry="9" />
      <path d="M12 3v18" />
    </>
  } />,
  tools: (p) => <Icon {...p} d="M14.7 6.3a4 4 0 00-5.4 5.4L3 18l3 3 6.3-6.3a4 4 0 005.4-5.4l-2.5 2.5-2.5-2.5 2.5-2.5z" />,
  trash: (p) => <Icon {...p} d={
    <>
      <path d="M3 6h18M8 6V4a2 2 0 012-2h4a2 2 0 012 2v2" />
      <path d="M5 6l1 14a2 2 0 002 2h8a2 2 0 002-2l1-14" />
    </>
  } />,
  qr: (p) => <Icon {...p} d={
    <>
      <rect x="3" y="3" width="7" height="7" />
      <rect x="14" y="3" width="7" height="7" />
      <rect x="3" y="14" width="7" height="7" />
      <path d="M14 14h3v3h-3zM18 18h3v3h-3z" />
    </>
  } />,
  more: (p) => <Icon {...p} d="M5 12h.01M12 12h.01M19 12h.01" stroke={3} />,
  logout: (p) => <Icon {...p} d="M16 17l5-5-5-5M21 12H9M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4" />,
  sun: (p) => <Icon {...p} d={
    <>
      <circle cx="12" cy="12" r="4" />
      <path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" />
    </>
  } />,
  moon: (p) => <Icon {...p} d="M21 13a9 9 0 11-10-10 7 7 0 0010 10z" />,
  home: (p) => <Icon {...p} d="M3 11l9-7 9 7v9a2 2 0 01-2 2h-4v-7H9v7H5a2 2 0 01-2-2v-9z" />,
  eye: (p) => <Icon {...p} d={
    <>
      <path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7-10-7-10-7z" />
      <circle cx="12" cy="12" r="3" />
    </>
  } />,
  eyeOff: (p) => <Icon {...p} d="M3 3l18 18M10.6 6.1A10 10 0 0112 6c6 0 10 7 10 7a18 18 0 01-3.5 4.3M6.6 6.6A18 18 0 002 12s4 7 10 7a10 10 0 003.4-.6M9.9 9.9a3 3 0 004.2 4.2" />,
  arrowDown: (p) => <Icon {...p} d="M12 5v14M5 12l7 7 7-7" />,
  arrowUp: (p) => <Icon {...p} d="M12 19V5M5 12l7-7 7 7" />,
};

Object.assign(window, { Icon, Icons });
