require("dotenv").config();
const VERSION_ID = "v2-AUTH-STRICT-DEBUG-FIXED";
console.log(`🚨 STARTING SERVER [${VERSION_ID}] FROM:`, __filename);

require("./db"); 
const express = require("express");
const cors = require("cors");
const authRoutes = require("./routes/auth");
const quizRoutes = require("./routes/quiz");

const app = express();

app.use(cors());
app.use(express.json());

// 🔴 Logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
  next();
});

// 🔴 Diagnostic route (made safe)
app.get("/api/debug", (req, res) => {
  const routes = app._router ? app._router.stack
      .filter(r => r.route)
      .map(r => `${Object.keys(r.route.methods).join(',').toUpperCase()} ${r.route.path}`) : ["Router not initialized"];
      
  res.json({
    status: "UP",
    version: VERSION_ID,
    file: __filename,
    mounted_routes: routes
  });
});

// 🔴 routes
app.use("/api/auth", authRoutes);
app.use("/api", quizRoutes);

app.get("/", (req, res) => {
  res.send(`MoneyVibe API [${VERSION_ID}] is running 🚀`);
});

// const PORT = 5000;
// app.listen(PORT, () => {
//   console.log(`✅ [${VERSION_ID}] SERVER RUNNING on http://localhost:${PORT}`);
// });
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});
