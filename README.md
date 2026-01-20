# 💰 MoneyVibe — Financial Personality Assessment (Flutter)

MoneyVibe is a Flutter-based financial personality assessment inspired by **Twigg’s MoneyVibe** experience.  
It helps users understand their money behavior through a short, intuitive quiz and presents results using clear visual indicators and personalized insights.

This project includes:
- A **Flutter app** implementing the full assessment flow
- A **backend service** for storing and retrieving user results

---

## ✨ Product Overview

### Flow
- **Welcome Screen** – Start the assessment
- **Quiz Screen** – One question at a time with an Agree/Disagree scale (1–5)
- **Results Screen** – Visual breakdown of personality traits
- **Insights Screen** – Personalized, human-readable insights
- **History Screen** – View past assessments

### Traits Assessed
- Planning  
- Impulse  
- Risk  
- Calmness  

All trait scoring is **deterministic and normalized**, ensuring consistency and scalability as questions evolve.

---

## 🎨 Design & UX

- **Theme:** Dark UI with gold/yellow accents (`#D4AF37`)
- **Style:** Clean, minimal, premium fintech
- **UX Principles:**
  - Low cognitive load during the quiz
  - Clear progress indicators
  - Visually rewarding results and insights

Inspired by **Twigg, CRED, and Jupiter**.

---

## 🧠 LLM / AI Approach

- Core assessment logic is **fully deterministic**
- AI usage (optional) is scoped **only to the insights layer**
- The model operates on **structured trait scores**, not raw user answers

This keeps the system **explainable, safe, and appropriate for a fintech context**, while still enabling personalized communication.

---

## 🏗 Project Structure (High Level)

moneyvibe-clone/
├── lib/ # Flutter source code (feature-based)
│ ├── core/ # Theme, shared utilities
│ ├── features/ # Assessment, auth, history
│ └── main.dart # App entry point
│
├── android/ ios/ web/ # Flutter platforms
├── assets/ # Images & fonts
├── test/
│
├── moneyvibe-backend/ # Backend service
└── README.md

🖼 Screenshots

Add screenshots for the following screens:

Welcome Screen

Quiz Screen (with progress indicator)

Results Screen (trait visualization)

Insights Screen

Screenshots help reviewers quickly understand UX quality and polish.

🎥 Demo Video

A short 2–3 minute demo video showcasing:

Complete assessment flow

Results and insights

Backend interaction

(Shared separately)

🔮 Future Enhancements

Trend visualization across multiple assessments

Deeper personalization in insights

Automated tests for scoring logic

👤 Author

Prerna Pandey
Flutter & Full-Stack Developer
<img width="1903" height="911" alt="Screenshot 2026-01-20 181657" src="https://github.com/user-attachments/assets/2bc14561-1e85-4f9f-aa4e-86fc6edfd3cb" />
<img width="1903" height="911" alt="Screenshot 2026-01-20 181721" src="https://github.com/user-attachments/assets/af784f36-1b4b-4ace-9498-ffa10cf02879" />
<img width="1900" height="901" alt="Screenshot 2026-01-20 181741" src="https://github.com/user-attachments/assets/dfeae942-dfc6-4506-bb89-d6973ca5d482" />
<img width="1891" height="889" alt="Screenshot 2026-01-20 181827" src="https://github.com/user-attachments/assets/2815f8b6-ef0a-4834-8477-7ea3fa972773" />
<img width="1564" height="894" alt="Screenshot 2026-01-20 181855" src="https://github.com/user-attachments/assets/fa69dda6-57af-4ff3-89d2-43b43fbbd01e" />
