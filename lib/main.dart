import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const GundamStreamApp());
}

// -----------------------------------------------------------------------------
// 1. Core Application & Theme
// -----------------------------------------------------------------------------
class GundamStreamApp extends StatelessWidget {
  const GundamStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gundam+ Streaming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE50914),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          secondary: Color(0xFFF9A825),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. Data Models
// -----------------------------------------------------------------------------
class Episode {
  final int number;
  final String title;
  final String duration;
  final String thumbnailUrl;
  final String synopsis;

  Episode({
    required this.number,
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.synopsis,
  });

  String get id => 'ep_$number';
}

class GundamSeries {
  final String id;
  final String title;
  final String year;
  final String rating;
  final List<String> tags;
  final String synopsis;
  final String posterUrl;
  final String bannerUrl;
  final List<Character> characters;
  final List<Mecha> mechas;
  final List<Episode> episodes;
  final Color themeColor;

  GundamSeries({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.tags,
    required this.synopsis,
    required this.posterUrl,
    required this.bannerUrl,
    required this.characters,
    required this.mechas,
    required this.episodes,
    required this.themeColor,
  });
}

class Character {
  final String name;
  final String role;
  final String avatarUrl;
  Character(this.name, this.role, this.avatarUrl);
}

class Mecha {
  final String name;
  final String model;
  final String mechaUrl;
  Mecha(this.name, this.model, this.mechaUrl);
}

class DownloadedVideo {
  final GundamSeries series;
  final Episode episode;
  final String fileSize;

  DownloadedVideo({
    required this.series,
    required this.episode,
    this.fileSize = '245 MB',
  });
}

List<Episode> generate30Episodes(String seriesTitle, String baseImageUrl) {
  return List.generate(30, (index) {
    final epNum = index + 1;
    return Episode(
      number: epNum,
      title: 'ตอนที่ $epNum: การเผชิญหน้าในอวกาศ พาร์ท $epNum',
      duration: '24:15',
      thumbnailUrl: baseImageUrl,
      synopsis: 'เรื่องราวเข้มข้นในตอนที่ $epNum ของภารกิจสำคัญในสมรภูมิอวกาศอันดุเดือด เหล่านักบินต้องเผชิญหน้ากับศัตรูที่ไม่คาดคิด...',
    );
  });
}

final List<GundamSeries> mockGundamData = [
  GundamSeries(
    id: 'gundam_uc',
    title: 'Mobile Suit Gundam Unicorn',
    year: '2010',
    rating: '13+',
    tags: ['Universal Century', 'Action', 'Sci-Fi'],
    posterUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRYw05bgh5bVFe9wizgW2TOYu21EsZI90ssg94hSXlCEJ9ETldfXxABYgm&s=10',
    bannerUrl: 'https://m.media-amazon.com/images/M/MV5BMTM4NjA0YzgtMjM4YS00NzQ4LWJjNmEtOWY4ZGRkNjM1N2VkXkEyXkFqcGc@._V1_.jpg',
    themeColor: Colors.redAccent,
    synopsis: 'ในปี U.C. 0096 กล่องของลาพลาซ (Laplace\'s Box) ที่เก็บซ่อนความลับของจุดกำเนิดศักราชอวกาศกำลังจะถูกเปิดเผย บานาจ ลิงก์ เด็กหนุ่มที่ถูกดึงเข้ามาพัวพันกับสงคราม...',
    characters: [
      Character('Banagher Links', 'Main Pilot (Unicorn)', 'https://gundam-official.com/media/UC_7ad8df6a05/UC_7ad8df6a05.png'),
      Character('Audrey Burne', 'Princess of Zeon', 'https://gundam-official.com/media/UC_39ce6efd8b/UC_39ce6efd8b.png'),
    ],
    mechas: [
      Mecha('RX-0 Unicorn Gundam', 'Destroy Mode / NT-D', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN6Gd9hex2shK0Y2Fhk7DYBtIyhAgsNvOT-eLU7QA-QQ&s=10'),
    ],
    episodes: generate30Episodes('Unicorn', 'https://static.wikia.nocookie.net/gundam/images/5/56/Gundam_UC_Episode_3_%27The_Ghost_of_Laplace%27_Posters.jpg/revision/latest/scale-to-width-down/1000?cb=20110317030444'),
  ),
  GundamSeries(
    id: 'gundam_ibo',
    title: 'Gundam: Iron-Blooded Orphans',
    year: '2015',
    rating: '16+',
    tags: ['Alternate Universe', 'Dark', 'Drama'],
    posterUrl: 'https://thumb.wikimedia.org/wikipedia/en/thumb/7/78/MobileSuitGundamIronBloodedOrphansPoster.jpg/250px-MobileSuitGundamIronBloodedOrphansPoster.jpg?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail',
    bannerUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEEUmOvhG2qLG1vILBFtBv5f2pQNgQR6_KIqjqZih5qg&s=10',
    themeColor: Colors.orangeAccent,
    synopsis: 'เรื่องราวของกลุ่มทหารรับจ้างเด็ก Tekkadan ในยุค Post Disaster ที่ต้องต่อสู้เพื่อเอาชีวิตรอดและค้นหาอิสรภาพ...',
    characters: [
      Character('Mikazuki Augus', 'Ace Pilot (Barbatos)', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkms8WVHImW1APTXTd3UB2w0YfgX0sV3hP-3THgnUU0w&s=10'),
    ],
    mechas: [
      Mecha('ASW-G-08 Barbatos', 'Lupus Rex Form', 'https://m.media-amazon.com/images/I/51HnH4FapCL._AC_SX569_.jpg'),
    ],
    episodes: generate30Episodes('Iron-Blooded Orphans', 'https://static.wikia.nocookie.net/gundam/images/3/3f/Mikazuki_Augus.png/revision/latest?cb=20210820145722'),
  ),
  GundamSeries(
    id: 'gundam_wfm',
    title: 'The Witch from Mercury',
    year: '2022',
    rating: '13+',
    tags: ['Academy', 'Mecha', 'New Release'],
    posterUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSsFZRKQuiqR_SI_8_1A7CqxtPj7y43uL1_ryuhfuD1w&s=10',
    bannerUrl: 'https://m.media-amazon.com/images/M/MV5BZGEwNDRlNGMtNGE4NC00YjYzLThjZjUtZWVmZmYzYWU2OTAyXkEyXkFqcGc@._V1_.jpg',
    themeColor: Colors.deepPurpleAccent,
    synopsis: 'ซูเล็ตต้า เมอร์คิวรี เด็กสาวจากดาวพุธได้ย้ายเข้ามาเรียนในโรงเรียนเทคโนโลยีแอสติคาสเชีย เธอได้พบกับมิโอริเน่...',
    characters: [
      Character('Suletta Mercury', 'Pilot of Aerial', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQribeUHH85g36FsZAoHxVcSSH-QMv6REuWmJG8484APg&s=10'),
    ],
    mechas: [
      Mecha('XVX-016 Gundam Aerial', 'Gund-Format MS', 'https://en.gundam-official.com/witch-from-mercury/gwitch/jp/mechanical/2022/07/01_front_2.png'),
    ],
    episodes: generate30Episodes('The Witch from Mercury', 'https://mechaalliance.com/wp-content/uploads/2022/10/image_2022-10-04_214846108.jpg'),
  ),
  GundamSeries(
    id: 'gundam_seed',
    title: 'Mobile Suit Gundam SEED',
    year: '2002',
    rating: '13+',
    tags: ['Cosmic Era', 'Romance', 'Classic'],
    posterUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxvWvreM5wA-HIQtC8Yxz8SK3GV9R8FN4meQvxUcRHiA&s=10',
    bannerUrl: 'https://m.media-amazon.com/images/M/MV5BM2NjODMxNWQtNWRhOC00NGU4LTlmZDUtNWViYzAyNjM2ZTM2XkEyXkFqcGc@._V1_.jpg',
    themeColor: Colors.blueAccent,
    synopsis: 'ความขัดแย้งระหว่างมนุษย์ธรรมดา (Naturals) และมนุษย์ดัดแปลงพันธุกรรม (Coordinators) คิระ ยามาโตะ ต้องเข้าควบคุม Strike Gundam...',
    characters: [
      Character('Kira Yamato', 'Pilot of Strike Gundam', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgl9mNeHJVUJD10MZGA9Tc4KusHqWDrFt_f2TEL4xU5A&s=10'),
    ],
    mechas: [
      Mecha('GAT-X105 Strike Gundam', 'All-Rounder MS', 'https://en.gundam-official.com/seed/seed/img/mecha/mecha1_2.png'),
    ],
    episodes: generate30Episodes('Gundam SEED', 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500'),
  ),
];

// -----------------------------------------------------------------------------
// 3. Navigation & App State Management
// -----------------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final Set<String> _favoriteIds = {'gundam_uc'};
  
  String _selectedQuality = '1080p (Full HD)';
  String _selectedSubtitle = 'TH (ภาษาไทย)';
  
  final List<DownloadedVideo> _downloadedList = [
    DownloadedVideo(
      series: mockGundamData[0],
      episode: mockGundamData[0].episodes[0],
    ),
  ];

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
        _showSnackBar('ลบออกจากรายการโปรดแล้ว');
      } else {
        _favoriteIds.add(id);
        _showSnackBar('เพิ่มไปยังรายการโปรดเรียบร้อย');
      }
    });
  }

  void _toggleDownload(GundamSeries series, Episode ep) {
    setState(() {
      int idx = _downloadedList.indexWhere((item) => item.series.id == series.id && item.episode.number == ep.number);
      if (idx >= 0) {
        _downloadedList.removeAt(idx);
        _showSnackBar('ลบวิดีโอออกจากไฟล์ดาวน์โหลดแล้ว');
      } else {
        _downloadedList.add(DownloadedVideo(series: series, episode: ep));
        _showSnackBar('ดาวน์โหลดสำเร็จ! เก็บไว้ในออฟไลน์แล้ว');
      }
    });
  }

  bool _isDownloaded(String seriesId, int epNum) {
    return _downloadedList.any((item) => item.series.id == seriesId && item.episode.number == epNum);
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        isDownloaded: _isDownloaded,
        onToggleDownload: _toggleDownload,
      ),
      SearchScreen(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        isDownloaded: _isDownloaded,
        onToggleDownload: _toggleDownload,
      ),
      MyListScreen(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        isDownloaded: _isDownloaded,
        onToggleDownload: _toggleDownload,
      ),
      ProfileScreen(
        selectedQuality: _selectedQuality,
        selectedSubtitle: _selectedSubtitle,
        downloadedList: _downloadedList,
        onUpdateQuality: (val) => setState(() => _selectedQuality = val),
        onUpdateSubtitle: (val) => setState(() => _selectedSubtitle = val),
        onRemoveDownload: (video) {
          setState(() {
            _downloadedList.remove(video);
            _showSnackBar('ลบวิดีโอออกเรียบร้อยแล้ว');
          });
        },
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'หน้าแรก'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'ค้นหา'),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${_favoriteIds.length}'),
              isLabelVisible: _favoriteIds.isNotEmpty,
              child: const Icon(Icons.video_library_outlined),
            ),
            activeIcon: const Icon(Icons.video_library),
            label: 'รายการโปรด',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. Home Screen & Interactive Banner
// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final Set<String> favoriteIds;
  final Function(String) onToggleFavorite;
  final bool Function(String, int) isDownloaded;
  final Function(GundamSeries, Episode) onToggleDownload;

  const HomeScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.isDownloaded,
    required this.onToggleDownload,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: BannerCarousel(
            items: mockGundamData,
            favoriteIds: favoriteIds,
            onToggleFavorite: onToggleFavorite,
            isDownloaded: isDownloaded,
            onToggleDownload: onToggleDownload,
          ),
        ),
        _buildSectionTitle('🔥 มาแรงติดเทรนด์วันนี้'),
        _buildHorizontalPosterList(context, mockGundamData),
        _buildSectionTitle('🌌 ศักราชอวกาศ Universal Century (UC)'),
        _buildHorizontalPosterList(context, mockGundamData.where((e) => e.tags.contains('Universal Century')).toList()),
        _buildSectionTitle('⚔️ โลกขนาน Alternate Universes'),
        _buildHorizontalPosterList(context, mockGundamData.where((e) => e.tags.contains('Alternate Universe') || e.tags.contains('Cosmic Era')).toList()),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 12.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildHorizontalPosterList(BuildContext context, List<GundamSeries> items) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isFav = favoriteIds.contains(item.id);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeDetailScreen(
                      series: item,
                      favoriteIds: favoriteIds,
                      onToggleFavorite: onToggleFavorite,
                      isDownloaded: isDownloaded,
                      onToggleDownload: onToggleDownload,
                    ),
                  ),
                );
              },
              child: Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Stack(
                  children: [
                    Hero(
                      tag: 'poster_${item.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: NetworkImageWithFallback(
                          url: item.posterUrl,
                          width: 120,
                          height: 180,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: const LinearGradient(
                          colors: [Colors.black54, Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => onToggleFavorite(item.id),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            isFav ? Icons.check : Icons.add,
                            size: 16,
                            color: isFav ? Colors.greenAccent : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. Banner Carousel Widget
// -----------------------------------------------------------------------------
class BannerCarousel extends StatefulWidget {
  final List<GundamSeries> items;
  final Set<String> favoriteIds;
  final Function(String) onToggleFavorite;
  final bool Function(String, int) isDownloaded;
  final Function(GundamSeries, Episode) onToggleDownload;

  const BannerCarousel({
    super.key,
    required this.items,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.isDownloaded,
    required this.onToggleDownload,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % widget.items.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _goToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _startTimer();
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final isFav = widget.favoriteIds.contains(item.id);

              return Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageWithFallback(url: item.bannerUrl),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                          Color(0xFF121212),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        Text(
                          item.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: item.tags
                              .map((tag) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(tag, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              icon: isFav ? Icons.check : Icons.add,
                              label: 'My List',
                              onTap: () => widget.onToggleFavorite(item.id),
                            ),
                            const SizedBox(width: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                      series: item,
                                      episode: item.episodes[0],
                                      isDownloaded: widget.isDownloaded,
                                      onToggleDownload: widget.onToggleDownload,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
                              label: const Text('เล่น', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              ),
                            ),
                            const SizedBox(width: 24),
                            _buildActionButton(
                              icon: Icons.info_outline,
                              label: 'รายละเอียด',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnimeDetailScreen(
                                      series: item,
                                      favoriteIds: widget.favoriteIds,
                                      onToggleFavorite: widget.onToggleFavorite,
                                      isDownloaded: widget.isDownloaded,
                                      onToggleDownload: widget.onToggleDownload,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            left: 8,
            top: 200,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  int prevPage = (_currentPage - 1 + widget.items.length) % widget.items.length;
                  _goToPage(prevPage);
                },
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 200,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  int nextPage = (_currentPage + 1) % widget.items.length;
                  _goToPage(nextPage);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.items.length,
                (index) => InkWell(
                  onTap: () => _goToPage(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentPage == index ? Theme.of(context).primaryColor : Colors.black54,
                      border: Border.all(color: Colors.white30, width: 1),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _currentPage == index ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6. Search Screen
// -----------------------------------------------------------------------------
class SearchScreen extends StatefulWidget {
  final Set<String> favoriteIds;
  final Function(String) onToggleFavorite;
  final bool Function(String, int) isDownloaded;
  final Function(GundamSeries, Episode) onToggleDownload;

  const SearchScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.isDownloaded,
    required this.onToggleDownload,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filteredList = mockGundamData.where((item) {
      final q = _searchQuery.toLowerCase();
      final titleMatch = item.title.toLowerCase().contains(q);
      final tagMatch = item.tags.any((t) => t.toLowerCase().contains(q));
      return titleMatch || tagMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'ค้นหาชื่อภาค หรือหมวดหมู่...',
            hintStyle: const TextStyle(color: Colors.white38),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white54),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final item = filteredList[index];
          final isFav = widget.favoriteIds.contains(item.id);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailScreen(
                    series: item,
                    favoriteIds: widget.favoriteIds,
                    onToggleFavorite: widget.onToggleFavorite,
                    isDownloaded: widget.isDownloaded,
                    onToggleDownload: widget.onToggleDownload,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: NetworkImageWithFallback(url: item.posterUrl),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: IconButton(
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                            onPressed: () => widget.onToggleFavorite(item.id),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 7. My List Screen
// -----------------------------------------------------------------------------
class MyListScreen extends StatelessWidget {
  final Set<String> favoriteIds;
  final Function(String) onToggleFavorite;
  final bool Function(String, int) isDownloaded;
  final Function(GundamSeries, Episode) onToggleDownload;

  const MyListScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.isDownloaded,
    required this.onToggleDownload,
  });

  @override
  Widget build(BuildContext context) {
    final favList = mockGundamData.where((item) => favoriteIds.contains(item.id)).toList();

    return Scaffold(
      appBar: AppBar(title: Text('รายการโปรดของฉัน (${favList.length})')),
      body: favList.isEmpty
          ? const Center(child: Text('ยังไม่มีอนิเมะในรายการโปรด', style: TextStyle(color: Colors.white54)))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: favList.length,
              itemBuilder: (context, index) {
                final item = favList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimeDetailScreen(
                          series: item,
                          favoriteIds: favoriteIds,
                          onToggleFavorite: onToggleFavorite,
                          isDownloaded: isDownloaded,
                          onToggleDownload: onToggleDownload,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: NetworkImageWithFallback(url: item.posterUrl),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onToggleFavorite(item.id),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black87,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// -----------------------------------------------------------------------------
// 8. Profile Screen & Detailed Account Settings Pages
// -----------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  final String selectedQuality;
  final String selectedSubtitle;
  final List<DownloadedVideo> downloadedList;
  final ValueChanged<String> onUpdateQuality;
  final ValueChanged<String> onUpdateSubtitle;
  final ValueChanged<DownloadedVideo> onRemoveDownload;

  const ProfileScreen({
    super.key,
    required this.selectedQuality,
    required this.selectedSubtitle,
    required this.downloadedList,
    required this.onUpdateQuality,
    required this.onUpdateSubtitle,
    required this.onRemoveDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์และสถิติผู้ใช้', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C2C2C), Color(0xFF1E1E1E)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1.5),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Amuro Ray (Pilot #007)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('สถานะ: Gundam+ VIP Ultra Gold', style: TextStyle(color: Colors.amber[400], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('การตั้งค่าบัญชีและการรับชม', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            icon: Icons.hd,
            title: 'คุณภาพการสตรีมมิง',
            subtitle: selectedQuality,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StreamingQualityScreen(
                    currentQuality: selectedQuality,
                    onSelected: onUpdateQuality,
                  ),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.download_for_offline,
            title: 'การดาวน์โหลดและออฟไลน์',
            subtitle: 'มีวิดีโอที่ดาวน์โหลดไว้ ${downloadedList.length} รายการ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DownloadsScreen(
                    downloadedList: downloadedList,
                    onRemoveDownload: onRemoveDownload,
                  ),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.subtitles,
            title: 'คำบรรยายภาษาและพากย์',
            subtitle: selectedSubtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubtitleSettingScreen(
                    currentSubtitle: selectedSubtitle,
                    onSelected: onUpdateSubtitle,
                  ),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: 'ศูนย์ช่วยเหลือและแจ้งปัญหา',
            subtitle: 'คำแนะนำเบื้องต้น & อีเมลติดต่อ 6714421010@rbru.ac.th',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpCenterScreen(),
                ),
              );
            },
          ),
          const Divider(color: Colors.white24, height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('ออกจากระบบ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.2),
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white30),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

class StreamingQualityScreen extends StatefulWidget {
  final String currentQuality;
  final ValueChanged<String> onSelected;

  const StreamingQualityScreen({
    super.key,
    required this.currentQuality,
    required this.onSelected,
  });

  @override
  State<StreamingQualityScreen> createState() => _StreamingQualityScreenState();
}

class _StreamingQualityScreenState extends State<StreamingQualityScreen> {
  late String _selected;

  final List<Map<String, String>> qualities = [
    {'title': '4K (Ultra HD)', 'desc': 'ความคมชัดสูงสุด สำหรับหน้าจอขนาดใหญ่ (ใช้เน็ตมากที่สุด)'},
    {'title': '1080p (Full HD)', 'desc': 'ความคมชัดมาตรฐานระดับสูง แนะนำสำหรับการรับชมทั่วไป'},
    {'title': '720p (HD)', 'desc': 'ความคมชัดระดับปานกลาง ประหยัดข้อมูลเน็ต'},
    {'title': '480p (SD)', 'desc': 'ความคมชัดระดับเริ่มต้น สำหรับเน็ตความเร็วต่ำ'},
    {'title': '360p (ประหยัดเน็ต)', 'desc': 'โหมดประหยัดอินเทอร์เน็ตสูงสุด'},
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentQuality;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('คุณภาพการสตรีมมิง')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: qualities.length,
        itemBuilder: (context, index) {
          final item = qualities[index];
          final title = item['title']!;
          final desc = item['desc']!;

          return RadioListTile<String>(
            activeColor: Theme.of(context).primaryColor,
            value: title,
            groupValue: _selected,
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selected = val);
                widget.onSelected(val);
              }
            },
          );
        },
      ),
    );
  }
}

class DownloadsScreen extends StatelessWidget {
  final List<DownloadedVideo> downloadedList;
  final ValueChanged<DownloadedVideo> onRemoveDownload;

  const DownloadsScreen({
    super.key,
    required this.downloadedList,
    required this.onRemoveDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('วิดีโอออฟไลน์ (${downloadedList.length})')),
      body: downloadedList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.download_for_offline, size: 80, color: Colors.white24),
                  SizedBox(height: 16),
                  Text('ยังไม่มีวิดีโอที่ดาวน์โหลดไว้', style: TextStyle(color: Colors.white54)),
                  SizedBox(height: 8),
                  Text('กดปุ่มดาวน์โหลดที่ตัวเล่นวิดีโอหรือหน้าเลือกตอนเพื่อดูออฟไลน์', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: downloadedList.length,
              itemBuilder: (context, index) {
                final item = downloadedList[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: NetworkImageWithFallback(
                        url: item.episode.thumbnailUrl,
                        width: 80,
                        height: 50,
                      ),
                    ),
                    title: Text(item.series.title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.episode.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('ขนาดไฟล์: ${item.fileSize} • พร้อมดูออฟไลน์', style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => onRemoveDownload(item),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class SubtitleSettingScreen extends StatefulWidget {
  final String currentSubtitle;
  final ValueChanged<String> onSelected;

  const SubtitleSettingScreen({
    super.key,
    required this.currentSubtitle,
    required this.onSelected,
  });

  @override
  State<SubtitleSettingScreen> createState() => _SubtitleSettingScreenState();
}

class _SubtitleSettingScreenState extends State<SubtitleSettingScreen> {
  late String _selected;

  final List<Map<String, String>> options = [
    {'code': 'TH (ภาษาไทย)', 'label': 'ภาษาไทย (Thai Subtitles / Audio)'},
    {'code': 'JP (日本語)', 'label': 'ภาษาญี่ปุ่น (Original Japanese Audio)'},
    {'code': 'EN (English)', 'label': 'English (English Subtitles)'},
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentSubtitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตั้งค่าคำบรรยายและพากย์')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final code = options[index]['code']!;
          final label = options[index]['label']!;

          return RadioListTile<String>(
            activeColor: Theme.of(context).primaryColor,
            value: code,
            groupValue: _selected,
            title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selected = val);
                widget.onSelected(val);
              }
            },
          );
        },
      ),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});
  final String contactEmail = '6714421010@rbru.ac.th';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ศูนย์ช่วยเหลือและรายงานปัญหา')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.mark_email_unread_outlined, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('อีเมลสำหรับแจ้งปัญหาและรายงานข้อผิดพลาด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  contactEmail,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                ),
                const SizedBox(height: 4),
                const Text('สามารถส่งข้อความ รายงานบั๊ก หรือสอบถามเรื่องบัญชีผู้ใช้ได้ตลอด 24 ชั่วโมง', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('คำแนะนำการแก้ปัญหาเบื้องต้น (FAQ)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildFaqItem('วิดีโอไม่เล่น หรือขึ้นโหลดค้างทำอย่างไร?', 'ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต หรือลองเปลี่ยนสลับความละเอียดวิดีโอเป็น 720p หรือ 480p ในหน้าโปรไฟล์'),
          _buildFaqItem('วิธีใช้งานโหมดดูออฟไลน์ดาวน์โหลดวิดีโอ', 'กดที่ไอคอนดาวน์โหลดข้างๆ รายชื่อตอน วิดีโอจะถูกบันทึกไว้ในหน้า "การดาวน์โหลดและออฟไลน์" สามารถเปิดดูได้แม้ไม่มีเน็ต'),
          _buildFaqItem('ปัญหาสิทธิ์รับชม Gundam+ VIP Gold', 'หากชำระเงินแล้วสิทธิ์ยังไม่ปรับเป็น VIP ให้ทำการรีสตาร์ทแอปพลิเคชัน 1 ครั้ง หรือส่งสลิปมาที่อีเมลด้านบน'),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Text(answer, style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4)),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 9. Anime Detail Screen
// -----------------------------------------------------------------------------
class AnimeDetailScreen extends StatefulWidget {
  final GundamSeries series;
  final Set<String> favoriteIds;
  final Function(String) onToggleFavorite;
  final bool Function(String, int) isDownloaded;
  final Function(GundamSeries, Episode) onToggleDownload;

  const AnimeDetailScreen({
    super.key,
    required this.series,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.isDownloaded,
    required this.onToggleDownload,
  });

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFav = widget.favoriteIds.contains(widget.series.id);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 260.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.series.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                background: NetworkImageWithFallback(url: widget.series.bannerUrl),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              series: widget.series,
                              episode: widget.series.episodes[0],
                              isDownloaded: widget.isDownloaded,
                              onToggleDownload: widget.onToggleDownload,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('เล่นตอนที่ 1'),
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(isFav ? Icons.check_circle : Icons.add_circle_outline, color: isFav ? Colors.greenAccent : Colors.white),
                    onPressed: () => widget.onToggleFavorite(widget.series.id),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'ตอนทั้งหมด (30)'),
                Tab(text: 'เรื่องย่อ'),
                Tab(text: 'ตัวละคร'),
                Tab(text: 'หุ่นรบ'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // แท็บที่ 1: ตอนทั้งหมด (ใช้โค้ดเดิม)
                  ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: widget.series.episodes.length,
                    itemBuilder: (context, index) {
                      final ep = widget.series.episodes[index];
                      final hasDownloaded = widget.isDownloaded(widget.series.id, ep.number);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(6)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: NetworkImageWithFallback(url: ep.thumbnailUrl, width: 80, height: 50),
                          ),
                          title: Text(ep.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          subtitle: Text('ความยาว: ${ep.duration} นาที', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          trailing: IconButton(
                            icon: Icon(
                              hasDownloaded ? Icons.download_done : Icons.download,
                              color: hasDownloaded ? Colors.greenAccent : Colors.white70,
                            ),
                            onPressed: () => widget.onToggleDownload(widget.series, ep),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  series: widget.series,
                                  episode: ep,
                                  isDownloaded: widget.isDownloaded,
                                  onToggleDownload: widget.onToggleDownload,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  
                  // แท็บที่ 2: เรื่องย่อ (ใช้โค้ดเดิม)
                  Padding(padding: const EdgeInsets.all(16.0), child: Text(widget.series.synopsis, style: const TextStyle(fontSize: 14, height: 1.5))),
                  
                  // แท็บที่ 3: ตัวละคร (อัปเดตใหม่)
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: widget.series.characters.length,
                    itemBuilder: (context, i) {
                      final character = widget.series.characters[i];
                      return ListTile(
                        leading: ClipOval(
                          child: NetworkImageWithFallback(
                            url: character.avatarUrl,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text(character.name),
                        subtitle: Text(character.role),
                      );
                    },
                  ),
                  
                  // แท็บที่ 4: หุ่นรบ (อัปเดตใหม่)
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: widget.series.mechas.length,
                    itemBuilder: (context, i) {
                      final mecha = widget.series.mechas[i];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: NetworkImageWithFallback(
                            url: mecha.mechaUrl,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        title: Text(mecha.name),
                        subtitle: Text(mecha.model),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 10. Video Player Screen
// -----------------------------------------------------------------------------
class VideoPlayerScreen extends StatefulWidget {
  final GundamSeries series;
  final Episode episode;
  final bool Function(String, int) isDownloaded;
  final Function(GundamSeries, Episode) onToggleDownload;

  const VideoPlayerScreen({
    super.key,
    required this.series,
    required this.episode,
    required this.isDownloaded,
    required this.onToggleDownload,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.play(); 
        });
      });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final hasDownloaded = widget.isDownloaded(widget.series.id, widget.episode.number);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.redAccent),
          ),
          Container(color: Colors.black38),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.series.title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text(widget.episode.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(hasDownloaded ? Icons.download_done : Icons.download, color: hasDownloaded ? Colors.greenAccent : Colors.white),
                  onPressed: () {
                    widget.onToggleDownload(widget.series, widget.episode);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          if (_isInitialized)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42, 
                    icon: const Icon(Icons.replay_10, color: Colors.white), 
                    onPressed: () {
                      final currentPos = _controller.value.position;
                      _controller.seekTo(currentPos - const Duration(seconds: 10));
                    }
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    iconSize: 64,
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, 
                      color: Colors.redAccent
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    iconSize: 42, 
                    icon: const Icon(Icons.forward_10, color: Colors.white), 
                    onPressed: () {
                      final currentPos = _controller.value.position;
                      _controller.seekTo(currentPos + const Duration(seconds: 10));
                    }
                  ),
                ],
              ),
            ),
          if (_isInitialized)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Slider(
                    value: _controller.value.position.inSeconds.toDouble(),
                    min: 0.0,
                    max: _controller.value.duration.inSeconds.toDouble(),
                    activeColor: Colors.redAccent,
                    onChanged: (val) {
                      _controller.seekTo(Duration(seconds: val.toInt()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${formatTime(_controller.value.position)} / ${formatTime(_controller.value.duration)}', 
                        style: const TextStyle(color: Colors.white, fontSize: 12)
                      ),
                      const Icon(Icons.fullscreen, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 11. Helper Widget (Image Error & Loading)
// -----------------------------------------------------------------------------
class NetworkImageWithFallback extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  const NetworkImageWithFallback({super.key, required this.url, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: const Icon(Icons.smart_toy, color: Colors.white24, size: 36),
        );
      },
    );
  }
}