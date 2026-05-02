// AgriPOS — sample data

const FARMERS = [
  { id: 'CIV-2148', name: 'Kouamé Yao', phone: '+225 07 12 34 56 78', village: 'Daloa', debt: 142500, credit: 250000, lastSeen: '2 days ago', recent: true },
  { id: 'CIV-3082', name: 'Aminata Traoré', phone: '+225 05 88 21 09 14', village: 'Bouaké', debt: 0, credit: 200000, lastSeen: '1 week ago' },
  { id: 'CIV-1957', name: 'Yves N\u2019Guessan', phone: '+225 01 44 76 88 02', village: 'San-Pédro', debt: 67800, credit: 150000, lastSeen: '3 days ago', recent: true },
  { id: 'CIV-4421', name: 'Awa Diallo', phone: '+225 07 32 18 90 55', village: 'Korhogo', debt: 318200, credit: 350000, lastSeen: 'Today' },
  { id: 'CIV-2867', name: 'Ibrahim Bamba', phone: '+225 05 67 45 23 11', village: 'Man', debt: 24000, credit: 100000, lastSeen: '5 days ago' },
  { id: 'CIV-5103', name: 'Fatou Koné', phone: '+225 01 78 92 04 37', village: 'Yamoussoukro', debt: 0, credit: 200000, lastSeen: '2 weeks ago' },
  { id: 'CIV-3344', name: 'Sékou Cissé', phone: '+225 07 09 81 22 64', village: 'Abengourou', debt: 88400, credit: 180000, lastSeen: 'Yesterday', recent: true },
];

const CATEGORIES = [
  { id: 'fert', name: 'Fertilizer', icon: 'leaf', count: 24, sub: [
    { id: 'fert-npk', name: 'NPK Compounds', count: 9 },
    { id: 'fert-urea', name: 'Urea & Nitrogen', count: 6 },
    { id: 'fert-org', name: 'Organic & Compost', count: 5 },
    { id: 'fert-foliar', name: 'Foliar feeds', count: 4 },
  ]},
  { id: 'crop', name: 'Crop Protection', icon: 'shield', count: 31, sub: [
    { id: 'crop-herb', name: 'Herbicides', count: 12 },
    { id: 'crop-fung', name: 'Fungicides', count: 8 },
    { id: 'crop-ins', name: 'Insecticides', count: 11 },
  ]},
  { id: 'seed', name: 'Seeds & Seedlings', icon: 'seed', count: 18 },
  { id: 'tool', name: 'Tools & Equipment', icon: 'tools', count: 14 },
  { id: 'ppe', name: 'PPE & Safety', icon: 'shield', count: 9 },
  { id: 'irr', name: 'Irrigation', icon: 'drop', count: 7 },
];

const NPK_PRODUCTS = [
  { id: 'p1', name: 'NPK 15-15-15', size: '50 kg sack', price: 28500, stock: 'In stock', popular: true },
  { id: 'p2', name: 'NPK 12-24-18 Cocoa Mix', size: '50 kg sack', price: 32000, stock: 'In stock', popular: true },
  { id: 'p3', name: 'NPK 17-17-17', size: '50 kg sack', price: 30500, stock: 'Low stock' },
  { id: 'p4', name: 'NPK 10-20-20', size: '25 kg sack', price: 17800, stock: 'In stock' },
  { id: 'p5', name: 'NPK 20-10-10', size: '50 kg sack', price: 27800, stock: 'In stock' },
  { id: 'p6', name: 'NPK 14-23-14', size: '50 kg sack', price: 31200, stock: 'In stock' },
];

const CART = [
  { id: 'p2', name: 'NPK 12-24-18 Cocoa Mix', size: '50 kg sack', qty: 4, unit: 32000 },
  { id: 'h1', name: 'Glyphosate 480 SL', size: '5 L jerrycan', qty: 2, unit: 14500 },
  { id: 's1', name: 'Hybrid Maize Seed F1', size: '10 kg bag', qty: 1, unit: 18800 },
];

const COMMODITIES = [
  { id: 'cocoa', name: 'Cocoa beans', grade: 'Grade I', rate: 1650, unit: 'kg' },
  { id: 'cashew', name: 'Raw cashew nuts', grade: 'Grade A', rate: 925, unit: 'kg' },
  { id: 'coffee', name: 'Robusta coffee', grade: 'Standard', rate: 1100, unit: 'kg' },
  { id: 'rubber', name: 'Natural rubber', grade: 'Cup lump', rate: 480, unit: 'kg' },
];

const DEBT_DETAIL = {
  total: 318200,
  limit: 350000,
  orders: [
    { id: 'ORD-8842', date: 'Apr 24, 2026', items: 'NPK 15-15-15 ×6, Urea ×2', total: 198400 },
    { id: 'ORD-8721', date: 'Apr 09, 2026', items: 'Glyphosate ×4, Sprayer ×1', total: 76800 },
    { id: 'ORD-8503', date: 'Mar 18, 2026', items: 'Hybrid Maize Seed ×3', total: 43000 },
  ],
  payments: [
    { date: 'Apr 14, 2026', kind: 'Cocoa beans · 22 kg', amount: 36300 },
    { date: 'Mar 30, 2026', kind: 'Cash', amount: 50000 },
  ],
};

Object.assign(window, { FARMERS, CATEGORIES, NPK_PRODUCTS, CART, COMMODITIES, DEBT_DETAIL });
