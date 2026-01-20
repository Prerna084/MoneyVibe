const genAI = process.env.GEMINI_API_KEY ? new GoogleGenerativeAI(process.env.GEMINI_API_KEY) : null;

async function generatePersonaWithGemini(scores) {
  try {
    if (!genAI) {
      console.log("⚠️ No GEMINI_API_KEY found, using fallback persona.");
      throw new Error("Missing API Key");
    }
    const model = genAI.getGenerativeModel({ 
      model: 'gemini-1.5-flash',
      generationConfig: {
        responseMimeType: 'application/json',
      },
    });

    const traitSummary = `
      Planning: ${scores.planning}%, 
      Impulse Control: ${100 - (scores.impulse || 0)}%, 
      Risk Tolerance: ${scores.risk}%, 
      Calmness: ${scores.calmness}%
    `;

    const prompt = `Act as an expert financial behavioral psychologist. Analyze these traits: ${traitSummary}.
    
    Generate a 'Money Vibe' profile.
    
    Return ONLY JSON with the following structure:
    {
      "name": "The Vibe Name (e.g., THE STRATEGIC MINIMALIST)",
      "powerColor": "hex string (luxury primary color, e.g. #D4AF37)",
      "secondaryColor": "hex string (harmonious accent color, e.g. #FFFFFF)",
      "insight": "Markdown formatted string containing: \n- A paragraph detailing their psychological relationship with wealth.\n- 'CORE STRENGTHS' as a small list.\n- 'POTENTIAL RISKS' as a small list.\n- One powerful actionable 'NORTH STAR' advice.\nKeep the tone sophisticated, exclusive, and precise. Avoid generic fluff."
    }`;

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();
    
    return JSON.parse(text);
  } catch (error) {
    console.error('Gemini API Error:', error);
    // Fallback to default persona
    return {
      name: 'The Strategist',
      powerColor: '#D4AF37',
      secondaryColor: '#FFFFFF',
      insight: 'Your financial personality shows a sophisticated blend of calculated risk and long-term vision. You prioritize security without sacrificing growth potential.\n\n**CORE STRENGTHS**\n- Long-term vision\n- Disciplined saving\n\n**POTENTIAL RISKS**\n- Over-caution\n- Analysis paralysis\n\n**NORTH STAR**\nAutomate your investments to bypass hesitation.',
    };
  }
}

module.exports = { generatePersonaWithGemini };
