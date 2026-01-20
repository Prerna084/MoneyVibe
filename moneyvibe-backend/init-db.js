const pool = require("./db");

async function initDb() {
  try {
    console.log("🚀 Initializing database schema...");

    // 1. Create Users Table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log("✅ Users table ensured");

    // 2. Create Quiz Sessions Table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS quiz_sessions (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log("✅ Quiz Sessions table ensured");

    // 3. Create Quiz Results Table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS quiz_results (
        id SERIAL PRIMARY KEY,
        session_id INTEGER REFERENCES quiz_sessions(id) ON DELETE CASCADE,
        result JSONB NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log("✅ Quiz Results table ensured");

    // 4. Create Quiz Answers Table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS quiz_answers (
        id SERIAL PRIMARY KEY,
        session_id INTEGER REFERENCES quiz_sessions(id) ON DELETE CASCADE,
        trait VARCHAR(50) NOT NULL,
        value FLOAT NOT NULL
      );
    `);
    console.log("✅ Quiz Answers table ensured");

    console.log("🎉 Database initialization complete!");
    process.exit(0);
  } catch (err) {
    console.error("❌ Database initialization failed:", err.message);
    process.exit(1);
  }
}

initDb();
