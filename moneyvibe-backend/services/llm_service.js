const generateInsight = async (scores, persona) => {
  // In a real app, call OpenAI API here using process.env.OPENAI_API_KEY
  
  // Mock response for now to ensure reliability and speed as per requirements
  const insights = {
    'The Strategist': "You have a clear vision for the future. Your discipline is your superpower, but don't forget to enjoy the present moment.",
    'The Spontaneous Spender': "You know how to enjoy life! Consider setting up a 'fun fund' so your joy doesn't impact your long-term goals.",
    'The Maverick': "You are bold and comfortable with uncertainty. Ensure your high-risk moves are balanced with a safety net.",
    'The Zen Master': "Market ups and downs don't phase you. Your emotional stability is a major asset in long-term wealth building.",
    'The Balancer': "You have a well-rounded approach to money. Keep maintaining that equilibrium between saving and spending."
  };

  return insights[persona] || "Your money vibe is unique! Keep exploring your financial personality.";
};

module.exports = { generateInsight };
