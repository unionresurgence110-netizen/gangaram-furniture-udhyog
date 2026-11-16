/*
  MANUAL / CODE-BASED FURNITURE CATALOGUE
  Add your own entries here. These entries appear alongside dashboard items.
  Use image paths inside /assets/images/ or full public image URLs.
  Example:
  { id:'manual-bed-01', name:'Carved Teak Bed', nameNe:'नक्काशीदार पलङ', description:'Hand-carved solid wood bed.', descriptionNe:'हातले कुँदिएको काठको पलङ।', image:'/assets/images/furniture/bed.webp', images:[], category:'Beds', price:null, woodType:'Teak', dimensions:'6 ft × 6.5 ft', finish:'Natural polish', featured:true, detailsVisibility:{description:true,price:false,woodType:true,finish:true,dimensions:true,customDesign:true} }
*/
window.MANUAL_FURNITURE = [
  {
    id: 'manual-bed-01',
    name: 'Hand Carved Wooden Bed',
    nameNe: 'हातले कुँदिएको काठको पलङ',
    description: 'Beautiful handcrafted wooden bed.',
    descriptionNe: 'सुन्दर हातले बनाइएको काठको पलङ।',
    image: '/assets/images/furniture/carved-bedwebp.jpg',
    images: [], // Add up to 3 extra image URLs here (4 images total including the main image).
    category: 'Beds',
    price: null,
    woodType: 'Sal Wood',
    dimensions: '6 ft × 6.5 ft',
    finish: 'Natural Polish',
    featured: true,
    detailsVisibility: { description: true, price: true, woodType: true, finish: true, dimensions: true, customDesign: true }
  }
];
window.MANUAL_GALLERY = [
  // Manual gallery entries stay in this file and are not saved to the database.
  // { id: 'work-01', title: 'Custom wooden door', description: 'Handcrafted solid wood door.', image: '/assets/images/work/door.webp' }
];
