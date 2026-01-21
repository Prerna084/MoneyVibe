# MoneyVibe — Financial Personality Assessment (Flutter)

MoneyVibe is a Flutter-based financial personality assessment inspired by **Twigg’s MoneyVibe** experience.  
It helps users understand their money behavior through a short, intuitive quiz and presents results using clear visual indicators and personalized insights.

This project includes:
- A **Flutter app** implementing the full assessment flow
- A **backend service** for storing and retrieving user results

---

## Product Overview

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

## Design & UX

- **Theme:** Dark UI with gold/yellow accents (`#D4AF37`)
- **Style:** Clean, minimal, premium fintech
- **UX Principles:**
  - Low cognitive load during the quiz
  - Clear progress indicators
  - Visually rewarding results and insights

Inspired by **Twigg, CRED, and Jupiter**.

---

## LLM / AI Approach

- Core assessment logic is **fully deterministic**
- AI usage (optional) is scoped **only to the insights layer**
- The model operates on **structured trait scores**, not raw user answers

This keeps the system **explainable, safe, and appropriate for a fintech context**, while still enabling personalized communication.

---

## Project Structure (High Level)

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


Start the Flutter App (Web)

From the project root:

flutter pub get
flutter run -d chrome

The app will launch in the browser and connect to the backend.

Screenshots:

Add screenshots for the following screens:

Welcome Screen

Quiz Screen (with progress indicator)

Results Screen (trait visualization)

Insights Screen



🎥 Demo Video

A short 2–3 minute demo video showcasing:

Complete assessment flow

Results and insights

Backend interaction
https://drive.google.com/file/d/1vOVHIGUD9XU7oNKPNdqbI4q4je5L6k_a/view?usp=drivesdk

🔮 Future Enhancements

Trend visualization across multiple assessments

Deeper personalization in insights

Automated tests for scoring logic

👤 Author

Prerna Pandey
Flutter & Full-Stack Developer

<img width="1904" height="896" alt="Screenshot 2026-01-21 121823" src="https://github.com/user-attachments/assets/1c1887bc-e24f-48c3-9d88-74eb2ebfadc3" />

<img width="1914" height="898" alt="Screenshot 2026-01-21 121839" src="https://github.com/user-attachments/assets/1a4f81a5-d380-41cd-bd77-d4fb3e76e8fe" />
<img width="1902" height="888" alt="Screenshot 2026-01-21 121904" src="https://github.com/user-attachments/assets/7864d26b-f9e1-47e9-9445-c53d6edabb6a" />
<img width="1877" height="892" alt="Screenshot 2026-01-21 121919" src="https://github.com/user-attachments/assets/a4e49a3d-fac1-4804-aece-3896ee5ee716" />
<img width="1902" height="900" alt="Screenshot 2026-01-21 121934" src="https://github.com/user-attachments/assets/1e19c926-ef58-4898-affb-1b03c8101d3e" />
<img width="1874" height="890" alt="Screenshot 2026-01-21 121950" src="https://github.com/user-attachments/assets/946b62c1-4a03-43bc-abaf-93d4614da8ee" />
<img width="1894" height="905" alt="Screenshot 2026-01-21 122007" src="https://github.com/user-attachments/assets/1aef93eb-f899-43e3-a850-36ddfdf4e519" />
<img width="1896" height="894" alt="Screenshot 2026-01-21 122023" src="https://github.com/user-attachments/assets/9db03398-6f78-4a88-b4c9-0e0c7a7e22de" />
<img width="1888" height="894" alt="Screenshot 2026-01-21 122040" src="https://github.com/user-attachments/assets/54224d29-5a5f-4a4d-b01c-a7efd926395b" />
<img width="1911" height="894" alt="Screenshot 2026-01-21 122112" src="https://github.com/user-attachments/assets/f9f15d86-680e-4b79-84f6-5e0d9ce74cd5" />
<img width="1891" height="891" alt="Screenshot 2026-01-21 122129" src="https://github.com/user-attachments/assets/08094b64-fed4-485f-83c0-0e1ddb4d987c" />
<img width="1245" height="953" alt="Screenshot 2026-01-21 122300" src="https://github.com/user-attachments/assets/dbb6caed-b376-4c7e-96f8-40c92f025925" />
<img width="1253" height="949" alt="Screenshot 2026-01-21 122358" src="https://github.com/user-attachments/assets/06f9cff4-53a4-4558-a734-c7ce062049a8" />
<img width="1255" height="954" alt="Screenshot 2026-01-21 122440" src="https://github.com/user-attachments/assets/0c09361a-d0a9-440f-b789-0ae0c60ec4fa" />
<img width="1252" height="953" alt="Screenshot 2026-01-21 122704" src="https://github.com/user-attachments/assets/f71c0780-9cca-4ae2-8139-244206871d3a" />
