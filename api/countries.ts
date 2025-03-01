import { Country } from '@/types/country';
import { countries } from '@/data/countries';

export async function fetchCountryDetails(code: string): Promise<Country> {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 300));
  
  const country = countries.find(c => c.code === code);
  
  if (!country) {
    throw new Error('Country not found');
  }
  
  return country;
}