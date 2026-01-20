
import { GoogleGenAI, Type } from "@google/genai";
import { TraitCategory } from "../types";

export async function generateFinancialInsights(scores: Record<TraitCategory, number>) {
  const ai = new GoogleGenAI({ apiKey: process.env.API_KEY || '' });
  
  const scoreDescription = Object.entries(scores)
    .map(([category, score]) => `${category}: ${score}/5`)
    .join(", ");

  const prompt = `Based on these financial trait scores (1-5 scale): ${scoreDescription}, generate a personalized financial persona name and 4 detailed insights. 
  Note: Impulse scores are interpreted such that high score means higher impulse (more spending).
  Planning: ${scores[TraitCategory.PLANNING]}
  Impulse: ${scores[TraitCategory.IMPULSE]}
  Risk: ${scores[TraitCategory.RISK]}
  Calmness: ${scores[TraitCategory.CALMNESS]}`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-3-flash-preview',
      contents: prompt,
      config: {
        responseMimeType: "application/json",
        responseSchema: {
          type: Type.OBJECT,
          properties: {
            persona: { type: Type.STRING, description: 'A creative title for this financial personality' },
            insights: { 
              type: Type.ARRAY, 
              items: { type: Type.STRING },
              description: 'Four specific pieces of advice or observations'
            }
          },
          required: ['persona', 'insights']
        }
      }
    });

    return JSON.parse(response.text);
  } catch (error) {
    console.error("Error generating insights:", error);
    return {
      persona: "The Balanced Observer",
      insights: [
        "Your financial approach shows signs of thoughtful consideration.",
        "Consider automating your savings to maintain consistency.",
        "Review your risk appetite periodically as your goals change.",
        "Focus on long-term wealth building rather than short-term gains."
      ]
    };
  }
}
