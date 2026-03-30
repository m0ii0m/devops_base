export const BONUSES = [
  // --- Bonus de Combo ---
  {
    id: 'combo_max_1',
    name: 'Folie du Combo',
    desc: '+5 au multiplicateur de combo maximum.',
    emoji: '🔥',
    cost: 5000,
    type: 'combo_max',
    value: 5.0
  },
  {
    id: 'combo_decay_1',
    name: 'Concentration intense',
    desc: 'Le combo descend 50% moins vite.',
    emoji: '🧘',
    cost: 15000,
    type: 'combo_decay',
    value: 0.5 // multiplicateur de réduction de la perte (0.5 = 50%)
  },
  {
    id: 'combo_growth_1',
    name: 'Frénésie',
    desc: 'La jauge de combo se remplit deux fois plus vite.',
    emoji: '⚡',
    cost: 50000,
    type: 'combo_growth',
    value: 2.0 // multiplicateur de remplissage (x2)
  },

  // --- Bonus de Clic ---
  {
    id: 'super_clic_1',
    name: 'Mains en or',
    desc: 'La puissance de base de vos clics est doublée.',
    emoji: '✨',
    cost: 25000,
    type: 'click_multiplier',
    value: 2.0
  },

  // --- Bonus de Zones (x2) ---
  {
    id: 'boost_zone',
    name: 'Urbanisme de pointe',
    desc: 'Les Zones Résidentielles rapportent 2x plus de population.',
    emoji: '🏘️',
    cost: 1000,
    type: 'zone_multiplier',
    target: 'zone',
    value: 2.0
  },
  {
    id: 'boost_usine',
    name: 'Révolution Industrielle',
    desc: 'Vos Usines rapportent 2x plus.',
    emoji: '⚙️',
    cost: 5000,
    type: 'zone_multiplier',
    target: 'usine',
    value: 2.0
  },
  {
    id: 'boost_banque',
    name: 'Capitalisme Sauvage',
    desc: 'Vos Banques rapportent 2x plus.',
    emoji: '📈',
    cost: 20000,
    type: 'zone_multiplier',
    target: 'banque',
    value: 2.0
  },
  {
    id: 'boost_centre_commercial',
    name: 'Hyper-consommation',
    desc: 'Vos Centres Commerciaux rapportent 2x plus.',
    emoji: '🛍️',
    cost: 100000,
    type: 'zone_multiplier',
    target: 'centre_commercial',
    value: 2.0
  },
  {
    id: 'boost_laboratoire',
    name: 'Découverte Majeure',
    desc: 'Vos Laboratoires rapportent 2x plus.',
    emoji: '🧬',
    cost: 500000,
    type: 'zone_multiplier',
    target: 'laboratoire',
    value: 2.0
  }
]
