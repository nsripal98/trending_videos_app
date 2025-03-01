import { Region } from '@/types/region';

// Mock data for US states
const usaRegions: Region[] = [
  { code: 'ca', name: 'California', countryCode: 'usa', videoCount: 156 },
  { code: 'ny', name: 'New York', countryCode: 'usa', videoCount: 142 },
  { code: 'tx', name: 'Texas', countryCode: 'usa', videoCount: 98 },
  { code: 'fl', name: 'Florida', countryCode: 'usa', videoCount: 87 },
  { code: 'il', name: 'Illinois', countryCode: 'usa', videoCount: 65 },
  { code: 'pa', name: 'Pennsylvania', countryCode: 'usa', videoCount: 58 },
  { code: 'oh', name: 'Ohio', countryCode: 'usa', videoCount: 52 },
  { code: 'ga', name: 'Georgia', countryCode: 'usa', videoCount: 49 },
  { code: 'nc', name: 'North Carolina', countryCode: 'usa', videoCount: 45 },
  { code: 'mi', name: 'Michigan', countryCode: 'usa', videoCount: 43 },
  { code: 'nj', name: 'New Jersey', countryCode: 'usa', videoCount: 41 },
  { code: 'va', name: 'Virginia', countryCode: 'usa', videoCount: 39 },
  { code: 'wa', name: 'Washington', countryCode: 'usa', videoCount: 38 },
  { code: 'az', name: 'Arizona', countryCode: 'usa', videoCount: 36 },
  { code: 'ma', name: 'Massachusetts', countryCode: 'usa', videoCount: 35 },
  { code: 'tn', name: 'Tennessee', countryCode: 'usa', videoCount: 33 },
  { code: 'in', name: 'Indiana', countryCode: 'usa', videoCount: 31 },
  { code: 'mo', name: 'Missouri', countryCode: 'usa', videoCount: 29 },
  { code: 'md', name: 'Maryland', countryCode: 'usa', videoCount: 28 },
  { code: 'co', name: 'Colorado', countryCode: 'usa', videoCount: 27 },
];

// Mock data for Indian states
const indiaRegions: Region[] = [
  { code: 'mh', name: 'Maharashtra', countryCode: 'ind', videoCount: 145 },
  { code: 'dl', name: 'Delhi', countryCode: 'ind', videoCount: 132 },
  { code: 'ka', name: 'Karnataka', countryCode: 'ind', videoCount: 89 },
  { code: 'tn', name: 'Tamil Nadu', countryCode: 'ind', videoCount: 78 },
  { code: 'tg', name: 'Telangana', countryCode: 'ind', videoCount: 67 },
  { code: 'wb', name: 'West Bengal', countryCode: 'ind', videoCount: 62 },
  { code: 'gj', name: 'Gujarat', countryCode: 'ind', videoCount: 54 },
  { code: 'rj', name: 'Rajasthan', countryCode: 'ind', videoCount: 48 },
  { code: 'up', name: 'Uttar Pradesh', countryCode: 'ind', videoCount: 45 },
  { code: 'kl', name: 'Kerala', countryCode: 'ind', videoCount: 42 },
  { code: 'hr', name: 'Haryana', countryCode: 'ind', videoCount: 38 },
  { code: 'pb', name: 'Punjab', countryCode: 'ind', videoCount: 35 },
  { code: 'mp', name: 'Madhya Pradesh', countryCode: 'ind', videoCount: 32 },
  { code: 'br', name: 'Bihar', countryCode: 'ind', videoCount: 28 },
  { code: 'ap', name: 'Andhra Pradesh', countryCode: 'ind', videoCount: 26 },
];

// Mock data for UK regions
const ukRegions: Region[] = [
  { code: 'ldn', name: 'London', countryCode: 'gbr', videoCount: 112 },
  { code: 'man', name: 'Manchester', countryCode: 'gbr', videoCount: 78 },
  { code: 'bham', name: 'Birmingham', countryCode: 'gbr', videoCount: 65 },
  { code: 'gla', name: 'Glasgow', countryCode: 'gbr', videoCount: 58 },
  { code: 'liv', name: 'Liverpool', countryCode: 'gbr', videoCount: 52 },
  { code: 'edn', name: 'Edinburgh', countryCode: 'gbr', videoCount: 48 },
  { code: 'bri', name: 'Bristol', countryCode: 'gbr', videoCount: 42 },
  { code: 'lee', name: 'Leeds', countryCode: 'gbr', videoCount: 38 },
  { code: 'new', name: 'Newcastle', countryCode: 'gbr', videoCount: 35 },
  { code: 'car', name: 'Cardiff', countryCode: 'gbr', videoCount: 32 },
];

export async function fetchRegions(countryCode: string): Promise<Region[]> {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 500));
  
  switch (countryCode) {
    case 'usa':
      return usaRegions;
    case 'ind':
      return indiaRegions;
    case 'gbr':
      return ukRegions;
    default:
      return [];
  }
}

export async function fetchRegionDetails(countryCode: string, regionCode: string): Promise<Region> {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 300));
  
  let regions: Region[] = [];
  
  switch (countryCode) {
    case 'usa':
      regions = usaRegions;
      break;
    case 'ind':
      regions = indiaRegions;
      break;
    case 'gbr':
      regions = ukRegions;
      break;
    default:
      regions = [];
  }
  
  const region = regions.find(r => r.code === regionCode);
  
  if (!region) {
    throw new Error('Region not found');
  }
  
  return region;
}