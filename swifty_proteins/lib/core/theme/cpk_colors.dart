import 'package:flutter/material.dart';

// Useful saved standard CPK (Corey-Pauling-Koltun) color codes, 1 entry per chemical element symbol exactly as it will appear in the parsed .cif file (the "_chem_comp_atom.type_symbol" column)

class CpkColors {
  CpkColors._();

  static const Map<String, Color> _colors = {
    'H': Color(0xFFFFFFFF), // hydrogen = white
    'HE': Color(0xFFD9FFFF), // helium = pale cyan
    'LI': Color(0xFFCC80FF), // lithium = light violet
    'BE': Color(0xFFC2FF00), // beryllium = yellow-green
    'B': Color(0xFFFFB5B5), // boron = pale salmon
    'C': Color(0xFF909090), // carbon = gray
    'N': Color(0xFF3050F8), // nitrogen = blue
    'O': Color(0xFFFF0D0D), // oxygen = red
    'F': Color(0xFF90E050), // fluorine = yellow-green
    'NE': Color(0xFFB3E3F5), // neon = pale blue
    'NA': Color(0xFFAB5CF2), // sodium = purple
    'MG': Color(0xFF8AFF00), // magnesium = bright green
    'AL': Color(0xFFBFA6A6), // aluminum = pinkish gray
    'SI': Color(0xFFF0C8A0), // silicon = tan
    'P': Color(0xFFFF8000), // phosphorus = orange
    'S': Color(0xFFFFFF30), // sulfur = yellow
    'CL': Color(0xFF1FF01F), // chlorine = green
    'AR': Color(0xFF80D1E3), // argon = pale cyan
    'K': Color(0xFF8F40D4), // potassium = purple
    'CA': Color(0xFF3DFF00), // calcium = bright green
    'SC': Color(0xFFE6E6E6), // scandium = light gray
    'TI': Color(0xFFBFC2C7), // titanium = gray
    'V': Color(0xFFA6A6AB), // vanadium = gray
    'CR': Color(0xFF8A99C7), // chromium = steel blue
    'MN': Color(0xFF9C7AC7), // manganese = violet
    'FE': Color(0xFFE06633), // iron = rust orange
    'CO': Color(0xFFF090A0), // cobalt = pink
    'NI': Color(0xFF50D050), // nickel = green
    'CU': Color(0xFFC88033), // copper = bronze orange
    'ZN': Color(0xFF7D80B0), // zinc = slate purple
    'GA': Color(0xFFC28F8F), // gallium = dusty rose
    'GE': Color(0xFF668F8F), // germanium = teal gray
    'AS': Color(0xFFBD80E3), // arsenic = light purple
    'SE': Color(0xFFFFA100), // selenium = orange
    'BR': Color(0xFFA62929), // bromine = dark red
    'KR': Color(0xFF5CB8D1), // krypton = light blue
    'RB': Color(0xFF702EB0), // rubidium = dark violet
    'SR': Color(0xFF00FF00), // strontium = bright green
    'Y': Color(0xFF94FFFF), // yttrium = pale cyan
    'ZR': Color(0xFF94E0E0), // zirconium = pale turquoise
    'NB': Color(0xFF73C2C9), // niobium = teal
    'MO': Color(0xFF54B5B5), // molybdenum = teal
    'TC': Color(0xFF3B9E9E), // technetium = dark teal
    'RU': Color(0xFF248F8F), // ruthenium = dark teal
    'RH': Color(0xFF0A7D8C), // rhodium = dark cyan
    'PD': Color(0xFF006985), // palladium = dark blue-teal
    'AG': Color(0xFFC0C0C0), // silver = silver
    'CD': Color(0xFFFFD98F), // cadmium = pale gold
    'IN': Color(0xFFA67573), // indium = brownish pink
    'SN': Color(0xFF668080), // tin = slate gray
    'SB': Color(0xFF9E63B5), // antimony = purple magenta
    'TE': Color(0xFFD47A00), // tellurium = amber orange
    'I': Color(0xFF940094), // iodine = dark magenta
    'XE': Color(0xFF429EB0), // xenon = teal blue
    'CS': Color(0xFF57178F), // cesium = dark purple
    'BA': Color(0xFF00C900), // barium = green
    'LA': Color(0xFF70D4FF), // lanthanum = light blue
    'CE': Color(0xFFFFFFC7), // cerium = pale yellow
    'PR': Color(0xFFD9FFC7), // praseodymium = pale green
    'ND': Color(0xFFC7FFC7), // neodymium = pale green
    'PM': Color(0xFFA3FFC7), // promethium = pale green
    'SM': Color(0xFF8FFFC7), // samarium = pale mint
    'EU': Color(0xFF61FFC7), // europium = mint green
    'GD': Color(0xFF45FFC7), // gadolinium = mint green
    'TB': Color(0xFF30FFC7), // terbium = mint green
    'DY': Color(0xFF1FFFC7), // dysprosium = mint green
    'HO': Color(0xFF00FF9C), // holmium = green
    'ER': Color(0xFF00E675), // erbium = green
    'TM': Color(0xFF00D452), // thulium = green
    'YB': Color(0xFF00BF38), // ytterbium = green
    'LU': Color(0xFF00AB24), // lutetium = dark green
    'HF': Color(0xFF4DC2FF), // hafnium = light blue
    'TA': Color(0xFF4DA6FF), // tantalum = light blue
    'W': Color(0xFF2194D6), // tungsten = blue
    'RE': Color(0xFF267DAB), // rhenium = steel blue
    'OS': Color(0xFF266696), // osmium = dark blue
    'IR': Color(0xFF175487), // iridium = dark blue
    'PT': Color(0xFFD0D0E0), // platinum = pale lavender gray
    'AU': Color(0xFFFFD123), // gold = gold
    'HG': Color(0xFFB8B8D0), // mercury = pale lavender gray
    'TL': Color(0xFFA6544D), // thallium = brownish red
    'PB': Color(0xFF575961), // lead = dark slate gray
    'BI': Color(0xFF9E4FB5), // bismuth = purple magenta
    'PO': Color(0xFFAB5C00), // polonium = dark brown orange
    'AT': Color(0xFF754F45), // astatine = dark brown
    'RN': Color(0xFF428296), // radon = dark teal blue
    'FR': Color(0xFF420066), // francium = dark purple
    'RA': Color(0xFF007D00), // radium = dark green
    'AC': Color(0xFF70ABFA), // actinium = light blue
    'TH': Color(0xFF00BAFF), // thorium = light blue
    'PA': Color(0xFF00A1FF), // protactinium = blue
    'U': Color(0xFF008FFF), // uranium = blue
    'NP': Color(0xFF0080FF), // neptunium = blue
    'PU': Color(0xFF006BFF), // plutonium = blue
    'AM': Color(0xFF545CF2), // americium = blue violet
    'CM': Color(0xFF785CE3), // curium = violet
    'BK': Color(0xFF8A4FE3), // berkelium = violet
    'CF': Color(0xFFA136D4), // californium = purple magenta
    'ES': Color(0xFFB31FD4), // einsteinium = magenta
    'FM': Color(0xFFB31FBA), // fermium = magenta pink
    'MD': Color(0xFFB30DA6), // mendelevium = magenta pink
    'NO': Color(0xFFBD0D87), // nobelium = pink magenta
    'LR': Color(0xFFC70066), // lawrencium = dark pink
    'RF': Color(0xFFCC0059), // rutherfordium = dark pink red
    'DB': Color(0xFFD1004F), // dubnium = dark pink red
    'SG': Color(0xFFD90045), // seaborgium = red pink
    'BH': Color(0xFFE00038), // bohrium = red pink
    'HS': Color(0xFFE6002E), // hassium = red
    'MT': Color(0xFFEB0026), // meitnerium = red
  };

  static const Color fallback = Color(0xFFFF00FF); // obvious "missing"/error color = fuchsia

  static Color forElement(String symbol) {
    return _colors[symbol.toUpperCase()] ?? fallback;
  }
}
