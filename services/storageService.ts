
import { QuizResult } from "../types";

const STORAGE_KEY = 'moneyvibe_history';

export const storageService = {
  saveResult: (result: QuizResult) => {
    const current = storageService.getHistory();
    const updated = [result, ...current];
    localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));
  },

  getHistory: (): QuizResult[] => {
    const data = localStorage.getItem(STORAGE_KEY);
    return data ? JSON.parse(data) : [];
  },

  clearHistory: () => {
    localStorage.removeItem(STORAGE_KEY);
  }
};
