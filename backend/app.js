require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const scoringService = require('./services/scoring_service');
const llmService = require('./services/llm_service');
const geminiService = require('./services/gemini_service');

const app = express();
console.log("⚠️ WARNING: This is the WRONG backend (backend/app.js). Use moneyvibe-backend/server.js instead.");
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// In-memory storage for history (replace with DB in prod)
let history = [];

// Routes
app.get('/', (req, res) => {
  res.send('MoneyVibe API is running');
});

app.post('/api/submit-quiz', async (req, res) => {
  try {
    const { answers } = req.body;
    
    if (!answers) {
      return res.status(400).json({ error: 'Answers are required' });
    }

    // 1. Calculate Scores
    const scores = scoringService.calculateScores(answers);
    
    // 2. Generate Dynamic Persona with Gemini (includes powerColor, secondaryColor, insight)
    const geminiPersona = await geminiService.generatePersonaWithGemini(scores);
    
    // 3. Generate additional insights (optional)
    const additionalInsights = await llmService.generateInsight(scores, geminiPersona.name);

    // 4. Generate serial number
    const serialNumber = `MV-${Date.now().toString(36).toUpperCase().substring(0, 10)}`;

    // 5. Save result
    const result = {
      id: Date.now().toString(),
      timestamp: new Date(),
      scores,
      persona: geminiPersona.name,
      powerColor: geminiPersona.powerColor,
      secondaryColor: geminiPersona.secondaryColor,
      insights: [geminiPersona.insight, ...additionalInsights],
      serialNumber,
    };
    history.push(result);

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/history', (req, res) => {
  res.json(history.reverse()); // Newest first
});

// Start Server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
