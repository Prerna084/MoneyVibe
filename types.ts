
export enum TraitCategory {
  PLANNING = 'Planning',
  IMPULSE = 'Impulse',
  RISK = 'Risk',
  CALMNESS = 'Calmness'
}

export interface Question {
  id: string;
  category: TraitCategory;
  text: string;
}

export interface QuizResult {
  id: string;
  timestamp: number;
  scores: Record<TraitCategory, number>;
  persona: string;
  insights: string[];
}

export type AppScreen = 'WELCOME' | 'QUIZ' | 'RESULTS' | 'INSIGHTS' | 'HISTORY';
