// lib/services/mock_data_service.dart
import '../models/trending_video.dart';

class MockDataService {
  static List<TrendingVideo> generateTrendingVideos({
    LocationFilter? locationFilter,
    SocialPlatform? platform,
    String? category,
    String? hashtag,
  }) {
    final all = _allVideos();
    var filtered = all;

    if (locationFilter != null && !locationFilter.isEmpty) {
      filtered = filtered.where((v) => v.trendingLocations.any((loc) {
        if (locationFilter.city != null) return loc.city.toLowerCase().contains(locationFilter.city!.toLowerCase());
        if (locationFilter.district != null) return loc.district.toLowerCase().contains(locationFilter.district!.toLowerCase());
        if (locationFilter.state != null) return loc.state.toLowerCase().contains(locationFilter.state!.toLowerCase());
        if (locationFilter.country != null) return loc.country.toLowerCase().contains(locationFilter.country!.toLowerCase());
        return true;
      })).toList();
    }

    if (platform != null) {
      filtered = filtered.where((v) => v.platform == platform).toList();
    }

    if (category != null && category != 'All') {
      filtered = filtered.where((v) => v.category == category).toList();
    }

    if (hashtag != null) {
      filtered = filtered.where((v) =>
        v.hashtags.any((h) => h.toLowerCase().contains(hashtag.toLowerCase()))
      ).toList();
    }

    filtered.sort((a, b) => b.trendScore.compareTo(a.trendScore));
    return filtered;
  }

  static List<TrendingTopic> getTrendingTopics({LocationFilter? locationFilter}) {
    final topics = _allTopics();
    if (locationFilter == null || locationFilter.isEmpty) return topics;

    return topics.where((t) => t.locations.any((loc) {
      if (locationFilter.city != null) return loc.city.toLowerCase().contains(locationFilter.city!.toLowerCase());
      if (locationFilter.district != null) return loc.district.toLowerCase().contains(locationFilter.district!.toLowerCase());
      if (locationFilter.state != null) return loc.state.toLowerCase().contains(locationFilter.state!.toLowerCase());
      return true;
    })).toList();
  }

  static List<TrendingVideo> _allVideos() => [
    // === HYDERABAD ELECTION VIDEOS ===
    TrendingVideo(
      id: 'hyd_001',
      title: 'Hyderabad Municipal Elections 2025 - Live Results & Analysis',
      description: 'Complete coverage of the Hyderabad municipal elections. Vote counting underway, TRS leads in early trends. Watch live updates from all zones.',
      thumbnailUrl: 'https://picsum.photos/seed/hyd001/640/360',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      originalUrl: 'https://youtube.com/watch?v=hyd_election_001',
      platform: SocialPlatform.youtube,
      creator: 'Hyderabad News Live',
      creatorAvatar: 'https://picsum.photos/seed/creator1/100/100',
      viewCount: 2450000,
      likeCount: 89000,
      shareCount: 45000,
      commentCount: 23000,
      hashtags: ['#HyderabadElections', '#HyderabadVotes', '#TelanganaElections', '#HMC2025', '#hyderabadelections'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Telangana', district: 'Hyderabad', city: 'Hyderabad', latitude: 17.3850, longitude: 78.4867),
        LocationInfo(country: 'India', state: 'Telangana', district: 'Secunderabad', city: 'Secunderabad'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      fetchedAt: DateTime.now(),
      trendScore: 98,
      category: 'Politics',
      isLocationSpecific: true,
      duration: '3:42:15',
      insight: ContentInsight(
        summary: 'Live election coverage gaining massive traction in Hyderabad with real-time vote counting updates',
        keyTopics: ['Municipal Elections', 'Vote Counting', 'TRS vs BJP', 'Hyderabad Development', 'Local Governance'],
        contentIdeas: [
          'Create a "What these election results mean for Hyderabad infrastructure" explainer video',
          'Interview locals about their expectations from newly elected candidates',
          'Make a "History of Hyderabad elections" series',
          'Live reaction video as results come in',
          'Comparison video: Before vs After promises of elected officials',
        ],
        sentiment: 'excited',
        category: 'Politics',
        targetAudience: 'Hyderabad residents, Political enthusiasts, Telugu speaking audience',
        suggestedHashtags: ['#HyderabadElections', '#TelanganaVotes', '#HMC2025', '#HyderabadPolitics', '#VoiceOfHyderabad'],
        bestTimeToPost: '6 PM - 10 PM IST (peak viewing during result announcement)',
        estimatedEngagement: 85,
      ),
    ),
    TrendingVideo(
      id: 'hyd_002',
      title: 'ఓట్ల లెక్కింపు LIVE | Hyderabad Election Results 2025',
      description: 'Hyderabad election results live telecast in Telugu. Watch as each ward announces results. Democracy in action!',
      thumbnailUrl: 'https://picsum.photos/seed/hyd002/640/360',
      videoUrl: 'https://instagram.com/reel/hyd_election',
      originalUrl: 'https://instagram.com/reel/hyd_election',
      platform: SocialPlatform.instagram,
      creator: 'Telugu_News_Now',
      creatorAvatar: 'https://picsum.photos/seed/creator2/100/100',
      viewCount: 1820000,
      likeCount: 156000,
      shareCount: 98000,
      commentCount: 41000,
      hashtags: ['#HyderabadElections', '#TeluguNews', '#GHMC', '#hyderabadelections', '#TelanganaVotes'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Telangana', district: 'Hyderabad', city: 'Hyderabad'),
        LocationInfo(country: 'India', state: 'Telangana', district: 'Rangareddy', city: 'LB Nagar'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      fetchedAt: DateTime.now(),
      trendScore: 95,
      category: 'Politics',
      isLocationSpecific: true,
      duration: '1:28:30',
      insight: ContentInsight(
        summary: 'Telugu language election coverage dominating Instagram Reels in Hyderabad region',
        keyTopics: ['Election Results', 'Telugu Politics', 'GHMC Wards', 'Local Issues'],
        contentIdeas: [
          'Short Reels explaining each ward result in 60 seconds',
          'Street interviews with voters in different localities',
          'Infographic reels showing winning margins',
          'Reaction compilation from different political supporters',
        ],
        sentiment: 'tense',
        category: 'Politics',
        targetAudience: 'Telugu speakers, Hyderabad youth, Local politics followers',
        suggestedHashtags: ['#HyderabadElections', '#GHMC', '#TeluguNews', '#HyderabadVotes'],
        bestTimeToPost: '7 PM - 11 PM IST',
        estimatedEngagement: 78,
      ),
    ),

    // === MUMBAI TRENDING ===
    TrendingVideo(
      id: 'mum_001',
      title: 'Mumbai Floods 2025: Entire Dharavi Underwater - Shocking Footage',
      description: 'Heavy monsoon rains cause severe flooding in Dharavi and surrounding areas. Citizens stranded, NDRF teams deployed.',
      thumbnailUrl: 'https://picsum.photos/seed/mum001/640/360',
      videoUrl: 'https://twitter.com/mumbainews/status/flood2025',
      originalUrl: 'https://twitter.com/mumbainews/status/flood2025',
      platform: SocialPlatform.twitter,
      creator: 'Mumbai_Mirror_Live',
      creatorAvatar: 'https://picsum.photos/seed/creator3/100/100',
      viewCount: 5600000,
      likeCount: 234000,
      shareCount: 189000,
      commentCount: 67000,
      hashtags: ['#MumbaiFloods', '#MumbaiRains', '#Maharashtra', '#Dharavi', '#MonsoonAlert'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Maharashtra', district: 'Mumbai', city: 'Mumbai'),
        LocationInfo(country: 'India', state: 'Maharashtra', district: 'Thane', city: 'Thane'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      fetchedAt: DateTime.now(),
      trendScore: 99,
      category: 'News',
      isLocationSpecific: true,
      duration: '8:45',
      insight: ContentInsight(
        summary: 'Flood footage going massively viral across all platforms from Mumbai',
        keyTopics: ['Urban Flooding', 'Climate Crisis', 'Infrastructure Failure', 'Disaster Response', 'NDRF Operations'],
        contentIdeas: [
          'Documentary: "Why Mumbai floods every year" - infrastructure analysis',
          'Interview with urban planning experts about flood-resistant city design',
          'Compilation of Mumbai flood history over decades',
          'Guide video: "How to prepare for monsoon floods" for urban dwellers',
          'Comparison: Mumbai vs other flood-prone cities globally',
        ],
        sentiment: 'alarming',
        category: 'News & Weather',
        targetAudience: 'Mumbai residents, Maharashtra audience, Climate change concerned viewers',
        suggestedHashtags: ['#MumbaiFloods', '#ClimateChange', '#UrbanFlooding', '#MonsoonIndia', '#MumbaiRains'],
        bestTimeToPost: 'Immediately - crisis content',
        estimatedEngagement: 92,
      ),
    ),

    // === BOLLYWOOD / ENTERTAINMENT ===
    TrendingVideo(
      id: 'bol_001',
      title: 'Pathaan 2 Official Trailer | Shah Rukh Khan | 2025',
      description: 'The most awaited trailer of 2025 is here! Shah Rukh Khan returns as Pathaan in this action-packed sequel.',
      thumbnailUrl: 'https://picsum.photos/seed/bol001/640/360',
      videoUrl: 'https://youtube.com/watch?v=pathaan2trailer',
      originalUrl: 'https://youtube.com/watch?v=pathaan2trailer',
      platform: SocialPlatform.youtube,
      creator: 'YRF Official',
      creatorAvatar: 'https://picsum.photos/seed/creator4/100/100',
      viewCount: 45000000,
      likeCount: 3200000,
      shareCount: 890000,
      commentCount: 456000,
      hashtags: ['#Pathaan2', '#SRK', '#ShahRukhKhan', '#YRF', '#Bollywood'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Maharashtra', district: 'Mumbai', city: 'Mumbai'),
        LocationInfo(country: 'India', state: 'Delhi', district: 'New Delhi', city: 'New Delhi'),
        LocationInfo(country: 'India', state: 'West Bengal', district: 'Kolkata', city: 'Kolkata'),
        LocationInfo(country: 'India', state: 'Karnataka', district: 'Bengaluru', city: 'Bengaluru'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
      fetchedAt: DateTime.now(),
      trendScore: 97,
      category: 'Entertainment',
      isLocationSpecific: false,
      duration: '2:45',
      insight: ContentInsight(
        summary: 'Pathaan 2 trailer breaking all records, most viewed Bollywood trailer in 24 hours',
        keyTopics: ['Bollywood', 'Action Movies', 'SRK Comeback', 'YRF Films', 'Hindi Cinema'],
        contentIdeas: [
          'Trailer breakdown and Easter eggs analysis video',
          'SRK career retrospective: From Pathaan 1 to 2',
          'Comparison: Pathaan 1 vs Pathaan 2 visual effects',
          'Fan reaction compilation video',
          '"Will Pathaan 2 break Pathaan 1 records?" analysis video',
        ],
        sentiment: 'euphoric',
        category: 'Entertainment',
        targetAudience: 'Bollywood fans, Hindi cinema lovers, SRK fans, Action movie enthusiasts',
        suggestedHashtags: ['#Pathaan2', '#SRK', '#Bollywood', '#TrailerReaction', '#YRF'],
        bestTimeToPost: 'Evening 7-10 PM IST',
        estimatedEngagement: 95,
      ),
    ),

    // === TECH TRENDS ===
    TrendingVideo(
      id: 'tech_001',
      title: 'OnePlus 13 Ultra Review: Best Android Phone of 2025?',
      description: 'In-depth review of OnePlus 13 Ultra. Camera, performance, battery life tested. Is this the Android phone to beat?',
      thumbnailUrl: 'https://picsum.photos/seed/tech001/640/360',
      videoUrl: 'https://youtube.com/watch?v=oneplus13review',
      originalUrl: 'https://youtube.com/watch?v=oneplus13review',
      platform: SocialPlatform.youtube,
      creator: 'TechWithMK',
      creatorAvatar: 'https://picsum.photos/seed/creator5/100/100',
      viewCount: 3200000,
      likeCount: 198000,
      shareCount: 45000,
      commentCount: 34000,
      hashtags: ['#OnePlus13Ultra', '#AndroidReview', '#TechReview', '#Smartphone2025', '#BestAndroid'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Karnataka', district: 'Bengaluru', city: 'Bengaluru'),
        LocationInfo(country: 'India', state: 'Telangana', district: 'Hyderabad', city: 'Hyderabad'),
        LocationInfo(country: 'India', state: 'Maharashtra', district: 'Mumbai', city: 'Pune'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      fetchedAt: DateTime.now(),
      trendScore: 88,
      category: 'Technology',
      isLocationSpecific: false,
      duration: '18:30',
      insight: ContentInsight(
        summary: 'Flagship phone review content performing extremely well, especially in tech-savvy cities',
        keyTopics: ['Smartphone Review', 'Camera Comparison', 'Battery Life', 'Performance Testing', 'Value for Money'],
        contentIdeas: [
          'Budget phone vs Flagship comparison video',
          '"Top 5 smartphones under 30k in India 2025" compilation',
          'Camera shootout: OnePlus vs Samsung vs iPhone',
          'First impressions after 30 days of use',
          'Gaming performance test video',
        ],
        sentiment: 'positive',
        category: 'Technology',
        targetAudience: 'Tech enthusiasts, Smartphone buyers, Young professionals',
        suggestedHashtags: ['#SmartphoneReview', '#Android2025', '#TechIndia', '#PhoneReview', '#OnePlus'],
        bestTimeToPost: '12 PM - 2 PM or 8 PM - 10 PM IST',
        estimatedEngagement: 82,
      ),
    ),

    // === CRICKET / SPORTS ===
    TrendingVideo(
      id: 'sport_001',
      title: 'India vs Pakistan ICC Champions Trophy - Final Highlights',
      description: 'Epic final! India beats Pakistan by 7 wickets. Kohli scores match-winning century. Scenes of celebration across India!',
      thumbnailUrl: 'https://picsum.photos/seed/sport001/640/360',
      videoUrl: 'https://instagram.com/reel/ipl_final_2025',
      originalUrl: 'https://instagram.com/reel/ipl_final_2025',
      platform: SocialPlatform.instagram,
      creator: 'CricketNation',
      creatorAvatar: 'https://picsum.photos/seed/creator6/100/100',
      viewCount: 28000000,
      likeCount: 4500000,
      shareCount: 2300000,
      commentCount: 890000,
      hashtags: ['#IndVsPak', '#ChampionsTrophy', '#TeamIndia', '#Cricket', '#Kohli100', '#ICCChampionsTrophy'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'All States', district: 'Nationwide', city: 'All Cities'),
        LocationInfo(country: 'India', state: 'Telangana', district: 'Hyderabad', city: 'Hyderabad'),
        LocationInfo(country: 'India', state: 'Maharashtra', district: 'Mumbai', city: 'Mumbai'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      fetchedAt: DateTime.now(),
      trendScore: 100,
      category: 'Sports',
      isLocationSpecific: false,
      duration: '15:20',
      insight: ContentInsight(
        summary: 'India cricket victory creating unprecedented engagement nationwide',
        keyTopics: ['Cricket', 'India vs Pakistan', 'Champions Trophy', 'Virat Kohli', 'Team India'],
        contentIdeas: [
          'Slow-motion breakdown of Kohli\'s century shots',
          'Top 10 moments from the match',
          'Celebration scenes from different Indian cities',
          'Analysis: Why India dominates Pakistan in ICC tournaments',
          'Fantasy cricket picks for next match',
        ],
        sentiment: 'celebratory',
        category: 'Sports',
        targetAudience: 'Cricket fans nationwide, Sports enthusiasts, Youth',
        suggestedHashtags: ['#IndVsPak', '#ChampionsTrophy2025', '#TeamIndia', '#Cricket', '#Kohli', '#BleedBlue'],
        bestTimeToPost: 'RIGHT NOW - trending moment',
        estimatedEngagement: 98,
      ),
    ),

    // === DELHI POLITICS ===
    TrendingVideo(
      id: 'del_001',
      title: 'Delhi Air Quality Hits Dangerous Levels - AQI 450+',
      description: 'Delhi chokes again as AQI crosses 450 in multiple zones. Schools shut, odd-even rule to return?',
      thumbnailUrl: 'https://picsum.photos/seed/del001/640/360',
      videoUrl: 'https://facebook.com/videos/delhi_aqi_2025',
      originalUrl: 'https://facebook.com/videos/delhi_aqi_2025',
      platform: SocialPlatform.facebook,
      creator: 'Delhi Speaks',
      creatorAvatar: 'https://picsum.photos/seed/creator7/100/100',
      viewCount: 4100000,
      likeCount: 312000,
      shareCount: 267000,
      commentCount: 98000,
      hashtags: ['#DelhiAirPollution', '#DelhiAQI', '#CleanAir', '#DelhiSmog', '#AQI450'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Delhi', district: 'New Delhi', city: 'New Delhi'),
        LocationInfo(country: 'India', state: 'Delhi', district: 'North Delhi', city: 'Rohini'),
        LocationInfo(country: 'India', state: 'Haryana', district: 'Gurugram', city: 'Gurugram'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      fetchedAt: DateTime.now(),
      trendScore: 91,
      category: 'Environment',
      isLocationSpecific: true,
      duration: '6:20',
      insight: ContentInsight(
        summary: 'Delhi pollution crisis driving massive content engagement, particularly from NCR audiences',
        keyTopics: ['Air Pollution', 'AQI Index', 'Health Risks', 'Government Response', 'Stubble Burning'],
        contentIdeas: [
          '"How to protect yourself during high AQI days" health guide',
          'Best air purifiers for Delhi homes - buyer\'s guide',
          'Time-lapse of Delhi skyline on good vs bad AQI days',
          'Interview with pulmonologists about respiratory health',
          'Tracking Delhi AQI history over 10 years - data visualization',
        ],
        sentiment: 'alarming',
        category: 'Environment',
        targetAudience: 'Delhi-NCR residents, Health-conscious viewers, Environmental activists',
        suggestedHashtags: ['#DelhiAQI', '#AirPollution', '#CleanAirDelhi', '#HealthFirst', '#DelhiSmog'],
        bestTimeToPost: 'Morning 7-9 AM or Evening 5-8 PM IST',
        estimatedEngagement: 88,
      ),
    ),

    // === BENGALURU TECH ===
    TrendingVideo(
      id: 'blr_001',
      title: 'Bengaluru Startup Gets $500M Funding - Unicorn Alert!',
      description: 'Another Bengaluru startup joins the unicorn club! The fintech startup Zenpay raises massive Series D round.',
      thumbnailUrl: 'https://picsum.photos/seed/blr001/640/360',
      videoUrl: 'https://twitter.com/startupnews/bengaluru_unicorn',
      originalUrl: 'https://twitter.com/startupnews/bengaluru_unicorn',
      platform: SocialPlatform.twitter,
      creator: 'StartupIndia_Hub',
      creatorAvatar: 'https://picsum.photos/seed/creator8/100/100',
      viewCount: 980000,
      likeCount: 67000,
      shareCount: 34000,
      commentCount: 12000,
      hashtags: ['#BengaluruStartup', '#IndianUnicorn', '#Fintech', '#StartupIndia', '#VentureCapital'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Karnataka', district: 'Bengaluru', city: 'Bengaluru'),
        LocationInfo(country: 'India', state: 'Maharashtra', district: 'Mumbai', city: 'Mumbai'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
      fetchedAt: DateTime.now(),
      trendScore: 82,
      category: 'Business',
      isLocationSpecific: true,
      duration: '4:15',
      insight: ContentInsight(
        summary: 'Startup funding news resonating strongly in tech and business communities',
        keyTopics: ['Startup Funding', 'Unicorn Club', 'Fintech India', 'Venture Capital', 'Bengaluru Ecosystem'],
        contentIdeas: [
          '"How Indian Fintech startups are changing banking" explainer',
          'Interview series with Bengaluru startup founders',
          'Investment guide: How to invest in Indian startups',
          'Bengaluru vs Mumbai startup ecosystems comparison',
          'Journey to unicorn: The Zenpay story',
        ],
        sentiment: 'optimistic',
        category: 'Business',
        targetAudience: 'Tech professionals, Entrepreneurs, Investors, MBA students',
        suggestedHashtags: ['#StartupIndia', '#BengaluruTech', '#IndianUnicorn', '#Fintech', '#Entrepreneurship'],
        bestTimeToPost: '9 AM - 11 AM IST (professional audience)',
        estimatedEngagement: 75,
      ),
    ),

    // === VIRAL CONTENT ===
    TrendingVideo(
      id: 'viral_001',
      title: 'Auto-Rickshaw Driver Sings Like A Pro - Goes Viral Overnight!',
      description: 'Chennai auto driver Murugan\'s incredible voice stuns passengers. His impromptu concert is taking the internet by storm!',
      thumbnailUrl: 'https://picsum.photos/seed/viral001/640/360',
      videoUrl: 'https://instagram.com/reel/murugan_sings',
      originalUrl: 'https://instagram.com/reel/murugan_sings',
      platform: SocialPlatform.instagram,
      creator: 'ChennaiVibes',
      creatorAvatar: 'https://picsum.photos/seed/creator9/100/100',
      viewCount: 18500000,
      likeCount: 2100000,
      shareCount: 890000,
      commentCount: 234000,
      hashtags: ['#AutoDriverSinger', '#ChennaiVibes', '#ViralIndia', '#HiddenTalent', '#FeelGood'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Tamil Nadu', district: 'Chennai', city: 'Chennai'),
        LocationInfo(country: 'India', state: 'Kerala', district: 'Kochi', city: 'Kochi'),
        LocationInfo(country: 'India', state: 'Karnataka', district: 'Bengaluru', city: 'Bengaluru'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 18)),
      fetchedAt: DateTime.now(),
      trendScore: 96,
      category: 'Viral',
      isLocationSpecific: false,
      duration: '3:45',
      insight: ContentInsight(
        summary: 'Heartwarming human interest story achieving massive organic viral reach across South India',
        keyTopics: ['Hidden Talent', 'Auto Rickshaw', 'Street Music', 'Viral Moment', 'Feel-Good Content'],
        contentIdeas: [
          '"Finding hidden talents in everyday people" documentary series',
          'Feature story video: "A day with Murugan the singer"',
          'Similar stories: Other everyday heroes with extraordinary talents',
          'Music talent hunt series for working-class professionals',
          'Collaboration: Get Murugan to record a proper music video',
        ],
        sentiment: 'heartwarming',
        category: 'Human Interest',
        targetAudience: 'General audience, Music lovers, Feel-good content consumers',
        suggestedHashtags: ['#HiddenTalent', '#ViralIndia', '#FeelGoodContent', '#StreetTalent', '#InspirationalStory'],
        bestTimeToPost: 'Any time - evergreen viral content',
        estimatedEngagement: 94,
      ),
    ),

    // === FOOD TRENDS ===
    TrendingVideo(
      id: 'food_001',
      title: 'Hyderabad Biryani Festival 2025 - 100+ Types of Biryani!',
      description: 'The biggest biryani festival in Hyderabad is back! Over 100 varieties of biryani from across India. This is paradise!',
      thumbnailUrl: 'https://picsum.photos/seed/food001/640/360',
      videoUrl: 'https://youtube.com/watch?v=biryani_fest_hyd',
      originalUrl: 'https://youtube.com/watch?v=biryani_fest_hyd',
      platform: SocialPlatform.youtube,
      creator: 'FoodieHyderabad',
      creatorAvatar: 'https://picsum.photos/seed/creator10/100/100',
      viewCount: 3800000,
      likeCount: 456000,
      shareCount: 123000,
      commentCount: 67000,
      hashtags: ['#HyderabadiFood', '#BiryaniLovers', '#FoodFestival', '#Hyderabad', '#FoodTour'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Telangana', district: 'Hyderabad', city: 'Hyderabad'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
      fetchedAt: DateTime.now(),
      trendScore: 87,
      category: 'Food',
      isLocationSpecific: true,
      duration: '12:30',
      insight: ContentInsight(
        summary: 'Food festival content from Hyderabad achieving exceptional regional reach',
        keyTopics: ['Hyderabadi Cuisine', 'Biryani', 'Food Festival', 'Local Culture', 'Food Tourism'],
        contentIdeas: [
          '"Best biryani places in Hyderabad under Rs. 200" budget guide',
          'Biryani making challenge: Home cook vs Restaurant',
          'History of Hyderabadi Biryani documentary',
          'Street food tour: Old City Hyderabad',
          'Regional biryani comparison: Hyderabad vs Lucknow vs Kolkata',
        ],
        sentiment: 'delightful',
        category: 'Food',
        targetAudience: 'Hyderabad foodies, Food content consumers, Travel enthusiasts',
        suggestedHashtags: ['#HyderabadFood', '#BiryaniLovers', '#FoodBlogger', '#FoodIndia', '#HyderabadiCuisine'],
        bestTimeToPost: '12 PM - 2 PM (lunch time) or 6 PM - 8 PM (dinner time)',
        estimatedEngagement: 86,
      ),
    ),

    // === KERALA FLOODS ===
    TrendingVideo(
      id: 'ker_001',
      title: 'Kerala Wayanad Landslide Rescue Operations - LIVE',
      description: 'Heroic rescue operations underway in Wayanad after massive landslide. Army, NDRF teams working round the clock.',
      thumbnailUrl: 'https://picsum.photos/seed/ker001/640/360',
      videoUrl: 'https://facebook.com/videos/wayanad_rescue',
      originalUrl: 'https://facebook.com/videos/wayanad_rescue',
      platform: SocialPlatform.facebook,
      creator: 'Kerala Crisis Watch',
      creatorAvatar: 'https://picsum.photos/seed/creator11/100/100',
      viewCount: 8900000,
      likeCount: 567000,
      shareCount: 890000,
      commentCount: 234000,
      hashtags: ['#WayanadLandslide', '#KeralaFloods', '#DisasterRelief', '#KeralaRescue', '#StayStrong'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Kerala', district: 'Wayanad', city: 'Wayanad'),
        LocationInfo(country: 'India', state: 'Kerala', district: 'Kozhikode', city: 'Kozhikode'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 7)),
      fetchedAt: DateTime.now(),
      trendScore: 93,
      category: 'News',
      isLocationSpecific: true,
      duration: '45:20',
      insight: ContentInsight(
        summary: 'Disaster relief content driving massive cross-platform sharing as people seek updates',
        keyTopics: ['Natural Disaster', 'Landslide', 'Rescue Operations', 'Kerala Geography', 'Climate Events'],
        contentIdeas: [
          'Guide: How to donate and help Wayanad victims',
          'Explainer: Why landslides are increasing in Kerala',
          'Profile: Unsung heroes of the rescue operation',
          'How to stay safe during monsoon landslides - awareness video',
          'Rebuilding Wayanad: Long-term recovery coverage',
        ],
        sentiment: 'urgent',
        category: 'Crisis Coverage',
        targetAudience: 'Kerala diaspora, Humanitarian volunteers, News consumers',
        suggestedHashtags: ['#WayanadStrong', '#KeralaDisaster', '#HelpWayanad', '#DisasterRelief', '#StandWithKerala'],
        bestTimeToPost: 'Immediately - crisis situation',
        estimatedEngagement: 91,
      ),
    ),

    // === RAJASTHAN TOURISM ===
    TrendingVideo(
      id: 'raj_001',
      title: 'Jaipur Pink City Travel Guide 2025 - Hidden Gems!',
      description: 'Complete travel guide to Jaipur with hidden spots tourists never visit. Budget tips, best food, and culture.',
      thumbnailUrl: 'https://picsum.photos/seed/raj001/640/360',
      videoUrl: 'https://youtube.com/watch?v=jaipur_guide_2025',
      originalUrl: 'https://youtube.com/watch?v=jaipur_guide_2025',
      platform: SocialPlatform.youtube,
      creator: 'WanderlustIndia',
      creatorAvatar: 'https://picsum.photos/seed/creator12/100/100',
      viewCount: 2100000,
      likeCount: 189000,
      shareCount: 78000,
      commentCount: 34000,
      hashtags: ['#Jaipur', '#PinkCity', '#RajasthanTourism', '#TravelIndia', '#HiddenGems'],
      trendingLocations: [
        LocationInfo(country: 'India', state: 'Rajasthan', district: 'Jaipur', city: 'Jaipur'),
      ],
      publishedAt: DateTime.now().subtract(const Duration(hours: 14)),
      fetchedAt: DateTime.now(),
      trendScore: 80,
      category: 'Travel',
      isLocationSpecific: true,
      duration: '22:45',
      insight: ContentInsight(
        summary: 'Jaipur travel content spiking as winter tourist season begins',
        keyTopics: ['Travel Guide', 'Rajasthan Tourism', 'Heritage Sites', 'Budget Travel', 'Local Culture'],
        contentIdeas: [
          '3-day Jaipur itinerary on Rs. 5000 budget',
          'Street food tour of Jaipur old city',
          'Photography spots in Jaipur at golden hour',
          'Jaipur vs Jodhpur - which to visit first?',
          'Best time to visit Rajasthan guide',
        ],
        sentiment: 'inspiring',
        category: 'Travel',
        targetAudience: 'Travel enthusiasts, Weekend travelers, Photography lovers',
        suggestedHashtags: ['#JaipurDiaries', '#RajasthanTourism', '#TravelIndia', '#IndiaTravel', '#PinkCity'],
        bestTimeToPost: 'Weekend 10 AM - 12 PM IST',
        estimatedEngagement: 79,
      ),
    ),
  ];

  static List<TrendingTopic> _allTopics() => [
    TrendingTopic(
      hashtag: '#HyderabadElections',
      category: 'Politics',
      videoCount: 2847,
      totalViews: 45000000,
      locations: [LocationInfo(country: 'India', state: 'Telangana', district: 'Hyderabad', city: 'Hyderabad')],
      platforms: [SocialPlatform.youtube, SocialPlatform.instagram, SocialPlatform.twitter, SocialPlatform.facebook],
      firstSeen: DateTime.now().subtract(const Duration(hours: 6)),
      trendScore: 98,
      growthRate: 342.5,
      relatedHashtags: ['#GHMC', '#TelanganaVotes', '#HMC2025', '#HyderabadVotes'],
    ),
    TrendingTopic(
      hashtag: '#IndVsPak',
      category: 'Sports',
      videoCount: 8921,
      totalViews: 189000000,
      locations: [LocationInfo(country: 'India', state: 'All States', district: 'Nationwide', city: 'Nationwide')],
      platforms: [SocialPlatform.instagram, SocialPlatform.youtube, SocialPlatform.twitter],
      firstSeen: DateTime.now().subtract(const Duration(hours: 2)),
      trendScore: 100,
      growthRate: 890.0,
      relatedHashtags: ['#ChampionsTrophy', '#TeamIndia', '#Cricket', '#Kohli100'],
    ),
    TrendingTopic(
      hashtag: '#MumbaiFloods',
      category: 'News',
      videoCount: 3456,
      totalViews: 67000000,
      locations: [LocationInfo(country: 'India', state: 'Maharashtra', district: 'Mumbai', city: 'Mumbai')],
      platforms: [SocialPlatform.twitter, SocialPlatform.facebook, SocialPlatform.instagram],
      firstSeen: DateTime.now().subtract(const Duration(hours: 8)),
      trendScore: 95,
      growthRate: 567.3,
      relatedHashtags: ['#MumbaiRains', '#Maharashtra', '#Monsoon2025'],
    ),
    TrendingTopic(
      hashtag: '#Pathaan2',
      category: 'Entertainment',
      videoCount: 12000,
      totalViews: 234000000,
      locations: [LocationInfo(country: 'India', state: 'Maharashtra', district: 'Mumbai', city: 'Mumbai')],
      platforms: [SocialPlatform.youtube, SocialPlatform.instagram, SocialPlatform.twitter],
      firstSeen: DateTime.now().subtract(const Duration(hours: 14)),
      trendScore: 97,
      growthRate: 445.2,
      relatedHashtags: ['#SRK', '#Bollywood', '#YRF', '#ShahRukhKhan'],
    ),
    TrendingTopic(
      hashtag: '#DelhiAQI',
      category: 'Environment',
      videoCount: 1567,
      totalViews: 23000000,
      locations: [LocationInfo(country: 'India', state: 'Delhi', district: 'New Delhi', city: 'New Delhi')],
      platforms: [SocialPlatform.twitter, SocialPlatform.facebook],
      firstSeen: DateTime.now().subtract(const Duration(hours: 10)),
      trendScore: 88,
      growthRate: 234.7,
      relatedHashtags: ['#DelhiSmog', '#AirPollution', '#CleanAir', '#DelhiWinter'],
    ),
    TrendingTopic(
      hashtag: '#WayanadLandslide',
      category: 'News',
      videoCount: 4200,
      totalViews: 89000000,
      locations: [LocationInfo(country: 'India', state: 'Kerala', district: 'Wayanad', city: 'Wayanad')],
      platforms: [SocialPlatform.facebook, SocialPlatform.youtube, SocialPlatform.instagram],
      firstSeen: DateTime.now().subtract(const Duration(hours: 9)),
      trendScore: 93,
      growthRate: 678.1,
      relatedHashtags: ['#KeralaFloods', '#DisasterRelief', '#HelpKerala', '#WayanadStrong'],
    ),
  ];

  static List<String> getIndianStates() => [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
    'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
    'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
    'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Delhi', 'Jammu & Kashmir', 'Ladakh',
  ];

  static Map<String, List<String>> getDistrictsByState() => {
    'Telangana': ['Hyderabad', 'Secunderabad', 'Warangal', 'Karimnagar', 'Nizamabad', 'Khammam', 'Rangareddy'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Thane', 'Nashik', 'Aurangabad', 'Solapur'],
    'Karnataka': ['Bengaluru Urban', 'Mysuru', 'Hubli-Dharwad', 'Mangaluru', 'Belagavi', 'Davangere'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Vellore'],
    'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur', 'Malappuram', 'Wayanad', 'Palakkad'],
    'Delhi': ['New Delhi', 'North Delhi', 'South Delhi', 'East Delhi', 'West Delhi', 'Central Delhi'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Bikaner', 'Ajmer'],
    'West Bengal': ['Kolkata', 'North 24 Parganas', 'South 24 Parganas', 'Howrah', 'Darjeeling'],
  };

  static List<String> getCategories() => [
    'All', 'Politics', 'Sports', 'Entertainment', 'Technology', 'Business',
    'Food', 'Travel', 'News', 'Environment', 'Viral', 'Education', 'Health',
  ];
}
