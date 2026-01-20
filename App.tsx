
import React, { useState, useEffect } from 'react';
import { Layout } from './components/Layout';
import { LikertScale } from './components/LikertScale';
import { TraitChart } from './components/TraitChart';
import { QUESTIONS } from './constants';
import { AppScreen, TraitCategory, QuizResult } from './types';
import { storageService } from './services/storageService';
import { generateFinancialInsights } from './services/geminiService';
import { apiService } from './services/apiService';
import { AuthModal } from './components/AuthModal';
import { motion, AnimatePresence } from 'framer-motion';
import {
  TrendingUp,
  ArrowRight,
  CheckCircle2,
  Sparkles,
  History,
  PlayCircle,
  BrainCircuit,
  PieChart,
  User,
  Zap
} from 'lucide-react';

const App: React.FC = () => {
  const [screen, setScreen] = useState<AppScreen>('WELCOME');
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [currentResult, setCurrentResult] = useState<QuizResult | null>(null);
  const [history, setHistory] = useState<QuizResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [pendingScores, setPendingScores] = useState<Record<TraitCategory, number> | null>(null);

  useEffect(() => {
    setHistory(storageService.getHistory());
  }, []);

  const handleStartQuiz = () => {
    setAnswers({});
    setCurrentQuestionIndex(0);
    setScreen('QUIZ');
  };

  const handleAnswer = (value: number) => {
    const question = QUESTIONS[currentQuestionIndex];
    setAnswers(prev => ({ ...prev, [question.id]: value }));

    if (currentQuestionIndex < QUESTIONS.length - 1) {
      setTimeout(() => {
        setCurrentQuestionIndex(prev => prev + 1);
      }, 300);
    } else {
      processResults();
    }
  };

  const processResults = async (overriddenScores?: Record<TraitCategory, number>) => {
    let scores = overriddenScores;

    if (!scores) {
      const categoryTotals: Record<TraitCategory, number[]> = {
        [TraitCategory.PLANNING]: [],
        [TraitCategory.IMPULSE]: [],
        [TraitCategory.RISK]: [],
        [TraitCategory.CALMNESS]: []
      };

      QUESTIONS.forEach(q => {
        categoryTotals[q.category].push(answers[q.id] || 3);
      });

      scores = {} as Record<TraitCategory, number>;
      Object.entries(categoryTotals).forEach(([cat, vals]) => {
        const avg = vals.reduce((a, b) => a + b, 0) / vals.length;
        scores![cat as TraitCategory] = Number(avg.toFixed(1));
      });
    }

    // Check for token
    const token = localStorage.getItem('auth_token');
    if (!token) {
      setPendingScores(scores);
      setShowAuthModal(true);
      return;
    }

    setLoading(true);
    setScreen('RESULTS');

    try {
      const aiData = await generateFinancialInsights(scores);

      const result: QuizResult = {
        id: Math.random().toString(36).substr(2, 9),
        timestamp: Date.now(),
        scores,
        persona: aiData.persona,
        insights: aiData.insights
      };

      // Submit to backend
      try {
        await apiService.submitQuiz(token, scores, result);
        console.log("Quiz submitted to backend successfully");
      } catch (backendErr) {
        console.error("Backend submission failed:", backendErr);
        // We still show results locally even if backend fails
      }

      storageService.saveResult(result);
      setHistory(storageService.getHistory());
      setCurrentResult(result);
    } catch (err) {
      console.error("Error processing results:", err);
    } finally {
      setLoading(false);
    }
  };

  const handleAuthSuccess = (token: string) => {
    setShowAuthModal(false);
    if (pendingScores) {
      processResults(pendingScores);
      setPendingScores(null);
    }
  };

  const pageVariants = {
    initial: { opacity: 0, x: 20 },
    animate: { opacity: 1, x: 0 },
    exit: { opacity: 0, x: -20 }
  };

  const renderWelcome = () => (
    <motion.div
      variants={pageVariants}
      initial="initial"
      animate="animate"
      exit="exit"
      className="flex flex-col items-center justify-center min-h-[75vh] text-center space-y-10"
    >
      <div className="relative">
        <motion.div
          animate={{ rotate: [12, 8, 12], scale: [1, 1.05, 1] }}
          transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
          className="w-36 h-36 rounded-[40px] bg-[#D4AF37] flex items-center justify-center shadow-[0_20px_40px_rgba(212,175,55,0.3)]"
        >
          <TrendingUp className="w-18 h-18 text-black" />
        </motion.div>
        <div className="absolute -top-4 -right-4 bg-white text-black text-xs font-black px-3 py-1 rounded-full shadow-lg">
          VER 2.0
        </div>
      </div>

      <div className="space-y-4">
        <h2 className="text-4xl font-black leading-[1.1] tracking-tight">
          Unlock Your <br /><span className="gold-text uppercase">Financial DNA</span>
        </h2>
        <p className="text-zinc-500 text-lg font-medium px-4">
          The smarter way to understand how you vibe with money.
        </p>
      </div>

      <div className="w-full space-y-4 pt-4">
        <button
          onClick={handleStartQuiz}
          className="w-full gold-gradient text-black font-black py-5 rounded-2xl flex items-center justify-center gap-3 text-lg active:scale-95 transition-all shadow-xl"
        >
          <PlayCircle className="w-6 h-6" />
          START ASSESSMENT
        </button>

        {history.length > 0 && (
          <button
            onClick={() => setScreen('HISTORY')}
            className="w-full bg-zinc-900 border border-zinc-800 text-zinc-300 font-bold py-5 rounded-2xl flex items-center justify-center gap-2 text-lg active:scale-95 transition-all"
          >
            <History className="w-5 h-5" />
            HISTORY
          </button>
        )}
      </div>
    </motion.div>
  );

  const renderQuiz = () => {
    const question = QUESTIONS[currentQuestionIndex];
    const progress = ((currentQuestionIndex + 1) / QUESTIONS.length) * 100;

    return (
      <motion.div
        variants={pageVariants}
        initial="initial"
        animate="animate"
        exit="exit"
        key={currentQuestionIndex}
        className="space-y-10 py-10"
      >
        <div className="space-y-4">
          <div className="flex justify-between items-end px-1">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-[#D4AF37] animate-pulse" />
              <span className="text-[#D4AF37] font-black text-xs tracking-[0.2em] uppercase">{question.category}</span>
            </div>
            <span className="text-zinc-600 font-bold text-xs">{currentQuestionIndex + 1} OF {QUESTIONS.length}</span>
          </div>
          <div className="w-full h-1.5 bg-zinc-900 rounded-full overflow-hidden">
            <motion.div
              className="h-full bg-[#D4AF37]"
              initial={{ width: 0 }}
              animate={{ width: `${progress}%` }}
              transition={{ duration: 0.5 }}
            />
          </div>
        </div>

        <div className="min-h-[160px] flex items-center px-2">
          <h2 className="text-3xl font-bold leading-tight tracking-tight">
            {question.text}
          </h2>
        </div>

        <LikertScale
          value={answers[question.id] || 0}
          onChange={handleAnswer}
        />

        <div className="pt-12 text-center text-zinc-600 text-[10px] font-black tracking-widest flex items-center justify-center gap-2 uppercase">
          <BrainCircuit className="w-4 h-4 text-[#D4AF37]" />
          AI Neural Processing Enabled
        </div>
      </motion.div>
    );
  };

  const renderResults = () => {
    if (loading || !currentResult) {
      return (
        <div className="flex flex-col items-center justify-center min-h-[60vh] space-y-8">
          <div className="relative">
            <motion.div
              animate={{ rotate: 360 }}
              transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
              className="w-24 h-24 border-[6px] border-zinc-900 border-t-[#D4AF37] rounded-full"
            />
            <Zap className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-8 h-8 text-[#D4AF37]" />
          </div>
          <div className="text-center space-y-2">
            <p className="text-xl font-bold gold-text uppercase tracking-tighter">Analyzing your patterns</p>
            <p className="text-zinc-600 text-sm font-medium">Gemini AI is crafting your profile...</p>
          </div>
        </div>
      );
    }

    return (
      <motion.div
        variants={pageVariants}
        initial="initial"
        animate="animate"
        exit="exit"
        className="space-y-8 py-6"
      >
        <div className="text-center space-y-3">
          <div className="inline-flex items-center gap-2 bg-zinc-900/50 px-4 py-2 rounded-full border border-zinc-800">
            <User className="w-3 h-3 text-[#D4AF37]" />
            <span className="text-[10px] font-black text-[#D4AF37] uppercase tracking-[0.2em]">Profile Unlocked</span>
          </div>
          <h2 className="text-4xl font-black tracking-tighter">THE {currentResult.persona.toUpperCase()}</h2>
        </div>

        <div className="glass-panel rounded-[32px] p-6 shadow-2xl">
          <div className="flex items-center gap-2 mb-2">
            <PieChart className="w-4 h-4 text-[#D4AF37]" />
            <h3 className="text-sm font-black uppercase tracking-widest text-zinc-400">Behavioral Map</h3>
          </div>
          <TraitChart scores={currentResult.scores} />
        </div>

        <div className="grid grid-cols-2 gap-4">
          {Object.entries(currentResult.scores).map(([trait, score]) => (
            <motion.div
              key={trait}
              whileHover={{ scale: 1.02 }}
              className="glass-panel rounded-2xl p-5 flex flex-col justify-between border-l-2 border-l-[#D4AF37]/30"
            >
              <span className="text-[10px] text-zinc-500 font-black uppercase tracking-widest">{trait}</span>
              <div className="flex items-baseline gap-1 mt-3">
                <span className="text-3xl font-black">{score}</span>
                <span className="text-zinc-600 text-xs font-bold">/ 5</span>
              </div>
            </motion.div>
          ))}
        </div>

        <button
          onClick={() => setScreen('INSIGHTS')}
          className="w-full gold-gradient text-black font-black py-5 rounded-2xl flex items-center justify-center gap-2 text-lg active:scale-95 transition-all shadow-[0_15px_30px_rgba(212,175,55,0.2)]"
        >
          AI INSIGHTS
          <ArrowRight className="w-5 h-5" />
        </button>
      </motion.div>
    );
  };

  const renderInsights = () => {
    if (!currentResult) return null;

    return (
      <motion.div
        variants={pageVariants}
        initial="initial"
        animate="animate"
        exit="exit"
        className="space-y-8 py-6"
      >
        <div className="space-y-1">
          <h2 className="text-3xl font-black tracking-tighter gold-text uppercase">Personalized Strategies</h2>
          <p className="text-zinc-500 font-bold text-sm">Actionable advice for {currentResult.persona}.</p>
        </div>

        <div className="space-y-4">
          {currentResult.insights.map((insight, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.1 }}
              className="glass-panel rounded-2xl p-6 flex gap-4 relative overflow-hidden group"
            >
              <div className="absolute top-0 left-0 w-1 h-full bg-[#D4AF37]" />
              <div className="mt-1">
                <CheckCircle2 className="w-5 h-5 text-[#D4AF37]" />
              </div>
              <p className="text-zinc-200 leading-relaxed font-semibold text-[15px]">
                {insight}
              </p>
            </motion.div>
          ))}
        </div>

        <div className="pt-8">
          <button
            onClick={() => setScreen('WELCOME')}
            className="w-full bg-white text-black font-black py-5 rounded-2xl transition-all shadow-lg active:scale-95"
          >
            RETURN HOME
          </button>
        </div>
      </motion.div>
    );
  };

  const renderHistory = () => (
    <motion.div
      variants={pageVariants}
      initial="initial"
      animate="animate"
      exit="exit"
      className="space-y-8 py-6"
    >
      <div className="space-y-1">
        <h2 className="text-3xl font-black tracking-tighter uppercase">Assessment History</h2>
        <p className="text-zinc-500 font-bold text-sm">Your financial evolution tracked.</p>
      </div>

      <div className="space-y-4">
        {history.length > 0 ? history.map((res, idx) => (
          <motion.button
            key={res.id}
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: idx * 0.05 }}
            onClick={() => {
              setCurrentResult(res);
              setScreen('RESULTS');
            }}
            className="w-full glass-panel rounded-2xl p-5 text-left hover:border-[#D4AF37] transition-all flex justify-between items-center group"
          >
            <div className="space-y-1">
              <h3 className="font-black text-lg group-hover:gold-text transition-colors">{res.persona.toUpperCase()}</h3>
              <p className="text-[10px] text-zinc-500 font-black tracking-widest uppercase">
                {new Date(res.timestamp).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}
              </p>
            </div>
            <div className="w-10 h-10 rounded-full bg-zinc-900 flex items-center justify-center group-hover:bg-[#D4AF37] transition-all">
              <ArrowRight className="w-4 h-4 text-zinc-500 group-hover:text-black" />
            </div>
          </motion.button>
        )) : (
          <div className="text-center py-20 text-zinc-600 font-bold uppercase tracking-widest">
            No history found
          </div>
        )}
      </div>

      {history.length > 0 && (
        <button
          onClick={() => {
            if (confirm("Wipe history data?")) {
              storageService.clearHistory();
              setHistory([]);
            }
          }}
          className="text-zinc-700 text-[10px] font-black uppercase tracking-[0.3em] text-center w-full pt-10 hover:text-red-900 transition-colors"
        >
          Factory Reset Database
        </button>
      )}
    </motion.div>
  );

  return (
    <Layout
      onBack={() => {
        if (screen === 'INSIGHTS') setScreen('RESULTS');
        else if (screen === 'RESULTS') setScreen('WELCOME');
        else if (screen === 'HISTORY') setScreen('WELCOME');
        else if (screen === 'QUIZ') {
          if (window.confirm("Abandon quiz? Progress will be lost.")) setScreen('WELCOME');
        }
      }}
      showBack={screen !== 'WELCOME'}
      title={screen === 'INSIGHTS' ? 'STRATEGY' : screen === 'HISTORY' ? 'JOURNAL' : undefined}
    >
      <AnimatePresence mode="wait">
        {screen === 'WELCOME' && renderWelcome()}
        {screen === 'QUIZ' && renderQuiz()}
        {screen === 'RESULTS' && renderResults()}
        {screen === 'INSIGHTS' && renderInsights()}
        {screen === 'HISTORY' && renderHistory()}
      </AnimatePresence>

      <AuthModal
        isOpen={showAuthModal}
        onClose={() => setShowAuthModal(false)}
        onSuccess={handleAuthSuccess}
      />
    </Layout>
  );
};

export default App;
