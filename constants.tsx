
import { Question, TraitCategory } from './types';

export const QUESTIONS: Question[] = [
  { id: '1', category: TraitCategory.PLANNING, text: "I save a portion of my income every month, no matter what." },
  { id: '2', category: TraitCategory.PLANNING, text: "I think a lot about how today's money decisions affect my future." },
  { id: '3', category: TraitCategory.IMPULSE, text: "I often buy things I don't need when I'm feeling down." },
  { id: '4', category: TraitCategory.IMPULSE, text: "I celebrate good news by spending money." },
  { id: '5', category: TraitCategory.RISK, text: "I feel confident investing in stocks or mutual funds." },
  { id: '6', category: TraitCategory.RISK, text: "I can tolerate temporary losses if it means higher long-term returns." },
  { id: '7', category: TraitCategory.CALMNESS, text: "I stay calm even when markets fluctuate sharply." }
];

export const COLORS = {
  GOLD: '#D4AF37',
  GOLD_LIGHT: '#F1D592',
  DARK: '#000000',
  ZINC: '#18181b',
};
