const calculateScores = (answers) => {
  // Mapping Question IDs to Categories (Sync with Frontend)
  // 1,2 -> Planning
  // 3,4 -> Impulse
  // 5,6 -> Risk
  // 7 -> Calmness
  
  const scores = {
    planning: 0,
    impulse: 0,
    risk: 0,
    calmness: 0
  };

  // Helper to normalize 1-5 to 0-100
  const normalize = (val) => {
    const score = (val || 0) * 20;
    console.log(`📊 Normalizing val ${val} to ${score}`);
    return score;
  };

  if (answers['1']) scores.planning += normalize(answers['1']);
  if (answers['2']) scores.planning += normalize(answers['2']);
  
  if (answers['3']) scores.impulse += normalize(answers['3']);
  if (answers['4']) scores.impulse += normalize(answers['4']);

  if (answers['5']) scores.risk += normalize(answers['5']);
  if (answers['6']) scores.risk += normalize(answers['6']);

  if (answers['7']) scores.calmness += normalize(answers['7']);

  // Average them if multiple questions per trait (simplified here as sum for radar)
  // For radar chart 0-10 scale, let's keep it simple.
  // 2 questions max = 20 points max. Let's average to 10.
  scores.planning /= 2;
  scores.impulse /= 2;
  scores.risk /= 2;
  // Calmness has 1 question, so just normalize
  
  console.log("📈 Final Calculated Scores:", scores);
  return scores;
};

const determinePersona = (scores) => {
  // Simple logic: highest score determines persona
  const maxTrait = Object.keys(scores).reduce((a, b) => scores[a] > scores[b] ? a : b);
  
  switch (maxTrait) {
    case 'planning': return 'The Strategist';
    case 'impulse': return 'The Spontaneous Spender';
    case 'risk': return 'The Maverick';
    case 'calmness': return 'The Zen Master';
    default: return 'The Balancer';
  }
};

module.exports = { calculateScores, determinePersona };
