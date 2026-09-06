class UsStates {
  UsStates._();

  static const Map<String, String> all = {
    'AL': 'Alabama',
    'AK': 'Alaska',
    'AZ': 'Arizona',
    'AR': 'Arkansas',
    'CA': 'California',
    'CO': 'Colorado',
    'CT': 'Connecticut',
    'DE': 'Delaware',
    'DC': 'District of Columbia',
    'FL': 'Florida',
    'GA': 'Georgia',
    'HI': 'Hawaii',
    'ID': 'Idaho',
    'IL': 'Illinois',
    'IN': 'Indiana',
    'IA': 'Iowa',
    'KS': 'Kansas',
    'KY': 'Kentucky',
    'LA': 'Louisiana',
    'ME': 'Maine',
    'MD': 'Maryland',
    'MA': 'Massachusetts',
    'MI': 'Michigan',
    'MN': 'Minnesota',
    'MS': 'Mississippi',
    'MO': 'Missouri',
    'MT': 'Montana',
    'NE': 'Nebraska',
    'NV': 'Nevada',
    'NH': 'New Hampshire',
    'NJ': 'New Jersey',
    'NM': 'New Mexico',
    'NY': 'New York',
    'NC': 'North Carolina',
    'ND': 'North Dakota',
    'OH': 'Ohio',
    'OK': 'Oklahoma',
    'OR': 'Oregon',
    'PA': 'Pennsylvania',
    'RI': 'Rhode Island',
    'SC': 'South Carolina',
    'SD': 'South Dakota',
    'TN': 'Tennessee',
    'TX': 'Texas',
    'UT': 'Utah',
    'VT': 'Vermont',
    'VA': 'Virginia',
    'WA': 'Washington',
    'WV': 'West Virginia',
    'WI': 'Wisconsin',
    'WY': 'Wyoming',
  };

  static String label(String code) {
    final name = all[code];
    return name == null ? code : '$code — $name';
  }

  static String? format({
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? fallback,
  }) {
    final streetParts = <String>[
      if ((line1 ?? '').trim().isNotEmpty) line1!.trim(),
      if ((line2 ?? '').trim().isNotEmpty) line2!.trim(),
    ];
    final cityPart = (city ?? '').trim();
    final statePart = (state ?? '').trim().toUpperCase();
    final zipPart = (postalCode ?? '').trim();
    String locality = cityPart;
    if (cityPart.isNotEmpty && statePart.isNotEmpty) {
      locality = '$cityPart, $statePart';
    } else if (statePart.isNotEmpty) {
      locality = statePart;
    }
    if (zipPart.isNotEmpty) {
      locality = locality.isEmpty ? zipPart : '$locality $zipPart';
    }
    final parts = <String>[
      if (streetParts.isNotEmpty) streetParts.join(', '),
      if (locality.isNotEmpty) locality,
    ];
    if (parts.isEmpty) {
      final fb = (fallback ?? '').trim();
      return fb.isEmpty ? null : fb;
    }
    return parts.join(', ');
  }
}
