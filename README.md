# MoneyVibe 💰✨

**MoneyVibe** is a premium financial personality assessment application designed to help users understand their relationship with money. By combining a sleek, modern user interface with AI-driven insights, MoneyVibe provides a personalized experience for financial self-discovery.

---

## 🚀 Features

- **Personalized Quiz**: Engaging assessments to determine your "Money Vibe" (financial personality).
- **AI-Powered Insights**: Uses Google Gemini AI to analyze your quiz results and provide tailored financial advice.
- **Dynamic Dashboards**: Beautifully designed progress indicators and result visualizations.
- **Cross-Platform**: Built with Flutter for a seamless experience across Mobile and Web.
- **Robust Backend**: Secure data management using Node.js, Express, and PostgreSQL.

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: [Flutter](https://flutter.dev/) (Mobile & Web)
- **Web App**: React + Vite + TypeScript
- **Styling**: Vanilla CSS, Glassmorphism, Framer Motion (for React)
- **State Management**: Riverpod (Flutter)
- **Charts**: fl_chart (Flutter), Recharts (React)

### Backend
- **Server**: Node.js & Express.js
- **Database**: PostgreSQL
- **AI**: Google Generative AI (Gemini)
- **Authentication**: JWT & Bcrypt

---

## 🏗️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org/) (v18+)
- [PostgreSQL](https://www.postgresql.org/)
- **Gemini AI API Key** (from [Google AI Studio](https://aistudio.google.com/))

### Installation

1. **Clone the Repo**
   ```bash
   git clone https://github.com/Prerna084/MoneyVibe.git
   cd MoneyVibe
   ```

2. **Frontend Setup (Flutter)**
   ```bash
   flutter pub get
   flutter run
   ```

3. **Backend Setup**
   ```bash
   cd moneyvibe-backend
   npm install
   ```
   - Create a `.env` file in the `moneyvibe-backend` directory and add:
     ```env
     DATABASE_URL=your_postgresql_url
     GEMINI_API_KEY=your_api_key
     JWT_SECRET=your_secret
     ```
   - Initialize the database:
     ```bash
     node init-db.js
     ```
   - Start the server:
     ```bash
     node server.js
     ```

---

## ✨ Design Philosophy

MoneyVibe prioritizes a **premium aesthetic** using:
- **Glassmorphism**: Elegant, transparent UI elements.
- **Vibrant Gradients**: Rich, modern color palettes.
- **Micro-animations**: Smooth transitions and interactive feedbacks to enhance user engagement.

---

## 📄 License

This project is licensed under the ISC License.
