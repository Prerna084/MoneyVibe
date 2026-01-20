const { Pool } = require("pg");

const isProduction = process.env.DATABASE_URL ? true : false;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || undefined,
  user: !process.env.DATABASE_URL ? process.env.DB_USER : undefined,
  host: !process.env.DATABASE_URL ? process.env.DB_HOST : undefined,
  database: !process.env.DATABASE_URL ? process.env.DB_NAME : undefined,
  password: !process.env.DATABASE_URL ? process.env.DB_PASSWORD : undefined,
  port: !process.env.DATABASE_URL ? process.env.DB_PORT : undefined,
  ssl: isProduction ? { rejectUnauthorized: false } : false,
});

pool
  .connect()
  .then(() => console.log(`✅ PostgreSQL connected (${isProduction ? "Remote/Render" : "Local"})`))
  .catch((err) => {
    console.error("❌ PostgreSQL connection error:", err.message);
  });

module.exports = pool;
