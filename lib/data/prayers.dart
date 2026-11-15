class PrayerSection {
  const PrayerSection({
    required this.title,
    required this.shortTitle,
    required this.lines,
  });

  final String title;
  final String shortTitle;
  final List<String> lines;
}

const prayerSections = <PrayerSection>[
  PrayerSection(
    title: 'አቡነ ዘበሰማያት በግዕዝ',
    shortTitle: 'Abune',
    lines: [
      'በስመ አብ ወወልድ ወመንፈስ ቅዱስ አሐዱ አምላክ አሜን',
      'አቡነ ዘበሰማያት ይትቀደስ ስምከ',
      'ትምፃእ መንግሥትከ ፣ ወይኩን ፈቃድከ',
      'በከመ በሰማይ ፣ ከማሁ በምድር',
      'ሲሳየነ ፣ ዘለለ ዕለትነ ፣ ሃበነ ዮም',
      'ኅድግ ለነ ፣ አበሳነ ወጌጋየነ',
      'ከመ ንሕነኒ ንኅድግ ለዘአበሰ ለነ',
      'ኢታብአነ እግዚኦ ውስተ መንሱት',
      'ኣላ አድኅነነ ወባልሐነ ፣ እምኩሉ እኩይ',
      'እስመ ዚኣከ ፣ ይእቲ መንግሥት',
      'ኃይል ወስብሐት ፣ ለዓለመ ዓለም ፣ አሜን',
    ],
  ),
  PrayerSection(
    title: 'በሰላም ቅዱስ ገብርኤል መልአክ',
    shortTitle: 'St Gabriel',
    lines: [
      'በሰላመ ቅዱስ ገብርኤል መልአክ',
      'ኦ እግዝእትየ ማርያም ሰላም ለኪ',
      'ድንግል በኅሊናኪ ፣ ወድንግል በሥጋኪ',
      'እመ እግዚአብሔር ጸባዖት ሰላም ለኪ',
      'ቡርክት አንቲ እምአንስት',
      'ወቡሩክ ፍሬ ከርሥኪ',
      'ተፈሥሒ ፍሥሕት ኦ ምልእተ ጸጋ',
      'እግዚአብሔር ምስሌኪ ፣ ሰአሊ ወጸልዪ',
      'ምሕረት በእንቲኣነ ፣ ኀበ ፍቁር ወልድኪ',
      'ኢየሱስ ክርስቶስ ፣ ከመ ይሥረይ ለነ ኃጣውኢነ',
    ],
  ),
];
