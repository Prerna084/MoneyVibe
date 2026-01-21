const express = require("express");
const jwt = require("jsonwebtoken");
const pool = require("../db");
const scoringService = require("../services/scoring_service");
const geminiService = require("../services/gemini_service");
const llmService = require("../services/llm_service");

const router = express.Router();

/**
 * JWT middleware
 */
function authenticate(req, res, next) {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.status(401).json({ message: "No token" });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch {
    res.status(401).json({ message: "Invalid token" });
  }
}

/**
 * SAVE QUIZ RESULT
 * POST /api/quiz/submit
 */
router.post(["/submit", "/submit-quiz"], authenticate, async (req, res) => {
  try {
    const { answers, scores: providedScores, result: providedResult } = req.body;
    
    let scores = providedScores;
    let result = providedResult;

    if (answers && !scores) {
      // 1. Calculate Scores
      scores = scoringService.calculateScores(answers);
      
      // 2. Generate Dynamic Persona with Gemini
      const geminiPersona = await geminiService.generatePersonaWithGemini(scores);
      
      // 3. Generate additional insights
      const additionalInsights = await llmService.generateInsight(scores, geminiPersona.name);

      // 4. Generate serial number
      const serialNumber = `MV-${Date.now().toString(36).toUpperCase().substring(0, 10)}`;

      // 5. Build result object
      result = {
        persona: geminiPersona.name,
        powerColor: geminiPersona.powerColor,
        secondaryColor: geminiPersona.secondaryColor,
        insights: [geminiPersona.insight, additionalInsights],
        serialNumber,
        timestamp: new Date().toISOString(),
        scores
      };
    }

    if (!scores || !result) {
      return res.status(400).json({ error: 'Answers or pre-calculated results are required' });
    }

    // 6. DB Persistence
    const quizSession = await pool.query(
      "INSERT INTO quiz_sessions (user_id) VALUES ($1) RETURNING id",
      [req.userId]
    );

    const sessionId = quizSession.rows[0].id;

    await pool.query(
      "INSERT INTO quiz_results (session_id, result) VALUES ($1, $2)",
      [sessionId, result]
    );

    for (const [trait, value] of Object.entries(scores)) {
      await pool.query(
        "INSERT INTO quiz_answers (session_id, trait, value) VALUES ($1, $2, $3)",
        [sessionId, trait, value]
      );
    }

    res.status(201).json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});

/**
 * FETCH HISTORY
 * GET /api/quiz/history
 */
router.get(["/history", "/get-history"], authenticate, async (req, res) => {
  try {
    const historyResult = await pool.query(
      `SELECT r.result 
       FROM quiz_results r
       JOIN quiz_sessions s ON r.session_id = s.id
       WHERE s.user_id = $1
       ORDER BY s.created_at DESC`,
      [req.userId]
    );

    const history = historyResult.rows.map(row => row.result);
    res.json(history);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});



module.exports = router;
